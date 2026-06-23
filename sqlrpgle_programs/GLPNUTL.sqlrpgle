**FREE
// ============================================================================
//  Modulo / *SRVPGM : GLPNUTL
//  Proyecto         : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
//  Descripcion      : Utilidades reutilizables del proceso de conciliacion:
//                     generacion de id de ejecucion, formateo ISO de fechas
//                     y timestamps, construccion de nombre de archivo y ruta
//                     IFS trazable, y bitacora de texto (objeto TXT en IFS).
//  Responsabilidad  : SRP -> solo utilitarios sin reglas de negocio ni acceso
//                     a tablas de datos del dominio. Reutilizable por cualquier
//                     capa (DIP).
//  Cumple           : RF-06 (nombre trazable), RF-07 (logging), RNF-05.
//  Hecho por        : Equipo Taller IBM i
//  Fecha            : 2026-05-19
// ============================================================================
ctl-opt nomain option(*srcstmt: *nodebugio) bnddir('SERVICES');
/define GLPNCPY_INCLUIDO
/include hneacosta2/qtxtsrc,glpncpy

// ----------------------------------------------------------------------------
//  utl_genIdEjecucion : genera 'YYYYMMDD_HHMMSS_NNN' (timestamp + correlativo).
//  Origen JSON        : ejecucion.idEjecucion  (Generado).
// ----------------------------------------------------------------------------
dcl-proc utl_genIdEjecucion export;
  dcl-pi *n varchar(30) end-pi;

  dcl-s wTs   timestamp;
  dcl-s wId   varchar(30);
  dcl-s wCorr packed(3:0) static;

  wTs   = %timestamp();
  wCorr += 1;
  if wCorr > 999;
    wCorr = 1;
  endif;

  // %char(date:*iso0) -> 'YYYYMMDD' ; %char(time:*hms0) -> 'HHMMSS'
  wId = %char(%date(wTs): *iso0) + '_'
      + %char(%time(wTs): *hms0) + '_'
      + %editc(wCorr: 'X');

  return wId;
end-proc;

// ----------------------------------------------------------------------------
//  utl_isoAhora : timestamp actual en 'YYYY-MM-DDThh:mm:ss'.
// ----------------------------------------------------------------------------
dcl-proc utl_isoAhora export;
  dcl-pi *n varchar(19) end-pi;
  return utl_isoTimestamp(%timestamp());
end-proc;

// ----------------------------------------------------------------------------
//  utl_isoTimestamp : convierte un timestamp a 'YYYY-MM-DDThh:mm:ss'.
//  Usado por        : ejecucion.fechaHoraInicio / fechaHoraFin.
// ----------------------------------------------------------------------------
dcl-proc utl_isoTimestamp export;
  dcl-pi *n varchar(19);
    pTimestamp timestamp value;
  end-pi;

  dcl-s wIso varchar(19);

  // %char(ts:*iso) -> 'YYYY-MM-DD-hh.mm.ss...' ; normalizamos a ISO con 'T'
  wIso = %subst(%char(%date(pTimestamp): *iso): 1: 10)
       + 'T'
       + %char(%time(pTimestamp): *hms);   // 'hh.mm.ss'
  wIso = %xlate('.': ':': wIso);           // 'hh:mm:ss'
  return wIso;
end-proc;

// ----------------------------------------------------------------------------
//  utl_nombreArchivo : nombre de archivo JSON trazable por ejecucion.
//  Patron            : concilia_glbln_<idEjecucion>.json  (RF-06).
// ----------------------------------------------------------------------------
dcl-proc utl_nombreArchivo export;
  dcl-pi *n varchar(120);
    pIdEjecucion varchar(30) const;
  end-pi;
  return 'concilia_glbln_' + %trim(pIdEjecucion) + '.json';
end-proc;

// ----------------------------------------------------------------------------
//  utl_construirRuta : compone ruta IFS = base + '/' + nombre (sin '//').
// ----------------------------------------------------------------------------
dcl-proc utl_construirRuta export;
  dcl-pi *n varchar(255);
    pRutaBase varchar(255) const;
    pNombre   varchar(120) const;
  end-pi;

  dcl-s wBase varchar(255);

  wBase = %trimr(pRutaBase);
  if wBase <> '' and %subst(wBase: %len(wBase): 1) = '/';
    wBase = %subst(wBase: 1: %len(wBase) - 1);
  endif;
  return wBase + '/' + %trim(pNombre);
end-proc;

// ----------------------------------------------------------------------------
//  utl_escribirLog : agrega una linea a una bitacora de texto en el IFS.
//  Medio            : QSYS2.IFS_WRITE_UTF8 con OVERWRITE 'APPEND' (RF-07).
// ----------------------------------------------------------------------------
dcl-proc utl_escribirLog export;
  dcl-pi *n ind;
    pRutaLog varchar(255) const;
    pTexto   varchar(500) const;
  end-pi;

  dcl-s wLinea varchar(540);

  wLinea = utl_isoAhora() + ' | ' + %trim(pTexto);

  exec sql
    CALL QSYS2.IFS_WRITE_UTF8(
           PATH_NAME   => :pRutaLog,
           LINE        => :wLinea,
           OVERWRITE   => 'APPEND',
           END_OF_LINE => 'CRLF');

  return (SQLCODE >= 0);
end-proc;
