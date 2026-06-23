      **free
// =============================================================================
// Programa de Servicio : GLUTIL
// Descripción          : Utilidades reutilizables para el proceso de
//                        conciliación GLBLN. Provee procedimientos de
//                        formateo de importes, fechas, generación de hash
//                        ligero, construcción de fragmentos JSON y
//                        validación de parámetros de entrada.
//
// Principio SOLID      : SRP — una única responsabilidad: utilidades
//                        transversales sin lógica de negocio ni acceso a BD.
//                        ISP — contrato separado por contexto (fechas,
//                        importes, JSON, hash).
//                        DIP — no depende de tablas ni de módulos de negocio.
//
// Artefacto            : Programa de servicio (*SRVPGM)
// Módulo fuente        : GLUTIL.sqlrpgle  → CRTRPGMOD / CRTSRVPGM
// Librería             : HNEACOSTA1
// Taller               : IBM i - Proceso CONCILIACION_GLBLN
// Fecha                : 2025-06-12
// Versión              : 1.0.0
// =============================================================================

// --- Prototipos exportados --------------------------------------------------

// Formatea un decimal como cadena JSON (sin notación científica)
dcl-pr gl_fmtMonto       varchar(30) extproc('GL_FMTMONTO');
  pMonto                 packed(18:2) const;
end-pr;

// Formatea una fecha Date como 'YYYY-MM-DD'
dcl-pr gl_fmtFecha       varchar(10) extproc('GL_FMTFECHA');
  pFecha                 date const;
end-pr;

// Formatea fecha+hora como 'YYYY-MM-DDTHH:MM:SS'
dcl-pr gl_fmtTimestamp   varchar(19) extproc('GL_FMTTIMESTAMP');
  pTs                    timestamp const;
end-pr;

// Genera id de ejecución: YYYYMMDD_HHMMSS_NNN
dcl-pr gl_genIdEjecucion varchar(22) extproc('GL_GENIDEJECUCION');
  pFecha                 date    const;
  pHora                  time    const;
  pCorrelativo           zoned(3:0) const;
end-pr;

// Hash ligero de integridad (XOR sobre campos clave, hex 25 chars)
dcl-pr gl_hashCuenta     varchar(25) extproc('GL_HASHCUENTA');
  pBanco                 varchar(20) const;
  pSucursal              varchar(20) const;
  pMoneda                varchar(20) const;
  pCuenta                varchar(24) const;
  pSaldo                 packed(18:2) const;
end-pr;

// Escapa caracteres especiales JSON en una cadena
dcl-pr gl_jsonEscape     varchar(500) extproc('GL_JSONESCAPE');
  pTexto                 varchar(500) const;
end-pr;

// Par JSON string:  "clave":"valor"
dcl-pr gl_jsonStr        varchar(600) extproc('GL_JSONSTR');
  pClave                 varchar(50)  const;
  pValor                 varchar(500) const;
end-pr;

// Par JSON numérico: "clave":valor
dcl-pr gl_jsonNum        varchar(100) extproc('GL_JSONNUM');
  pClave                 varchar(50)  const;
  pValor                 packed(18:2) const;
end-pr;

// Par JSON boolean: "clave":true/false
dcl-pr gl_jsonBool       varchar(60)  extproc('GL_JSONBOOL');
  pClave                 varchar(50)  const;
  pValor                 ind          const;
end-pr;

// Par JSON entero: "clave":valor
dcl-pr gl_jsonInt        varchar(80)  extproc('GL_JSONINT');
  pClave                 varchar(50)  const;
  pValor                 int(10)      const;
end-pr;

// Valida parámetros de ejecución; retorna *on si válidos
dcl-pr gl_validarParams  ind          extproc('GL_VALIDARPARAMS');
  pBanco                 varchar(20)  const;
  pSucursal              varchar(20)  const;
  pMoneda                varchar(20)  const;
  pCuentaDesde           varchar(24)  const;
  pCuentaHasta           varchar(24)  const;
  pFechaProceso          date         const;
  pRutaIfs               varchar(200) const;
  pMsgError              varchar(200);        // output
end-pr;

