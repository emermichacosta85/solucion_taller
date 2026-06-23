SET SCHEMA HNEACOSTA2;
-- =============================================================================
-- Script de Datos Semilla (INSERT) - Proceso de Conciliacion GLBLN
-- Taller IBM i
-- =============================================================================
-- Objetivo:
--   Poblar las tablas necesarias para que el proceso SQLRPGLE de conciliacion
--   pueda consultar GLBLN y tablas relacionadas y generar el JSON de salida
--   descrito en "requerimientos_taller.md".
--
-- Secciones de requerimientos cubiertas por estos datos:
--   - Seccion 5  : Requerimientos Funcionales (RF-01 a RF-08)
--   - Seccion 7.1: Componentes (datos de origen para cada capa)
--   - Seccion 7.2: Flujo de proceso (insumos de cada paso)
--   - Seccion 8.1: Estructura de Salida JSON (estructura objetivo)
--   - Seccion 8.2: Reglas minimas del JSON de conciliacion
--   - Seccion 14 : Matriz de Trazabilidad JSON vs BD
--
-- Tablas pobladas (segun estructura_bd.md):
--   GLMST  -> Maestro de Cuentas Contables       (descripcion, naturaleza, nivel)
--   CCDSC  -> Maestro de Centros de Costos        (centroCosto)
--   GLBLN  -> Balances Generales                  (cuenta, saldo final fuente)
--   TRANS  -> Historico de transacciones          (debitos/creditos del periodo)
--   TRDSC  -> Descripciones adicionales de TRANS  (subtipo/observacion de partidas)
--   TTRAN  -> Transacciones del dia               (partidas conciliatorias en transito)
--
-- Mapa de cuentas semilla (banco 01 / sucursal 001 / moneda USD / corte 2026-05-19):
--   11010101 CAJA GENERAL ................ PARCIAL       (dif 0.50, dentro de tolerancia)
--   11020201 BANCOS MONEDA NACIONAL ...... CONCILIADA    (dif 0.00)
--   11030301 CUENTAS POR COBRAR CLIENTES . NO_CONCILIADA (dif 150.00, excede tolerancia)
--
-- Cuadratura global esperada (controlTotales del JSON):
--   totalCuentasProcesadas        = 3
--   totalCuentasConciliadas       = 1
--   totalCuentasConDiferencia     = 2
--   sumatoriaSaldoFinalFuente     = 765150.50
--   sumatoriaSaldoFinalConciliado = 765000.00
--   sumatoriaDiferenciaNeta       =    150.50   (765150.50 - 765000.00)
--
-- Supuestos y notas:
--   1. saldoInicial del JSON no tiene columna propia en GLBLN; se deriva del
--      saldo_anterior del primer movimiento del periodo (TRANS). Los movimientos
--      de cada cuenta estan encadenados (saldo_anterior/saldo_posterior) para que
--      el saldo inicial sea reconstruible y el saldoFinalCalculado cuadre.
--   2. GLBLN.saldo_actual representa el saldoFinalFuente (saldo reportado por la
--      fuente contable).
--   3. Las columnas FK opcionales TRANS.numero_cuenta y TRANS.id_cliente se dejan
--      en NULL: la conciliacion es a nivel de cuenta contable (mayor), no de
--      cuenta de detalle. En estructura_bd.md la FK a ACMST.numero_cuenta es laxa
--      (ACMST no expone esa columna), por lo que no se siembran ACMST/CUMST.
--   4. La cantidad de movimientos es representativa (no se replican los 98 del
--      ejemplo ilustrativo). cantidadMovimientos del JSON = conteo real de TRANS.
--   5. Cumple Seccion 14 de Revision_IBMi.md: solo se usa DML SQL, sin PF/LF.
--
-- Ejecucion:
--   Establezca el esquema/libreria de destino antes de correr el script.
--   En IBM i (ejemplo):  SET SCHEMA TALLERLIB;
-- =============================================================================

-- SET SCHEMA TALLERLIB;   -- <- descomente y ajuste la libreria de destino


-- =============================================================================
-- 1. GLMST  -  Maestro de Cuentas Contables
--    Origen JSON: cuentas[].cuentaMayor.descripcionCuenta / naturaleza / nivelCuenta
-- =============================================================================
INSERT INTO GLMST
    (codigo_banco, codigo_moneda, cuenta_contable, descripcion_cuenta,
     naturaleza_cuenta, nivel_cuenta, saldo_actual, fecha_proceso_sistema,
     observaciones, usuario_creacion, version_registro, estado_registro,
     created_at, updated_at)
