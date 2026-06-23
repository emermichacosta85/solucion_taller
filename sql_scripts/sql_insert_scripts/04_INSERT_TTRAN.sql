-- =============================================================================
-- Script  : 04_INSERT_TTRAN.sql
-- Módulo  : Archivos Comunes - Transacciones del Día
-- Propósito: Poblar TTRAN con las transacciones intradiarias del 2026-05-19
--            que aún no han migrado a TRANS (histórico).
--            Son la fuente de:
--              · saldos.debitosPeriodo (complemento intradiario)     (§8.1)
--              · partidasConciliatorias[].origen = "TTRAN"            (§8.1)
--              · trazabilidad.registrosFuente.ttran = 10              (§8.1)
--              · RF-01 consulta conjunta TRANS+TTRAN por periodo
--
-- Depende : 02_INSERT_GLBLN.sql, 03_INSERT_TRANS_TRDSC.sql
-- Tabla   : TTRAN
-- Taller  : IBM i - Proceso CONCILIACION_GLBLN
-- Fecha   : 2025-06-12
-- =============================================================================

INSERT INTO HNEACOSTA1/TTRAN (
    id_transaccion_dia,
    numero_registro_relativo,
    codigo_banco,
    codigo_sucursal,
    codigo_moneda,
    cuenta_contable,
    numero_cuenta,
    id_cliente,
    fecha,
    fecha_valor,
    hora_operacion,
    tipo_movimiento,
    debito_credito,
    monto,
    saldo_anterior,
    saldo_posterior,
    canal_origen,
    terminal_origen,
    referencia_externa,
    estado_transaccion,
    usuario_creacion,
    version_registro,
    estado_registro,
    created_at
) VALUES

-- =========================================================================
-- Cuenta 11010101 — CAJA GENERAL
-- 10 transacciones del día 2026-05-19
-- Origen de partidasConciliatorias[0] (PC-0001, referencia DEP-884771)
-- trazabilidad.registrosFuente.ttran = 10
-- =========================================================================

-- Transacción pendiente principal (partida conciliatoria PC-0001 del JSON)
( 90001, 'RR-1004', '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-19', '2026-05-19', '11:45:00',
  'DEPOSITO_EFECTIVO', 'D',   500.50, 124999.50, 125500.00,
  'CAJA', 'TERM-001', 'DEP-884771', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Movimientos regulares del día aplicados
( 90002, NULL, '01', '001', 'USD', '11010101', '00110101002', 'CLI-00002',
  '2026-05-19', '2026-05-19', '08:30:00',
  'DEPOSITO_EFECTIVO', 'D',  1200.00, 123799.50, 124999.50,
  'CAJA', 'TERM-002', 'DEP-884700', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90003, NULL, '01', '001', 'USD', '11010101', '00110101003', 'CLI-00003',
  '2026-05-19', '2026-05-19', '09:10:00',
  'DEPOSITO_CHEQUE',   'D',  2500.00, 121299.50, 123799.50,
  'CAJA', 'TERM-003', 'DEP-884715', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90004, NULL, '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-19', '2026-05-19', '09:45:00',
  'RETIRO_EFECTIVO',   'C',   800.00, 122099.50, 121299.50,
  'CAJA', 'TERM-001', 'RET-884730', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90005, NULL, '01', '001', 'USD', '11010101', '00110101004', 'CLI-00004',
  '2026-05-19', '2026-05-19', '10:00:00',
  'DEPOSITO_EFECTIVO', 'D',  3000.00, 119099.50, 122099.50,
  'CAJA', 'TERM-001', 'DEP-884740', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90006, NULL, '01', '001', 'USD', '11010101', '00110101005', 'CLI-00005',
  '2026-05-19', '2026-05-19', '10:20:00',
  'RETIRO_EFECTIVO',   'C',  1500.00, 120599.50, 119099.50,
  'CAJA', 'TERM-002', 'RET-884745', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90007, NULL, '01', '001', 'USD', '11010101', '00110101006', 'CLI-00006',
  '2026-05-19', '2026-05-19', '10:55:00',
  'DEPOSITO_EFECTIVO', 'D',  2000.00, 118599.50, 120599.50,
  'CAJA', 'TERM-003', 'DEP-884755', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90008, NULL, '01', '001', 'USD', '11010101', '00110101007', 'CLI-00007',
  '2026-05-19', '2026-05-19', '11:10:00',
  'RETIRO_EFECTIVO',   'C',  2200.00, 120799.50, 118599.50,
  'CAJA', 'TERM-001', 'RET-884760', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90009, NULL, '01', '001', 'USD', '11010101', '00110101008', 'CLI-00008',
  '2026-05-19', '2026-05-19', '11:30:00',
  'DEPOSITO_CHEQUE',   'D',  1800.00, 118999.50, 120799.50,
  'CAJA', 'TERM-002', 'DEP-884765', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 90010, NULL, '01', '001', 'USD', '11010101', '00110101009', 'CLI-00009',
  '2026-05-19', '2026-05-19', '11:58:44',
  'RETIRO_EFECTIVO',   'C',   500.00, 119499.50, 118999.50,
  'CAJA', 'TERM-003', 'RET-884780', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- =========================================================================
-- Cuenta 11010201 — ENCAJE LEGAL (ajuste intradiario pendiente)
-- =========================================================================
( 90011, 'RR-2002', '01', '001', 'USD', '11010201', '00110102001', NULL,
  '2026-05-19', '2026-05-19', '23:55:00',
  'AJUSTE_ENCAJE',     'D',  5000.00, 600000.00, 605000.00,
  'BATCH', 'BATCH-01', 'AJE-20260519', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- =========================================================================
-- Cuenta 11010302 — DEPOSITO CORRESPONSAL (transferencia en tránsito)
-- =========================================================================
( 90012, 'RR-3001', '01', '001', 'USD', '11010302', '00110103002', NULL,
  '2026-05-19', '2026-05-19', '17:00:00',
  'TRANSFERENCIA_ENTRADA', 'D', 8750.00, 391250.00, 400000.00,
  'SWIFT', 'SWIFT-01', 'SWT-884400', 'TRANSITO',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- =========================================================================
-- Cuenta 11020201 — ACCIONES SECTOR REAL (valorización pendiente, critica)
-- =========================================================================
( 90013, 'RR-4001', '01', '001', 'USD', '11020201', '00112002001', NULL,
  '2026-05-19', '2026-05-19', '22:00:00',
  'VALORIZACION_MERCADO', 'D', 25000.00, 725000.00, 750000.00,
  'BATCH', 'BATCH-FIN', 'VAL-20260519', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- Fin de script: 04_INSERT_TTRAN.sql
-- =============================================================================
