      **free
// =============================================================================
// Programa principal  : GLRPT001
// Descripción         : Orquestador del proceso de conciliación GLBLN.
//                       Recibe parámetros, coordina los módulos de datos
//                       (GLDATA) y negocio (GLBIZN), y delega a GLOUTS la
//                       construcción completa del JSON via SQL y su escritura
//                       en IFS a través de QSYS2.IFS_WRITE_UTF8.
//
// Principio SOLID     : SRP — solo orquestación del flujo §7.2.
//                       OCP — extensión de reglas en GLBIZN sin tocar aquí.
//                       DIP — depende de contratos de módulos; no SQL ni IFS.
//
// RF cubiertos        : RF-01..RF-08 (todos, via delegación)
// §7.2 Flujo          : 1-Params → 2-Validar → 3-Tolera → 4-Log inicio →
//                       5-Construir JSON SQL → 6-Escribir IFS → 7-Log fin
//
// Parámetros          : §9 requerimientos_taller.md
// Artefacto           : Programa (*PGM)
// Módulo fuente       : GLRPT001.sqlrpgle
// Librería            : HNEACOSTA1
// Taller              : IBM i - Proceso CONCILIACION_GLBLN
// Fecha               : 2025-06-12
// Versión             : 2.0.0  (adaptado a GLOUTS v2 SQL-nativa)
//
// Compilar con:
//   CRTSQLRPGI OBJ(HNEACOSTA1/GLRPT001) SRCFILE(HNEACOSTA1/QRPGLESRC)
//              SRCMBR(GLRPT001) COMMIT(*NONE) DBGVIEW(*SOURCE)
//              BNDSRVPGM(HNEACOSTA1/GLUTIL)
//              BNDMOD(HNEACOSTA1/GLDATA HNEACOSTA1/GLBIZN HNEACOSTA1/GLOUTS)
// =============================================================================

/copy HNEACOSTA1/QRPGLESRC,GLDATA
/copy HNEACOSTA1/QRPGLESRC,GLBIZN
/copy HNEACOSTA1/QRPGLESRC,GLUTIL
/copy HNEACOSTA1/QRPGLESRC,GLOUTS

// =============================================================================
// PARÁMETROS DE ENTRADA — §9 requerimientos_taller.md
// =============================================================================
dcl-pi GLRPT001;
  pBanco        varchar(20)  const;   // RF-01: banco
  pSucursal     varchar(20)  const;   // RF-01: sucursal
  pMoneda       varchar(20)  const;   // RF-01: moneda
  pCuentaDesde  varchar(24)  const;   // RF-01: cuenta inicio rango
  pCuentaHasta  varchar(24)  const;   // RF-01: cuenta fin rango
  pFechaProceso date         const;   // RF-01: fecha de corte
  pRutaIfs      varchar(200) const;   // RF-06: ruta IFS destino
  pModo         char(4)      const;   // 'TEST' / 'PROD'
end-pi;

// =============================================================================
// Variables de orquestación
// =============================================================================

dcl-s wTsInicio       timestamp;
dcl-s wTsFin          timestamp;
dcl-s wFechaDesde     date;            // 1ro del mes de pFechaProceso

dcl-s wIdEjecucion    varchar(22);
dcl-s wCorrelativo    zoned(3:0) inz(1);

dcl-s wNombreJson     varchar(60);
dcl-s wNombreLog      varchar(60);

dcl-s wUsuario        varchar(30);
dcl-s wAmbiente       varchar(10);

dcl-s wMsgError       varchar(200);
dcl-s wParamsOk       ind;
dcl-s wJsonOk         ind;

dcl-s wTolerancia     packed(18:2) inz(1.00);
dcl-s wEstadoFinal    varchar(12);

// Para determinar estadoEjecucion usamos GLBIZN via un conjunto mínimo
// de incidentes técnicos (solo errores del propio orquestador)
dcl-ds wIncidentes    likeds(t_incidente) dim(10);
dcl-ds wIncTmp        likeds(t_incidente);
dcl-s  wCantInc       int(5)   inz(0);
dcl-s  wIncSeq        int(5)   inz(0);

// =============================================================================
// PASO 1 — Inicialización
// =============================================================================

wTsInicio   = %timestamp();
wFechaDesde = %date(
                %subst(%char(pFechaProceso:*iso):1:7) + '-01' : *iso);

exec sql values(current_user) into :wUsuario;

wIdEjecucion = gl_genIdEjecucion(
                 pFechaProceso :
                 %time(wTsInicio) :
                 wCorrelativo);

// Nombre de archivo JSON trazable (RF-06)
wNombreJson =
  'GLBLN_' +
  %subst(%char(pFechaProceso:*iso):1:4) +
  %subst(%char(pFechaProceso:*iso):6:2) +
  %subst(%char(pFechaProceso:*iso):9:2) + '_' +
  %subst(%char(%time(wTsInicio):*hms):1:2) +
  %subst(%char(%time(wTsInicio):*hms):4:2) +
  %subst(%char(%time(wTsInicio):*hms):7:2) + '_' +
  %editc(wCorrelativo:'X') + '.json';

// Nombre de bitácora (RF-07)
wNombreLog =
  'GLBLN_' +
  %subst(%char(pFechaProceso:*iso):1:4) +
  %subst(%char(pFechaProceso:*iso):6:2) +
  %subst(%char(pFechaProceso:*iso):9:2) + '_LOG.txt';

// Ambiente según modo de ejecución (§8.1 metadata.ambiente)
if %trimr(pModo) = 'PROD';
  wAmbiente = 'PRD';
