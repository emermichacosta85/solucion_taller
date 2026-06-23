**FREE
// ============================================================================
//  Modulo          : GLPNJSON
//  Proyecto        : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
//  Descripcion     : Capa de salida. Construye el documento JSON de
//                    conciliacion 100% mediante SQL (JSON_OBJECT /
//                    JSON_ARRAYAGG / FORMAT JSON) leyendo las tablas de
//                    trabajo de sesion (SESSION.GLWRK*) ya clasificadas, lo
//                    materializa en una variable CLOB y lo publica en el IFS
//                    con QSYS2.IFS_WRITE_UTF8 (UTF-8, CCSID 1208).
//  Responsabilidad : SRP -> solo serializacion y escritura IFS. DIP -> recibe
//                    el contrato de datos via las GTT y los host vars de
//                    contexto; no calcula reglas (viven en GLCNBUS) ni lee las
//                    tablas fisicas del dominio (eso es de GLCNDAO).
//  Estructura JSON : seccion 8.1 de requerimientos_taller.md (objetivo).
//  Cumple          : RF-04 (JSON via SQL), RF-05 (escritura IFS UTF-8),
//                    seccion 7 de Revision_IBMi.md (estructura minima).
//  Hecho por       : Equipo Taller IBM i
//  Fecha           : 2026-05-19
// ============================================================================
ctl-opt nomain option(*srcstmt: *nodebugio);

/define GLPNCPY_INCLUIDO
/include hneacosta2/qtxtsrc,glpncpy

exec sql set option commit = *none, closqlcsr = *endmod,
                    datfmt = *iso, timfmt = *iso;

// ----------------------------------------------------------------------------
//  Estado del modulo (DIP): el ultimo documento generado se conserva para que
//  jsn_validarUltimo pueda verificar su estructura sin volver a leer el IFS.
// ----------------------------------------------------------------------------
dcl-s g_ultimoJson sqltype(clob: 16000000);
dcl-s g_ultimaRuta varchar(255);

