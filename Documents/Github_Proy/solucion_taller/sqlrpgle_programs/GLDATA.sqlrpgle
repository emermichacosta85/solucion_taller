      **free
// =============================================================================
// Módulo              : GLDATA
// Descripción         : Capa de acceso a datos del proceso de conciliación.
//                       Encapsula todas las consultas SQL sobre GLBLN, GLMST,
//                       TRANS, TTRAN y TRDSC. El resto de módulos y el
//                       programa principal nunca acceden directamente a las
//                       tablas; lo hacen exclusivamente a través de este módulo.
//
// Principio SOLID     : SRP — solo acceso a datos, sin lógica de negocio.
//                       DIP — la capa de negocio depende de este contrato,
//                             no de las tablas directamente.
//                       ISP — procedimientos separados por entidad fuente.
//
// RF cubiertos        : RF-01 (consulta GLBLN con filtros configurables)
//                       RF-07 (conteo de registros para trazabilidad)
//
// Artefacto           : Módulo (*MODULE) enlazado al programa principal
// Módulo fuente       : GLDATA.sqlrpgle
// Librería            : HNEACOSTA1
// Taller              : IBM i - Proceso CONCILIACION_GLBLN
// Fecha               : 2025-06-12
// Versión             : 1.0.0
// =============================================================================

// --- Estructuras de datos compartidas (DS exportadas) -----------------------

// Registro de una cuenta mayor de GLBLN + GLMST
dcl-ds t_cuentaMayor  qualified  template;
  codigo_banco        varchar(20);
  codigo_sucursal     varchar(20);
  codigo_moneda       varchar(20);
  cuenta_contable     varchar(24);
  descripcion_cuenta  varchar(120);
  naturaleza_cuenta   varchar(20);
  nivel_cuenta        varchar(50);
  saldo_actual        packed(18:2);
  fecha_proceso       timestamp;
  centro_costo        varchar(20);   // derivado de CCDSC
end-ds;

// Totales de movimientos por cuenta (TRANS + TTRAN)
dcl-ds t_movimientos  qualified  template;
  cuenta_contable     varchar(24);
  debitos_periodo     packed(18:2);
  creditos_periodo    packed(18:2);
  cantidad_movimientos int(10);
  primer_movimiento   timestamp;
  ultimo_movimiento   timestamp;
  cnt_trans           int(10);   // registros leídos de TRANS
  cnt_ttran           int(10);   // registros leídos de TTRAN
end-ds;

// Partida conciliatoria individual
dcl-ds t_partida      qualified  template;
  id_partida          varchar(12);
  tipo                varchar(30);
  subtipo             varchar(50);
  referencia          varchar(40);
  fecha_partida       date;
  monto               packed(18:2);
  signo               varchar(6);    // DEBITO / CREDITO
  estado              varchar(15);
  origen              varchar(10);   // TRANS / TTRAN
  observacion         varchar(200);
  cnt_trdsc           int(5);        // descripciones relacionadas
end-ds;

// Contadores de trazabilidad por cuenta
dcl-ds t_trazFuente   qualified  template;
  cnt_glbln           int(10);
  cnt_trans           int(10);
  cnt_trdsc           int(10);
  cnt_ttran           int(10);
end-ds;

// =============================================================================
// Prototipos exportados
// =============================================================================

// Abre cursor de cuentas GLBLN con los filtros del proceso
dcl-pr gl_abrirCursorCuentas  ind   extproc('GL_ABRIR_CURSOR_CUENTAS');
  pBanco         varchar(20)  const;
  pSucursal      varchar(20)  const;
  pMoneda        varchar(20)  const;
  pCuentaDesde   varchar(24)  const;
  pCuentaHasta   varchar(24)  const;
  pFechaProceso  date         const;
end-pr;

// Lee la siguiente cuenta del cursor; retorna *off cuando no hay más
dcl-pr gl_leerSiguienteCuenta  ind   extproc('GL_LEER_SIGUIENTE_CUENTA');
  pReg           likeds(t_cuentaMayor);
end-pr;

// Cierra el cursor de cuentas
dcl-pr gl_cerrarCursorCuentas  extproc('GL_CERRAR_CURSOR_CUENTAS');
end-pr;