elseif %trimr(pModo) = 'TEST';
  wAmbiente = 'QA';
else;
  wAmbiente = 'UAT';
endif;

// =============================================================================
// PASO 2 — Validar parámetros (RF-08, GLUTIL.gl_validarParams)
// =============================================================================

gl_escribirBitacora(pRutaIfs : wNombreLog :
  'INICIO | ' + wIdEjecucion +
  ' | BANCO='    + %trimr(pBanco)     +
  ' | SUCURSAL=' + %trimr(pSucursal)  +
  ' | MONEDA='   + %trimr(pMoneda)    +
  ' | DESDE='    + %trimr(pCuentaDesde) +
  ' | HASTA='    + %trimr(pCuentaHasta) +
  ' | FECHA='    + gl_fmtFecha(pFechaProceso) +
  ' | MODO='     + %trimr(pModo));

wParamsOk = gl_validarParams(
              pBanco : pSucursal : pMoneda :
              pCuentaDesde : pCuentaHasta :
              pFechaProceso : pRutaIfs :
              wMsgError);

if not wParamsOk;
  gl_escribirBitacora(pRutaIfs : wNombreLog :
    'ERROR | Parametros invalidos: ' + %trimr(wMsgError));
  *inlr = *on;
  return;
endif;

// =============================================================================
// PASO 3 — Leer tolerancia desde CNTRLCNT (§8.1 diferencias.toleranciaPermitida)
// =============================================================================

exec sql
  select valor_numerico
  into   :wTolerancia
  from   HNEACOSTA1/CNTRLCNT
  where  codigo_banco    = :pBanco
    and  descripcion     like '%oleran%'
    and  estado_registro = 'A'
  fetch first 1 rows only;

if sqlcode <> 0;
  wTolerancia = 1.00;  // default si no está parametrizado en CNTRLCNT
  gl_escribirBitacora(pRutaIfs : wNombreLog :
    'AVISO | Tolerancia no encontrada en CNTRLCNT; usando default 1.00');
endif;

// =============================================================================
// PASO 4 — Construir JSON completo via SQL y escribir en IFS
//          (GLOUTS.gl_generarJsonIfs — RF-05, RF-06)
//
//          Una sola llamada delega a GLOUTS toda la responsabilidad:
//            · Ejecuta la sentencia JSON_OBJECT / JSON_ARRAYAGG sobre
//              GLBLN, GLMST, CCDSC, TRANS, TTRAN, TRDSC.
//            · Obtiene el resultado como CLOB.
//            · Llama a QSYS2.IFS_WRITE_UTF8 para depositar el archivo.
// =============================================================================

gl_escribirBitacora(pRutaIfs : wNombreLog :
  'PROCESO | Construyendo JSON via SQL...');

wTsFin  = %timestamp();   // se pasa ahora; GLOUTS lo incluye en ejecucion.fechaHoraFin

// Determinar estadoEjecucion preliminar (sin incidentes de negocio aún,
// los incidentes detallados quedan dentro del JSON generado por GLOUTS)
wEstadoFinal = 'FINALIZADO';

wJsonOk = gl_generarJsonIfs(
            wIdEjecucion   :   // idEjecucion
            pFechaProceso  :   // fechaProceso
            wTsInicio      :   // fechaHoraInicio
            wTsFin         :   // fechaHoraFin
            %trimr(wUsuario) : // usuario
            'GLRPT001'     :   // programa
            'HNEACOSTA1'    :   // libreria
            wAmbiente      :   // ambiente
            pBanco         :   // contexto.banco
            pSucursal      :   // contexto.sucursal
            pMoneda        :   // contexto.moneda
            pCuentaDesde   :   // rangoCuentas.desde
            pCuentaHasta   :   // rangoCuentas.hasta
            wFechaDesde    :   // inicio período para TRANS/TTRAN
            wEstadoFinal   :   // estadoEjecucion
            wTolerancia    :   // diferencias.toleranciaPermitida
            pRutaIfs       :   // ruta IFS
            wNombreJson    :   // nombre archivo JSON
            wMsgError);        // output: error si falla

// =============================================================================
// PASO 5 — Evaluar resultado y registrar en bitácora (RF-07)
// =============================================================================

if not wJsonOk;
  // Registrar incidente técnico de IFS/SQL
  gl_generarIncidente(
    'N/A' : 'IFS' :
    'Fallo al generar o escribir JSON: ' + %trimr(wMsgError) :
    'CRITICA' : wIncTmp : wIncSeq);
  wCantInc += 1;
  wIncidentes(wCantInc) = wIncTmp;
  wEstadoFinal = 'ERROR';

  gl_escribirBitacora(pRutaIfs : wNombreLog :
    'ERROR | ' + %trimr(wMsgError));
else;
  gl_escribirBitacora(pRutaIfs : wNombreLog :
    'OK | JSON publicado en ' +
    %trimr(pRutaIfs) + %trimr(wNombreJson));
endif;

// =============================================================================
// PASO 6 — Resumen final en bitácora (RF-07, RNF-05)
// =============================================================================

wTsFin = %timestamp();

gl_escribirBitacora(pRutaIfs : wNombreLog :
  'FIN | ' + wIdEjecucion +
  ' | ESTADO='  + %trimr(wEstadoFinal) +
  ' | ARCHIVO=' + %trimr(wNombreJson)  +
  ' | DURACION_SEG=' +
    %char(%diff(wTsFin : wTsInicio : *seconds)));

*inlr = *on;

// =============================================================================
// Fin de GLRPT001  (versión 2.0.0)
// =============================================================================