VALUES
    ('01', 'USD', '11010101', 'CAJA GENERAL',
     'DEUDORA', '4', 125000.50, TIMESTAMP('2026-05-19 12:00:00'),
     'Cuenta de caja - conciliacion mensual', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('01', 'USD', '11020201', 'BANCOS MONEDA NACIONAL',
     'DEUDORA', '4', 550000.00, TIMESTAMP('2026-05-19 12:00:00'),
     'Cuenta de bancos - conciliacion mensual', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('01', 'USD', '11030301', 'CUENTAS POR COBRAR CLIENTES',
     'DEUDORA', '4', 90150.00, TIMESTAMP('2026-05-19 12:00:00'),
     'Cuentas por cobrar - conciliacion mensual', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 2. CCDSC  -  Maestro de Centros de Costos
--    Origen JSON: cuentas[].cuentaMayor.centroCosto
--    Nota: la estructura de CCDSC es generica (sin columna de codigo de centro),
--          por lo que el codigo logico 'CC001' se documenta en descripcion_cuenta.
-- =============================================================================
INSERT INTO CCDSC
    (id, descripcion_cuenta, naturaleza_cuenta, nivel_cuenta, saldo_actual,
     fecha_proceso_sistema, observaciones, usuario_creacion, version_registro,
     estado_registro, created_at, updated_at)
VALUES
    (1, 'CC001 - CENTRO DE COSTO CAJA Y BANCOS', 'DEUDORA', '1', 0.00,
     TIMESTAMP('2026-05-19 12:00:00'), 'Centro de costo CC001', 'USRFIN01', 1,
     'A', CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    (2, 'CC002 - CENTRO DE COSTO CARTERA', 'DEUDORA', '1', 0.00,
     TIMESTAMP('2026-05-19 12:00:00'), 'Centro de costo CC002', 'USRFIN01', 1,
     'A', CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 3. GLBLN  -  Balances Generales
--    Origen JSON: cuentas[].cuentaMayor.* (clave) y cuentas[].saldos.saldoFinalFuente
--    GLBLN.saldo_actual = saldoFinalFuente
-- =============================================================================
INSERT INTO GLBLN
    (codigo_banco, codigo_sucursal, codigo_moneda, cuenta_contable,
     descripcion_cuenta, naturaleza_cuenta, nivel_cuenta, saldo_actual,
     fecha_proceso_sistema, observaciones, usuario_creacion, version_registro,
     estado_registro, created_at, updated_at)
VALUES
    -- Cuenta 1: saldoFinalFuente 125000.50 (calculado 125000.00 -> dif 0.50)
    ('01', '001', 'USD', '11010101', 'CAJA GENERAL', 'DEUDORA', '4',
     125000.50, TIMESTAMP('2026-05-19 12:00:00'),
     'Saldo fuente con partida en transito', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    -- Cuenta 2: saldoFinalFuente 550000.00 (calculado 550000.00 -> dif 0.00)
    ('01', '001', 'USD', '11020201', 'BANCOS MONEDA NACIONAL', 'DEUDORA', '4',
     550000.00, TIMESTAMP('2026-05-19 12:00:00'),
     'Saldo fuente conciliado sin diferencias', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    -- Cuenta 3: saldoFinalFuente 90150.00 (calculado 90000.00 -> dif 150.00)
    ('01', '001', 'USD', '11030301', 'CUENTAS POR COBRAR CLIENTES', 'DEUDORA', '4',
     90150.00, TIMESTAMP('2026-05-19 12:00:00'),
     'Saldo fuente con diferencia fuera de tolerancia', 'USRFIN01', 1, 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 4. TRANS  -  Historico de transacciones (movimientos APLICADOS del periodo)
--    Origen JSON: cuentas[].saldos.debitosPeriodo / creditosPeriodo
--                 cuentas[].resumenMovimientos.*
--    saldo_anterior / saldo_posterior encadenados para reconstruir saldoInicial.
--
--    Cuenta 11010101: saldoInicial 120000.00 | debitos 40000.00 | creditos 35000.00
--    Cuenta 11020201: saldoInicial 500000.00 | debitos 250000.00 | creditos 200000.00
--    Cuenta 11030301: saldoInicial  80000.00 | debitos  15000.00 | creditos   5000.00
-- =============================================================================
INSERT INTO TRANS
    (numero_registro_relativo, codigo_banco, codigo_sucursal,
     codigo_moneda, cuenta_contable, numero_cuenta, id_cliente, fecha_operacion,
     fecha_valor, hora_operacion, tipo_movimiento, debito_credito, monto,
     saldo_anterior, saldo_posterior, canal_origen, terminal_origen,
     referencia_externa, estado_transaccion, usuario_creacion, version_registro,
     observaciones, estado_registro, created_at, updated_at)
VALUES
    -- ---- Cuenta 11010101 (CAJA GENERAL) ----
    ('GL00000001', '01', '001', 'USD', '11010101', NULL, NULL,
     DATE('2026-05-03'), DATE('2026-05-03'), TIME('08:12:10'), 'INGRESO', 'D',
     25000.00, 120000.00, 145000.00, 'VENTANILLA', 'TER001', 'ING-100001',
     'APLICADA', 'USRFIN01', 1, 'Ingreso por ventanilla', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000002', '01', '001', 'USD', '11010101', NULL, NULL,
     DATE('2026-05-07'), DATE('2026-05-07'), TIME('10:05:00'), 'EGRESO', 'C',
     20000.00, 145000.00, 125000.00, 'VENTANILLA', 'TER001', 'EGR-100002',
     'APLICADA', 'USRFIN01', 1, 'Pago a proveedores', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000003', '01', '001', 'USD', '11010101', NULL, NULL,
     DATE('2026-05-10'), DATE('2026-05-10'), TIME('09:30:00'), 'INGRESO', 'D',
     15000.00, 125000.00, 140000.00, 'VENTANILLA', 'TER002', 'ING-100003',
     'APLICADA', 'USRFIN01', 1, 'Ingreso por ventanilla', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000004', '01', '001', 'USD', '11010101', NULL, NULL,
     DATE('2026-05-15'), DATE('2026-05-15'), TIME('14:20:00'), 'EGRESO', 'C',
     15000.00, 140000.00, 125000.00, 'VENTANILLA', 'TER002', 'EGR-100004',
     'APLICADA', 'USRFIN01', 1, 'Pago de servicios', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),

    -- ---- Cuenta 11020201 (BANCOS MONEDA NACIONAL) ----
    ('GL00000005', '01', '001', 'USD', '11020201', NULL, NULL,
     DATE('2026-05-02'), DATE('2026-05-02'), TIME('09:00:00'), 'DEPOSITO', 'D',
     150000.00, 500000.00, 650000.00, 'INTERBANCARIO', 'SWIFT', 'DEP-200001',
     'APLICADA', 'USRFIN01', 1, 'Deposito en corresponsal', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000006', '01', '001', 'USD', '11020201', NULL, NULL,
     DATE('2026-05-09'), DATE('2026-05-09'), TIME('11:15:00'), 'DEPOSITO', 'D',
     100000.00, 650000.00, 750000.00, 'INTERBANCARIO', 'SWIFT', 'DEP-200002',
     'APLICADA', 'USRFIN01', 1, 'Deposito en corresponsal', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000007', '01', '001', 'USD', '11020201', NULL, NULL,
     DATE('2026-05-12'), DATE('2026-05-12'), TIME('15:40:00'), 'TRANSFERENCIA', 'C',
     120000.00, 750000.00, 630000.00, 'INTERBANCARIO', 'SWIFT', 'TRF-200003',
     'APLICADA', 'USRFIN01', 1, 'Transferencia saliente', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000008', '01', '001', 'USD', '11020201', NULL, NULL,
     DATE('2026-05-18'), DATE('2026-05-18'), TIME('16:00:00'), 'TRANSFERENCIA', 'C',
     80000.00, 630000.00, 550000.00, 'INTERBANCARIO', 'SWIFT', 'TRF-200004',
     'APLICADA', 'USRFIN01', 1, 'Transferencia saliente', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),

    -- ---- Cuenta 11030301 (CUENTAS POR COBRAR CLIENTES) ----
    ('GL00000009', '01', '001', 'USD', '11030301', NULL, NULL,
     DATE('2026-05-04'), DATE('2026-05-04'), TIME('10:00:00'), 'CARGO', 'D',
     10000.00, 80000.00, 90000.00, 'BATCH', 'JOBCXC', 'CXC-300001',
     'APLICADA', 'USRFIN01', 1, 'Generacion de cuenta por cobrar', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000010', '01', '001', 'USD', '11030301', NULL, NULL,
     DATE('2026-05-11'), DATE('2026-05-11'), TIME('10:30:00'), 'CARGO', 'D',
     5000.00, 90000.00, 95000.00, 'BATCH', 'JOBCXC', 'CXC-300002',
     'APLICADA', 'USRFIN01', 1, 'Generacion de cuenta por cobrar', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000011', '01', '001', 'USD', '11030301', NULL, NULL,
     DATE('2026-05-16'), DATE('2026-05-16'), TIME('12:45:00'), 'ABONO', 'C',
     5000.00, 95000.00, 90000.00, 'VENTANILLA', 'TER003', 'CXC-300003',
     'APLICADA', 'USRFIN01', 1, 'Cobro parcial de cliente', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 5. TRDSC  -  Descripciones Adicionales a las Transacciones
--    Origen JSON: cuentas[].partidasConciliatorias[].subtipo  (tipo_descripcion)
--                 cuentas[].partidasConciliatorias[].observacion (texto_descripcion)
--    Se enlazan por numero_registro_relativo a TRANS.
-- =============================================================================
INSERT INTO TRDSC
    (numero_registro_relativo, secuencia, tipo_descripcion, texto_descripcion,
     codigo_idioma, formato_salida, obligatorio, usuario_creacion,
     usuario_actualizacion, version_registro, observaciones, estado_registro,
     created_at, updated_at)
VALUES
    -- Glosas de movimientos aplicados
    ('GL00000001', 1, 'GLOSA', 'Movimiento de caja - ingreso por ventanilla',
     'ES', 'TEXTO', 'S', 'USRFIN01', 'USRFIN01', 1, ' ', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000002', 1, 'GLOSA', 'Pago a proveedores desde caja',
     'ES', 'TEXTO', 'N', 'USRFIN01', 'USRFIN01', 1, ' ', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000005', 1, 'GLOSA', 'Deposito en banco corresponsal',
     'ES', 'TEXTO', 'S', 'USRFIN01', 'USRFIN01', 1, ' ', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000009', 1, 'GLOSA', 'Cargo por generacion de cuenta por cobrar',
     'ES', 'TEXTO', 'N', 'USRFIN01', 'USRFIN01', 1, ' ', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    -- Subtipo / observacion para partidas conciliatorias
    ('GL00000001', 2, 'DEPOSITO_NO_APLICADO', 'Pendiente de aplicacion en mayor',
     'ES', 'TEXTO', 'S', 'USRFIN01', 'USRFIN01', 1,
     'Soporta partida conciliatoria cuenta 11010101', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000009', 2, 'AJUSTE_PENDIENTE', 'Ajuste pendiente por diferencia detectada',
     'ES', 'TEXTO', 'N', 'USRFIN01', 'USRFIN01', 1,
     'Soporta partida conciliatoria cuenta 11030301', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    ('GL00000005', 2, 'NOTA', 'Conciliacion sin diferencias',
     'ES', 'TEXTO', 'N', 'USRFIN01', 'USRFIN01', 1, ' ', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 6. TTRAN  -  Transacciones del dia (partidas conciliatorias EN TRANSITO)
--    Origen JSON: cuentas[].partidasConciliatorias[] (tipo, referencia, monto,
--                 signo, estado, origen)
--    Estas partidas explican las diferencias y NO estan incluidas en los
--    debitos/creditos aplicados de TRANS.
--    Nota: numero_cuenta es parte de la PK (NOT NULL); se usa un valor logico.
--          id_cliente (FK opcional a CUMST) se deja en NULL.
-- =============================================================================
INSERT INTO TTRAN
    (numero_registro_relativo, codigo_banco, codigo_sucursal,
     codigo_moneda, cuenta_contable, numero_cuenta, id_cliente, fecha_transaccion, fecha_valor,
     hora_operacion, tipo_movimiento, debito_credito, monto_transaccion, saldo_anterior,
     saldo_posterior, canal_origen, terminal_origen, referencia_externa,
     estado_transaccion, usuario_creacion, version_registro, observaciones,
     estado_registro, created_at, updated_at)
VALUES
    -- Partida 1 (cuenta 11010101): deposito no aplicado en transito (PC-0001)
    ('GL00000001', '01', '001', 'USD', '11010101', 'NA-11010101', NULL,
     DATE('2026-05-19'), DATE('2026-05-19'), TIME('11:58:44'), 'DEPOSITO', 'D',
     500.50, 0.00, 0.00, 'ATM', 'ATM015', 'DEP-884771',
     'PENDIENTE', 'USRFIN01', 1, 'Deposito no aplicado - partida en transito', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP),
    -- Partida 2 (cuenta 11030301): ajuste pendiente que excede tolerancia
    ('GL00000009', '01', '001', 'USD', '11030301', 'NA-11030301', NULL,
     DATE('2026-05-19'), DATE('2026-05-19'), TIME('12:10:00'), 'AJUSTE', 'D',
     150.00, 0.00, 0.00, 'BATCH', 'JOBAJU', 'AJU-100200',
     'PENDIENTE', 'USRFIN01', 1, 'Ajuste pendiente - diferencia fuera de tolerancia', 'A',
     CURRENT TIMESTAMP, CURRENT TIMESTAMP);


-- =============================================================================
-- 7. (OPCIONAL) Consultas de verificacion de cuadratura
--    Permiten validar las "Reglas minimas del JSON de conciliacion" (Seccion 8.2)
--    y la consistencia de controlTotales antes de generar el JSON.
--    Descomente para ejecutar.
-- =============================================================================

-- 7.1 Debitos y creditos del periodo por cuenta (saldos.debitosPeriodo / creditosPeriodo)
-- SELECT cuenta_contable,
--        SUM(CASE WHEN debito_credito = 'D' THEN monto ELSE 0 END) AS debitos_periodo,
--        SUM(CASE WHEN debito_credito = 'C' THEN monto ELSE 0 END) AS creditos_periodo,
--        COUNT(*)            AS cantidad_movimientos,
--        MIN(fecha_operacion) AS primer_movimiento,
--        MAX(fecha_operacion) AS ultimo_movimiento
--   FROM TRANS
--  WHERE codigo_banco = '01' AND codigo_sucursal = '001' AND codigo_moneda = 'USD'
--    AND cuenta_contable BETWEEN '11000000' AND '11999999'
--    AND estado_transaccion = 'APLICADA'
--  GROUP BY cuenta_contable
--  ORDER BY cuenta_contable;

-- 7.2 Diferencia por cuenta: saldoFinalFuente (GLBLN) vs saldoFinalCalculado (TRANS)
--     diferenciaNeta = saldoFuente - saldoConciliado (= saldoCalculado en esta semilla)
-- SELECT b.cuenta_contable,
--        b.saldo_actual AS saldo_final_fuente,
--        MAX(CASE WHEN t.rn = 1 THEN t.saldo_anterior END)
--          + SUM(CASE WHEN t.debito_credito = 'D' THEN t.monto ELSE 0 END)
--          - SUM(CASE WHEN t.debito_credito = 'C' THEN t.monto ELSE 0 END) AS saldo_final_calculado
--   FROM GLBLN b
--   JOIN (SELECT cuenta_contable, debito_credito, monto, saldo_anterior,
--                ROW_NUMBER() OVER (PARTITION BY cuenta_contable
--                                   ORDER BY fecha_operacion, hora_operacion) AS rn
--           FROM TRANS
--          WHERE estado_transaccion = 'APLICADA') t
--     ON t.cuenta_contable = b.cuenta_contable
--  WHERE b.codigo_banco = '01' AND b.codigo_sucursal = '001' AND b.codigo_moneda = 'USD'
--  GROUP BY b.cuenta_contable, b.saldo_actual
--  ORDER BY b.cuenta_contable;

-- 7.3 Cuadratura global (controlTotales.sumatoriaDiferenciaNeta)
-- SELECT SUM(saldo_actual) AS sumatoria_saldo_final_fuente
--   FROM GLBLN
--  WHERE codigo_banco = '01' AND codigo_sucursal = '001' AND codigo_moneda = 'USD';
--   -> Debe ser 765150.50 ; saldoConciliado total = 765000.00 ; dif neta = 150.50

-- =============================================================================
-- Fin del script de datos semilla
-- =============================================================================

select * from glbln;
