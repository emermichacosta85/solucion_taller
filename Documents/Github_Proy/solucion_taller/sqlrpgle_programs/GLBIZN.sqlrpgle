      **free
// =============================================================================
// Módulo              : GLBIZN
// Descripción         : Capa de negocio del proceso de conciliación GLBLN.
//                       Contiene todas las reglas para:
//                         · Cálculo de saldos y balance por cuenta (RF-02).
//                         · Asignación de estado de conciliación   (RF-03).
//                         · Determinación de diferencias y tolerancia.
//                         · Clasificación de severidad e incidentes.
//                         · Consolidación de totales de control     (RF-04).
//
// Principio SOLID     : SRP — solo lógica de negocio, sin SQL ni IFS.
//                       OCP — reglas encapsuladas en procedimientos;
//                             extender sin modificar orquestador.
//                       LSP — procedimientos intercambiables por contrato.
//                       DIP — depende de contratos de GLDATA/GLUTIL,
//                             no de implementaciones concretas.
//
// RF cubiertos        : RF-02, RF-03, RF-04, RF-08
//
// Artefacto           : Módulo (*MODULE)
// Módulo fuente       : GLBIZN.sqlrpgle
// Librería            : HNEACOSTA1
// Taller              : IBM i - Proceso CONCILIACION_GLBLN
// Fecha               : 2025-06-12
// Versión             : 1.0.0
// =============================================================================

/copy HNEACOSTA1/QRPGLESRC,GLDATA     // tipos compartidos t_cuentaMayor, etc.
/copy HNEACOSTA1/QRPGLESRC,GLUTIL     // prototipos de utilidades

// --- Estructura de resultado por cuenta (RF-04) ------------------------------
dcl-ds t_resultCuenta  qualified  template;
  // Saldos calculados (RF-02)
  saldo_inicial           packed(18:2);
  debitos_periodo         packed(18:2);
  creditos_periodo        packed(18:2);
  saldo_final_calculado   packed(18:2);
  saldo_final_fuente      packed(18:2);
  saldo_final_conciliado  packed(18:2);
  // Diferencias
  diferencia_neta         packed(18:2);
  diferencia_absoluta     packed(18:2);
  tolerancia_permitida    packed(18:2);
  excede_tolerancia       ind;
  motivo_principal        varchar(120);
  // Estado (RF-03)
  estado_codigo           varchar(20);   // CONCILIADA/PARCIAL/NO_CONCILIADA
  estado_descripcion      varchar(120);
  severidad               varchar(10);   // BAJA/MEDIA/ALTA/CRITICA
  requiere_revision       ind;
  // Hash de integridad (§8.1 trazabilidad)
  hash_cuenta             varchar(25);
end-ds;

// Estructura de incidente de negocio (§8.1 incidentes[])
dcl-ds t_incidente  qualified  template;
  codigo       varchar(20);
  tipo         varchar(20);   // VALIDACION/DATOS/IFS/EJECUCION
  cuenta_contable varchar(24);
  mensaje      varchar(200);
  severidad    varchar(10);
end-ds;

// Totales de control del JSON (§8.1 controlTotales)
dcl-ds t_controlTotales  qualified  template;
  total_cuentas_procesadas     int(10);
  total_cuentas_conciliadas    int(10);
  total_cuentas_con_diferencia int(10);
  sumatoria_saldo_fuente       packed(18:2);
  sumatoria_saldo_conciliado   packed(18:2);
  sumatoria_diferencia_neta    packed(18:2);
end-ds;

// =============================================================================
// Prototipos exportados
// =============================================================================

// Calcula todos los saldos y balance de una cuenta (RF-02)
dcl-pr gl_calcularBalance  ind   extproc('GL_CALCULAR_BALANCE');
  pCuenta     likeds(t_cuentaMayor) const;
  pMov        likeds(t_movimientos) const;
  pPartidas   likeds(t_partida) dim(50) const;
  pCantPart   int(5)  const;
  pTolera     packed(18:2) const;
  pResult     likeds(t_resultCuenta);
end-pr;

// Determina estado de conciliación y severidad (RF-03)
dcl-pr gl_determinarEstado  extproc('GL_DETERMINAR_ESTADO');
  pResult     likeds(t_resultCuenta);
end-pr;

// Genera incidente a partir de un resultado (RF-08)
dcl-pr gl_generarIncidente  extproc('GL_GENERAR_INCIDENTE');
  pCuenta     varchar(24)  const;
  pTipo       varchar(20)  const;
  pMensaje    varchar(200) const;
  pSeveridad  varchar(10)  const;
  pIncidente  likeds(t_incidente);
  pIncSeq     int(5);       // correlativo para código único
end-pr;

// Acumula los totales globales de control (RF-04)
dcl-pr gl_acumularTotales  extproc('GL_ACUMULAR_TOTALES');
  pResult     likeds(t_resultCuenta) const;
  pTotales    likeds(t_controlTotales);
end-pr;

