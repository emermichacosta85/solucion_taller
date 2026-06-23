--=============================================================================
--  Script de Pruebas y Cuadratura : pruebas_conciliacion.sql
--  Proyecto : Conciliacion de Cuentas Mayores GLBLN (Taller IBM i)
--  Objetivo : Automatizar la validacion de las reglas clave de conciliacion
--             (seccion 6.4 de Revision_IBMi.md) replicando con SQL puro los
--             calculos que el conjunto SQLRPGLE materializa, y contrastarlos
--             contra los valores esperados de los datos semilla.
--  Uso      : ejecutar en RUNSQLSTM / Run SQL Scripts apuntando al schema con
--             los datos semilla ya cargados.  Ajustar SET SCHEMA si aplica.
--  Resultado: cada consulta devuelve una columna RESULTADO = 'OK' o 'FALLA'.
--  Hecho por: Equipo Taller IBM i
--  Fecha    : 2026-05-19
--=============================================================================

SET SCHEMA HNEACOSTA2;

-- ---------------------------------------------------------------------------
-- Vista logica reutilizable: calculo base por cuenta (espejo de GLCNDAO).
--   No crea PF/LF; es una VISTA SQL (permitida por seccion 14 de Revision).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_GLCN_PRUEBA AS
WITH mov AS (
   SELECT t.cuenta_contable AS cta,
          SUM(CASE WHEN t.debito_credito = 'D' THEN t.monto ELSE 0 END) AS deb,
          SUM(CASE WHEN t.debito_credito = 'C' THEN t.monto ELSE 0 END) AS cre,
          COUNT(*) AS cant
     FROM TRANS t
    WHERE t.codigo_banco='01' AND t.codigo_sucursal='001'
      AND t.codigo_moneda='USD'
      AND t.cuenta_contable BETWEEN '11000000' AND '11999999'
      AND t.estado_transaccion='APLICADA' AND t.estado_registro='A'
    GROUP BY t.cuenta_contable
),
ini AS (
   SELECT cta, saldoIni FROM (
      SELECT t.cuenta_contable AS cta, t.saldo_anterior AS saldoIni,
             ROW_NUMBER() OVER (PARTITION BY t.cuenta_contable
                ORDER BY t.fecha_operacion, t.hora_operacion) AS rn
        FROM TRANS t
       WHERE t.codigo_banco='01' AND t.codigo_sucursal='001'
         AND t.codigo_moneda='USD'
         AND t.cuenta_contable BETWEEN '11000000' AND '11999999'
         AND t.estado_transaccion='APLICADA' AND t.estado_registro='A'
   ) z WHERE z.rn=1
),
par AS (
   SELECT x.cuenta_contable AS cta, COUNT(*) AS cantPar
     FROM TTRAN x
    WHERE x.codigo_banco='01' AND x.codigo_sucursal='001'
      AND x.codigo_moneda='USD'
      AND x.cuenta_contable BETWEEN '11000000' AND '11999999'
      AND x.estado_transaccion='PENDIENTE' AND x.estado_registro='A'
    GROUP BY x.cuenta_contable
)
SELECT b.cuenta_contable                         AS cuenta,
       COALESCE(i.saldoIni,0)                     AS saldo_inicial,
       COALESCE(mv.deb,0)                         AS debitos,
       COALESCE(mv.cre,0)                         AS creditos,
       COALESCE(i.saldoIni,0)+COALESCE(mv.deb,0)
              -COALESCE(mv.cre,0)                 AS saldo_calculado,
       b.saldo_actual                            AS saldo_fuente,
       COALESCE(i.saldoIni,0)+COALESCE(mv.deb,0)
              -COALESCE(mv.cre,0)                 AS saldo_conciliado,
       b.saldo_actual-(COALESCE(i.saldoIni,0)
              +COALESCE(mv.deb,0)-COALESCE(mv.cre,0)) AS dif_neta,
       COALESCE(par.cantPar,0)                    AS partidas
  FROM GLBLN b
  LEFT JOIN mov mv ON mv.cta=b.cuenta_contable
  LEFT JOIN ini i  ON i.cta =b.cuenta_contable
  LEFT JOIN par    ON par.cta=b.cuenta_contable
 WHERE b.codigo_banco='01' AND b.codigo_sucursal='001'
   AND b.codigo_moneda='USD'
   AND b.cuenta_contable BETWEEN '11000000' AND '11999999'
   AND b.estado_registro='A';

-- ---------------------------------------------------------------------------
-- PRUEBA 1 : saldos calculados por cuenta vs valores esperados del seed.
-- ---------------------------------------------------------------------------
SELECT cuenta, saldo_inicial, debitos, creditos, saldo_calculado,
       saldo_fuente, dif_neta, partidas,
       CASE
         WHEN cuenta='11010101' AND saldo_calculado=125000.00
              AND saldo_fuente=125000.50 AND dif_neta=0.50  THEN 'OK'
         WHEN cuenta='11020201' AND saldo_calculado=550000.00
              AND saldo_fuente=550000.00 AND dif_neta=0.00  THEN 'OK'
         WHEN cuenta='11030301' AND saldo_calculado=90000.00
              AND saldo_fuente=90150.00 AND dif_neta=150.00 THEN 'OK'
         ELSE 'FALLA'
       END AS resultado
  FROM VW_GLCN_PRUEBA
 ORDER BY cuenta;

