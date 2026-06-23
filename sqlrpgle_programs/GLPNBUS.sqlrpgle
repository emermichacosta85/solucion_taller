**FREE
// ============================================================================
//  Modulo          : GLPNBUS
//  Proyecto        : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
//  Descripcion     : Reglas de negocio de la conciliacion. Clasifica el estado
//                    de cada cuenta, deriva severidad y partidas de revision,
//                    genera incidentes de auditoria y resuelve el estado global
//                    de ejecucion.
//  Responsabilidad : SRP -> solo reglas; NO accede a tablas ni IFS (DIP).
//                    OCP -> nuevas reglas se agregan sin tocar otras capas.
//                    Procedimientos puros y deterministas (testeables).
//  Cumple          : RF-03 (estado financiero), seccion 7 de Revision_IBMi.md
//                    (incidentes ALTA/CRITICA impactan estado de ejecucion).
//  Hecho por       : Equipo Taller IBM i
//  Fecha           : 2026-05-19
// ============================================================================
ctl-opt nomain option(*srcstmt: *nodebugio);

/define GLPNCPY_INCLUIDO
/include hneacosta2/qtxtsrc,glpncpy

// ----------------------------------------------------------------------------
//  bus_clasificarCuenta : asigna estado de conciliacion a partir de la
//  diferencia, la tolerancia y la existencia de partidas en transito.
//
//  Reglas (parametrizadas por tolerancia, seccion 8 de requerimientos_taller):
//    1) |diferencia| >  tolerancia        -> NO_CONCILIADA / ALTA  / revisar
//    2) |diferencia| <= tolerancia y
//       (diferencia<>0 o hay partidas)     -> PARCIAL       / MEDIA / revisar
//    3) diferencia=0 y sin partidas        -> CONCILIADA    / BAJA
// ----------------------------------------------------------------------------
dcl-proc bus_clasificarCuenta export;
  dcl-pi *n likeds(tClasif_t);
    pDifAbs        packed(18:2) const;
    pDifNeta       packed(18:2) const;
    pTol           packed(18:2) const;
    pTienePartidas ind value;
  end-pi;

  dcl-ds wClasif likeds(tClasif_t);

  if pDifAbs > pTol;
    wClasif.excedeTol   = CN_JSON_TRUE;*
    wClasif.estadoCod   = CN_EST_NO_CONCILIADA;
    wClasif.estadoDesc  = 'Diferencia excede la tolerancia permitida';
    wClasif.severidad   = CN_SEV_ALTA;
    wClasif.requiereRev = CN_JSON_TRUE;
    wClasif.motivo      = 'Diferencia fuera de tolerancia';

  elseif pDifAbs > 0 or pTienePartidas;
    wClasif.excedeTol   = CN_JSON_FALSE;
    wClasif.estadoCod   = CN_EST_PARCIAL;
    wClasif.estadoDesc  = 'Conciliada con partidas pendientes';
    wClasif.severidad   = CN_SEV_MEDIA;
    wClasif.requiereRev = CN_JSON_TRUE;
    wClasif.motivo      = 'Partida en transito';

  else;
    wClasif.excedeTol   = CN_JSON_FALSE;
    wClasif.estadoCod   = CN_EST_CONCILIADA;
    wClasif.estadoDesc  = 'Conciliada sin diferencias';
    wClasif.severidad   = CN_SEV_BAJA;
    wClasif.requiereRev = CN_JSON_FALSE;
    wClasif.motivo      = 'Sin diferencias';
  endif;

  return wClasif;
end-proc;

// ----------------------------------------------------------------------------
//  bus_incidenteCuenta : genera (o no) un incidente funcional para la cuenta
//  segun su clasificacion. Alimenta incidentes[] del JSON.
//
//  - NO_CONCILIADA -> ERR-GL-001  VALIDACION  ALTA
//  - PARCIAL       -> WARN-GL-002 VALIDACION  BAJA  (dentro de tolerancia)
//  - CONCILIADA    -> sin incidente
// ----------------------------------------------------------------------------
dcl-proc bus_incidenteCuenta export;
  dcl-pi *n likeds(tIncid_t);
    pClasif likeds(tClasif_t) const;
    pCuenta char(24) const;
  end-pi;

  dcl-ds wInc likeds(tIncid_t);

  clear wInc;
  wInc.cuenta = pCuenta;
  wInc.tipo   = 'VALIDACION';

  select;
    when pClasif.estadoCod = CN_EST_NO_CONCILIADA;
      wInc.hay       = *ON;
      wInc.codigo    = 'ERR-GL-001';
      wInc.mensaje   = 'Diferencia excede la tolerancia permitida';
      wInc.severidad = CN_SEV_ALTA;

    when pClasif.estadoCod = CN_EST_PARCIAL;
      wInc.hay       = *ON;
      wInc.codigo    = 'WARN-GL-002';
      wInc.mensaje   = 'Diferencia menor dentro de tolerancia';
      wInc.severidad = CN_SEV_BAJA;

    other;
      wInc.hay = *OFF;
  endsl;

  return wInc;
end-proc;

// ----------------------------------------------------------------------------
//  bus_estadoEjecucion : resuelve ejecucion.estadoEjecucion del JSON.
//
//  - error tecnico (lectura/IFS)        -> ERROR
//  - incidentes de severidad ALTA/CRIT  -> PARCIAL
//  - en otro caso                       -> FINALIZADO
// ----------------------------------------------------------------------------
dcl-proc bus_estadoEjecucion export;
  dcl-pi *n varchar(20);
    pIncidentesAltos int(10) value;
    pErrorTecnico    ind value;
  end-pi;

  if pErrorTecnico;
    return CN_EJE_ERROR;
  elseif pIncidentesAltos > 0;
    return CN_EJE_PARCIAL;
  endif;
  return CN_EJE_FINALIZADO;
end-proc;