// =============================================================================
// Implementaciones
// =============================================================================

// --- gl_fmtMonto -------------------------------------------------------------
dcl-proc gl_fmtMonto export;
  dcl-pi *n varchar(30);
    pMonto packed(18:2) const;
  end-pi;

  dcl-s wStr varchar(30);
  dcl-s wInt packed(18:0);
  dcl-s wDec packed(2:0);
  dcl-s wNeg ind;

  wNeg = (pMonto < 0);
  wInt = %abs(%int(pMonto));
  wDec = %abs(%rem(%dec(pMonto * 100 : 20 : 0) : 100));

  wStr = %char(wInt) + '.' +
         %editc(%dec(wDec:2:0) : 'X');   // always 2 decimal digits

  if wNeg;
    wStr = '-' + wStr;
  endif;

  return wStr;
end-proc;

// --- gl_fmtFecha -------------------------------------------------------------
dcl-proc gl_fmtFecha export;
  dcl-pi *n varchar(10);
    pFecha date const;
  end-pi;

  return %char(pFecha : *iso);   // yyyy-mm-dd
end-proc;

// --- gl_fmtTimestamp ---------------------------------------------------------
dcl-proc gl_fmtTimestamp export;
  dcl-pi *n varchar(19);
    pTs timestamp const;
  end-pi;

  dcl-s wStr varchar(26);
  wStr = %char(pTs : *iso);      // yyyy-mm-dd-hh.mm.ss.nnnnnn
  // Convertir al formato JSON ISO 8601: YYYY-MM-DDTHH:MM:SS
  return %subst(wStr:1:10) + 'T' +
         %subst(wStr:12:2) + ':' +
         %subst(wStr:15:2) + ':' +
         %subst(wStr:18:2);
end-proc;

// --- gl_genIdEjecucion -------------------------------------------------------
dcl-proc gl_genIdEjecucion export;
  dcl-pi *n varchar(22);
    pFecha       date      const;
    pHora        time      const;
    pCorrelativo zoned(3:0) const;
  end-pi;

  dcl-s wFecha  varchar(8);
  dcl-s wHora   varchar(6);
  dcl-s wCorr   varchar(3);

  wFecha = %subst(%char(pFecha:*iso):1:4) +
           %subst(%char(pFecha:*iso):6:2) +
           %subst(%char(pFecha:*iso):9:2);

  wHora  = %subst(%char(pHora:*iso):1:2) +
           %subst(%char(pHora:*iso):4:2) +
           %subst(%char(pHora:*iso):7:2);

  wCorr  = %editc(%dec(pCorrelativo:3:0):'X');

  return wFecha + '_' + wHora + '_' + wCorr;
end-proc;

// --- gl_hashCuenta -----------------------------------------------------------
// Hash ligero: combina longitudes y caracteres clave con XOR y convierte a hex.
// No es criptográfico; sirve para detección básica de tampering en el JSON.
dcl-proc gl_hashCuenta export;
  dcl-pi *n varchar(25);
    pBanco    varchar(20) const;
    pSucursal varchar(20) const;
    pMoneda   varchar(20) const;
    pCuenta   varchar(24) const;
    pSaldo    packed(18:2) const;
  end-pi;

  dcl-s wBase  varchar(200);
  dcl-s wHash  varchar(25);
  dcl-s wVal   int(10);
  dcl-s i      int(5);
  dcl-s wHex   char(16) inz('0123456789abcdef');

  wBase = pBanco + pSucursal + pMoneda + pCuenta + gl_fmtMonto(pSaldo);
  wVal  = %len(wBase) * 31;

  for i = 1 to %len(wBase);
    wVal = %bitxor(wVal * 17 : %inth(%subst(wBase:i:1)));
    if wVal < 0;
      wVal = %abs(wVal);
    endif;
  endfor;

  // Convierte entero a cadena hexadecimal de 25 chars (padding con ceros)
  wHash = '';
  dow %len(wHash) < 25;
    wHash = %subst(wHex : %rem(wVal:16)+1 : 1) + wHash;
    wVal  = wVal / 16;
    if wVal = 0 and %len(wHash) < 25;
      wHash = %subst(wHex:1:25-%len(wHash)) + wHash;
      leave;
    endif;
  enddo;

  return %subst(wHash:1:25);
