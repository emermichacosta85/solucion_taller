-- =============================================================================
-- Script  : 05_INSERT_verificacion_json.sql
-- Módulo  : Verificación y Trazabilidad del Proceso
-- Propósito: Provee las consultas de verificación (SELECT) que permiten
--            confirmar que los datos insertados producen exactamente los
--            valores del JSON de ejemplo de requerimientos_taller.md §8.1.
--
--            Incluye también los INSERTs de la tabla CNOFT para
--            parametrizar los catálogos de:
--              · estados de conciliación   (§8.1 estadoConciliacion.codigo)
--              · severidades               (§8.1 estadoConciliacion.severidad)
--              · tipos de partida          (§8.1 partidasConciliatorias.tipo)
--              · estados de partida        (§8.1 partidasConciliatorias.estado)
--
-- Depende : Todos los scripts anteriores (01 al 04)
-- Tablas  : CNOFT (catálogos), más SELECTs de verificación
-- Taller  : IBM i - Proceso CONCILIACION_GLBLN
-- Fecha   : 2025-06-12
-- =============================================================================

-- =============================================================================
-- PARTE A: CNOFT — Catálogos de dominio del proceso de conciliación
--          RF-03: reglas de estado financiero / §8.1 estructuras de dominio
-- =============================================================================

