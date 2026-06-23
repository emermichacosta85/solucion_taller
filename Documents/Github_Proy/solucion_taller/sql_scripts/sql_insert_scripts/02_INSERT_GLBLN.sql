-- =============================================================================
-- Script  : 02_INSERT_GLBLN.sql
-- Módulo  : Contabilidad - Balances Generales
-- Propósito: Poblar GLBLN con los saldos fuente que el proceso de conciliación
--            lee, calcula y publica en JSON (RF-01, RF-02, RF-04).
--            Refleja el escenario del JSON de ejemplo del requerimiento:
--            · banco 01 / sucursal 001 / moneda USD
--            · periodo mayo 2026 / fecha corte 2026-05-19
--            · rango cuentas 11000000 – 11999999
--            · 20 cuentas procesadas del rango activo corriente
--
-- Depende : 01_INSERT_catalogos_base.sql (GLMST debe existir antes)
-- Tabla   : GLBLN
-- Taller  : IBM i - Proceso CONCILIACION_GLBLN
-- Fecha   : 2025-06-12
-- =============================================================================

INSERT INTO HNEACOSTA1/GLBLN (
    codigo_banco,
    codigo_sucursal,
    codigo_moneda,
    cuenta_contable,
    descripcion_cuenta,
    naturaleza_cuenta,
    nivel_cuenta,
    saldo_actual,
    fecha_proceso_sistema,
    observaciones,
    usuario_creacion,
    version_registro,
    estado_registro,
    created_at
) VALUES
-- -------------------------------------------------------------------------
-- Cuentas Nivel 4 — fuente primaria de conciliación
-- Saldo saldoFinalFuente del JSON: §8.1 saldos.saldoFinalFuente
-- -------------------------------------------------------------------------

-- 11010101 CAJA GENERAL — cuenta del ejemplo JSON (diferencia 0.50)
( '01', '001', 'USD', '11010101', 'CAJA GENERAL',
  'DEUDORA', '4',  125000.50,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010102 CAJA CHICA ADMINISTRATIVA — conciliada sin diferencia
( '01', '001', 'USD', '11010102', 'CAJA CHICA ADMINISTRATIVA',
  'DEUDORA', '4',    5000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010103 CAJA SUCURSAL NORTE — conciliada sin diferencia
( '01', '001', 'USD', '11010103', 'CAJA SUCURSAL NORTE',
  'DEUDORA', '4',   80000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010201 ENCAJE LEGAL BANCO CENTRAL — diferencia alta
( '01', '001', 'USD', '11010201', 'ENCAJE LEGAL BANCO CENTRAL',
  'DEUDORA', '4',  600005.00,
  '2026-05-19 23:59:59',
  'Diferencia pendiente por asiento de cierre', 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010202 DEPOSITO ORDINARIO BANCO CENTRAL — conciliada
( '01', '001', 'USD', '11010202', 'DEPOSITO ORDINARIO BANCO CENTRAL',
  'DEUDORA', '4',  600000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010301 DEPOSITO BANCO CORRESPONSAL LOCAL A — conciliada
( '01', '001', 'USD', '11010301', 'DEPOSITO BANCO CORRESPONSAL LOCAL A',
  'DEUDORA', '4',  400000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11010302 DEPOSITO BANCO CORRESPONSAL LOCAL B — diferencia media
( '01', '001', 'USD', '11010302', 'DEPOSITO BANCO CORRESPONSAL LOCAL B',
  'DEUDORA', '4',  400008.75,
  '2026-05-19 23:59:59',
  'Transaccion en transito fin de mes', 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11020101 BONOS DEL TESORO NACIONAL — conciliada
( '01', '001', 'USD', '11020101', 'BONOS DEL TESORO NACIONAL',
  'DEUDORA', '4', 1000000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11020102 LETRAS DEL BANCO CENTRAL — conciliada
( '01', '001', 'USD', '11020102', 'LETRAS DEL BANCO CENTRAL',
  'DEUDORA', '4', 1000000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11020201 — diferencia critica (excede tolerancia)
( '01', '001', 'USD', '11020201', 'ACCIONES SECTOR REAL',
  'DEUDORA', '4',  750025.00,
  '2026-05-19 23:59:59',
  'Diferencia critica identificada por auditoria', 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11020202 — conciliada
( '01', '001', 'USD', '11020202', 'ACCIONES SECTOR FINANCIERO',
  'DEUDORA', '4',  450000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11030101 CREDITOS VIGENTES CONSUMO — conciliada
( '01', '001', 'USD', '11030101', 'CREDITOS VIGENTES CONSUMO',
  'DEUDORA', '4',  900000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11030102 CREDITOS VIGENTES COMERCIALES — conciliada
( '01', '001', 'USD', '11030102', 'CREDITOS VIGENTES COMERCIALES',
  'DEUDORA', '4',  900000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11030201 CREDITOS EN MORA 30-60 DIAS — diferencia baja
( '01', '001', 'USD', '11030201', 'CREDITOS EN MORA 30-60 DIAS',
  'DEUDORA', '4',  325000.25,
  '2026-05-19 23:59:59',
  'Provision parcialmente aplicada', 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- 11030202 CREDITOS EN MORA MAS DE 60 DIAS — conciliada
( '01', '001', 'USD', '11030202', 'CREDITOS EN MORA MAS DE 60 DIAS',
  'DEUDORA', '4',  330000.00,
  '2026-05-19 23:59:59', NULL, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- Fin de script: 02_INSERT_GLBLN.sql
-- =============================================================================
