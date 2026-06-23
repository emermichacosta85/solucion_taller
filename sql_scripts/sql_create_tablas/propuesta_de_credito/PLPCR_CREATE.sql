-- ==============================================================================
-- Nombre de la Tabla  : PLPCR
-- DESCRIPCION         : Maestro de Propuestas de Credito. Contiene la cabecera
--                       de cada solicitud formal de credito presentada por un
--                       cliente, con monto, plazo, tasa, dictamen y estado.
-- Objetivo            : Registrar y controlar el ciclo de vida de cada
--                       propuesta de credito desde su creacion hasta su
--                       aprobacion o rechazo.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por oficial de credito en modulo de propuestas
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo de Propuesta de Credito - consulta, aprobacion
--                       y seguimiento de solicitudes
-- Restricciones       : numero_propuesta unico; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE PLPCR (
    numero_propuesta      FOR COLUMN PLPCRNPR  VARCHAR(30)    NOT NULL,
    fecha_propuesta       FOR COLUMN PLPCRFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN PLPCRMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN PLPCRPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN PLPCRTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN PLPCRDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN PLPCREPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN PLPCRUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN PLPCRUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN PLPCRVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN PLPCROBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN PLPCRERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN PLPCRCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN PLPCRUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PLPCR PRIMARY KEY (numero_propuesta)
)
RCDFMT PLPCRR;

RENAME TABLE PLPCR
    TO PLPCR_TABLE FOR SYSTEM NAME PLPCR;

COMMENT ON TABLE PLPCR IS
    'Maestro de Propuestas de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE PLPCR IS
    'Propuestas de Credito';

COMMENT ON COLUMN PLPCR.numero_propuesta      IS 'Numero unico de identificacion de la propuesta de credito';
COMMENT ON COLUMN PLPCR.fecha_propuesta       IS 'Fecha en que se registro la propuesta de credito';
COMMENT ON COLUMN PLPCR.monto_solicitado      IS 'Monto total solicitado en la propuesta de credito';
COMMENT ON COLUMN PLPCR.plazo_meses           IS 'Plazo solicitado en meses para la operacion de credito';
COMMENT ON COLUMN PLPCR.tasa_propuesta        IS 'Tasa de interes propuesta para la operacion de credito';
COMMENT ON COLUMN PLPCR.dictamen_credito      IS 'Dictamen o resolucion emitida por el comite de credito';
COMMENT ON COLUMN PLPCR.estado_propuesta      IS 'Estado actual de la propuesta: PENDIENTE, APROBADA, RECHAZADA';
COMMENT ON COLUMN PLPCR.usuario_creacion      IS 'Usuario que registro la propuesta en el sistema';
COMMENT ON COLUMN PLPCR.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN PLPCR.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN PLPCR.observaciones         IS 'Notas adicionales o comentarios sobre la propuesta';
COMMENT ON COLUMN PLPCR.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN PLPCR.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN PLPCR.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN PLPCR (
    numero_propuesta      IS 'No. Propuesta',
    fecha_propuesta       IS 'Fec Propuesta',
    monto_solicitado      IS 'Monto Solic',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Prop',
    dictamen_credito      IS 'Dictamen',
    estado_propuesta      IS 'Estado Prop',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN PLPCR (
    numero_propuesta      TEXT IS 'Numero de Propuesta',
    fecha_propuesta       TEXT IS 'Fecha de Propuesta',
    monto_solicitado      TEXT IS 'Monto Solicitado',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Propuesta',
    dictamen_credito      TEXT IS 'Dictamen de Credito',
    estado_propuesta      TEXT IS 'Estado de Propuesta',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_PLPCR_C ON PLPCR (created_at);