// Valida cuadratura de totales (§8.2 regla de sumatoriaDiferenciaNeta)
dcl-pr gl_validarCuadratura  ind   extproc('GL_VALIDAR_CUADRATURA');
  pTotales    likeds(t_controlTotales) const;
  pMsgError   varchar(200);
end-pr;

// Determina estadoEjecucion final según incidentes acumulados (§8.1 ejecucion)
dcl-pr gl_estadoEjecucion  varchar(12)  extproc('GL_ESTADO_EJECUCION');
  pIncidentes  likeds(t_incidente) dim(200) const;
  pCantInc     int(5) const;
end-pr;

// =============================================================================
// Implementaciones
// =============================================================================

// --- gl_calcularBalance ------------------------------------------------------
// RF-02: saldoFinalCalculado = saldoInicial + débitos - créditos
//        saldoFinalConciliado = saldoFinalCalculado + sumatoria partidas netas
// Matriz §14: saldos.* completos
dcl-proc gl_calcularBalance export;
  dcl-pi *n ind;
    pCuenta   likeds(t_cuentaMayor) const;
    pMov      likeds(t_movimientos) const;
    pPartidas likeds(t_partida) dim(50) const;
    pCantPart int(5)  const;
    pTolera   packed(18:2) const;
    pResult   likeds(t_resultCuenta);
  end-pi;

  dcl-s i           int(5);
  dcl-s wPartNetas  packed(18:2) inz(0);
  dcl-s wMotivo     varchar(120);

  // Saldo inicial = saldo fuente menos movimientos del periodo
  // (se toma el saldo_actual de GLBLN como saldo final fuente y se
  //  reconstruye el inicial restando la variación neta del período)
  pResult.saldo_final_fuente    = pCuenta.saldo_actual;
  pResult.debitos_periodo       = pMov.debitos_periodo;
  pResult.creditos_periodo      = pMov.creditos_periodo;
  pResult.saldo_inicial         = pCuenta.saldo_actual
                                  - pMov.debitos_periodo
                                  + pMov.creditos_periodo;
  pResult.saldo_final_calculado = pResult.saldo_inicial
                                  + pResult.debitos_periodo
                                  - pResult.creditos_periodo;

  // Suma neta de partidas conciliatorias
  wMotivo = '';
  for i = 1 to pCantPart;
    if pPartidas(i).signo = 'DEBITO';
      wPartNetas += pPartidas(i).monto;
    else;
      wPartNetas -= pPartidas(i).monto;
    endif;
    if wMotivo = '' and pPartidas(i).subtipo <> '';
      wMotivo = pPartidas(i).subtipo;
    endif;
  endfor;

  pResult.saldo_final_conciliado = pResult.saldo_final_calculado - wPartNetas;

  // Diferencias
  pResult.diferencia_neta      = pResult.saldo_final_fuente
                                 - pResult.saldo_final_conciliado;
  pResult.diferencia_absoluta  = %abs(pResult.diferencia_neta);
  pResult.tolerancia_permitida = pTolera;
  pResult.excede_tolerancia    = (pResult.diferencia_absoluta > pTolera);

  if wMotivo = '';
    if pResult.diferencia_neta = 0;
      wMotivo = 'Sin diferencia';
    else;
      wMotivo = 'Diferencia sin partida clasificada';
    endif;
  else;
    wMotivo = 'Partida en tránsito';
  endif;
  pResult.motivo_principal = wMotivo;

  // Hash de integridad (§8.1 trazabilidad.hashCuenta)
  pResult.hash_cuenta = gl_hashCuenta(
      pCuenta.codigo_banco,
      pCuenta.codigo_sucursal,
      pCuenta.codigo_moneda,
      pCuenta.cuenta_contable,
      pResult.saldo_final_fuente);

  return *on;
end-proc;

// --- gl_determinarEstado -----------------------------------------------------
// RF-03: asigna estado, severidad y requiereRevision.
// Reglas §8.2 + §14 taller (CONCILIADA/PARCIAL/NO_CONCILIADA):
//   · diferencia = 0                        → CONCILIADA / BAJA
//   · diferencia > 0 y <= tolerancia        → PARCIAL    / MEDIA
//   · diferencia > tolerancia y <= 100      → PARCIAL    / ALTA
//   · diferencia > 100                      → NO_CONCILIADA / CRITICA
dcl-proc gl_determinarEstado export;
  dcl-pi *n;
    pResult likeds(t_resultCuenta);
  end-pi;

  dcl-s wDif packed(18:2);
  wDif = pResult.diferencia_absoluta;

  select;
    when wDif = 0;
      pResult.estado_codigo       = 'CONCILIADA';
      pResult.estado_descripcion  = 'Conciliada sin diferencias';
      pResult.severidad           = 'BAJA';
      pResult.requiere_revision   = *off;

    when wDif > 0 and wDif <= pResult.tolerancia_permitida;
      pResult.estado_codigo       = 'PARCIAL';
      pResult.estado_descripcion  = 'Conciliada con partidas pendientes';
      pResult.severidad           = 'MEDIA';
      pResult.requiere_revision   = *on;

    when wDif > pResult.tolerancia_permitida and wDif <= 100;
      pResult.estado_codigo       = 'PARCIAL';
      pResult.estado_descripcion  = 'Diferencia relevante requiere revisión';
      pResult.severidad           = 'ALTA';
      pResult.requiere_revision   = *on;

    other;
      pResult.estado_codigo       = 'NO_CONCILIADA';
      pResult.estado_descripcion  = 'Diferencia critica supera tolerancia';
      pResult.severidad           = 'CRITICA';
      pResult.requiere_revision   = *on;
  endsl;
