-- ================================================================
-- Nombre de la Tabla  : NXINP
-- DESCRIPCION         : Transacciones Contables del Proximo Dia
-- Objetivo            : Registrar los asientos contables con fecha del
--                       dia siguiente, generados anticipadamente por el
--                       proceso de cierre o por transacciones programadas,
--                       para ser aplicados al abrir el siguiente dia operativo.
-- Tipo de Tabla       : Transaccional / Pre-cierre
-- Origen de los Datos : Proceso de cierre diario y transacciones programadas
-- Permanencia de Datos: Transitoria (se aplica al abrir el siguiente dia)
-- Uso de los datos    : Apertura del dia operativo siguiente
-- Restricciones       : FK hacia GLMST por cuenta_contable
--                       (segun ERD: GLMST ||--o{ NXINP)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE NXINP (
    numero_batch             FOR COLUMN NXINPBAT VARCHAR(30)    NOT NULL,
    secuencia                FOR COLUMN NXINPSEQ INT            NOT NULL,
    descripcion_cuenta       FOR COLUMN NXINPDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN NXINPNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN NXINPNIV VARCHAR(50),
    saldo_actual             FOR COLUMN NXINPSAL DECIMAL(18,2),
    estado_asiento           FOR COLUMN NXINPEAS VARCHAR(20)    NOT NULL,
    fecha_proceso_sistema    FOR COLUMN NXINPFPS TIMESTAMP,
    observaciones            FOR COLUMN NXINPOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN NXINPUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN NXINPUSA VARCHAR(30),
    version_registro         FOR COLUMN NXINPVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN NXINPERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN NXINPCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN NXINPUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_NXINP PRIMARY KEY (numero_batch, secuencia)
    --CONSTRAINT FK_NXINP_GLMST FOREIGN KEY (cuenta_contable)
    --    REFERENCES GLMST (cuenta_contable)
)
RCDFMT NXINPR;

RENAME TABLE NXINP
    TO NXINP_TABLE FOR SYSTEM NAME NXINP;

COMMENT ON TABLE NXINP IS
    'Transacciones Contables del Proximo Dia - Modulo 7 Contabilidad';

LABEL ON TABLE NXINP
    IS 'Trans Contab Prox Dia';

COMMENT ON COLUMN NXINP.numero_batch IS
    'Identificador del lote batch con las transacciones del dia siguiente';
COMMENT ON COLUMN NXINP.secuencia IS
    'Numero de secuencia del asiento dentro del batch de proximo dia';
COMMENT ON COLUMN NXINP.descripcion_cuenta IS
    'Descripcion de la cuenta contable del asiento programado';
COMMENT ON COLUMN NXINP.naturaleza_cuenta IS
    'Naturaleza de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN NXINP.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN NXINP.saldo_actual IS
    'Saldo de la cuenta al momento de programar el asiento del proximo dia';
COMMENT ON COLUMN NXINP.fecha_proceso_sistema IS
    'Marca de tiempo del proceso que genero o programo el asiento';
COMMENT ON COLUMN NXINP.observaciones IS
    'Notas sobre el asiento programado o condiciones de su aplicacion';
COMMENT ON COLUMN NXINP.usuario_creacion IS
    'Usuario o proceso que programo el asiento del proximo dia';
COMMENT ON COLUMN NXINP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN NXINP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN NXINP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN NXINP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN NXINP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN NXINP (
    numero_batch             TEXT IS 'No. Batch',
    secuencia                TEXT IS 'Secuencia',
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

CREATE INDEX INXINPPK ON NXINP (numero_batch, secuencia);
CREATE INDEX INXINPCAT ON NXINP (created_at);