-- ---------------------------------------------------------------------------
-- PRUEBA 2 : clasificacion esperada por regla de tolerancia (tol = 1.00).
-- ---------------------------------------------------------------------------
SELECT cuenta, dif_neta, partidas,
       CASE WHEN ABS(dif_neta) > 1.00 THEN 'NO_CONCILIADA'
            WHEN ABS(dif_neta) > 0 OR partidas > 0 THEN 'PARCIAL'
            ELSE 'CONCILIADA' END AS estado_calculado,
       CASE
         WHEN cuenta='11010101'
              AND (CASE WHEN ABS(dif_neta)>1.00 THEN 'NO_CONCILIADA'
                        WHEN ABS(dif_neta)>0 OR partidas>0 THEN 'PARCIAL'
                        ELSE 'CONCILIADA' END)='PARCIAL'       THEN 'OK'
         WHEN cuenta='11020201'
              AND (CASE WHEN ABS(dif_neta)>1.00 THEN 'NO_CONCILIADA'
                        WHEN ABS(dif_neta)>0 OR partidas>0 THEN 'PARCIAL'
                        ELSE 'CONCILIADA' END)='CONCILIADA'    THEN 'OK'
         WHEN cuenta='11030301'
              AND (CASE WHEN ABS(dif_neta)>1.00 THEN 'NO_CONCILIADA'
                        WHEN ABS(dif_neta)>0 OR partidas>0 THEN 'PARCIAL'
                        ELSE 'CONCILIADA' END)='NO_CONCILIADA' THEN 'OK'
         ELSE 'FALLA'
       END AS resultado
  FROM VW_GLCN_PRUEBA
 ORDER BY cuenta;

-- ---------------------------------------------------------------------------
-- PRUEBA 3 : cuadratura global de controlTotales (suma por cuenta).
--   sumatoriaDiferenciaNeta debe coincidir con la suma de diferencias.
-- ---------------------------------------------------------------------------
SELECT COUNT(*)                          AS total_cuentas,
       SUM(CASE WHEN ABS(dif_neta)<=1.00 AND dif_neta=0 AND partidas=0
                THEN 1 ELSE 0 END)        AS total_conciliadas,
       SUM(CASE WHEN dif_neta<>0 THEN 1 ELSE 0 END) AS total_con_dif,
       SUM(saldo_fuente)                  AS sum_fuente,
       SUM(saldo_conciliado)              AS sum_conciliado,
       SUM(dif_neta)                      AS sum_dif_neta,
       CASE WHEN COUNT(*)=3
             AND SUM(saldo_fuente)=765150.50
             AND SUM(saldo_conciliado)=765000.00
             AND SUM(dif_neta)=150.50 THEN 'OK' ELSE 'FALLA'
       END AS resultado
  FROM VW_GLCN_PRUEBA;

-- ---------------------------------------------------------------------------
-- PRUEBA 4 : partidas conciliatorias en transito esperadas (TTRAN PENDIENTE).
-- ---------------------------------------------------------------------------
SELECT x.cuenta_contable AS cuenta, x.referencia_externa AS referencia,
       x.monto_transaccion AS monto, x.estado_transaccion AS estado,
       CASE
         WHEN x.cuenta_contable='11010101' AND x.referencia_externa='DEP-884771'
              AND x.monto_transaccion=500.50 THEN 'OK'
         WHEN x.cuenta_contable='11030301' AND x.referencia_externa='AJU-100200'
              AND x.monto_transaccion=150.00 THEN 'OK'
         ELSE 'FALLA'
       END AS resultado
  FROM TTRAN x
 WHERE x.codigo_banco='01' AND x.codigo_sucursal='001'
   AND x.codigo_moneda='USD'
   AND x.cuenta_contable BETWEEN '11000000' AND '11999999'
   AND x.estado_transaccion='PENDIENTE' AND x.estado_registro='A'
 ORDER BY x.cuenta_contable;

-- ---------------------------------------------------------------------------
-- PRUEBA 5 : prueba del motor JSON (JSON_OBJECT) sobre una cuenta de muestra.
--   Verifica que el documento por cuenta se serializa sin error.
-- ---------------------------------------------------------------------------
SELECT JSON_OBJECT(
          'cuentaContable' VALUE cuenta,
          'saldoFinalCalculado' VALUE saldo_calculado,
          'saldoFinalFuente'    VALUE saldo_fuente,
          'diferenciaNeta'      VALUE dif_neta,
          'excedeTolerancia'    VALUE
             CASE WHEN ABS(dif_neta)>1.00 THEN 'true'
                  ELSE 'false' END FORMAT JSON
       ) AS json_cuenta
  FROM VW_GLCN_PRUEBA
 ORDER BY cuenta;
