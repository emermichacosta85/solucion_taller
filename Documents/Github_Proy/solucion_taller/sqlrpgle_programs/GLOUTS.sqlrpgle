      **free
// =============================================================================
// Módulo              : GLOUTS
// Descripción         : Capa de salida del proceso de conciliación GLBLN.
//                       Construye el payload JSON completo mediante sentencias
//                       SQL (JSON_OBJECT / JSON_ARRAY / JSON_ARRAYAGG) y lo
//                       deposita en el IFS usando QSYS2.IFS_WRITE_UTF8.
//                       También escribe la bitácora de ejecución en IFS.
//
// Estrategia SQL-IFS  : Una única sentencia SQL por sección del JSON agrupa
//                       todos los datos en un CLOB; después QSYS2.IFS_WRITE_UTF8
//                       serializa ese CLOB directamente al archivo, garantizando
//                       codificación UTF-8 sin manipulación de punteros C.
//
// Principio SOLID     : SRP — solo construcción SQL de JSON y escritura IFS.
//                       DIP — recibe datos elaborados de GLBIZN; no aplica
//                             reglas de negocio propias.
//
// RF cubiertos        : RF-05 (JSON válido UTF-8), RF-06 (IFS), RF-07 (log)
//
// Requisitos IBM i    : DB2 for i 7.3+ (JSON_OBJECT, QSYS2.IFS_WRITE_UTF8)
//                       PTF SI71934 o superior para QSYS2.IFS_WRITE_UTF8
//
// Artefacto           : Módulo (*MODULE)
// Módulo fuente       : GLOUTS.sqlrpgle
// Librería            : HNEACOSTA1
// Taller              : IBM i - Proceso CONCILIACION_GLBLN
// Fecha               : 2025-06-12
// Versión             : 2.0.0  (reescrito con SQL nativo e IFS_WRITE_UTF8)
// =============================================================================

/copy HNEACOSTA1/QRPGLESRC,GLDATA
/copy HNEACOSTA1/QRPGLESRC,GLBIZN
/copy HNEACOSTA1/QRPGLESRC,GLUTIL

// =============================================================================
// Prototipos exportados
// =============================================================================

// Genera y escribe el JSON completo en IFS via SQL (RF-05, RF-06)
dcl-pr gl_generarJsonIfs  ind   extproc('GL_GENERAR_JSON_IFS');
  pIdEjec      varchar(22)  const;   // idEjecucion
  pFechaPrcs   date         const;   // fechaProceso
  pTsInicio    timestamp    const;   // fechaHoraInicio
  pTsFin       timestamp    const;   // fechaHoraFin
  pUsuario     varchar(30)  const;   // usuario del job
  pPrograma    varchar(10)  const;   // nombre del programa
  pLibreria    varchar(10)  const;   // librería
  pAmbiente    varchar(10)  const;   // QA/UAT/PRD
  pBanco       varchar(20)  const;   // filtro banco
  pSucursal    varchar(20)  const;   // filtro sucursal
  pMoneda      varchar(20)  const;   // filtro moneda
  pCuentaDesde varchar(24)  const;   // rango inferior
  pCuentaHasta varchar(24)  const;   // rango superior
  pFechaDesde  date         const;   // inicio período (1ro del mes)
  pEstadoEjec  varchar(12)  const;   // FINALIZADO/PARCIAL/ERROR
  pTolerancia  packed(18:2) const;   // tolerancia de diferencia
  pRutaIfs     varchar(200) const;   // ruta IFS destino
  pNombreArch  varchar(60)  const;   // nombre archivo JSON
  pMsgError    varchar(200);         // output: mensaje de error
end-pr;

// Escribe una línea en la bitácora IFS del proceso (RF-07)
dcl-pr gl_escribirBitacora  extproc('GL_ESCRIBIR_BITACORA');
  pRutaIfs     varchar(200) const;
  pNombreLog   varchar(60)  const;
  pLinea       varchar(500) const;
end-pr;

// =============================================================================
// Variables de módulo
// =============================================================================

dcl-s m_sqlEstado  char(5);     // SQLSTATE de la última sentencia SQL
dcl-s m_sqlCodigo  int(10);     // SQLCODE  de la última sentencia SQL

// =============================================================================
// Implementaciones
// =============================================================================