end-proc;

// --- gl_generarIncidente -----------------------------------------------------
// RF-08: genera incidente trazable con código único.
// §8.2: registrar incidentes funcionales o técnicos para auditoría.
dcl-proc gl_generarIncidente export;
  dcl-pi *n;
    pCuenta    varchar(24)  const;
    pTipo      varchar(20)  const;
    pMensaje   varchar(200) const;
    pSeveridad varchar(10)  const;
    pIncidente likeds(t_incidente);
    pIncSeq    int(5);
  end-pi;

  pIncSeq += 1;

  // Código: WARN/ERR/CRIT-GL-NNN
  select;
    when pSeveridad = 'BAJA' or pSeveridad = 'MEDIA';
      pIncidente.codigo = 'WARN-GL-' + %editc(%dec(pIncSeq:3:0):'X');
    when pSeveridad = 'ALTA';
      pIncidente.codigo = 'ERR-GL-'  + %editc(%dec(pIncSeq:3:0):'X');
    other;
      pIncidente.codigo = 'CRIT-GL-' + %editc(%dec(pIncSeq:3:0):'X');
  endsl;

  pIncidente.tipo            = %trimr(pTipo);
  pIncidente.cuenta_contable = %trimr(pCuenta);
  pIncidente.mensaje         = %trimr(pMensaje);
  pIncidente.severidad       = %trimr(pSeveridad);
end-proc;

// --- gl_acumularTotales ------------------------------------------------------
// RF-04: acumula controlTotales para cuadratura global §8.1.
dcl-proc gl_acumularTotales export;
  dcl-pi *n;
    pResult  likeds(t_resultCuenta) const;
    pTotales likeds(t_controlTotales);
  end-pi;

  pTotales.total_cuentas_procesadas     += 1;
  pTotales.sumatoria_saldo_fuente       += pResult.saldo_final_fuente;
  pTotales.sumatoria_saldo_conciliado   += pResult.saldo_final_conciliado;
  pTotales.sumatoria_diferencia_neta    += pResult.diferencia_neta;

  if pResult.estado_codigo = 'CONCILIADA';
    pTotales.total_cuentas_conciliadas  += 1;
  endif;

  if pResult.diferencia_neta <> 0;
    pTotales.total_cuentas_con_diferencia += 1;
  endif;
end-proc;

// --- gl_validarCuadratura ----------------------------------------------------
// §8.2 regla: sumatoriaDiferenciaNeta = saldoFuente - saldoConciliado
dcl-proc gl_validarCuadratura export;
  dcl-pi *n ind;
    pTotales  likeds(t_controlTotales) const;
    pMsgError varchar(200);
  end-pi;

  dcl-s wDifCalculada packed(18:2);
  wDifCalculada = pTotales.sumatoria_saldo_fuente
                - pTotales.sumatoria_saldo_conciliado;

  if %abs(wDifCalculada - pTotales.sumatoria_diferencia_neta) > 0.01;
    pMsgError = 'Cuadratura fallida: sumatoriaDiferenciaNeta inconsistente.';
    return *off;
  endif;

  pMsgError = '';
  return *on;
end-proc;

// --- gl_estadoEjecucion ------------------------------------------------------
// §8.1 ejecucion.estadoEjecucion: FINALIZADO / PARCIAL / ERROR
// §14 taller: ALTA/CRITICA → PARCIAL o ERROR
dcl-proc gl_estadoEjecucion export;
  dcl-pi *n varchar(12);
    pIncidentes likeds(t_incidente) dim(200) const;
    pCantInc    int(5) const;
  end-pi;

  dcl-s i        int(5);
  dcl-s wTieneCritica ind inz(*off);
  dcl-s wTieneAlta    ind inz(*off);

  for i = 1 to pCantInc;
    if pIncidentes(i).severidad = 'CRITICA';
      wTieneCritica = *on;
    endif;
    if pIncidentes(i).severidad = 'ALTA';
      wTieneAlta = *on;
    endif;
  endfor;

  if wTieneCritica;
    return 'ERROR';
  elseif wTieneAlta;
    return 'PARCIAL';
  else;
    return 'FINALIZADO';
  endif;
end-proc;

// =============================================================================
// Fin de GLBIZN
// =============================================================================
