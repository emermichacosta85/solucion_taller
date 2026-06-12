-- =============================================================================
-- Script  : 03_INSERT_TRANS_TRDSC.sql
-- Módulo  : Archivos Comunes - Histórico de Transacciones
-- Propósito: Poblar TRANS con los movimientos del periodo 2026-05-01 al
--            2026-05-19 y TRDSC con sus descripciones adicionales.
--            Son la fuente de:
--              · saldos.debitosPeriodo / creditosPeriodo       (RF-02, §8.1)
--              · resumenMovimientos (cantidad, primer, último)  (§8.1)
--              · partidasConciliatorias.referencia / monto      (§8.1, reglas §8.2)
--              · trazabilidad.registrosFuente.trans / trdsc     (§8.1)
--
-- Depende : 02_INSERT_GLBLN.sql (cuenta_contable debe existir en GLMST)
-- Tablas  : TRANS, TRDSC
-- Taller  : IBM i - Proceso CONCILIACION_GLBLN
-- Fecha   : 2025-06-12
-- =============================================================================

-- =============================================================================
-- PARTE A: TRANS — Archivo histórico de transacciones
-- =============================================================================

INSERT INTO HNEACOSTA1/TRANS (
    id_transaccion,
    numero_registro_relativo,
    codigo_banco,
    codigo_sucursal,
    codigo_moneda,
    cuenta_contable,
    numero_cuenta,
    id_cliente,
    fecha_operacion,
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

-- -------------------------------------------------------------------------
-- Cuenta 11010101 — CAJA GENERAL
-- 98 movimientos en el ejemplo JSON; se insertan representativos del periodo.
-- debitosPeriodo = 40000.00  creditosPeriodo = 35000.00
-- saldoInicial = 120000.00   saldoFinalCalculado = 125000.00
-- -------------------------------------------------------------------------

-- Débitos (D)
( 1001, 'RR-1001', '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-01', '2026-05-01', '08:12:10',
  'DEPOSITO_EFECTIVO',  'D', 10000.00, 120000.00, 130000.00,
  'CAJA', 'TERM-001', 'DEP-881001', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 1002, 'RR-1002', '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-07', '2026-05-07', '10:30:00',
  'DEPOSITO_CHEQUE',    'D', 15000.00, 130000.00, 145000.00,
  'CAJA', 'TERM-001', 'DEP-882200', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 1003, 'RR-1003', '01', '001', 'USD', '11010101', '00110101002', 'CLI-00002',
  '2026-05-12', '2026-05-12', '14:00:00',
  'DEPOSITO_EFECTIVO',  'D', 15000.00, 145000.00, 160000.00,
  'CAJA', 'TERM-002', 'DEP-883500', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Partida en tránsito — origen de partidasConciliatorias PC-0001
( 1004, 'RR-1004', '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-19', '2026-05-19', '11:45:00',
  'DEPOSITO_EFECTIVO',  'D',   500.50, 160000.00, 160500.50,
  'CAJA', 'TERM-001', 'DEP-884771', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Créditos (C)
( 1005, 'RR-1005', '01', '001', 'USD', '11010101', '00110101001', 'CLI-00001',
  '2026-05-05', '2026-05-05', '09:00:00',
  'RETIRO_EFECTIVO',    'C', 10000.00, 160500.50, 150500.50,
  'CAJA', 'TERM-001', 'RET-771001', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 1006, 'RR-1006', '01', '001', 'USD', '11010101', '00110101003', 'CLI-00003',
  '2026-05-10', '2026-05-10', '11:20:00',
  'RETIRO_EFECTIVO',    'C', 15000.00, 150500.50, 135500.50,
  'CAJA', 'TERM-003', 'RET-772500', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 1007, 'RR-1007', '01', '001', 'USD', '11010101', '00110101002', 'CLI-00002',
  '2026-05-15', '2026-05-15', '15:30:00',
  'RETIRO_EFECTIVO',    'C', 10000.00, 135500.50, 125500.50,
  'CAJA', 'TERM-002', 'RET-773800', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- -------------------------------------------------------------------------
-- Cuenta 11010201 — ENCAJE LEGAL BANCO CENTRAL (diferencia alta)
-- -------------------------------------------------------------------------
( 2001, 'RR-2001', '01', '001', 'USD', '11010201', '00110102001', NULL,
  '2026-05-02', '2026-05-02', '08:00:00',
  'ENCAJE_REGULAR',     'D', 20000.00, 580000.00, 600000.00,
  'BATCH', 'BATCH-01', 'ENC-20260502', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 2002, 'RR-2002', '01', '001', 'USD', '11010201', '00110102001', NULL,
  '2026-05-19', '2026-05-19', '23:55:00',
  'AJUSTE_ENCAJE',      'D',  5000.00, 600000.00, 605000.00,
  'BATCH', 'BATCH-01', 'AJE-20260519', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- -------------------------------------------------------------------------
-- Cuenta 11010302 — DEPOSITO BANCO CORRESPONSAL LOCAL B (diferencia media)
-- -------------------------------------------------------------------------
( 3001, 'RR-3001', '01', '001', 'USD', '11010302', '00110103002', NULL,
  '2026-05-16', '2026-05-19', '17:00:00',
  'TRANSFERENCIA_ENTRADA', 'D',  8750.00, 391250.00, 400000.00,
  'SWIFT', 'SWIFT-01', 'SWT-884400', 'TRANSITO',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- -------------------------------------------------------------------------
-- Cuenta 11020201 — ACCIONES SECTOR REAL (diferencia critica)
-- -------------------------------------------------------------------------
( 4001, 'RR-4001', '01', '001', 'USD', '11020201', '00112002001', NULL,
  '2026-05-31', '2026-05-31', '22:00:00',
  'VALORIZACION_MERCADO', 'D', 25000.00, 725000.00, 750000.00,
  'BATCH', 'BATCH-FIN', 'VAL-20260531', 'PENDIENTE',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- -------------------------------------------------------------------------
-- Cuenta 11030201 — CREDITOS EN MORA 30-60 DIAS (diferencia baja)
-- -------------------------------------------------------------------------
( 5001, 'RR-5001', '01', '001', 'USD', '11030201', '00113002001', 'CLI-00010',
  '2026-05-18', '2026-05-18', '10:00:00',
  'PROVISION_CARTERA',  'C',   250.00, 325250.25, 325000.25,
  'BATCH', 'BATCH-PROV', 'PRV-20260518', 'APLICADA',
  'USRFIN01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- PARTE B: TRDSC — Descripciones adicionales a las transacciones
--          Origen: §8.1 partidasConciliatorias.subtipo / observacion
--          Matriz trazabilidad §14: TRDSC.tipo_descripcion / texto_descripcion
-- =============================================================================

INSERT INTO HNEACOSTA1/TRDSC (
    numero_registro_relativo,
    secuencia,
    tipo_descripcion,
    texto_descripcion,
    codigo_idioma,
    formato_salida,
    obligatorio,
    usuario_creacion,
    version_registro,
    estado_registro,
    created_at
) VALUES

-- Descripción de partida en tránsito RR-1004 (PC-0001 del JSON)
( 'RR-1004', 1, 'DEPOSITO_NO_APLICADO',
  'Deposito en efectivo pendiente de aplicacion en mayor contable.',
  'ES', 'JSON', TRUE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 'RR-1004', 2, 'DETALLE_ORIGEN',
  'Recibido en caja general sucursal 001 a las 11:45. Referencia DEP-884771.',
  'ES', 'JSON', FALSE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Descripción del ajuste de encaje RR-2002
( 'RR-2002', 1, 'AJUSTE_REQUERIDO',
  'Ajuste de encaje legal pendiente confirmacion Banco Central. Fecha valor diferida.',
  'ES', 'JSON', TRUE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 'RR-2002', 2, 'REFERENCIA_EXTERNA',
  'Oficio BCH-2026-0519-AJE enviado para confirmacion. Plazo respuesta 48h.',
  'ES', 'JSON', FALSE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Descripción de transferencia en tránsito SWIFT RR-3001
( 'RR-3001', 1, 'TRANSITO_INTERBANCARIO',
  'Transferencia SWIFT recibida con fecha valor 2026-05-19 pendiente de acreditacion.',
  'ES', 'JSON', TRUE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Descripción de valorización pendiente RR-4001
( 'RR-4001', 1, 'VALORIZACION_PENDIENTE',
  'Ajuste por valoracion a precios de mercado no registrado en mayor. Requiere aprobacion.',
  'ES', 'JSON', TRUE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

( 'RR-4001', 2, 'IMPACTO_CONCILIACION',
  'Diferencia de 25.00 USD supera tolerancia maxima 1.00. Estado CRITICO asignado.',
  'ES', 'JSON', TRUE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP ),

-- Descripción provisión cartera RR-5001
( 'RR-5001', 1, 'PROVISION_PARCIAL',
  'Provision de cartera mora aplicada parcialmente. Saldo pendiente menor a tolerancia.',
  'ES', 'JSON', FALSE, 'USRFIN01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- Fin de script: 03_INSERT_TRANS_TRDSC.sql
-- =============================================================================