// Obtiene totales de movimientos TRANS + TTRAN para una cuenta y período
dcl-pr gl_obtenerMovimientos   ind   extproc('GL_OBTENER_MOVIMIENTOS');
  pBanco         varchar(20)  const;
  pSucursal      varchar(20)  const;
  pMoneda        varchar(20)  const;
  pCuenta        varchar(24)  const;
  pFechaDesde    date         const;
  pFechaHasta    date         const;
  pMov           likeds(t_movimientos);
end-pr;

// Obtiene partidas conciliatorias (PENDIENTE/TRANSITO) para una cuenta
dcl-pr gl_obtenerPartidas      ind   extproc('GL_OBTENER_PARTIDAS');
  pBanco         varchar(20)  const;
  pSucursal      varchar(20)  const;
  pMoneda        varchar(20)  const;
  pCuenta        varchar(24)  const;
  pPartidas      likeds(t_partida) dim(50);
  pCantidad      int(5);
end-pr;

// Obtiene contadores de trazabilidad de fuentes para una cuenta
dcl-pr gl_obtenerTrazFuente    ind   extproc('GL_OBTENER_TRAZFUENTE');
  pBanco         varchar(20)  const;
  pSucursal      varchar(20)  const;
  pMoneda        varchar(20)  const;
  pCuenta        varchar(24)  const;
  pFechaDesde    date         const;
  pFechaHasta    date         const;
  pTraz          likeds(t_trazFuente);
end-pr;

// =============================================================================
// Variables de módulo (cursor y estado)
// =============================================================================

dcl-s m_cursorAbierto  ind inz(*off);

// Parámetros de filtro guardados para el cursor
dcl-s m_banco         varchar(20);
dcl-s m_sucursal      varchar(20);
dcl-s m_moneda        varchar(20);
dcl-s m_cuentaDesde   varchar(24);
dcl-s m_cuentaHasta   varchar(24);
dcl-s m_fechaProceso  date;

// Contadores internos para el cursor
dcl-s m_partida_seq   int(5) inz(0);

// =============================================================================
// Implementaciones
// =============================================================================

// --- gl_abrirCursorCuentas ---------------------------------------------------
// RF-01: abre cursor sobre GLBLN con JOIN a GLMST para enriquecer
//        descripcion, naturaleza y nivel de la cuenta.
dcl-proc gl_abrirCursorCuentas export;
  dcl-pi *n ind;
    pBanco        varchar(20) const;
    pSucursal     varchar(20) const;
    pMoneda       varchar(20) const;
    pCuentaDesde  varchar(24) const;
    pCuentaHasta  varchar(24) const;
    pFechaProceso date        const;
  end-pi;

  if m_cursorAbierto;
    exec sql close crsCuentas;
    m_cursorAbierto = *off;
  endif;

  m_banco        = pBanco;
  m_sucursal     = pSucursal;
  m_moneda       = pMoneda;
  m_cuentaDesde  = pCuentaDesde;
  m_cuentaHasta  = pCuentaHasta;
  m_fechaProceso = pFechaProceso;

  // Cursor principal del proceso (RF-01)
  // JOIN con GLMST para obtener descripcion, naturaleza y nivel_cuenta
  // LEFT JOIN con CCDSC para centro de costo (campo derivado §14)
  exec sql
    declare crsCuentas cursor for
      select
          g.codigo_banco,
          g.codigo_sucursal,
          g.codigo_moneda,
          g.cuenta_contable,
          coalesce(m.descripcion_cuenta, g.descripcion_cuenta) as descripcion_cuenta,
          coalesce(m.naturaleza_cuenta,  g.naturaleza_cuenta)  as naturaleza_cuenta,
          coalesce(m.nivel_cuenta,       g.nivel_cuenta)       as nivel_cuenta,
          g.saldo_actual,
          g.fecha_proceso_sistema,
          coalesce(cast(c.id as varchar(20)), 'SIN_CC')        as centro_costo
      from   HNEACOSTA1/GLBLN g
      left join HNEACOSTA1/GLMST m
             on  m.codigo_banco     = g.codigo_banco
             and m.codigo_moneda    = g.codigo_moneda
             and m.cuenta_contable  = g.cuenta_contable
      left join HNEACOSTA1/CCDSC c
             on  c.id = cast(
                   substr(g.cuenta_contable, 1, 2)
                   as integer)
      where  g.codigo_banco        = :m_banco
        and  g.codigo_sucursal     = :m_sucursal
        and  g.codigo_moneda       = :m_moneda
        and  g.cuenta_contable     between :m_cuentaDesde and :m_cuentaHasta
        and  g.estado_registro     = 'A'
      order by g.cuenta_contable;

  exec sql open crsCuentas;

  if sqlcode <> 0;
    return *off;
  endif;

  m_cursorAbierto = *on;
  return *on;