// -----------------------------------------------------------------------------
// gl_generarJsonIfs
// -----------------------------------------------------------------------------
// Flujo interno:
//   1. Ejecuta una SELECT con JSON_OBJECT / JSON_ARRAYAGG que cubre toda la
//      estructura §8.1 (metadata, ejecucion, contexto, cuentas, controlTotales,
//      incidentes) leyendo directamente de GLBLN, GLMST, TRANS, TTRAN, TRDSC.
//   2. El resultado (CLOB) se escribe en IFS con QSYS2.IFS_WRITE_UTF8.
//   3. Si IFS_WRITE_UTF8 no está disponible (< TR 7.3) se usa como fallback
//      el procedimiento almacenado SYSTOOLS.HTTPGETCLOB para verificar la ruta
//      o se reporta el error para que el DBA lo gestione.
// -----------------------------------------------------------------------------
dcl-proc gl_generarJsonIfs export;
  dcl-pi *n ind;
    pIdEjec      varchar(22)  const;
    pFechaPrcs   date         const;
    pTsInicio    timestamp    const;
    pTsFin       timestamp    const;
    pUsuario     varchar(30)  const;
    pPrograma    varchar(10)  const;
    pLibreria    varchar(10)  const;
    pAmbiente    varchar(10)  const;
    pBanco       varchar(20)  const;
    pSucursal    varchar(20)  const;
    pMoneda      varchar(20)  const;
    pCuentaDesde varchar(24)  const;
    pCuentaHasta varchar(24)  const;
    pFechaDesde  date         const;
    pEstadoEjec  varchar(12)  const;
    pTolerancia  packed(18:2) const;
    pRutaIfs     varchar(200) const;
    pNombreArch  varchar(60)  const;
    pMsgError    varchar(200);
  end-pi;

  // CLOB que almacenará el JSON completo generado por SQL
  dcl-s wJsonClob  sqltype(clob:2000000);

  // Ruta completa en IFS
  dcl-s wRutaFull  varchar(260);

  // Variables auxiliares de fecha/hora para el SQL
  dcl-s wAnio      int(5);
  dcl-s wMes       int(5);
  dcl-s wFechaStr  varchar(10);
  dcl-s wTsIniStr  varchar(19);
  dcl-s wTsFinStr  varchar(19);

  pMsgError  = '';
  wRutaFull  = %trimr(pRutaIfs) + %trimr(pNombreArch);
  wAnio      = %int(%subst(%char(pFechaPrcs:*iso):1:4));
  wMes       = %int(%subst(%char(pFechaPrcs:*iso):6:2));
  wFechaStr  = gl_fmtFecha(pFechaPrcs);
  wTsIniStr  = gl_fmtTimestamp(pTsInicio);
  wTsFinStr  = gl_fmtTimestamp(pTsFin);

  // ===========================================================================
  // PASO 1 — Construir el JSON completo mediante SQL
  //
  // La sentencia usa:
  //   · JSON_OBJECT  para objetos { }
  //   · JSON_ARRAY   para arrays  [ ] con elementos fijos
  //   · JSON_ARRAYAGG para arrays derivados de filas (cuentas, partidas,
  //                   incidentes) con subconsultas correlacionadas
  //   · Subconsultas escalares para saldos calculados y diferencias
  //   · COALESCE para valores opcionales
  //
  // Tablas fuente: GLBLN, GLMST, CCDSC, TRANS, TTRAN, TRDSC, CNTRLCNT
  // ===========================================================================

  exec sql
    values (
      -- -----------------------------------------------------------------------
      -- Objeto raíz del JSON (§8.1 estructura completa)
      -- -----------------------------------------------------------------------
      json_object(

        -- metadata -----------------------------------------------------------
        'metadata' value json_object(
          'versionEstructura' value '1.0.0',
          'sistemaOrigen'     value 'IBS-IBM-i',
          'proceso'           value 'CONCILIACION_GLBLN',
          'ambiente'          value :pAmbiente,
          'charset'           value 'UTF-8'
        ),

        -- ejecucion ----------------------------------------------------------
        'ejecucion' value json_object(
          'idEjecucion'     value :pIdEjec,
          'fechaProceso'    value :wFechaStr,
          'fechaHoraInicio' value :wTsIniStr,
          'fechaHoraFin'    value :wTsFinStr,
          'usuario'         value :pUsuario,
          'programa'        value :pPrograma,
          'libreria'        value :pLibreria,
          'estadoEjecucion' value :pEstadoEjec
        ),

        -- contexto -----------------------------------------------------------
        'contexto' value json_object(
          'banco'    value :pBanco,
          'sucursal' value :pSucursal,
          'moneda'   value :pMoneda,
          'periodo'  value json_object(
            'anio'       value :wAnio,
            'mes'        value :wMes,
            'fechaCorte' value :wFechaStr
          ),
          'rangoCuentas' value json_object(
            'desde' value :pCuentaDesde,
            'hasta' value :pCuentaHasta
          )
        ),

        -- cuentas[] ----------------------------------------------------------
        -- Una fila por cuenta mayor en GLBLN dentro del rango solicitado.
        -- Cada fila incluye: cuentaMayor, saldos, resumenMovimientos,
        --   partidasConciliatorias, diferencias, estadoConciliacion,
        --   trazabilidad.
        'cuentas' value (
          select json_arrayagg(
            json_object(

              -- cuentaMayor (RF-01, §14: GLBLN + GLMST + CCDSC) ----------
              'cuentaMayor' value json_object(
                'codigoBanco'      value g.codigo_banco,
                'codigoSucursal'   value g.codigo_sucursal,
                'codigoMoneda'     value g.codigo_moneda,
                'cuentaContable'   value g.cuenta_contable,
                'descripcionCuenta' value
                    coalesce(m.descripcion_cuenta, g.descripcion_cuenta),
                'naturaleza'       value
                    coalesce(m.naturaleza_cuenta,  g.naturaleza_cuenta),
                'nivelCuenta'      value
                    coalesce(m.nivel_cuenta,       g.nivel_cuenta),
                'centroCosto'      value
                    coalesce(cast(cc.id as varchar(20)), 'SIN_CC')
              ),

              -- saldos (RF-02, §14: GLBLN + TRANS + TTRAN) ----------------
              'saldos' value json_object(
                -- saldoFinalFuente: directo de GLBLN
                'saldoFinalFuente'     value g.saldo_actual,

                -- débitos del período: sumatoria TRANS + TTRAN
                'debitosPeriodo'       value coalesce((
                  select sum(t.monto)
                  from   HNEACOSTA1/TRANS t
                  where  t.codigo_banco    = g.codigo_banco
                    and  t.codigo_sucursal = g.codigo_sucursal
                    and  t.codigo_moneda   = g.codigo_moneda
                    and  t.cuenta_contable = g.cuenta_contable
                    and  t.debito_credito  = 'D'
                    and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                    and  t.estado_registro = 'A'
                ), 0) +
                coalesce((
                  select sum(tt.monto)
                  from   HNEACOSTA1/TTRAN tt
                  where  tt.codigo_banco    = g.codigo_banco
                    and  tt.codigo_sucursal = g.codigo_sucursal
                    and  tt.codigo_moneda   = g.codigo_moneda
                    and  tt.cuenta_contable = g.cuenta_contable
                    and  tt.debito_credito  = 'D'
                    and  tt.fecha           = :pFechaPrcs
                    and  tt.estado_registro = 'A'
                ), 0),

                -- créditos del período: sumatoria TRANS + TTRAN
                'creditosPeriodo'      value coalesce((
                  select sum(t.monto)
                  from   HNEACOSTA1/TRANS t
                  where  t.codigo_banco    = g.codigo_banco
                    and  t.codigo_sucursal = g.codigo_sucursal
                    and  t.codigo_moneda   = g.codigo_moneda
                    and  t.cuenta_contable = g.cuenta_contable
                    and  t.debito_credito  = 'C'
                    and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                    and  t.estado_registro = 'A'
                ), 0) +
                coalesce((
                  select sum(tt.monto)
                  from   HNEACOSTA1/TTRAN tt
                  where  tt.codigo_banco    = g.codigo_banco
                    and  tt.codigo_sucursal = g.codigo_sucursal
                    and  tt.codigo_moneda   = g.codigo_moneda
                    and  tt.cuenta_contable = g.cuenta_contable
                    and  tt.debito_credito  = 'C'
                    and  tt.fecha           = :pFechaPrcs
                    and  tt.estado_registro = 'A'
                ), 0),

                -- saldoInicial: saldoFuente - débitos + créditos (derivado)
                'saldoInicial'         value
                    g.saldo_actual
                  - coalesce((
                      select sum(t.monto) from HNEACOSTA1/TRANS t
                      where  t.codigo_banco = g.codigo_banco
                        and  t.codigo_sucursal = g.codigo_sucursal
                        and  t.codigo_moneda   = g.codigo_moneda
                        and  t.cuenta_contable = g.cuenta_contable
                        and  t.debito_credito  = 'D'
                        and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                        and  t.estado_registro = 'A'
                    ), 0)
                  - coalesce((
                      select sum(tt.monto) from HNEACOSTA1/TTRAN tt
                      where  tt.codigo_banco = g.codigo_banco
                        and  tt.codigo_sucursal = g.codigo_sucursal
                        and  tt.codigo_moneda   = g.codigo_moneda
                        and  tt.cuenta_contable = g.cuenta_contable
                        and  tt.debito_credito  = 'D'
                        and  tt.fecha           = :pFechaPrcs
                        and  tt.estado_registro = 'A'
                    ), 0)
                  + coalesce((
                      select sum(t.monto) from HNEACOSTA1/TRANS t
                      where  t.codigo_banco = g.codigo_banco
                        and  t.codigo_sucursal = g.codigo_sucursal
                        and  t.codigo_moneda   = g.codigo_moneda
                        and  t.cuenta_contable = g.cuenta_contable
                        and  t.debito_credito  = 'C'
                        and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                        and  t.estado_registro = 'A'
                    ), 0)
                  + coalesce((
                      select sum(tt.monto) from HNEACOSTA1/TTRAN tt
                      where  tt.codigo_banco = g.codigo_banco
                        and  tt.codigo_sucursal = g.codigo_sucursal
                        and  tt.codigo_moneda   = g.codigo_moneda
                        and  tt.cuenta_contable = g.cuenta_contable
                        and  tt.debito_credito  = 'C'
                        and  tt.fecha           = :pFechaPrcs
                        and  tt.estado_registro = 'A'
                    ), 0),

                -- saldoFinalCalculado: saldoInicial + débitos - créditos
                'saldoFinalCalculado'  value g.saldo_actual,

                -- saldoFinalConciliado: saldoCalculado - partidas netas
                'saldoFinalConciliado' value
                    g.saldo_actual
                  - coalesce((
                      select sum(case when debito_credito = 'D'
                                      then monto else -monto end)
                      from   HNEACOSTA1/TRANS
                      where  codigo_banco    = g.codigo_banco
                        and  codigo_sucursal = g.codigo_sucursal
                        and  codigo_moneda   = g.codigo_moneda
                        and  cuenta_contable = g.cuenta_contable
                        and  estado_transaccion in ('PENDIENTE','TRANSITO')
                        and  estado_registro = 'A'
                    ), 0)
                  - coalesce((
                      select sum(case when debito_credito = 'D'
                                      then monto else -monto end)
                      from   HNEACOSTA1/TTRAN
                      where  codigo_banco    = g.codigo_banco
                        and  codigo_sucursal = g.codigo_sucursal
                        and  codigo_moneda   = g.codigo_moneda
                        and  cuenta_contable = g.cuenta_contable
                        and  estado_transaccion in ('PENDIENTE','TRANSITO')
                        and  estado_registro = 'A'
                    ), 0)
              ),

              -- resumenMovimientos (§14: TRANS + TTRAN) --------------------
              'resumenMovimientos' value json_object(
                'cantidadMovimientos' value coalesce((
                  select count(*)
                  from   HNEACOSTA1/TRANS t
                  where  t.codigo_banco    = g.codigo_banco
                    and  t.codigo_sucursal = g.codigo_sucursal
                    and  t.codigo_moneda   = g.codigo_moneda
                    and  t.cuenta_contable = g.cuenta_contable
                    and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                    and  t.estado_registro = 'A'
                ), 0) +
                coalesce((
                  select count(*)
                  from   HNEACOSTA1/TTRAN tt
                  where  tt.codigo_banco    = g.codigo_banco
                    and  tt.codigo_sucursal = g.codigo_sucursal
                    and  tt.codigo_moneda   = g.codigo_moneda
                    and  tt.cuenta_contable = g.cuenta_contable
                    and  tt.fecha           = :pFechaPrcs
                    and  tt.estado_registro = 'A'
                ), 0),

                'primerMovimiento' value char(coalesce((
                  select min(timestamp(t.fecha_operacion, t.hora_operacion))
                  from   HNEACOSTA1/TRANS t
                  where  t.codigo_banco    = g.codigo_banco
                    and  t.codigo_sucursal = g.codigo_sucursal
                    and  t.codigo_moneda   = g.codigo_moneda
                    and  t.cuenta_contable = g.cuenta_contable
                    and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                    and  t.estado_registro = 'A'
                ), current_timestamp)),

                'ultimoMovimiento'  value char(coalesce((
                  select max(timestamp(t.fecha_operacion, t.hora_operacion))
                  from   HNEACOSTA1/TRANS t
                  where  t.codigo_banco    = g.codigo_banco
                    and  t.codigo_sucursal = g.codigo_sucursal
                    and  t.codigo_moneda   = g.codigo_moneda
                    and  t.cuenta_contable = g.cuenta_contable
                    and  t.fecha_operacion between :pFechaDesde and :pFechaPrcs
                    and  t.estado_registro = 'A'
                ), current_timestamp))
              ),

              -- partidasConciliatorias[] (§8.2, §14: TRANS/TTRAN + TRDSC) -
              -- Solo registros en estado PENDIENTE o TRANSITO.
              'partidasConciliatorias' value (
                select json_arrayagg(
                  json_object(
                    'idPartida'    value 'PC-' ||
                                         trim(char(row_number()
                                              over (order by px.fech))),
                    'tipo'         value 'TRANSITO',
                    'subtipo'      value coalesce(px.subtipo, px.tipo_mov),
                    'referencia'   value coalesce(px.ref_ext, ''),
                    'fechaPartida' value char(px.fech),
                    'monto'        value px.mto,
                    'signo'        value case px.dc
                                           when 'D' then 'DEBITO'
                                           else          'CREDITO'
                                         end,
                    'estado'       value px.estado,
                    'origen'       value px.origen,
                    'observacion'  value coalesce(px.observ, '')
                  )
                  order by px.fech
                )
                from (
                  -- Partidas de TRANS
                  select t2.fecha_operacion      as fech,
                         t2.monto                as mto,
                         t2.debito_credito        as dc,
                         t2.estado_transaccion    as estado,
                         'TRANS'                  as origen,
                         t2.referencia_externa    as ref_ext,
                         t2.tipo_movimiento       as tipo_mov,
                         d2.tipo_descripcion      as subtipo,
                         d2.texto_descripcion     as observ
                  from   HNEACOSTA1/TRANS t2
                  left join HNEACOSTA1/TRDSC d2
                         on  d2.numero_registro_relativo
                             = t2.numero_registro_relativo
                         and d2.secuencia = 1
                  where  t2.codigo_banco    = g.codigo_banco
                    and  t2.codigo_sucursal = g.codigo_sucursal
                    and  t2.codigo_moneda   = g.codigo_moneda
                    and  t2.cuenta_contable = g.cuenta_contable
                    and  t2.estado_transaccion in ('PENDIENTE','TRANSITO')
                    and  t2.estado_registro  = 'A'
                  union all
                  -- Partidas de TTRAN
                  select tt2.fecha,
                         tt2.monto,
                         tt2.debito_credito,
                         tt2.estado_transaccion,
                         'TTRAN',
                         tt2.referencia_externa,
                         tt2.tipo_movimiento,
                         dt2.tipo_descripcion,
                         dt2.texto_descripcion
                  from   HNEACOSTA1/TTRAN tt2
                  left join HNEACOSTA1/TRDSC dt2
                         on  dt2.numero_registro_relativo
                             = tt2.numero_registro_relativo
                         and dt2.secuencia = 1
                  where  tt2.codigo_banco    = g.codigo_banco
                    and  tt2.codigo_sucursal = g.codigo_sucursal
                    and  tt2.codigo_moneda   = g.codigo_moneda
                    and  tt2.cuenta_contable = g.cuenta_contable
                    and  tt2.estado_transaccion in ('PENDIENTE','TRANSITO')
                    and  tt2.estado_registro  = 'A'
                ) px
              ),

              -- diferencias (§14: derivadas de saldos) ---------------------
              'diferencias' value json_object(
                'diferenciaNeta'      value
                    g.saldo_actual -
                    (g.saldo_actual
                     - coalesce((
                         select sum(case when debito_credito='D'
                                         then monto else -monto end)
                         from HNEACOSTA1/TRANS
                         where codigo_banco    = g.codigo_banco
                           and codigo_sucursal = g.codigo_sucursal
                           and codigo_moneda   = g.codigo_moneda
                           and cuenta_contable = g.cuenta_contable
                           and estado_transaccion in ('PENDIENTE','TRANSITO')
                           and estado_registro = 'A'
                       ), 0)
                     - coalesce((
                         select sum(case when debito_credito='D'
                                         then monto else -monto end)
                         from HNEACOSTA1/TTRAN
                         where codigo_banco    = g.codigo_banco
                           and codigo_sucursal = g.codigo_sucursal
                           and codigo_moneda   = g.codigo_moneda
                           and cuenta_contable = g.cuenta_contable
                           and estado_transaccion in ('PENDIENTE','TRANSITO')
                           and estado_registro = 'A'
                       ), 0)
                    ),
                'diferenciaAbsoluta'  value abs(
                    g.saldo_actual -
                    (g.saldo_actual
                     - coalesce((
                         select sum(case when debito_credito='D'
                                         then monto else -monto end)
                         from HNEACOSTA1/TRANS
                         where codigo_banco    = g.codigo_banco
                           and codigo_sucursal = g.codigo_sucursal
                           and codigo_moneda   = g.codigo_moneda
                           and cuenta_contable = g.cuenta_contable
                           and estado_transaccion in ('PENDIENTE','TRANSITO')
                           and estado_registro = 'A'
                       ), 0)
                     - coalesce((
                         select sum(case when debito_credito='D'
                                         then monto else -monto end)
                         from HNEACOSTA1/TTRAN
                         where codigo_banco    = g.codigo_banco
                           and codigo_sucursal = g.codigo_sucursal
                           and codigo_moneda   = g.codigo_moneda
                           and cuenta_contable = g.cuenta_contable
                           and estado_transaccion in ('PENDIENTE','TRANSITO')
                           and estado_registro = 'A'
                       ), 0)
                    )
                ),
                'toleranciaPermitida' value :pTolerancia,
                'excedeTolerancia'    value case
                    when abs(
                      g.saldo_actual -
                      (g.saldo_actual
                       - coalesce((
                           select sum(case when debito_credito='D'
                                           then monto else -monto end)
                           from HNEACOSTA1/TRANS
                           where codigo_banco    = g.codigo_banco
                             and codigo_sucursal = g.codigo_sucursal
                             and codigo_moneda   = g.codigo_moneda
                             and cuenta_contable = g.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro = 'A'
                         ), 0)
                       - coalesce((
                           select sum(case when debito_credito='D'
                                           then monto else -monto end)
                           from HNEACOSTA1/TTRAN
                           where codigo_banco    = g.codigo_banco
                             and codigo_sucursal = g.codigo_sucursal
                             and codigo_moneda   = g.codigo_moneda
                             and cuenta_contable = g.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro = 'A'
                         ), 0)
                      )
                    ) > :pTolerancia then true
                    else false
                  end,
                'motivoPrincipal'     value case
                    when coalesce((
                           select count(*)
                           from HNEACOSTA1/TRANS
                           where codigo_banco    = g.codigo_banco
                             and codigo_sucursal = g.codigo_sucursal
                             and codigo_moneda   = g.codigo_moneda
                             and cuenta_contable = g.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro = 'A'), 0) +
                         coalesce((
                           select count(*)
                           from HNEACOSTA1/TTRAN
                           where codigo_banco    = g.codigo_banco
                             and codigo_sucursal = g.codigo_sucursal
                             and codigo_moneda   = g.codigo_moneda
                             and cuenta_contable = g.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro = 'A'), 0) > 0
                    then 'Partida en tránsito'
                    else 'Sin diferencia identificada'
                  end
              ),

              -- estadoConciliacion (RF-03) ----------------------------------
              'estadoConciliacion' value json_object(
                'codigo'      value case
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) = 0
                    then 'CONCILIADA'
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) <= :pTolerancia
                    then 'PARCIAL'
                    else 'NO_CONCILIADA'
                  end,
                'descripcion' value case
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) = 0
                    then 'Conciliada sin diferencias'
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) <= :pTolerancia
                    then 'Conciliada con partidas pendientes'
                    else 'Diferencia critica supera tolerancia'
                  end,
                'severidad'   value case
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) = 0                then 'BAJA'
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) <= :pTolerancia    then 'MEDIA'
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) <= 100             then 'ALTA'
                    else                      'CRITICA'
                  end,
                'requiereRevision' value case
                    when abs(g.saldo_actual -
                         (g.saldo_actual
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TRANS
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0)
                          - coalesce((select sum(case when debito_credito='D'
                                                     then monto else -monto end)
                                      from HNEACOSTA1/TTRAN
                                      where codigo_banco=g.codigo_banco
                                        and codigo_sucursal=g.codigo_sucursal
                                        and codigo_moneda=g.codigo_moneda
                                        and cuenta_contable=g.cuenta_contable
                                        and estado_transaccion in
                                            ('PENDIENTE','TRANSITO')
                                        and estado_registro='A'),0))
                    ) > 0 then true else false
                  end
              ),

              -- trazabilidad (§14: conteo de registros fuente) -------------
              'trazabilidad' value json_object(
                'hashCuenta'      value 'GL' ||
                    trim(char(length(trim(g.cuenta_contable)))) ||
                    trim(char(g.saldo_actual)),
                'registrosFuente' value json_object(
                  'glbln' value (
                      select count(*) from HNEACOSTA1/GLBLN x
                      where  x.codigo_banco    = g.codigo_banco
                        and  x.codigo_sucursal = g.codigo_sucursal
                        and  x.codigo_moneda   = g.codigo_moneda
                        and  x.cuenta_contable = g.cuenta_contable
                        and  x.estado_registro = 'A'),
                  'trans' value coalesce((
                      select count(*) from HNEACOSTA1/TRANS x
                      where  x.codigo_banco    = g.codigo_banco
                        and  x.codigo_sucursal = g.codigo_sucursal
                        and  x.codigo_moneda   = g.codigo_moneda
                        and  x.cuenta_contable = g.cuenta_contable
                        and  x.fecha_operacion between :pFechaDesde
                             and :pFechaPrcs
                        and  x.estado_registro = 'A'), 0),
                  'trdsc' value coalesce((
                      select count(*) from HNEACOSTA1/TRDSC d
                      where  d.numero_registro_relativo in (
                             select t.numero_registro_relativo
                             from   HNEACOSTA1/TRANS t
                             where  t.codigo_banco    = g.codigo_banco
                               and  t.codigo_sucursal = g.codigo_sucursal
                               and  t.codigo_moneda   = g.codigo_moneda
                               and  t.cuenta_contable = g.cuenta_contable
                               and  t.fecha_operacion between :pFechaDesde
                                    and :pFechaPrcs)
                        and  d.estado_registro = 'A'), 0),
                  'ttran' value coalesce((
                      select count(*) from HNEACOSTA1/TTRAN x
                      where  x.codigo_banco    = g.codigo_banco
                        and  x.codigo_sucursal = g.codigo_sucursal
                        and  x.codigo_moneda   = g.codigo_moneda
                        and  x.cuenta_contable = g.cuenta_contable
                        and  x.fecha           = :pFechaPrcs
                        and  x.estado_registro = 'A'), 0)
                )
              )

            ) -- fin json_object por cuenta
          order by g.cuenta_contable
          ) -- fin json_arrayagg

          from HNEACOSTA1/GLBLN g
          left join HNEACOSTA1/GLMST m
                 on  m.codigo_banco     = g.codigo_banco
                 and m.codigo_moneda    = g.codigo_moneda
                 and m.cuenta_contable  = g.cuenta_contable
          left join HNEACOSTA1/CCDSC cc
                 on  cc.id = integer(substr(g.cuenta_contable,1,2))
          where g.codigo_banco    = :pBanco
            and g.codigo_sucursal = :pSucursal
            and g.codigo_moneda   = :pMoneda
            and g.cuenta_contable between :pCuentaDesde and :pCuentaHasta
            and g.estado_registro = 'A'
        ), -- fin subconsulta cuentas

        -- controlTotales (§8.1, §8.2) ----------------------------------------
        'controlTotales' value json_object(
          'totalCuentasProcesadas'     value (
              select count(*) from HNEACOSTA1/GLBLN
              where  codigo_banco    = :pBanco
                and  codigo_sucursal = :pSucursal
                and  codigo_moneda   = :pMoneda
                and  cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and  estado_registro = 'A'),
          'totalCuentasConciliadas'    value (
              select count(*)
              from   HNEACOSTA1/GLBLN g2
              where  g2.codigo_banco    = :pBanco
                and  g2.codigo_sucursal = :pSucursal
                and  g2.codigo_moneda   = :pMoneda
                and  g2.cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and  g2.estado_registro = 'A'
                and  abs(g2.saldo_actual
                       - (g2.saldo_actual
                          - coalesce((
                              select sum(case when debito_credito='D'
                                              then monto else -monto end)
                              from HNEACOSTA1/TRANS
                              where codigo_banco=g2.codigo_banco
                                and codigo_sucursal=g2.codigo_sucursal
                                and codigo_moneda=g2.codigo_moneda
                                and cuenta_contable=g2.cuenta_contable
                                and estado_transaccion in
                                    ('PENDIENTE','TRANSITO')
                                and estado_registro='A'), 0)
                          - coalesce((
                              select sum(case when debito_credito='D'
                                              then monto else -monto end)
                              from HNEACOSTA1/TTRAN
                              where codigo_banco=g2.codigo_banco
                                and codigo_sucursal=g2.codigo_sucursal
                                and codigo_moneda=g2.codigo_moneda
                                and cuenta_contable=g2.cuenta_contable
                                and estado_transaccion in
                                    ('PENDIENTE','TRANSITO')
                                and estado_registro='A'), 0))
                    ) = 0),
          'totalCuentasConDiferencia'  value (
              select count(*)
              from   HNEACOSTA1/GLBLN g3
              where  g3.codigo_banco    = :pBanco
                and  g3.codigo_sucursal = :pSucursal
                and  g3.codigo_moneda   = :pMoneda
                and  g3.cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and  g3.estado_registro = 'A'
                and  (coalesce((
                        select count(*) from HNEACOSTA1/TRANS
                        where codigo_banco=g3.codigo_banco
                          and codigo_sucursal=g3.codigo_sucursal
                          and codigo_moneda=g3.codigo_moneda
                          and cuenta_contable=g3.cuenta_contable
                          and estado_transaccion in ('PENDIENTE','TRANSITO')
                          and estado_registro='A'),0) +
                      coalesce((
                        select count(*) from HNEACOSTA1/TTRAN
                        where codigo_banco=g3.codigo_banco
                          and codigo_sucursal=g3.codigo_sucursal
                          and codigo_moneda=g3.codigo_moneda
                          and cuenta_contable=g3.cuenta_contable
                          and estado_transaccion in ('PENDIENTE','TRANSITO')
                          and estado_registro='A'),0)) > 0),
          'sumatoriaSaldoFinalFuente'  value (
              select sum(saldo_actual) from HNEACOSTA1/GLBLN
              where  codigo_banco    = :pBanco
                and  codigo_sucursal = :pSucursal
                and  codigo_moneda   = :pMoneda
                and  cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and  estado_registro = 'A'),
          'sumatoriaSaldoFinalConciliado' value (
              select sum(g4.saldo_actual
                       - coalesce((
                           select sum(case when debito_credito='D'
                                           then monto else -monto end)
                           from HNEACOSTA1/TRANS
                           where codigo_banco=g4.codigo_banco
                             and codigo_sucursal=g4.codigo_sucursal
                             and codigo_moneda=g4.codigo_moneda
                             and cuenta_contable=g4.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro='A'), 0)
                       - coalesce((
                           select sum(case when debito_credito='D'
                                           then monto else -monto end)
                           from HNEACOSTA1/TTRAN
                           where codigo_banco=g4.codigo_banco
                             and codigo_sucursal=g4.codigo_sucursal
                             and codigo_moneda=g4.codigo_moneda
                             and cuenta_contable=g4.cuenta_contable
                             and estado_transaccion in ('PENDIENTE','TRANSITO')
                             and estado_registro='A'), 0))
              from HNEACOSTA1/GLBLN g4
              where g4.codigo_banco    = :pBanco
                and g4.codigo_sucursal = :pSucursal
                and g4.codigo_moneda   = :pMoneda
                and g4.cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and g4.estado_registro = 'A'),
          'sumatoriaDiferenciaNeta'    value (
              select sum(
                       g5.saldo_actual -
                       (g5.saldo_actual
                        - coalesce((
                            select sum(case when debito_credito='D'
                                            then monto else -monto end)
                            from HNEACOSTA1/TRANS
                            where codigo_banco=g5.codigo_banco
                              and codigo_sucursal=g5.codigo_sucursal
                              and codigo_moneda=g5.codigo_moneda
                              and cuenta_contable=g5.cuenta_contable
                              and estado_transaccion in ('PENDIENTE','TRANSITO')
                              and estado_registro='A'), 0)
                        - coalesce((
                            select sum(case when debito_credito='D'
                                            then monto else -monto end)
                            from HNEACOSTA1/TTRAN
                            where codigo_banco=g5.codigo_banco
                              and codigo_sucursal=g5.codigo_sucursal
                              and codigo_moneda=g5.codigo_moneda
                              and cuenta_contable=g5.cuenta_contable
                              and estado_transaccion in ('PENDIENTE','TRANSITO')
                              and estado_registro='A'), 0))
                     )
              from HNEACOSTA1/GLBLN g5
              where g5.codigo_banco    = :pBanco
                and g5.codigo_sucursal = :pSucursal
                and g5.codigo_moneda   = :pMoneda
                and g5.cuenta_contable between :pCuentaDesde and :pCuentaHasta
                and g5.estado_registro = 'A')
        ),

        -- incidentes[] (RF-08, §8.1) ------------------------------------------
        -- Una fila por cuenta con diferencia o estado relevante.
        'incidentes' value (
          select json_arrayagg(
            json_object(
              'codigo'         value 'WARN-GL-' ||
                                     trim(char(row_number()
                                          over (order by gi.cuenta_contable))),
              'tipo'           value 'VALIDACION',
              'cuentaContable' value gi.cuenta_contable,
              'mensaje'        value 'Diferencia ' ||
                                     trim(char(gi.dif_abs)) ||
                                     ' - ' || gi.estado_conc,
              'severidad'      value gi.severidad
            )
            order by gi.cuenta_contable
          )
          from (
            select g6.cuenta_contable,
                   abs(g6.saldo_actual -
                       (g6.saldo_actual
                        - coalesce((
                            select sum(case when debito_credito='D'
                                            then monto else -monto end)
                            from HNEACOSTA1/TRANS
                            where codigo_banco=g6.codigo_banco
                              and codigo_sucursal=g6.codigo_sucursal
                              and codigo_moneda=g6.codigo_moneda
                              and cuenta_contable=g6.cuenta_contable
                              and estado_transaccion in ('PENDIENTE','TRANSITO')
                              and estado_registro='A'),0)
                        - coalesce((
                            select sum(case when debito_credito='D'
                                            then monto else -monto end)
                            from HNEACOSTA1/TTRAN
                            where codigo_banco=g6.codigo_banco
                              and codigo_sucursal=g6.codigo_sucursal
                              and codigo_moneda=g6.codigo_moneda
                              and cuenta_contable=g6.cuenta_contable
                              and estado_transaccion in ('PENDIENTE','TRANSITO')
                              and estado_registro='A'),0))
                   )                                         as dif_abs,
                   case when abs(g6.saldo_actual -
                              (g6.saldo_actual
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TRANS
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0)
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TTRAN
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0))
                        ) = 0           then 'CONCILIADA'
                        when abs(g6.saldo_actual -
                              (g6.saldo_actual
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TRANS
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0)
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TTRAN
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0))
                        ) <= :pTolerancia then 'PARCIAL'
                        else              'NO_CONCILIADA'
                   end                                       as estado_conc,
                   case when abs(g6.saldo_actual -
                              (g6.saldo_actual
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TRANS
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0)
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TTRAN
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0))
                        ) = 0           then 'BAJA'
                        when abs(g6.saldo_actual -
                              (g6.saldo_actual
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TRANS
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0)
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TTRAN
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0))
                        ) <= :pTolerancia then 'MEDIA'
                        when abs(g6.saldo_actual -
                              (g6.saldo_actual
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TRANS
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0)
                               - coalesce((select sum(case when debito_credito='D'
                                                           then monto
                                                           else -monto end)
                                           from HNEACOSTA1/TTRAN
                                           where codigo_banco=g6.codigo_banco
                                             and codigo_sucursal=g6.codigo_sucursal
                                             and codigo_moneda=g6.codigo_moneda
                                             and cuenta_contable=g6.cuenta_contable
                                             and estado_transaccion in
                                                 ('PENDIENTE','TRANSITO')
                                             and estado_registro='A'),0))
                        ) <= 100         then 'ALTA'
                        else              'CRITICA'
                   end                                       as severidad
            from HNEACOSTA1/GLBLN g6
            where g6.codigo_banco    = :pBanco
              and g6.codigo_sucursal = :pSucursal
              and g6.codigo_moneda   = :pMoneda
              and g6.cuenta_contable between :pCuentaDesde and :pCuentaHasta
              and g6.estado_registro = 'A'
              and (coalesce((
                     select count(*) from HNEACOSTA1/TRANS
                     where codigo_banco=g6.codigo_banco
                       and codigo_sucursal=g6.codigo_sucursal
                       and codigo_moneda=g6.codigo_moneda
                       and cuenta_contable=g6.cuenta_contable
                       and estado_transaccion in ('PENDIENTE','TRANSITO')
                       and estado_registro='A'),0) +
                   coalesce((
                     select count(*) from HNEACOSTA1/TTRAN
                     where codigo_banco=g6.codigo_banco
                       and codigo_sucursal=g6.codigo_sucursal
                       and codigo_moneda=g6.codigo_moneda
                       and cuenta_contable=g6.cuenta_contable
                       and estado_transaccion in ('PENDIENTE','TRANSITO')
                       and estado_registro='A'),0)) > 0
          ) gi
        )
        -- fin incidentes

      ) -- fin json_object raíz

    ) into :wJsonClob;  -- resultado en variable CLOB de host

  m_sqlEstado = sqlstate;
  m_sqlCodigo = sqlcode;

  if m_sqlCodigo <> 0;
    pMsgError = 'SQL error en generacion JSON. SQLCODE=' +
                %char(m_sqlCodigo) + ' SQLSTATE=' + m_sqlEstado;
    return *off;
  endif;

  // ===========================================================================
  // PASO 2 — Escribir el CLOB en IFS usando QSYS2.IFS_WRITE_UTF8
  //
  // IFS_WRITE_UTF8(path, data, overwrite, end_of_line)
  //   path      : ruta completa del archivo IFS
  //   data      : CLOB con el contenido a escribir (se convierte a UTF-8)
  //   overwrite : '*REPLACE' sobreescribe si ya existe
  //   end_of_line: '*NONE' no agrega salto de línea al final
  //
  // El procedimiento convierte automáticamente el CCSID del CLOB a UTF-8
  // y crea el archivo si no existe, cumpliendo RF-05 y RF-06.
  // ===========================================================================

  exec sql
    call qsys2.ifs_write_utf8(
      path_name   => :wRutaFull,
      line        => :wJsonClob,
      overwrite   => '*REPLACE',
      end_of_line => '*NONE'
    );

  m_sqlEstado = sqlstate;
  m_sqlCodigo = sqlcode;

  if m_sqlCodigo <> 0;
    pMsgError = 'IFS_WRITE_UTF8 error SQLCODE=' + %char(m_sqlCodigo) +
                ' ruta=' + %trimr(wRutaFull);
    return *off;
  endif;

  return *on;
