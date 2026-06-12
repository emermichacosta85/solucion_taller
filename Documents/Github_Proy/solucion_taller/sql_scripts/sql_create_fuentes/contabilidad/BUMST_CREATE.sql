-- ================================================================
-- Nombre de la Tabla  : BUMST
-- DESCRIPCION         : Maestro de Presupuestos
-- Objetivo            : Registrar el presupuesto aprobado desglosado por
--                       banco, sucursal, moneda, periodo y centro de costo,
--                       permitiendo el control de ejecucion presupuestaria
--                       y el analisis de variaciones frente a lo real.
-- Tipo de Tabla       : Maestra / Control Presupuestario
-- Origen de los Datos : Carga del presupuesto aprobado por la gerencia
-- Permanencia de Datos: Permanente (por anio fiscal)
-- Uso de los datos    : Control presupuestario, reportes de ejecucion
--                       y analisis de variaciones real vs presupuesto
-- Restricciones       : FK hacia CCDSC por (centro_costo, codigo_banco)
--                       relacion funcional del modulo presupuestario
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BUMST (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN BUMSTBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN BUMSTSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN BUMSTMON,
    numero_presupuesto       VARCHAR(30)    NOT NULL     FOR COLUMN BUMSTPRS,
    centro_costo             VARCHAR(50)    NOT NULL     FOR COLUMN BUMSTCC,
    anio_fiscal              INT            NOT NULL     FOR COLUMN BUMSTYEA,
    mes_presupuesto          INT            NOT NULL     FOR COLUMN BUMSTMES,
    cuenta_contable          VARCHAR(24)                 FOR COLUMN BUMSTCTC,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN BUMSTDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN BUMSTNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN BUMSTNIV,
    monto_presupuestado      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTMPR,
    monto_ejecutado          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTMEJ,
    monto_comprometido       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTMCO,
    saldo_disponible         DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTSDP,
    variacion_absoluta       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTVAB,
    variacion_porcentual     DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BUMSTVPC,
    saldo_actual             DECIMAL(18,2)               FOR COLUMN BUMSTSAL,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN BUMSTFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BUMSTUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BUMSTUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BUMSTVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BUMSTOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BUMSTERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BUMSTCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BUMSTUAT,
    CONSTRAINT PK_BUMST PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_presupuesto,
                                     centro_costo, anio_fiscal,
                                     mes_presupuesto),
    CONSTRAINT FK_BUMST_CCDSC FOREIGN KEY (centro_costo, codigo_banco)
        REFERENCES HNEACOSTA1/CCDSC (codigo_centro, codigo_banco)
)
RCDFMT BUMSTR;

RENAME TABLE HNEACOSTA1/BUMST
    TO BUMST FOR SYSTEM NAME BUMST;

COMMENT ON TABLE HNEACOSTA1/BUMST IS
    'Maestro de Presupuestos por Banco y Centro de Costo - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/BUMST
    IS 'Maestro Presupuestos';

COMMENT ON COLUMN HNEACOSTA1/BUMST.codigo_banco IS
    'Codigo del banco al que pertenece el registro presupuestario';
COMMENT ON COLUMN HNEACOSTA1/BUMST.codigo_sucursal IS
    'Codigo de la sucursal a la que corresponde la asignacion presupuestaria';
COMMENT ON COLUMN HNEACOSTA1/BUMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el presupuesto';
COMMENT ON COLUMN HNEACOSTA1/BUMST.numero_presupuesto IS
    'Numero o codigo del presupuesto aprobado para el periodo fiscal';
COMMENT ON COLUMN HNEACOSTA1/BUMST.centro_costo IS
    'Centro de costo al que se asigna la partida presupuestaria (FK CCDSC)';
COMMENT ON COLUMN HNEACOSTA1/BUMST.anio_fiscal IS
    'Anio fiscal al que corresponde el presupuesto en formato AAAA';
COMMENT ON COLUMN HNEACOSTA1/BUMST.mes_presupuesto IS
    'Mes al que corresponde la partida presupuestaria: 1=Enero a 12=Diciembre';
COMMENT ON COLUMN HNEACOSTA1/BUMST.cuenta_contable IS
    'Cuenta contable asociada a la partida presupuestaria';
COMMENT ON COLUMN HNEACOSTA1/BUMST.descripcion_cuenta IS
    'Descripcion de la cuenta o concepto presupuestario';
COMMENT ON COLUMN HNEACOSTA1/BUMST.naturaleza_cuenta IS
    'Naturaleza de la cuenta: DEUDORA (gasto) o ACREEDORA (ingreso)';
COMMENT ON COLUMN HNEACOSTA1/BUMST.nivel_cuenta IS
    'Nivel de la cuenta contable en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/BUMST.monto_presupuestado IS
    'Monto aprobado en el presupuesto para este centro y periodo';
COMMENT ON COLUMN HNEACOSTA1/BUMST.monto_ejecutado IS
    'Monto efectivamente ejecutado (gasto o ingreso real) en el periodo';
COMMENT ON COLUMN HNEACOSTA1/BUMST.monto_comprometido IS
    'Monto comprometido pendiente que afecta el saldo disponible presupuestario';
COMMENT ON COLUMN HNEACOSTA1/BUMST.saldo_disponible IS
    'Saldo disponible: presupuestado menos ejecutado y comprometido';
COMMENT ON COLUMN HNEACOSTA1/BUMST.variacion_absoluta IS
    'Diferencia absoluta entre monto ejecutado y presupuestado';
COMMENT ON COLUMN HNEACOSTA1/BUMST.variacion_porcentual IS
    'Porcentaje de ejecucion presupuestaria sobre el monto aprobado';
COMMENT ON COLUMN HNEACOSTA1/BUMST.saldo_actual IS
    'Saldo contable real de la cuenta en el periodo para comparacion';
COMMENT ON COLUMN HNEACOSTA1/BUMST.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de actualizacion de ejecucion';
COMMENT ON COLUMN HNEACOSTA1/BUMST.usuario_creacion IS
    'Usuario que registro o cargo la partida presupuestaria';
COMMENT ON COLUMN HNEACOSTA1/BUMST.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro presupuestario';
COMMENT ON COLUMN HNEACOSTA1/BUMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BUMST.observaciones IS
    'Notas sobre la partida presupuestaria, ajustes o reasignaciones';
COMMENT ON COLUMN HNEACOSTA1/BUMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BUMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BUMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BUMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_presupuesto       TEXT IS 'No. Presup',
    centro_costo             TEXT IS 'Centro Costo',
    anio_fiscal              TEXT IS 'Anio Fiscal',
    mes_presupuesto          TEXT IS 'Mes',
    cuenta_contable          TEXT IS 'Cta Contable',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    monto_presupuestado      TEXT IS 'Mto Presup',
    monto_ejecutado          TEXT IS 'Mto Ejec',
    monto_comprometido       TEXT IS 'Mto Comprom',
    saldo_disponible         TEXT IS 'Saldo Disp',
    variacion_absoluta       TEXT IS 'Var Absoluta',
    variacion_porcentual     TEXT IS 'Var Porc',
    saldo_actual             TEXT IS 'Saldo Real',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IBUMSTCAT ON HNEACOSTA1/BUMST (created_at);
CREATE INDEX HNEACOSTA1/IBUMSTCC  ON HNEACOSTA1/BUMST (centro_costo);
CREATE INDEX HNEACOSTA1/IBUMSTANIO ON HNEACOSTA1/BUMST (anio_fiscal, mes_presupuesto);