end-proc;

// --- gl_leerSiguienteCuenta --------------------------------------------------
dcl-proc gl_leerSiguienteCuenta export;
  dcl-pi *n ind;
    pReg likeds(t_cuentaMayor);
  end-pi;

  exec sql
    fetch next from crsCuentas
    into :pReg.codigo_banco,
         :pReg.codigo_sucursal,
         :pReg.codigo_moneda,
         :pReg.cuenta_contable,
         :pReg.descripcion_cuenta,
         :pReg.naturaleza_cuenta,
         :pReg.nivel_cuenta,
         :pReg.saldo_actual,
         :pReg.fecha_proceso,
         :pReg.centro_costo;

  if sqlcode = 100;
    return *off;   // No more rows
  endif;

  return (sqlcode = 0);
end-proc;

// --- gl_cerrarCursorCuentas --------------------------------------------------
dcl-proc gl_cerrarCursorCuentas export;
  dcl-pi *n;
  end-pi;

  if m_cursorAbierto;
    exec sql close crsCuentas;
    m_cursorAbierto = *off;
  endif;
end-proc;

// --- gl_obtenerMovimientos ---------------------------------------------------
// RF-02: suma débitos y créditos del periodo desde TRANS y TTRAN.
// Matriz trazabilidad §14: debitosPeriodo, creditosPeriodo,
//   cantidadMovimientos, primerMovimiento, ultimoMovimiento.
dcl-proc gl_obtenerMovimientos export;
  dcl-pi *n ind;
    pBanco      varchar(20)  const;
    pSucursal   varchar(20)  const;
    pMoneda     varchar(20)  const;
    pCuenta     varchar(24)  const;
    pFechaDesde date         const;
    pFechaHasta date         const;
    pMov        likeds(t_movimientos);
  end-pi;

  dcl-s wDebTrans    packed(18:2);
  dcl-s wCreTrans    packed(18:2);
  dcl-s wCntTrans    int(10);
  dcl-s wPrimerTrans timestamp;
  dcl-s wUltimoTrans timestamp;

  dcl-s wDebTtran    packed(18:2);
  dcl-s wCreTtran    packed(18:2);
  dcl-s wCntTtran    int(10);
  dcl-s wPrimerTtran timestamp;
  dcl-s wUltimoTtran timestamp;

  // ---- TRANS: histórico del período
  exec sql
    select
      coalesce(sum(case when debito_credito = 'D' then monto else 0 end), 0),
      coalesce(sum(case when debito_credito = 'C' then monto else 0 end), 0),
      count(*),
      coalesce(min(timestamp(fecha_operacion, hora_operacion)),
               current_timestamp),
      coalesce(max(timestamp(fecha_operacion, hora_operacion)),
               current_timestamp)
    into :wDebTrans, :wCreTrans, :wCntTrans,
         :wPrimerTrans, :wUltimoTrans
    from HNEACOSTA1/TRANS
    where codigo_banco    = :pBanco
      and codigo_sucursal = :pSucursal
      and codigo_moneda   = :pMoneda
      and cuenta_contable = :pCuenta
      and fecha_operacion between :pFechaDesde and :pFechaHasta
      and estado_registro = 'A';

  // ---- TTRAN: transacciones del día
  exec sql
    select
      coalesce(sum(case when debito_credito = 'D' then monto else 0 end), 0),
      coalesce(sum(case when debito_credito = 'C' then monto else 0 end), 0),
      count(*),
      coalesce(min(timestamp(fecha, hora_operacion)), current_timestamp),
      coalesce(max(timestamp(fecha, hora_operacion)), current_timestamp)
    into :wDebTtran, :wCreTtran, :wCntTtran,
         :wPrimerTtran, :wUltimoTtran
    from HNEACOSTA1/TTRAN
    where codigo_banco    = :pBanco
      and codigo_sucursal = :pSucursal
      and codigo_moneda   = :pMoneda
      and cuenta_contable = :pCuenta
      and fecha           = :pFechaHasta    // solo día de corte
      and estado_registro = 'A';

  // Consolida TRANS + TTRAN
  pMov.cuenta_contable    = pCuenta;
  pMov.debitos_periodo    = wDebTrans  + wDebTtran;
  pMov.creditos_periodo   = wCreTrans  + wCreTtran;
  pMov.cantidad_movimientos = wCntTrans + wCntTtran;
  pMov.cnt_trans          = wCntTrans;
  pMov.cnt_ttran          = wCntTtran;

  // Primer y último movimiento: el mínimo/máximo entre ambas fuentes
  if wPrimerTrans <= wPrimerTtran;
    pMov.primer_movimiento = wPrimerTrans;
  else;
    pMov.primer_movimiento = wPrimerTtran;
  endif;

  if wUltimoTrans >= wUltimoTtran;
    pMov.ultimo_movimiento = wUltimoTrans;
  else;
    pMov.ultimo_movimiento = wUltimoTtran;
  endif;

  return *on;
