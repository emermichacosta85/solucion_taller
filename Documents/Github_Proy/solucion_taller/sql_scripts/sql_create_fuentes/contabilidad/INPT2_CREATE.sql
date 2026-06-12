-- ================================================================
-- Nombre de la Tabla  : INPT2
-- DESCRIPCION         : Entradas Contables Automaticas de Fin de Dia
-- Objetivo            : Registrar los asientos contables generados
--                       automaticamente por el proceso de cierre de dia
--                       (acumulacion de intereses, provisiones, diferencias
--                       de cambio, reversiones, etc.), diferenciados de
--                       los asientos manuales en INPUT.
-- Tipo de Tabla       : Transaccional / Cierre de Dia
-- Origen de los Datos : Procesos batch automaticos de cierre de dia
-- Permanencia de Datos: Historica
-- Uso de los datos    : Auditoria de asientos de cierre, conciliacion
--                       y verificacion del proceso batch diario
-- Restricciones       : FK hacia GLMST por cuenta_contable
--                       (segun ERD: GLMST ||--o{ INPT2)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/INPT2 (
    id                       BIGINT         NOT NULL     FOR COLUMN INPT2ID,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN INPT2CTC,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN INPT2BNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN INPT2SUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN INPT2MON,
    fecha_proceso            DATE           NOT NULL     FOR COLUMN INPT2FPR,
    tipo_asiento_automatico  VARCHAR(20)    NOT NULL     FOR COLUMN INPT2TAA,
    tipo_movimiento          CHAR(1)        NOT NULL     FOR COLUMN INPT2TMV,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN INPT2MNT,
    referencia_proceso       VARCHAR(50)                 FOR COLUMN INPT2REF,
    centro_costo             VARCHAR(50)                 FOR COLUMN INPT2CC,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN INPT2DSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN INPT2NCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN INPT2NIV,
    saldo_actual             DECIMAL(18,2)               FOR COLUMN INPT2SAL,
    estado_asiento           VARCHAR(20)    NOT NULL     FOR COLUMN INPT2EAS,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN INPT2FPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN INPT2USC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN INPT2USA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN INPT2VRS,
    observaciones            VARCHAR(120)                FOR COLUMN INPT2OBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN INPT2ERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN INPT2CAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN INPT2UAT,
    CONSTRAINT PK_INPT2 PRIMARY KEY (id),
    CONSTRAINT FK_INPT2_GLMST FOREIGN KEY (cuenta_contable)
        REFERENCES HNEACOSTA1/GLMST (cuenta_contable)
)
RCDFMT INPT2R;

RENAME TABLE HNEACOSTA1/INPT2
    TO INPT2 FOR SYSTEM NAME INPT2;

COMMENT ON TABLE HNEACOSTA1/INPT2 IS
    'Entradas Contables Automaticas de Fin de Dia - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/INPT2
    IS 'Asientos Auto Fin Dia';

COMMENT ON COLUMN HNEACOSTA1/INPT2.id IS
    'Identificador tecnico unico autoincremental del asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.cuenta_contable IS
    'Numero de cuenta contable afectada por el asiento automatico (FK GLMST)';
COMMENT ON COLUMN HNEACOSTA1/INPT2.codigo_banco IS
    'Codigo del banco al que pertenece el asiento automatico de cierre';
COMMENT ON COLUMN HNEACOSTA1/INPT2.codigo_sucursal IS
    'Codigo de la sucursal en la que se genera el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.fecha_proceso IS
    'Fecha contable del proceso de fin de dia que genero el asiento';
COMMENT ON COLUMN HNEACOSTA1/INPT2.tipo_asiento_automatico IS
    'Proceso que genero el asiento: INTERES, PROVISION, DIFERENCIA_CAMBIO, REVERSION';
COMMENT ON COLUMN HNEACOSTA1/INPT2.tipo_movimiento IS
    'Naturaleza del movimiento contable automatico: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/INPT2.monto IS
    'Monto del movimiento contable automatico en la moneda del asiento';
COMMENT ON COLUMN HNEACOSTA1/INPT2.referencia_proceso IS
    'Referencia del proceso batch o batch ID que genero este asiento';
COMMENT ON COLUMN HNEACOSTA1/INPT2.centro_costo IS
    'Centro de costo al que se imputa el asiento cuando la cuenta lo requiere';
COMMENT ON COLUMN HNEACOSTA1/INPT2.descripcion_cuenta IS
    'Descripcion de la cuenta contable afectada por el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.naturaleza_cuenta IS
    'Naturaleza de la cuenta contable afectada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/INPT2.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/INPT2.saldo_actual IS
    'Saldo de la cuenta antes de aplicar el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.estado_asiento IS
    'Estado del asiento automatico: GENERADO, CONTABILIZADO, REVERSADO, ERROR';
COMMENT ON COLUMN HNEACOSTA1/INPT2.fecha_proceso_sistema IS
    'Marca de tiempo del proceso batch que genero el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.usuario_creacion IS
    'Proceso batch o usuario que genero el asiento automatico';
COMMENT ON COLUMN HNEACOSTA1/INPT2.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/INPT2.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/INPT2.observaciones IS
    'Notas sobre el asiento automatico o condiciones del proceso que lo origino';
COMMENT ON COLUMN HNEACOSTA1/INPT2.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/INPT2.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/INPT2.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/INPT2 (
    id                       TEXT IS 'ID Asiento',
    cuenta_contable          TEXT IS 'Cta Contable',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_proceso            TEXT IS 'Fec Proceso',
    tipo_asiento_automatico  TEXT IS 'Tipo Asiento',
    tipo_movimiento          TEXT IS 'D/C',
    monto                    TEXT IS 'Monto',
    referencia_proceso       TEXT IS 'Ref Proceso',
    centro_costo             TEXT IS 'Centro Costo',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Prev',
    estado_asiento           TEXT IS 'Estado',
    fecha_proceso_sistema    TEXT IS 'Fec Sis',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IINPT2CTC ON HNEACOSTA1/INPT2 (cuenta_contable);
CREATE INDEX HNEACOSTA1/IINPT2FPR ON HNEACOSTA1/INPT2 (fecha_proceso);
CREATE INDEX HNEACOSTA1/IINPT2CAT ON HNEACOSTA1/INPT2 (created_at);
CREATE INDEX HNEACOSTA1/IINPT2TAA ON HNEACOSTA1/INPT2 (tipo_asiento_automatico);
