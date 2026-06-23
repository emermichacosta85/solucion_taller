**FREE
// ============================================================================
//  Modulo          : GLPNDAO
//  Proyecto        : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
//  Descripcion     : Capa de acceso a datos. Encapsula TODO el SQL contra las
//                    tablas fuente (GLBLN, GLMST, TRANS, TRDSC, TTRAN) y las
//                    tablas temporales de trabajo de sesion (SESSION.GLWRK*).
//                    Calcula de forma set-based los saldos, debitos/creditos,
//                    diferencias, conteos de trazabilidad y partidas.
//  Responsabilidad : SRP/DIP -> unica capa que conoce el modelo fisico; expone
//                    datos crudos a la capa de negocio. NO contiene reglas de
//                    clasificacion (esas viven en GLCNBUS).
//  Objetos creados : SESSION.GLWRKCTA / GLWRKPAR / GLWRKINC via DECLARE GLOBAL
//                    TEMPORARY TABLE (SQL DDL temporal -> sin PF/LF, seccion 14
//                    de Revision_IBMi.md).
//  Cumple          : RF-01, RF-02, RF-04; matriz seccion 14 requerimientos.
//  Hecho por       : Equipo Taller IBM i
//  Fecha           : 2026-05-19
// ============================================================================
ctl-opt nomain option(*srcstmt: *nodebugio);

/define GLPNCPY_INCLUIDO
/include hneacosta2/qtxtsrc,glpncpy

exec sql set option commit = *none, closqlcsr = *endmod,
                    datfmt = *iso, timfmt = *iso;

// ----------------------------------------------------------------------------
//  dao_prepararEntorno : declara las tablas temporales de trabajo de sesion.
//  Se invoca una sola vez por job antes de cargar datos.
// ----------------------------------------------------------------------------
dcl-proc dao_prepararEntorno export;
  dcl-pi *n ind end-pi;

  // --- Cuentas conciliadas (insumo principal de cuentas[] del JSON) ---
  exec sql
    DECLARE GLOBAL TEMPORARY TABLE SESSION.GLWRKCTA (
        cuentaContable    VARCHAR(24)   NOT NULL,
        codigoBanco       VARCHAR(20),
        codigoSucursal    VARCHAR(20),
        codigoMoneda      VARCHAR(20),
        descripcionCuenta VARCHAR(120),
        naturaleza        VARCHAR(20),
        nivelCuenta       INTEGER,
        centroCosto       VARCHAR(20),
        saldoInicial      DECIMAL(18, 2),
        debitosPeriodo    DECIMAL(18, 2),
        creditosPeriodo   DECIMAL(18, 2),
        saldoCalculado    DECIMAL(18, 2),
        saldoFuente       DECIMAL(18, 2),
        saldoConciliado   DECIMAL(18, 2),
        cantidadMov       INTEGER,
        primerMov         VARCHAR(19),
        ultimoMov         VARCHAR(19),
        difNeta           DECIMAL(18, 2),
        difAbs            DECIMAL(18, 2),
        tolerancia        DECIMAL(18, 2),
        excedeTol         VARCHAR(5),
        motivo            VARCHAR(120),
        estadoCod         VARCHAR(20),
        estadoDesc        VARCHAR(120),
        severidad         VARCHAR(10),
        requiereRev       VARCHAR(5),
        hashCuenta        VARCHAR(64),
        regGlbln          INTEGER,
        regTrans          INTEGER,
        regTrdsc          INTEGER,
        regTtran          INTEGER
    ) WITH REPLACE ON COMMIT PRESERVE ROWS;
  if SQLCODE < 0;
    return *OFF;
  endif;

  // --- Partidas conciliatorias (partidasConciliatorias[] del JSON) ---
  exec sql
    DECLARE GLOBAL TEMPORARY TABLE SESSION.GLWRKPAR (
        cuentaContable VARCHAR(24) NOT NULL,
        idPartida      VARCHAR(20),
        tipo           VARCHAR(20),
        subtipo        VARCHAR(40),
        referencia     VARCHAR(40),
        fechaPartida   VARCHAR(10),
        monto          DECIMAL(18, 2),
        signo          VARCHAR(10),
        estado         VARCHAR(20),
        origen         VARCHAR(20),
        observacion    VARCHAR(200),
        ordPartida     INTEGER
    ) WITH REPLACE ON COMMIT PRESERVE ROWS;
  if SQLCODE < 0;
    return *OFF;
  endif;

  // --- Incidentes (incidentes[] del JSON) ---
  exec sql
    DECLARE GLOBAL TEMPORARY TABLE SESSION.GLWRKINC (
        codigo         VARCHAR(20),
        tipo           VARCHAR(20),
        cuentaContable VARCHAR(24),
        mensaje        VARCHAR(200),
        severidad      VARCHAR(10),
        ordInc         INTEGER GENERATED ALWAYS AS IDENTITY
                       (START WITH 1 INCREMENT BY 1)
    ) WITH REPLACE ON COMMIT PRESERVE ROWS;

  return (SQLCODE >= 0);