end-proc;

// --- gl_obtenerPartidas ------------------------------------------------------
// Obtiene partidas PENDIENTE/TRANSITO de TRANS y TTRAN con descripción TRDSC.
// Matriz §14: tipo, subtipo, referencia, fechaPartida, monto, signo,
//             estado, origen, observacion.
dcl-proc gl_obtenerPartidas export;
  dcl-pi *n ind;
    pBanco    varchar(20)  const;
    pSucursal varchar(20)  const;
    pMoneda   varchar(20)  const;
    pCuenta   varchar(24)  const;
    pPartidas likeds(t_partida) dim(50);
    pCantidad int(5);
  end-pi;

  dcl-s wIdx      int(5)   inz(0);
  dcl-s wRef      varchar(40);
  dcl-s wFecha    date;
  dcl-s wMonto    packed(18:2);
  dcl-s wDC       char(1);
  dcl-s wEstado   varchar(20);
  dcl-s wOrigen   varchar(10);
  dcl-s wSubtipo  varchar(50);
  dcl-s wObserv   varchar(200);
  dcl-s wRegRel   varchar(30);

  pCantidad = 0;

  // Cursor partidas TRANS
  exec sql
    declare crsPartidas cursor for
      select
          t.referencia_externa,
          t.fecha_operacion,
          t.monto,
          t.debito_credito,
          t.estado_transaccion,
          'TRANS'                            as origen,
          coalesce(d.tipo_descripcion, t.tipo_movimiento) as subtipo,
          coalesce(d.texto_descripcion, t.observaciones)  as observacion,
          t.numero_registro_relativo
      from  HNEACOSTA1/TRANS t
      left join HNEACOSTA1/TRDSC d
             on  d.numero_registro_relativo = t.numero_registro_relativo
             and d.secuencia = 1
      where t.codigo_banco    = :pBanco
        and t.codigo_sucursal = :pSucursal
        and t.codigo_moneda   = :pMoneda
        and t.cuenta_contable = :pCuenta
        and t.estado_transaccion in ('PENDIENTE', 'TRANSITO')
        and t.estado_registro  = 'A'
      union all
      select
          tt.referencia_externa,
          tt.fecha,
          tt.monto,
          tt.debito_credito,
          tt.estado_transaccion,
          'TTRAN',
          coalesce(d2.tipo_descripcion, tt.tipo_movimiento),
          coalesce(d2.texto_descripcion, tt.observaciones),
          tt.numero_registro_relativo
      from  HNEACOSTA1/TTRAN tt
      left join HNEACOSTA1/TRDSC d2
             on  d2.numero_registro_relativo = tt.numero_registro_relativo
             and d2.secuencia = 1
      where tt.codigo_banco    = :pBanco
        and tt.codigo_sucursal = :pSucursal
        and tt.codigo_moneda   = :pMoneda
        and tt.cuenta_contable = :pCuenta
        and tt.estado_transaccion in ('PENDIENTE', 'TRANSITO')
        and tt.estado_registro  = 'A'
      order by fecha_operacion;

  exec sql open crsPartidas;

  dow sqlcode = 0 and wIdx < 50;
    exec sql
      fetch next from crsPartidas
      into :wRef, :wFecha, :wMonto, :wDC,
           :wEstado, :wOrigen, :wSubtipo, :wObserv, :wRegRel;

    if sqlcode <> 0;
      leave;
    endif;

    wIdx += 1;
    m_partida_seq += 1;

    pPartidas(wIdx).id_partida   = 'PC-' + %editc(%dec(m_partida_seq:4:0):'X');
    pPartidas(wIdx).tipo         = 'TRANSITO';
    pPartidas(wIdx).subtipo      = %trimr(wSubtipo);
    pPartidas(wIdx).referencia   = %trimr(wRef);
    pPartidas(wIdx).fecha_partida = wFecha;
    pPartidas(wIdx).monto        = wMonto;
    pPartidas(wIdx).signo        = %trimr(
        %xlate('DC':'DEBITO   CREDITO  ':wDC));
    if wDC = 'D';
      pPartidas(wIdx).signo = 'DEBITO';
    else;
      pPartidas(wIdx).signo = 'CREDITO';
    endif;
    pPartidas(wIdx).estado       = %trimr(wEstado);
    pPartidas(wIdx).origen       = %trimr(wOrigen);
    pPartidas(wIdx).observacion  = %trimr(wObserv);

    // Contar descripciones TRDSC relacionadas (§14 trazabilidad.trdsc)
    exec sql
      select count(*) into :pPartidas(wIdx).cnt_trdsc
      from HNEACOSTA1/TRDSC
      where numero_registro_relativo = :wRegRel;
  enddo;

  exec sql close crsPartidas;

  pCantidad = wIdx;
  return *on;