// ----------------------------------------------------------------------------
//  jsn_generarDocumento : arma el JSON raiz con un unico SELECT sobre
//  SYSIBM.SYSDUMMY1, combinando host vars (metadata/ejecucion/contexto/
//  controlTotales) con sub-consultas JSON_ARRAYAGG sobre las GTT (cuentas e
//  incidentes) y un sub-array correlacionado para partidasConciliatorias.
//  Luego escribe el CLOB resultante al IFS (REPLACE, sin EOL).
//  Devuelve *ON si genero y escribio correctamente; pRutaSalida = ruta final.
// ----------------------------------------------------------------------------
dcl-proc jsn_generarDocumento export;
  dcl-pi *n ind;
    pParam likeds(tParam_t)    const;
    pCtx   likeds(tContexto_t) const;
    pTot   likeds(tTotales_t)  const;
    pRutaSalida varchar(255);
  end-pi;

  // Host vars escalares (recortadas) para el encabezado del documento
  dcl-s wVer       varchar(10);
  dcl-s wSis       varchar(20);
  dcl-s wProc      varchar(30);
  dcl-s wCharset   varchar(10);
  dcl-s wAmbiente  varchar(10);
  dcl-s wIdEje     varchar(30);
  dcl-s wFProc     varchar(10);
  dcl-s wIni       varchar(19);
  dcl-s wFin       varchar(19);
  dcl-s wUsuario   varchar(10);
  dcl-s wPrograma  varchar(10);
  dcl-s wLibreria  varchar(10);
  dcl-s wEstadoEje varchar(20);
  dcl-s wBanco     varchar(20);
  dcl-s wSuc       varchar(20);
  dcl-s wMon       varchar(20);
  dcl-s wAnio      int(10);
  dcl-s wMes       int(10);
  dcl-s wFCorte    varchar(10);
  dcl-s wDesde     varchar(24);
  dcl-s wHasta     varchar(24);
  dcl-s wTotCta    int(10);
  dcl-s wTotConc   int(10);
  dcl-s wTotDif    int(10);
  dcl-s wSumFue    packed(18:2);
  dcl-s wSumConc   packed(18:2);
  dcl-s wSumDif    packed(18:2);
  dcl-s wRuta      varchar(255);

  // Mapear contrato -> host vars SQL (TRIM para no arrastrar relleno char)
  wVer       = CN_VERSION_ESTRUCTURA;
  wSis       = CN_SISTEMA_ORIGEN;
  wProc      = CN_PROCESO;
  wCharset   = CN_CHARSET;
  wAmbiente  = %trim(pParam.ambiente);
  wIdEje     = %trim(pCtx.idEjecucion);
  wFProc     = %trim(pCtx.fechaProceso);
  wIni       = %trim(pCtx.fechaHoraInicio);
  wFin       = %trim(pCtx.fechaHoraFin);
  wUsuario   = %trim(pCtx.usuario);
  wPrograma  = CN_PROGRAMA_PRINCIPAL;
  wLibreria  = %trim(pCtx.libreria);
  wEstadoEje = %trim(pCtx.estadoEjecucion);
  wBanco     = %trim(pParam.banco);
  wSuc       = %trim(pParam.sucursal);
  wMon       = %trim(pParam.moneda);
  wAnio      = pCtx.anio;
  wMes       = pCtx.mes;
  wFCorte    = %trim(pCtx.fechaCorte);
  wDesde     = %trim(pParam.ctaDesde);
  wHasta     = %trim(pParam.ctaHasta);
  wTotCta    = pTot.totalCuentas;
  wTotConc   = pTot.totalConciliadas;
  wTotDif    = pTot.totalConDiferencia;
  wSumFue    = pTot.sumFuente;
  wSumConc   = pTot.sumConciliado;
  wSumDif    = pTot.sumDiferenciaNeta;

  // --- Construccion del documento JSON completo mediante SQL ---
  //  Notas de sintaxis Db2 for i:
  //   * Objetos/arrays anidados ya formateados se insertan con FORMAT JSON.
  //   * Booleanos: las columnas excedeTol/requiereRev guardan 'true'/'false'
  //     y se emiten como booleano JSON real con FORMAT JSON.
  //   * Arrays potencialmente vacios -> COALESCE(..., JSON_ARRAY()) FORMAT JSON.
  exec sql
    SELECT JSON_OBJECT(
             'metadata' VALUE JSON_OBJECT(
                'versionEstructura' VALUE :wVer,
                'sistemaOrigen'     VALUE :wSis,
                'proceso'           VALUE :wProc,
                'ambiente'          VALUE :wAmbiente,
                'charset'           VALUE :wCharset
             ) FORMAT JSON,
             'ejecucion' VALUE JSON_OBJECT(
                'idEjecucion'     VALUE :wIdEje,
                'fechaProceso'    VALUE :wFProc,
                'fechaHoraInicio' VALUE :wIni,
                'fechaHoraFin'    VALUE :wFin,
                'usuario'         VALUE :wUsuario,
                'programa'        VALUE :wPrograma,
                'libreria'        VALUE :wLibreria,
                'estadoEjecucion' VALUE :wEstadoEje
             ) FORMAT JSON,
             'contexto' VALUE JSON_OBJECT(
                'banco'    VALUE :wBanco,
                'sucursal' VALUE :wSuc,
                'moneda'   VALUE :wMon,
                'periodo'  VALUE JSON_OBJECT(
                   'anio'       VALUE :wAnio,
                   'mes'        VALUE :wMes,
                   'fechaCorte' VALUE :wFCorte
                ) FORMAT JSON,
                'rangoCuentas' VALUE JSON_OBJECT(
                   'desde' VALUE :wDesde,
                   'hasta' VALUE :wHasta
                ) FORMAT JSON
             ) FORMAT JSON,
             'cuentas' VALUE COALESCE((
                SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                      'cuentaMayor' VALUE JSON_OBJECT(
                         'codigoBanco'       VALUE c.codigoBanco,
                         'codigoSucursal'    VALUE c.codigoSucursal,
                         'codigoMoneda'      VALUE c.codigoMoneda,
                         'cuentaContable'    VALUE c.cuentaContable,
                         'descripcionCuenta' VALUE c.descripcionCuenta,
                         'naturaleza'        VALUE c.naturaleza,
                         'nivelCuenta'       VALUE c.nivelCuenta,
                         'centroCosto'       VALUE c.centroCosto
                      ) FORMAT JSON,
                      'saldos' VALUE JSON_OBJECT(
                         'saldoInicial'         VALUE c.saldoInicial,
                         'debitosPeriodo'       VALUE c.debitosPeriodo,
                         'creditosPeriodo'      VALUE c.creditosPeriodo,
                         'saldoFinalCalculado'  VALUE c.saldoCalculado,
                         'saldoFinalFuente'     VALUE c.saldoFuente,
                         'saldoFinalConciliado' VALUE c.saldoConciliado
                      ) FORMAT JSON,
                      'resumenMovimientos' VALUE JSON_OBJECT(
                         'cantidadMovimientos' VALUE c.cantidadMov,
                         'primerMovimiento'    VALUE c.primerMov,
                         'ultimoMovimiento'    VALUE c.ultimoMov
                      ) FORMAT JSON,
                      'partidasConciliatorias' VALUE COALESCE((
                         SELECT JSON_ARRAYAGG(
                            JSON_OBJECT(
                               'idPartida'   VALUE p.idPartida,
                               'tipo'        VALUE p.tipo,
                               'subtipo'     VALUE p.subtipo,
                               'referencia'  VALUE p.referencia,
                               'fechaPartida' VALUE p.fechaPartida,
                               'monto'       VALUE p.monto,
                               'signo'       VALUE p.signo,
                               'estado'      VALUE p.estado,
                               'origen'      VALUE p.origen,
                               'observacion' VALUE p.observacion
                            )
                            ORDER BY p.ordPartida
                         )
                         FROM SESSION.GLWRKPAR p
                        WHERE p.cuentaContable = c.cuentaContable
                      ), JSON_ARRAY()) FORMAT JSON,
                      'diferencias' VALUE JSON_OBJECT(
                         'diferenciaNeta'      VALUE c.difNeta,
                         'diferenciaAbsoluta'  VALUE c.difAbs,
                         'toleranciaPermitida' VALUE c.tolerancia,
                         'excedeTolerancia'    VALUE c.excedeTol FORMAT JSON,
                         'motivoPrincipal'     VALUE c.motivo
                      ) FORMAT JSON,
                      'estadoConciliacion' VALUE JSON_OBJECT(
                         'codigo'          VALUE c.estadoCod,
                         'descripcion'     VALUE c.estadoDesc,
                         'severidad'       VALUE c.severidad,
                         'requiereRevision' VALUE c.requiereRev FORMAT JSON
                      ) FORMAT JSON,
                      'trazabilidad' VALUE JSON_OBJECT(
                         'hashCuenta' VALUE c.hashCuenta,
                         'registrosFuente' VALUE JSON_OBJECT(
                            'glbln' VALUE c.regGlbln,
                            'trans' VALUE c.regTrans,
                            'trdsc' VALUE c.regTrdsc,
                            'ttran' VALUE c.regTtran
                         ) FORMAT JSON
                      ) FORMAT JSON
                   )
                   ORDER BY c.cuentaContable
                )
                FROM SESSION.GLWRKCTA c
             ), JSON_ARRAY()) FORMAT JSON,
             'controlTotales' VALUE JSON_OBJECT(
                'totalCuentasProcesadas'        VALUE :wTotCta,
                'totalCuentasConciliadas'       VALUE :wTotConc,
                'totalCuentasConDiferencia'     VALUE :wTotDif,
                'sumatoriaSaldoFinalFuente'     VALUE :wSumFue,
                'sumatoriaSaldoFinalConciliado' VALUE :wSumConc,
                'sumatoriaDiferenciaNeta'       VALUE :wSumDif
             ) FORMAT JSON,
             'incidentes' VALUE COALESCE((
                SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                      'codigo'         VALUE i.codigo,
                      'tipo'           VALUE i.tipo,
                      'cuentaContable' VALUE i.cuentaContable,
                      'mensaje'        VALUE i.mensaje,
                      'severidad'      VALUE i.severidad
                   )
                   ORDER BY i.ordInc
                )
                FROM SESSION.GLWRKINC i
             ), JSON_ARRAY()) FORMAT JSON
           )
      INTO :g_ultimoJson
      FROM SYSIBM.SYSDUMMY1;

  if SQLCODE < 0;
    return *OFF;
  endif;

  // Ruta final de publicacion en el IFS
  wRuta = utl_construirRuta(pParam.rutaIfs:
                            utl_nombreArchivo(pCtx.idEjecucion));
  g_ultimaRuta = wRuta;
  pRutaSalida  = wRuta;

  // Publicacion del documento (UTF-8, reemplazo total, sin fin de linea)
  exec sql
    CALL QSYS2.IFS_WRITE_UTF8(
           PATH_NAME   => :wRuta,
           LINE        => :g_ultimoJson,
           OVERWRITE   => 'REPLACE',
           END_OF_LINE => 'NONE');

  return (SQLCODE >= 0);
end-proc;

// ----------------------------------------------------------------------------
//  jsn_validarUltimo : validacion estructural minima (seccion 7 de
//  Revision_IBMi.md). Verifica con JSON_EXISTS que el ultimo documento
//  generado contenga las seis claves obligatorias.
// ----------------------------------------------------------------------------
dcl-proc jsn_validarUltimo export;
  dcl-pi *n ind end-pi;

  dcl-s wOk int(10);

  exec sql
    SELECT CASE
             WHEN JSON_EXISTS(:g_ultimoJson, '$.metadata')
              AND JSON_EXISTS(:g_ultimoJson, '$.ejecucion')
              AND JSON_EXISTS(:g_ultimoJson, '$.contexto')
              AND JSON_EXISTS(:g_ultimoJson, '$.cuentas')
              AND JSON_EXISTS(:g_ultimoJson, '$.controlTotales')
              AND JSON_EXISTS(:g_ultimoJson, '$.incidentes')
             THEN 1 ELSE 0
           END
      INTO :wOk
      FROM SYSIBM.SYSDUMMY1;

  if SQLCODE < 0;
    return *OFF;
  endif;
  return (wOk = 1);
end-proc;