end-proc;

// ----------------------------------------------------------------------------
//  dao_cargarCuentas : calcula y materializa una fila por cuenta mayor del
//  contexto con todos los escalares base (sin clasificacion).
//
//  Derivaciones (matriz seccion 14 de requerimientos_taller.md):
//    saldoInicial  = saldo_anterior del primer movimiento APLICADA (TRANS).
//    debitos/cred. = SUM por debito_credito en TRANS APLICADA.
//    saldoCalculado= saldoInicial + debitos - creditos.
//    saldoFuente   = GLBLN.saldo_actual.
//    saldoConcil.  = saldoCalculado (partidas en transito aun no aplicadas).
//    difNeta       = saldoFuente - saldoConciliado.
//    centroCosto   = derivado por prefijo de cuenta (regla del taller).
//    hashCuenta    = SHA-256 (25 hex) de campos clave -> integridad.
//  Devuelve la cantidad de cuentas cargadas.
// ----------------------------------------------------------------------------
dcl-proc dao_cargarCuentas export;
  dcl-pi *n int(10);
    pParam likeds(tParam_t) const;
  end-pi;

  dcl-s wBanco char(20);
  dcl-s wSuc   char(20);
  dcl-s wMon   char(20);
  dcl-s wDesde char(24);
  dcl-s wHasta char(24);
  dcl-s wTol   packed(18:2);
  dcl-s wCant  int(10);

  wBanco = pParam.banco;
  wSuc   = pParam.sucursal;
  wMon   = pParam.moneda;
  wDesde = pParam.ctaDesde;
  wHasta = pParam.ctaHasta;
  wTol   = pParam.tolerancia;

  exec sql
    INSERT INTO SESSION.GLWRKCTA
      (cuentaContable, codigoBanco, codigoSucursal, codigoMoneda,
       descripcionCuenta, naturaleza, nivelCuenta, centroCosto,
       saldoInicial, debitosPeriodo, creditosPeriodo, saldoCalculado,
       saldoFuente, saldoConciliado, cantidadMov, primerMov, ultimoMov,
       difNeta, difAbs, tolerancia, hashCuenta,
       regGlbln, regTrans, regTrdsc, regTtran)
    WITH mov AS (
       SELECT t.cuenta_contable AS cta,
              SUM(CASE WHEN t.debito_credito = 'D' THEN t.monto ELSE 0 END) AS deb,
              SUM(CASE WHEN t.debito_credito = 'C' THEN t.monto ELSE 0 END) AS cre,
              COUNT(*) AS cant,
              MIN(TIMESTAMP(t.fecha_operacion, t.hora_operacion)) AS pmin,
              MAX(TIMESTAMP(t.fecha_operacion, t.hora_operacion)) AS pmax
         FROM TRANS t
        WHERE t.codigo_banco    = :wBanco
          AND t.codigo_sucursal = :wSuc
          AND t.codigo_moneda   = :wMon
          AND t.cuenta_contable BETWEEN :wDesde AND :wHasta
          AND t.estado_transaccion = 'APLICADA'
          AND t.estado_registro    = 'A'
        GROUP BY t.cuenta_contable
    ),
    ini AS (
       SELECT cta, saldoIni FROM (
          SELECT t.cuenta_contable AS cta,
                 t.saldo_anterior  AS saldoIni,
                 ROW_NUMBER() OVER (
                    PARTITION BY t.cuenta_contable
                    ORDER BY t.fecha_operacion, t.hora_operacion) AS rn
            FROM TRANS t
           WHERE t.codigo_banco    = :wBanco
             AND t.codigo_sucursal = :wSuc
             AND t.codigo_moneda   = :wMon
             AND t.cuenta_contable BETWEEN :wDesde AND :wHasta
             AND t.estado_transaccion = 'APLICADA'
             AND t.estado_registro    = 'A'
       ) z WHERE z.rn = 1
    ),
    par AS (
       SELECT x.cuenta_contable AS cta, COUNT(*) AS cantPar
         FROM TTRAN x
        WHERE x.codigo_banco    = :wBanco
          AND x.codigo_sucursal = :wSuc
          AND x.codigo_moneda   = :wMon
          AND x.cuenta_contable BETWEEN :wDesde AND :wHasta
          AND x.estado_transaccion = 'PENDIENTE'
          AND x.estado_registro    = 'A'
        GROUP BY x.cuenta_contable
    ),
    trd AS (
       SELECT t.cuenta_contable AS cta, COUNT(*) AS cant
         FROM TRDSC d
         JOIN TRANS t
           ON t.numero_registro_relativo = d.numero_registro_relativo
        WHERE t.codigo_banco    = :wBanco
          AND t.codigo_sucursal = :wSuc
          AND t.codigo_moneda   = :wMon
          AND t.cuenta_contable BETWEEN :wDesde AND :wHasta
        GROUP BY t.cuenta_contable
    ),
    base AS (
       SELECT b.cuenta_contable AS cta,
              b.codigo_banco     AS ban,
              b.codigo_sucursal  AS suc,
              b.codigo_moneda    AS mon,
              COALESCE(m.descripcion_cuenta, b.descripcion_cuenta) AS descr,
              COALESCE(m.naturaleza_cuenta,  b.naturaleza_cuenta)  AS nat,
              INT(COALESCE(m.nivel_cuenta, b.nivel_cuenta))    AS niv,
              CASE WHEN b.cuenta_contable LIKE '1101%'
                     OR b.cuenta_contable LIKE '1102%' THEN 'CC001'
                   WHEN b.cuenta_contable LIKE '1103%' THEN 'CC002'
                   ELSE 'CC000' END                               AS cc,
              COALESCE(i.saldoIni, 0) AS sIni,
              COALESCE(mv.deb, 0)     AS deb,
              COALESCE(mv.cre, 0)     AS cre,
              b.saldo_actual          AS sFuente,
              COALESCE(mv.cant, 0)    AS cant,
              mv.pmin                 AS pmin,
              mv.pmax                 AS pmax,
              COALESCE(td.cant, 0)    AS nTrdsc,
              COALESCE(p.cantPar, 0)  AS nTtran
         FROM GLBLN b
         LEFT JOIN GLMST m
                ON m.codigo_banco    = b.codigo_banco
               AND m.codigo_moneda   = b.codigo_moneda
               AND m.cuenta_contable = b.cuenta_contable
         LEFT JOIN mov mv ON mv.cta = b.cuenta_contable
         LEFT JOIN ini i  ON i.cta  = b.cuenta_contable
         LEFT JOIN par p  ON p.cta  = b.cuenta_contable
         LEFT JOIN trd td ON td.cta = b.cuenta_contable
        WHERE b.codigo_banco    = :wBanco
          AND b.codigo_sucursal = :wSuc
          AND b.codigo_moneda   = :wMon
          AND b.cuenta_contable BETWEEN :wDesde AND :wHasta
          AND b.estado_registro = 'A'
    )
    SELECT cta, ban, suc, mon, descr, nat, niv, cc,
           sIni, deb, cre,
           (sIni + deb - cre)                       AS sCalc,
           sFuente,
           (sIni + deb - cre)                       AS sConc,
           cant,
           REPLACE(VARCHAR_FORMAT(pmin, 'YYYY-MM-DD HH24:MI:SS'), ' ', 'T'),
           REPLACE(VARCHAR_FORMAT(pmax, 'YYYY-MM-DD HH24:MI:SS'), ' ', 'T'),
           (sFuente - (sIni + deb - cre))           AS dNeta,
           ABS(sFuente - (sIni + deb - cre))        AS dAbs,
           :wTol,
           SUBSTR(LOWER(HEX(HASH_SHA256(
              ban CONCAT suc CONCAT mon CONCAT cta
                  CONCAT VARCHAR_FORMAT(sFuente)))), 1, 25),
           1, cant, nTrdsc, nTtran
      FROM base;

  if SQLCODE < 0;
    return -1;
  endif;
  wCant = SQLERRD(3);   // filas insertadas
  return wCant;