end-proc;

// --- gl_jsonEscape -----------------------------------------------------------
dcl-proc gl_jsonEscape export;
  dcl-pi *n varchar(500);
    pTexto varchar(500) const;
  end-pi;

  dcl-s wOut varchar(500);
  dcl-s wCh  char(1);
  dcl-s i    int(5);

  wOut = '';
  for i = 1 to %len(%trimr(pTexto));
    wCh = %subst(pTexto:i:1);
    select;
      when wCh = '"';  wOut = %trimr(wOut) + '\"';
      when wCh = '\';  wOut = %trimr(wOut) + '\\';
      when wCh = x'15';  wOut = %trimr(wOut) + '\n';   // EBCDIC LF
      when wCh = x'0d';  wOut = %trimr(wOut) + '\r';
      other;           wOut = %trimr(wOut) + wCh;
    endsl;
  endfor;

  return %trimr(wOut);
end-proc;

// --- gl_jsonStr --------------------------------------------------------------
dcl-proc gl_jsonStr export;
  dcl-pi *n varchar(600);
    pClave varchar(50)  const;
    pValor varchar(500) const;
  end-pi;

  return '"' + %trimr(pClave) + '":"' +
         gl_jsonEscape(%trimr(pValor)) + '"';
end-proc;

// --- gl_jsonNum --------------------------------------------------------------
dcl-proc gl_jsonNum export;
  dcl-pi *n varchar(100);
    pClave varchar(50)  const;
    pValor packed(18:2) const;
  end-pi;

  return '"' + %trimr(pClave) + '":' + gl_fmtMonto(pValor);
end-proc;

// --- gl_jsonBool -------------------------------------------------------------
dcl-proc gl_jsonBool export;
  dcl-pi *n varchar(60);
    pClave varchar(50) const;
    pValor ind         const;
  end-pi;

  if pValor;
    return '"' + %trimr(pClave) + '":true';
  else;
    return '"' + %trimr(pClave) + '":false';
  endif;
end-proc;

// --- gl_jsonInt --------------------------------------------------------------
dcl-proc gl_jsonInt export;
  dcl-pi *n varchar(80);
    pClave varchar(50) const;
    pValor int(10)     const;
  end-pi;

  return '"' + %trimr(pClave) + '":' + %char(pValor);
end-proc;

// --- gl_validarParams --------------------------------------------------------
dcl-proc gl_validarParams export;
  dcl-pi *n ind;
    pBanco       varchar(20)  const;
    pSucursal    varchar(20)  const;
    pMoneda      varchar(20)  const;
    pCuentaDesde varchar(24)  const;
    pCuentaHasta varchar(24)  const;
    pFechaProceso date        const;
    pRutaIfs     varchar(200) const;
    pMsgError    varchar(200);
  end-pi;

  pMsgError = '';

  if %trimr(pBanco) = '';
    pMsgError = 'Parámetro BANCO es obligatorio.';
    return *off;
  endif;

  if %trimr(pSucursal) = '';
    pMsgError = 'Parámetro SUCURSAL es obligatorio.';
    return *off;
  endif;

  if %trimr(pMoneda) = '';
    pMsgError = 'Parámetro MONEDA es obligatorio.';
    return *off;
  endif;

  if %trimr(pCuentaDesde) = '' or %trimr(pCuentaHasta) = '';
    pMsgError = 'Rango de cuentas (DESDE/HASTA) es obligatorio.';
    return *off;
  endif;

  if pCuentaDesde > pCuentaHasta;
    pMsgError = 'CUENTA_DESDE no puede ser mayor que CUENTA_HASTA.';
    return *off;
  endif;

  if pFechaProceso > %date();
    pMsgError = 'FECHA_PROCESO no puede ser futura.';
    return *off;
  endif;

  if %trimr(pRutaIfs) = '';
    pMsgError = 'Parámetro RUTA_IFS es obligatorio.';
    return *off;
  endif;

  return *on;
end-proc;

// =============================================================================
// Fin de GLUTIL
// =============================================================================