end-proc;

// --- gl_obtenerTrazFuente ----------------------------------------------------
// RF-07: conteo de registros por fuente para trazabilidad del JSON.
dcl-proc gl_obtenerTrazFuente export;
  dcl-pi *n ind;
    pBanco      varchar(20) const;
    pSucursal   varchar(20) const;
    pMoneda     varchar(20) const;
    pCuenta     varchar(24) const;
    pFechaDesde date        const;
    pFechaHasta date        const;
    pTraz       likeds(t_trazFuente);
  end-pi;

  // GLBLN
  exec sql
    select count(*) into :pTraz.cnt_glbln
    from HNEACOSTA1/GLBLN
    where codigo_banco    = :pBanco
      and codigo_sucursal = :pSucursal
      and codigo_moneda   = :pMoneda
      and cuenta_contable = :pCuenta
      and estado_registro = 'A';

  // TRANS
  exec sql
    select count(*) into :pTraz.cnt_trans
    from HNEACOSTA1/TRANS
    where codigo_banco    = :pBanco
      and codigo_sucursal = :pSucursal
      and codigo_moneda   = :pMoneda
      and cuenta_contable = :pCuenta
      and fecha_operacion between :pFechaDesde and :pFechaHasta
      and estado_registro = 'A';

  // TRDSC (via TRANS)
  exec sql
    select count(d.numero_registro_relativo)
    into   :pTraz.cnt_trdsc
    from   HNEACOSTA1/TRDSC d
    where  d.numero_registro_relativo in (
           select t.numero_registro_relativo
           from   HNEACOSTA1/TRANS t
           where  t.codigo_banco    = :pBanco
             and  t.codigo_sucursal = :pSucursal
             and  t.codigo_moneda   = :pMoneda
             and  t.cuenta_contable = :pCuenta
             and  t.fecha_operacion between :pFechaDesde and :pFechaHasta)
      and  d.estado_registro = 'A';

  // TTRAN
  exec sql
    select count(*) into :pTraz.cnt_ttran
    from HNEACOSTA1/TTRAN
    where codigo_banco    = :pBanco
      and codigo_sucursal = :pSucursal
      and codigo_moneda   = :pMoneda
      and cuenta_contable = :pCuenta
      and fecha           = :pFechaHasta
      and estado_registro = 'A';

  return *on;
end-proc;

// =============================================================================
// Fin de GLDATA
// =============================================================================