end-proc;

// ----------------------------------------------------------------------------
//  dao_cargarPartidas : materializa las partidas conciliatorias en transito
//  (TTRAN PENDIENTE) enriquecidas con subtipo/observacion de TRDSC (seq 2).
//  Genera idPartida correlativo 'PC-NNNN'.
//  Devuelve la cantidad de partidas cargadas.
// ----------------------------------------------------------------------------
dcl-proc dao_cargarPartidas export;
  dcl-pi *n int(10);
    pParam likeds(tParam_t) const;
  end-pi;

  dcl-s wBanco char(20);
  dcl-s wSuc   char(20);
  dcl-s wMon   char(20);
  dcl-s wDesde char(24);
  dcl-s wHasta char(24);

  wBanco = pParam.banco;
  wSuc   = pParam.sucursal;
  wMon   = pParam.moneda;
  wDesde = pParam.ctaDesde;
  wHasta = pParam.ctaHasta;

  exec sql
    INSERT INTO SESSION.GLWRKPAR
      (cuentaContable, idPartida, tipo, subtipo, referencia, fechaPartida,
       monto, signo, estado, origen, observacion, ordPartida)
    WITH p AS (
       SELECT x.cuenta_contable           AS cta,
              x.referencia_externa         AS ref,
              x.tipo_movimiento            AS tipoMov,
              x.debito_credito             AS dc,
              x.monto_transaccion          AS monto,
              VARCHAR_FORMAT(x.fecha_transaccion, 'YYYY-MM-DD') AS fpart,
              x.estado_transaccion         AS estado,
              x.numero_registro_relativo   AS nrr,
              ROW_NUMBER() OVER (
                 ORDER BY x.cuenta_contable, x.referencia_externa) AS rn
         FROM TTRAN x
        WHERE x.codigo_banco    = :wBanco
          AND x.codigo_sucursal = :wSuc
          AND x.codigo_moneda   = :wMon
          AND x.cuenta_contable BETWEEN :wDesde AND :wHasta
          AND x.estado_transaccion = 'PENDIENTE'
          AND x.estado_registro    = 'A'
    )
    SELECT p.cta,
           'PC-' CONCAT DIGITS(DECIMAL(p.rn, 4, 0)),
           CASE WHEN p.tipoMov = 'DEPOSITO' THEN 'TRANSITO'
                WHEN p.tipoMov = 'AJUSTE'   THEN 'AJUSTE'
                ELSE 'OTRO' END,
           COALESCE(d.tipo_descripcion, 'NA'),
           p.ref,
           p.fpart,
           p.monto,
           CASE WHEN p.dc = 'D' THEN 'DEBITO' ELSE 'CREDITO' END,
           p.estado,
           'TTRAN',
           COALESCE(d.texto_descripcion, 'Partida en transito'),
           p.rn
      FROM p
      LEFT JOIN TRDSC d
             ON d.numero_registro_relativo = p.nrr
            AND d.secuencia = 2
            AND d.tipo_descripcion IN ('DEPOSITO_NO_APLICADO', 'AJUSTE_PENDIENTE');

  if SQLCODE < 0;
    return -1;
  endif;
  return SQLERRD(3);
