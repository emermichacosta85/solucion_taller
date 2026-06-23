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

CREATE OR REPLACE TABLE INPT2 (
    id                       FOR COLUMN INPT2ID BIGINT         NOT NULL,
    descripcion_cuenta       FOR COLUMN INPT2DSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN INPT2NCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN INPT2NIV VARCHAR(50),
    saldo_actual             FOR COLUMN INPT2SAL DECIMAL(18,2),
    fecha_proceso_sistema    FOR COLUMN INPT2FPS TIMESTAMP,
    observaciones            FOR COLUMN INPT2OBS VARCHAR(120),
    usuario_creacion         FOR COLUMN INPT2USC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN INPT2USA VARCHAR(30),
    version_registro         FOR COLUMN INPT2VRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN INPT2ERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN INPT2CAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN INPT2UAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_INPT2 PRIMARY KEY (id)
    --CONSTRAINT FK_INPT2_GLMST FOREIGN KEY (cuenta_contable)
    --    REFERENCES GLMST (cuenta_contable)
)
RCDFMT INPT2R;

RENAME TABLE INPT2
    TO INPT2_TABLE FOR SYSTEM NAME INPT2;

COMMENT ON TABLE INPT2 IS
    'Entradas Contables Automaticas de Fin de Dia - Modulo 7 Contabilidad';

LABEL ON TABLE INPT2
    IS 'Asientos Auto Fin Dia';

COMMENT ON COLUMN INPT2.id IS
    'Identificador tecnico unico autoincremental del asiento automatico';
COMMENT ON COLUMN INPT2.descripcion_cuenta IS
    'Descripcion de la cuenta contable afectada por el asiento automatico';
COMMENT ON COLUMN INPT2.naturaleza_cuenta IS
    'Naturaleza de la cuenta contable afectada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN INPT2.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN INPT2.saldo_actual IS
    'Saldo de la cuenta antes de aplicar el asiento automatico';
COMMENT ON COLUMN INPT2.fecha_proceso_sistema IS
    'Marca de tiempo del proceso batch que genero el asiento automatico';
COMMENT ON COLUMN INPT2.observaciones IS
    'Notas sobre el asiento automatico o condiciones del proceso que lo origino';
COMMENT ON COLUMN INPT2.usuario_creacion IS
    'Proceso batch o usuario que genero el asiento automatico';
COMMENT ON COLUMN INPT2.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN INPT2.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN INPT2.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN INPT2.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN INPT2.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN INPT2 (
    id                       TEXT IS 'ID Asiento',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Prev',
    fecha_proceso_sistema    TEXT IS 'Fec Sis',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IINPT2PK ON INPT2 (id);
CREATE INDEX IINPT2CAT ON INPT2 (created_at);

