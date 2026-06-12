-- =============================================================================
-- Script  : 01_INSERT_catalogos_base.sql
-- Módulo  : Contabilidad - Catálogos Base
-- Propósito: Poblar los catálogos que sirven de fundamento al proceso de
--            conciliación GLBLN definido en requerimientos_taller.md.
--            Este script debe ejecutarse PRIMERO (no tiene dependencias).
--
-- Tablas  : CNTRLCNT  → Parámetros Generales del Sistema (RF-01 filtros)
--           CNTRLBRN  → Archivo de Sucursales            (RF-01 filtros)
--           CCDSC     → Maestro de Centros de Costo      (§8.1 centroCosto)
--           GLMST     → Maestro de Cuentas Contables     (RF-02, §8.1 cuentaMayor)
--
-- Taller  : IBM i - Proceso CONCILIACION_GLBLN
-- Fecha   : 2025-06-12
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CNTRLCNT — Parámetros Generales del Sistema
--    RF-01: parametriza banco, ambiente, tolerancia y ruta IFS de salida.
-- -----------------------------------------------------------------------------
INSERT INTO HNEACOSTA1/CNTRLCNT (
    codigo_banco,
    descripcion,
    valor_texto,
    valor_numerico,
    vigencia_desde,
    vigencia_hasta,
    orden_visualizacion,
    usuario_creacion,
    version_registro,
    estado_registro,
    created_at
) VALUES
-- Banco principal del taller
( '01',  'Banco principal del taller IBS',      'BANCO TALLER IBS',  NULL,
  '2026-01-01', '2026-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Ambiente de ejecución (QA/UAT/PRD) — usado en metadata.ambiente del JSON
( '01',  'Ambiente de ejecucion del proceso',   'QA',                NULL,
  '2026-01-01', '2026-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Tolerancia permitida para diferencias de conciliación — §8.1 diferencias.toleranciaPermitida
( '01',  'Tolerancia maxima de diferencia neta','TOLERANCIA_NETA',   1.00,
  '2026-01-01', '2026-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Ruta IFS de salida de archivos JSON — RF-06
( '01',  'Ruta IFS salida JSON conciliacion',   '/TALLERIFS/GLBLN/', NULL,
  '2026-01-01', '2026-12-31', 4, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Versión de estructura JSON — metadata.versionEstructura
( '01',  'Version estructura JSON conciliacion','1.0.0',             NULL,
  '2026-01-01', '2026-12-31', 5, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Sistema origen — metadata.sistemaOrigen
( '01',  'Sistema origen del proceso',          'IBS-IBM-i',         NULL,
  '2026-01-01', '2026-12-31', 6, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP );

-- -----------------------------------------------------------------------------
-- 2. CNTRLBRN — Archivo de Sucursales
--    RF-01: filtro de sucursal en consulta a GLBLN.
-- -----------------------------------------------------------------------------
INSERT INTO HNEACOSTA1/CNTRLBRN (
    codigo_banco,
    codigo_sucursal,
    descripcion,
    valor_texto,
    valor_numerico,
    vigencia_desde,
    vigencia_hasta,
    orden_visualizacion,
    usuario_creacion,
    version_registro,
    estado_registro,
    created_at
) VALUES
( '01', '001', 'Sucursal Central',       'CENTRAL',    NULL, '2026-01-01', '2026-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', '002', 'Sucursal Norte',         'NORTE',      NULL, '2026-01-01', '2026-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', '003', 'Sucursal Sur',           'SUR',        NULL, '2026-01-01', '2026-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP );

-- -----------------------------------------------------------------------------
-- 3. CCDSC — Maestro de Centros de Costo
--    §8.1 cuentaMayor.centroCosto; matriz trazabilidad §14 GLMST/CCDSC.
-- -----------------------------------------------------------------------------
INSERT INTO HNEACOSTA1/CCDSC (
    id,
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
( 1, 'Centro de Costo Operaciones',     'OPERATIVO',   '1', 0.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 2, 'Centro de Costo Finanzas',        'FINANCIERO',  '1', 0.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 3, 'Centro de Costo Tecnologia',      'SOPORTE',     '1', 0.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 4, 'Centro de Costo Administracion',  'APOYO',       '1', 0.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP );

-- -----------------------------------------------------------------------------
-- 4. GLMST — Maestro de Cuentas Contables
--    RF-02, RF-03; origen de descripcionCuenta, naturaleza, nivelCuenta,
--    centroCosto en §8.1 cuentaMayor (matriz trazabilidad §14).
--    Rango de cuentas del taller: 11000000 – 11999999 (contexto.rangoCuentas).
-- -----------------------------------------------------------------------------
INSERT INTO HNEACOSTA1/GLMST (
    codigo_banco,
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
-- Nivel 1 — Grupo
( '01', 'USD', '11000000', 'ACTIVO CORRIENTE',                    'DEUDORA',   '1',  12455000.25, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Nivel 2 — Subgrupo
( '01', 'USD', '11010000', 'DISPONIBILIDADES',                    'DEUDORA',   '2',   5800000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11020000', 'INVERSIONES TEMPORALES',              'DEUDORA',   '2',   3200000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11030000', 'CARTERA DE CREDITOS',                 'DEUDORA',   '2',   2455000.25, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Nivel 3 — Rubro
( '01', 'USD', '11010100', 'CAJA',                                'DEUDORA',   '3',    500000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010200', 'DEPOSITOS EN BANCO CENTRAL',          'DEUDORA',   '3',   1200000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010300', 'DEPOSITOS EN BANCOS DEL PAIS',        'DEUDORA',   '3',    800000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11020100', 'INVERSIONES EN TITULOS DEL ESTADO',   'DEUDORA',   '3',   2000000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11020200', 'INVERSIONES EN TITULOS PRIVADOS',     'DEUDORA',   '3',   1200000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11030100', 'CREDITOS VIGENTES',                   'DEUDORA',   '3',   1800000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11030200', 'CREDITOS EN MORA',                    'DEUDORA',   '3',    655000.25, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
-- Nivel 4 — Cuenta detalle (fuente principal del proceso de conciliación)
( '01', 'USD', '11010101', 'CAJA GENERAL',                        'DEUDORA',   '4',    125000.50, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010102', 'CAJA CHICA ADMINISTRATIVA',           'DEUDORA',   '4',      5000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010103', 'CAJA SUCURSAL NORTE',                 'DEUDORA',   '4',     80000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010201', 'ENCAJE LEGAL BANCO CENTRAL',          'DEUDORA',   '4',    600000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010202', 'DEPOSITO ORDINARIO BANCO CENTRAL',    'DEUDORA',   '4',    600000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010301', 'DEPOSITO BANCO CORRESPONSAL LOCAL A', 'DEUDORA',   '4',    400000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11010302', 'DEPOSITO BANCO CORRESPONSAL LOCAL B', 'DEUDORA',   '4',    400000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11020101', 'BONOS DEL TESORO NACIONAL',           'DEUDORA',   '4',   1000000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( '01', 'USD', '11020102', 'LETRAS DEL BANCO CENTRAL',            'DEUDORA',   '4',   1000000.00, CURRENT_TIMESTAMP, NULL, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- Fin de script: 01_INSERT_catalogos_base.sql
-- =============================================================================