end-proc;

// ----------------------------------------------------------------------------
//  Cursor de recorrido de cuentas (procesar cada cuenta - flujo 7.2).
//  Solo expone los campos que necesita la capa de negocio para clasificar.
// ----------------------------------------------------------------------------
dcl-proc dao_cuentaOpen export;
  dcl-pi *n ind end-pi;

  exec sql
    DECLARE curCta CURSOR FOR
      SELECT cuentaContable, difNeta, difAbs, tolerancia, regTtran
        FROM SESSION.GLWRKCTA
       ORDER BY cuentaContable;
  exec sql OPEN curCta;
  return (SQLCODE >= 0);
end-proc;

dcl-proc dao_cuentaFetch export;
  dcl-pi *n ind;
    pRow likeds(tCtaRow_t);
  end-pi;
  dcl-s cuentaContable  char(24);
  dcl-s difNeta         packed(18:2);
  dcl-s difAbs          packed(18:2);
  dcl-s tolerancia      packed(18:2);
  dcl-s cantPartidas    int(10);
  exec sql
    FETCH curCta INTO :cuentaContable, :difNeta, :difAbs, :tolerancia, :cantPartidas;
  pRow.cuentaContable = cuentaContable;
  pRow.difNeta = difNeta;
  pRow.difAbs = difAbs;
  pRow.tolerancia = tolerancia;
  pRow.cantPartidas = cantPartidas;
  return (SQLCODE = 0);   // *ON mientras haya fila
end-proc;

dcl-proc dao_cuentaClose export;
  dcl-pi *n ind end-pi;
  exec sql CLOSE curCta;
  return (SQLCODE >= 0);