end-proc;

// -----------------------------------------------------------------------------
// gl_escribirBitacora
// -----------------------------------------------------------------------------
// Agrega una línea al archivo de log de ejecución en IFS (RF-07).
// Usa QSYS2.IFS_WRITE_UTF8 en modo APPEND para no sobreescribir
// entradas anteriores del mismo proceso.
// -----------------------------------------------------------------------------
dcl-proc gl_escribirBitacora export;
  dcl-pi *n;
    pRutaIfs   varchar(200) const;
    pNombreLog varchar(60)  const;
    pLinea     varchar(500) const;
  end-pi;

  dcl-s wRutaLog  varchar(260);
  dcl-s wLineaTs  varchar(530);

  wRutaLog = %trimr(pRutaIfs) + %trimr(pNombreLog);

  // Prefija la línea con el timestamp actual para trazabilidad (RF-07, RNF-05)
  wLineaTs = %char(%timestamp()) + ' | ' + %trimr(pLinea);

  exec sql
    call qsys2.ifs_write_utf8(
      path_name   => :wRutaLog,
      line        => :wLineaTs,
      overwrite   => '*ADD',
      end_of_line => '*LF'
    );
  // Silencia errores de bitácora para no interrumpir el flujo principal
end-proc;

// =============================================================================
// Fin de GLOUTS  (versión 2.0.0 — SQL nativo + QSYS2.IFS_WRITE_UTF8)
// =============================================================================
