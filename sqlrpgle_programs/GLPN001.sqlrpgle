**FREE
// ============================================================================
//  Programa        : GLPN001
//  Proyecto        : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
//  Tipo            : Programa principal batch de orquestacion (SQLRPGLE).
//  Descripcion     : Coordina el proceso completo de conciliacion de cuentas
//                    mayores GLBLN para un banco/sucursal/moneda y un rango de
//                    cuentas en una fecha de proceso. Orquesta las capas:
//                       utilidades (GLCNUTL) -> acceso a datos (GLCNDAO)
//                       -> negocio (GLCNBUS) -> salida JSON/IFS (GLCNJSON)
//                    y produce el documento JSON de conciliacion en el IFS mas
//                    una bitacora de ejecucion trazable por idEjecucion.
//  Responsabilidad : SRP -> solo orquesta y controla el flujo; NO contiene SQL
//                    de dominio, reglas de negocio ni serializacion (delegados
//                    a cada modulo). DIP -> depende de los contratos de GLCNCPY.
//  Parametros      : seccion 9 de requerimientos_taller.md (todos opcionales;
//                    si llegan en blanco se aplican valores por defecto del
//                    contexto del taller: banco 01 / suc 001 / USD / rango 11*).
//  Cumple          : RF-01..RF-08, RNF-01..RNF-05, criterios de aceptacion 11.
//  Hecho por       : Equipo Taller IBM i
//  Fecha           : 2026-05-19
// ============================================================================
ctl-opt main(glpn001) option(*srcstmt: *nodebugio) dftactgrp(*no)
        actgrp(*new) bnddir('SERVICES');

/define GLPNCPY_INCLUIDO
/include hneacosta2/qtxtsrc,glpncpy

exec sql set option commit = *none, closqlcsr = *endmod,
                    datfmt = *iso, timfmt = *iso;

// Prototipo local (referencia anticipada del helper de parametros)
dcl-pr valorODefault varchar(255);
  pPresente ind   value;
  pValor    char(255) const;
  pDefault  varchar(255) const;
end-pr;