end-proc;

// ----------------------------------------------------------------------------
//  dao_cuentaUpdateClasif : persiste la clasificacion calculada por negocio.
// ----------------------------------------------------------------------------
dcl-proc dao_cuentaUpdateClasif export;
  dcl-pi *n ind;
    pCuenta char(24) const;
    pClasif likeds(tClasif_t) const;
  end-pi;

  dcl-s wCta   char(24);
  dcl-s wEstC  varchar(20);
  dcl-s wEstD  varchar(120);
  dcl-s wSev   varchar(10);
  dcl-s wReq   varchar(5);
  dcl-s wExc   varchar(5);
  dcl-s wMot   varchar(120);

  wCta  = pCuenta;
  wEstC = pClasif.estadoCod;
  wEstD = pClasif.estadoDesc;
  wSev  = pClasif.severidad;
  wReq  = pClasif.requiereRev;
  wExc  = pClasif.excedeTol;
  wMot  = pClasif.motivo;

  exec sql
    UPDATE SESSION.GLWRKCTA
       SET estadoCod   = :wEstC,
           estadoDesc  = :wEstD,
           severidad   = :wSev,
           requiereRev = :wReq,
           excedeTol   = :wExc,
           motivo      = :wMot
     WHERE cuentaContable = :wCta;

  return (SQLCODE >= 0);
end-proc;

// ----------------------------------------------------------------------------
//  dao_insertarIncidente : agrega un incidente a la tabla de trabajo.
// ----------------------------------------------------------------------------
dcl-proc dao_insertarIncidente export;
  dcl-pi *n ind;
    pInc likeds(tIncid_t) const;
  end-pi;

  dcl-s wCod char(20);
  dcl-s wTip char(20);
  dcl-s wCta char(24);
  dcl-s wMsg varchar(200);
  dcl-s wSev char(10);

  wCod = pInc.codigo;
  wTip = pInc.tipo;
  wCta = pInc.cuenta;
  wMsg = pInc.mensaje;
  wSev = pInc.severidad;

  exec sql
    INSERT INTO SESSION.GLWRKINC
      (codigo, tipo, cuentaContable, mensaje, severidad)
    VALUES (:wCod, :wTip, :wCta, :wMsg, :wSev);

  return (SQLCODE >= 0);
end-proc;

// ----------------------------------------------------------------------------
//  dao_calcularTotales : agrega los controlTotales globales del archivo
//  (cuadratura) a partir de la tabla de trabajo ya clasificada.
// ----------------------------------------------------------------------------
dcl-proc dao_calcularTotales export;
  dcl-pi *n ind;
    pTot likeds(tTotales_t);
  end-pi;
  dcl-s totalCuentas        int(10);
  dcl-s totalConciliadas    int(10);
  dcl-s totalConDiferencia  int(10);
  dcl-s sumFuente           packed(18:2);
  dcl-s sumConciliado       packed(18:2);
  dcl-s sumDiferenciaNeta   packed(18:2);
  dcl-s incidentesAltos     int(10);

  exec sql
    SELECT COUNT(*),
           COALESCE(SUM(CASE WHEN estadoCod = 'CONCILIADA'
                             THEN 1 ELSE 0 END), 0),
           COALESCE(SUM(CASE WHEN difNeta <> 0
                             THEN 1 ELSE 0 END), 0),
           COALESCE(SUM(saldoFuente), 0),
           COALESCE(SUM(saldoConciliado), 0),
           COALESCE(SUM(difNeta), 0)
      INTO :totalCuentas, :totalConciliadas,
           :totalConDiferencia, :sumFuente,
           :sumConciliado, :sumDiferenciaNeta
      FROM SESSION.GLWRKCTA;
 pTot.totalCuentas = totalCuentas;
 pTot.totalConciliadas = totalConciliadas;
 pTot.totalConDiferencia = totalConDiferencia;
 pTot.sumFuente = sumFuente;
 pTot.sumConciliado = sumConciliado;
 pTot.sumDiferenciaNeta = sumDiferenciaNeta;


  if SQLCODE < 0;
    return *OFF;
  endif;

  exec sql
    SELECT COALESCE(COUNT(*), 0)
      INTO :incidentesAltos
      FROM SESSION.GLWRKINC
     WHERE severidad IN ('ALTA', 'CRITICA');
pTot.incidentesAltos = incidentesAltos;

  return (SQLCODE >= 0);
end-proc;