INSERT INTO HNEACOSTA1/CNOFT (
    codigo_tabla,
    idioma,
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

-- -----------------------------------------------------------------------
-- Tabla: ESTADO_CONCILIACION  — §8.1 estadoConciliacion.codigo
-- -----------------------------------------------------------------------
( 'ESTADO_CONC', 'ES', 'Conciliada sin diferencias',          'CONCILIADA',     NULL, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_CONC', 'ES', 'Conciliada con partidas pendientes',  'PARCIAL',        NULL, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_CONC', 'ES', 'No conciliada diferencia relevante',  'NO_CONCILIADA',  NULL, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),

-- -----------------------------------------------------------------------
-- Tabla: SEVERIDAD_CONC  — §8.1 estadoConciliacion.severidad / incidentes.severidad
-- -----------------------------------------------------------------------
( 'SEVERIDAD_CONC', 'ES', 'Sin impacto operativo relevante',     'BAJA',    1.00, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'SEVERIDAD_CONC', 'ES', 'Impacto potencial en confiabilidad',  'MEDIA',   2.00, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'SEVERIDAD_CONC', 'ES', 'Riesgo de error operativo',           'ALTA',    3.00, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'SEVERIDAD_CONC', 'ES', 'Falla critica requiere escalamiento',  'CRITICA', 4.00, '2026-01-01', '2099-12-31', 4, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),

-- -----------------------------------------------------------------------
-- Tabla: TIPO_PARTIDA  — §8.1 partidasConciliatorias.tipo
-- -----------------------------------------------------------------------
( 'TIPO_PARTIDA', 'ES', 'Transaccion en transito no aplicada',   'TRANSITO',        NULL, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_PARTIDA', 'ES', 'Ajuste contable pendiente',             'AJUSTE',          NULL, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_PARTIDA', 'ES', 'Reverso de transaccion anterior',       'REVERSO',         NULL, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_PARTIDA', 'ES', 'Diferencia por redondeo contable',      'REDONDEO',        NULL, '2026-01-01', '2099-12-31', 4, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_PARTIDA', 'ES', 'Valoracion a precios de mercado',       'VALORIZACION',    NULL, '2026-01-01', '2099-12-31', 5, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),

-- -----------------------------------------------------------------------
-- Tabla: ESTADO_PARTIDA  — §8.1 partidasConciliatorias.estado
-- -----------------------------------------------------------------------
( 'ESTADO_PARTIDA', 'ES', 'Partida detectada sin resolver',      'PENDIENTE',   NULL, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_PARTIDA', 'ES', 'Partida registrada en mayor',         'APLICADA',    NULL, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_PARTIDA', 'ES', 'Partida anulada o revertida',         'REVERSADA',   NULL, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),

-- -----------------------------------------------------------------------
-- Tabla: TIPO_INCIDENTE  — §8.1 incidentes.tipo
-- -----------------------------------------------------------------------
( 'TIPO_INCIDENTE', 'ES', 'Incidente de validacion de datos',    'VALIDACION',  NULL, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_INCIDENTE', 'ES', 'Incidente de calidad de datos',       'DATOS',       NULL, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_INCIDENTE', 'ES', 'Incidente en escritura IFS',          'IFS',         NULL, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'TIPO_INCIDENTE', 'ES', 'Incidente de ejecucion del proceso',  'EJECUCION',   NULL, '2026-01-01', '2099-12-31', 4, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),

-- -----------------------------------------------------------------------
-- Tabla: ESTADO_EJECUCION  — §8.1 ejecucion.estadoEjecucion
-- -----------------------------------------------------------------------
( 'ESTADO_EJEC', 'ES', 'Proceso completado sin incidentes',      'FINALIZADO',  NULL, '2026-01-01', '2099-12-31', 1, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_EJEC', 'ES', 'Proceso con incidentes no criticos',     'PARCIAL',     NULL, '2026-01-01', '2099-12-31', 2, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP ),
( 'ESTADO_EJEC', 'ES', 'Proceso con error critico detenido',     'ERROR',       NULL, '2026-01-01', '2099-12-31', 3, 'USRADM01', 1, 'A', CURRENT_TIMESTAMP );

-- =============================================================================
-- PARTE B: SELECTs de verificación
--          Confirman que los datos insertados cuadran con el JSON §8.1
--          y cumplen las reglas §8.2.
-- =============================================================================

-- -----------------------------------------------------------------------
-- VER-01: Saldos fuente por cuenta (origen: saldos.saldoFinalFuente)
--         RF-01, RF-02 — consulta base del proceso
-- -----------------------------------------------------------------------
-- SELECT
--     g.codigo_banco,
--     g.codigo_sucursal,
--     g.codigo_moneda,
--     g.cuenta_contable,
--     g.descripcion_cuenta,
--     g.naturaleza_cuenta,
--     g.nivel_cuenta,
--     g.saldo_actual                        AS saldo_final_fuente,
--     m.nivel_cuenta                        AS nivel_glmst,
--     m.naturaleza_cuenta                   AS naturaleza_glmst
-- FROM HNEACOSTA1/GLBLN g
-- LEFT JOIN HNEACOSTA1/GLMST m
--     ON m.codigo_banco  = g.codigo_banco
--    AND m.codigo_moneda = g.codigo_moneda
--    AND m.cuenta_contable = g.cuenta_contable
-- WHERE g.codigo_banco    = '01'
--   AND g.codigo_sucursal = '001'
--   AND g.codigo_moneda   = 'USD'
--   AND g.cuenta_contable BETWEEN '11000000' AND '11999999'
-- ORDER BY g.cuenta_contable;

-- -----------------------------------------------------------------------
-- VER-02: Débitos y créditos del período por cuenta contable
--         Origen: saldos.debitosPeriodo, saldos.creditosPeriodo (§8.1)
--         Fuente combinada TRANS + TTRAN por ventana de conciliación
-- -----------------------------------------------------------------------
-- SELECT
--     cuenta_contable,
--     SUM(CASE WHEN debito_credito = 'D' THEN monto ELSE 0 END) AS debitos_periodo,
--     SUM(CASE WHEN debito_credito = 'C' THEN monto ELSE 0 END) AS creditos_periodo,
--     COUNT(*)                                                   AS cantidad_movimientos,
--     MIN(fecha_operacion)                                       AS primer_movimiento,
--     MAX(fecha_operacion)                                       AS ultimo_movimiento
-- FROM HNEACOSTA1/TRANS
-- WHERE codigo_banco    = '01'
--   AND codigo_sucursal = '001'
--   AND codigo_moneda   = 'USD'
--   AND cuenta_contable BETWEEN '11000000' AND '11999999'
--   AND fecha_operacion BETWEEN '2026-05-01' AND '2026-05-19'
-- GROUP BY cuenta_contable
-- UNION ALL
-- SELECT
--     cuenta_contable,
--     SUM(CASE WHEN debito_credito = 'D' THEN monto ELSE 0 END),
--     SUM(CASE WHEN debito_credito = 'C' THEN monto ELSE 0 END),
--     COUNT(*),
--     MIN(fecha),
--     MAX(fecha)
-- FROM HNEACOSTA1/TTRAN
-- WHERE codigo_banco    = '01'
--   AND codigo_sucursal = '001'
--   AND codigo_moneda   = 'USD'
--   AND cuenta_contable BETWEEN '11000000' AND '11999999'
--   AND fecha = '2026-05-19'
-- GROUP BY cuenta_contable;

-- -----------------------------------------------------------------------
-- VER-03: Partidas conciliatorias en tránsito
--         Origen: partidasConciliatorias[] + descripciones TRDSC (§8.1)
--         Regla §8.2: incluir cuando exista diferencia
-- -----------------------------------------------------------------------
-- SELECT
--     t.cuenta_contable,
--     t.referencia_externa                  AS referencia,
--     t.fecha_operacion                     AS fecha_partida,
--     t.monto,
--     t.debito_credito                      AS signo,
--     t.estado_transaccion                  AS estado,
--     t.canal_origen                        AS origen,
--     d.tipo_descripcion                    AS subtipo,
--     d.texto_descripcion                   AS observacion
-- FROM HNEACOSTA1/TRANS t
-- LEFT JOIN HNEACOSTA1/TRDSC d
--     ON d.numero_registro_relativo = t.numero_registro_relativo
--    AND d.secuencia = 1
-- WHERE t.estado_transaccion IN ('PENDIENTE', 'TRANSITO')
--   AND t.codigo_banco    = '01'
--   AND t.codigo_sucursal = '001'
--   AND t.codigo_moneda   = 'USD'
-- ORDER BY t.cuenta_contable, t.fecha_operacion;

-- -----------------------------------------------------------------------
-- VER-04: Control de totales — cuadratura global del JSON (§8.2)
--         Regla: sumatoriaDiferenciaNeta = SUM(saldoFuente - saldoConciliado)
--         Regla §8.2: incluir controlTotales para cuadratura global
-- -----------------------------------------------------------------------
-- SELECT
--     COUNT(*)                              AS total_cuentas_procesadas,
--     SUM(saldo_actual)                     AS sumatoria_saldo_final_fuente
-- FROM HNEACOSTA1/GLBLN
-- WHERE codigo_banco    = '01'
--   AND codigo_sucursal = '001'
--   AND codigo_moneda   = 'USD'
--   AND cuenta_contable BETWEEN '11000000' AND '11999999'
--   AND nivel_cuenta = '4';

-- -----------------------------------------------------------------------
-- VER-05: Incidentes — cuentas con diferencia (§8.1 incidentes[])
--         Regla §8.2: registrar incidentes para auditoría
--         Regla §14 taller: incidente ALTA/CRITICA impacta estadoEjecucion
-- -----------------------------------------------------------------------
-- SELECT
--     g.cuenta_contable,
--     g.saldo_actual                        AS saldo_fuente,
--     p.monto_partida                       AS partidas_netas,
--     g.saldo_actual - COALESCE(p.monto_partida, 0) AS saldo_conciliado,
--     ABS(COALESCE(p.monto_partida, 0))     AS diferencia_absoluta,
--     CASE
--         WHEN ABS(COALESCE(p.monto_partida,0)) = 0      THEN 'CONCILIADA'
--         WHEN ABS(COALESCE(p.monto_partida,0)) <= 1.00  THEN 'PARCIAL'
--         ELSE 'NO_CONCILIADA'
--     END                                   AS estado_conciliacion,
--     CASE
--         WHEN ABS(COALESCE(p.monto_partida,0)) = 0      THEN 'BAJA'
--         WHEN ABS(COALESCE(p.monto_partida,0)) <= 1.00  THEN 'MEDIA'
--         WHEN ABS(COALESCE(p.monto_partida,0)) <= 100   THEN 'ALTA'
--         ELSE 'CRITICA'
--     END                                   AS severidad
-- FROM HNEACOSTA1/GLBLN g
-- LEFT JOIN (
--     SELECT cuenta_contable,
--            SUM(CASE WHEN debito_credito='D' THEN monto ELSE -monto END) AS monto_partida
--     FROM HNEACOSTA1/TRANS
--     WHERE estado_transaccion IN ('PENDIENTE','TRANSITO')
--       AND codigo_banco = '01' AND codigo_sucursal = '001' AND codigo_moneda = 'USD'
--     GROUP BY cuenta_contable
-- ) p ON p.cuenta_contable = g.cuenta_contable
-- WHERE g.codigo_banco = '01' AND g.codigo_sucursal = '001'
--   AND g.codigo_moneda = 'USD'
--   AND g.cuenta_contable BETWEEN '11000000' AND '11999999'
-- ORDER BY severidad DESC, g.cuenta_contable;

-- =============================================================================
-- Fin de script: 05_INSERT_verificacion_json.sql
-- =============================================================================