// ----------------------------------------------------------------------------
//  Procedimiento principal
// ----------------------------------------------------------------------------
dcl-proc glpn001;
  dcl-pi *n;
    pBanco      char(20) const options(*nopass);
    pSucursal   char(20) const options(*nopass);
    pMoneda     char(20) const options(*nopass);
    pCtaDesde   char(24) const options(*nopass);
    pCtaHasta   char(24) const options(*nopass);
    pFechaProc  char(10) const options(*nopass);
    pRutaIfs    char(255) const options(*nopass);
    pModo       char(10) const options(*nopass);
    pAmbiente   char(10) const options(*nopass);
    pTolerancia char(15) const options(*nopass);
  end-pi;

  dcl-ds wParam likeds(tParam_t);
  dcl-ds wCtx   likeds(tContexto_t);
  dcl-ds wTot   likeds(tTotales_t);
  dcl-ds wRow   likeds(tCtaRow_t);
  dcl-ds wClasif likeds(tClasif_t);
  dcl-ds wInc    likeds(tIncid_t);

  dcl-s wIdEje    varchar(30);
  dcl-s wRutaLog  varchar(255);
  dcl-s wRutaJson varchar(255);
  dcl-s wNumCtas  int(10);
  dcl-s wNumPart  int(10);
  dcl-s wError    ind inz(*OFF);
  dcl-s wMsg      varchar(500);

  dcl-s wUsuario  varchar(10);
  dcl-s wLibreria varchar(10);

  // Manejo de errores tecnico global: cualquier excepcion -> estado ERROR
  monitor;

    // --- 1. Identidad de la corrida ------------------------------------------
    wIdEje = utl_genIdEjecucion();

    // --- 2. Resolver parametros de ejecucion (con valores por defecto) -------
    clear wParam;
    wParam.banco      = valorODefault(%parms() >= 1: pBanco:      '01');
    wParam.sucursal   = valorODefault(%parms() >= 2: pSucursal:   '001');
    wParam.moneda     = valorODefault(%parms() >= 3: pMoneda:     'USD');
    wParam.ctaDesde   = valorODefault(%parms() >= 4: pCtaDesde:   '11000000');
    wParam.ctaHasta   = valorODefault(%parms() >= 5: pCtaHasta:   '11999999');
    wParam.fechaProc  = valorODefault(%parms() >= 6: pFechaProc:
                                      %char(%date(): *iso));
    wParam.rutaIfs    = valorODefault(%parms() >= 7: pRutaIfs:
                                      '/tmp/conciliacion');
    wParam.modo       = valorODefault(%parms() >= 8: pModo: 'PRODUCTIVO');
    wParam.ambiente   = valorODefault(%parms() >= 9: pAmbiente: 'QA');

    if %parms() >= 10 and %trim(pTolerancia) <> '';
      wParam.tolerancia = %dec(%trim(pTolerancia): 18: 2);
    else;
      wParam.tolerancia = 1.00;
    endif;

    // --- 3. Identidad de usuario y libreria (registros especiales SQL) -------
    exec sql VALUES (CURRENT_USER, CURRENT_SCHEMA)
               INTO :wUsuario, :wLibreria;

    // --- 4. Armar contexto de ejecucion (metadata/ejecucion/contexto JSON) ---
    clear wCtx;
    wCtx.idEjecucion     = wIdEje;
    wCtx.fechaProceso    = wParam.fechaProc;
    wCtx.fechaHoraInicio = utl_isoAhora();
    wCtx.usuario         = wUsuario;
    wCtx.libreria        = wLibreria;
    wCtx.fechaCorte      = wParam.fechaProc;
    wCtx.anio            = %int(%subst(wParam.fechaProc: 1: 4));
    wCtx.mes             = %int(%subst(wParam.fechaProc: 6: 2));

    // --- 5. Bitacora: inicio -------------------------------------------------
    wRutaLog = utl_construirRuta(wParam.rutaIfs: 'glcn001_' +
                                 %trim(wIdEje) + '.log');
    utl_escribirLog(wRutaLog: 'INICIO conciliacion GLBLN id=' +
                    %trim(wIdEje) + ' banco=' + %trim(wParam.banco) +
                    ' suc=' + %trim(wParam.sucursal) +
                    ' mon=' + %trim(wParam.moneda) +
                    ' rango=' + %trim(wParam.ctaDesde) + '..' +
                    %trim(wParam.ctaHasta));

    // --- 6. Preparar tablas de trabajo de sesion -----------------------------
    if not dao_prepararEntorno();
      wError = *ON;
      utl_escribirLog(wRutaLog: 'ERROR preparando entorno de trabajo');
    endif;

    // --- 7. Carga set-based de cuentas y partidas ----------------------------
    if not wError;
      wNumCtas = dao_cargarCuentas(wParam);
      if wNumCtas < 0;
        wError = *ON;
        utl_escribirLog(wRutaLog: 'ERROR en carga de cuentas');
      else;
        utl_escribirLog(wRutaLog: 'Cuentas cargadas: ' + %char(wNumCtas));
      endif;
    endif;

    if not wError;
      wNumPart = dao_cargarPartidas(wParam);
      if wNumPart < 0;
        wError = *ON;
        utl_escribirLog(wRutaLog: 'ERROR en carga de partidas');
      else;
        utl_escribirLog(wRutaLog: 'Partidas cargadas: ' + %char(wNumPart));
      endif;
    endif;

    // --- 8. Clasificacion cuenta por cuenta (negocio) ------------------------
    if not wError;
      if dao_cuentaOpen();
        dow dao_cuentaFetch(wRow);
          // 8.1 Reglas de conciliacion (modulo de negocio)
          wClasif = bus_clasificarCuenta(wRow.difAbs: wRow.difNeta:
                                         wRow.tolerancia:
                                         (wRow.cantPartidas > 0));
          // 8.2 Persistir clasificacion en la cuenta de trabajo
          dao_cuentaUpdateClasif(wRow.cuentaContable: wClasif);

          // 8.3 Generar incidente funcional si corresponde
          wInc = bus_incidenteCuenta(wClasif: wRow.cuentaContable);
          if wInc.hay;
            dao_insertarIncidente(wInc);
          endif;
        enddo;
        dao_cuentaClose();
      else;
        wError = *ON;
        utl_escribirLog(wRutaLog: 'ERROR abriendo cursor de cuentas');
      endif;
    endif;

    // --- 9. Totales globales de cuadratura -----------------------------------
    if not wError;
      if not dao_calcularTotales(wTot);
        wError = *ON;
        utl_escribirLog(wRutaLog: 'ERROR calculando control de totales');
      endif;
    endif;

    // --- 10. Estado global de la ejecucion (negocio) -------------------------
    wCtx.estadoEjecucion = bus_estadoEjecucion(wTot.incidentesAltos: wError);
    wCtx.fechaHoraFin    = utl_isoAhora();

    // --- 11. Generar y publicar el JSON en el IFS (via SQL) ------------------
    if not wError;
      if jsn_generarDocumento(wParam: wCtx: wTot: wRutaJson);
        utl_escribirLog(wRutaLog: 'JSON publicado en IFS: ' +
                        %trim(wRutaJson));
        // --- 12. Validacion estructural minima del JSON ---------------------
        if jsn_validarUltimo();
          utl_escribirLog(wRutaLog: 'Validacion estructural JSON: OK');
        else;
          utl_escribirLog(wRutaLog:
                          'ADVERTENCIA: validacion estructural JSON fallida');
        endif;
      else;
        wError = *ON;
        utl_escribirLog(wRutaLog: 'ERROR generando/escribiendo JSON');
      endif;
    endif;

    // --- 13. Resumen final ---------------------------------------------------
    wMsg = 'FIN estado=' + %trim(wCtx.estadoEjecucion) +
           ' cuentas=' + %char(wTot.totalCuentas) +
           ' conciliadas=' + %char(wTot.totalConciliadas) +
           ' conDif=' + %char(wTot.totalConDiferencia) +
           ' sumDifNeta=' + %char(wTot.sumDiferenciaNeta) +
           ' incidentesAltos=' + %char(wTot.incidentesAltos);
    utl_escribirLog(wRutaLog: wMsg);

  on-error;
    // Falla tecnica no controlada -> estado ERROR y bitacora
    wError = *ON;
    utl_escribirLog(wRutaLog: 'EXCEPCION tecnica no controlada (' +
                    %char(SQLCODE) + ')');
  endmon;

  return;
end-proc;

// ----------------------------------------------------------------------------
//  valorODefault : helper local. Si la condicion (parametro presente) es falsa
//  o el valor llega vacio, devuelve el valor por defecto recortado.
//  SRP local: centraliza la resolucion de parametros opcionales del taller.
// ----------------------------------------------------------------------------
dcl-proc valorODefault;
  dcl-pi *n varchar(255);
    pPresente ind   value;
    pValor    char(255) const;
    pDefault  varchar(255) const;
  end-pi;

  if pPresente and %trim(pValor) <> '';
    return %trim(pValor);
  endif;
  return %trim(pDefault);
end-proc;
