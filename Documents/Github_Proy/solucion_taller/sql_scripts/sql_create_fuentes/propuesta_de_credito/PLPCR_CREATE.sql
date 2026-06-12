-- ==============================================================================
-- Nombre de la Tabla  : PLPCR
-- DESCRIPCION         : Maestro de Propuestas de Crédito. Contiene la cabecera
--                       de cada solicitud formal de crédito presentada por un
--                       cliente, con monto, plazo, tasa, dictamen y estado.
-- Objetivo            : Registrar y controlar el ciclo de vida de cada
--                       propuesta de crédito desde su creación hasta su
--                       aprobación o rechazo.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por oficial de crédito en módulo de propuestas
-- Permanencia de Datos: Permanente con histórico
-- Uso de los datos    : Módulo de Propuesta de Crédito - consulta, aprobación
--                       y seguimiento de solicitudes
-- Restricciones       : numero_propuesta único; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/PLPCR (
    numero_propuesta      FOR COLUMN NUMPROP  VARCHAR(30)      NOT NULL,
    fecha_propuesta       FOR COLUMN FECPROP  DATE             NOT NULL,
    monto_solicitado      FOR COLUMN MONTSOL  DECIMAL(18, 2)   NOT NULL DEFAULT 0,
    plazo_meses           FOR COLUMN PLZMESES INTEGER          NOT NULL DEFAULT 0,
    tasa_propuesta        FOR COLUMN TASAPROP DECIMAL(18, 2)   NOT NULL DEFAULT 0,
    dictamen_credito      FOR COLUMN DICTCRED VARCHAR(120)     NOT NULL DEFAULT '',
    estado_propuesta      FOR COLUMN ESTPROP  VARCHAR(20)      NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)      NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)      NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER          NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)     NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)          NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PLPCR PRIMARY KEY (numero_propuesta)
)
RCDFMT PLPCRR;

RENAME TABLE HNEACOSTA1/PLPCR
    TO PLPCR FOR SYSTEM NAME PLPCR;

COMMENT ON TABLE HNEACOSTA1/PLPCR IS
    'Maestro de Propuestas de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/PLPCR IS
    'Propuestas de Credito';

COMMENT ON COLUMN HNEACOSTA1/PLPCR.numero_propuesta      IS 'Numero unico de identificacion de la propuesta de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.fecha_propuesta       IS 'Fecha en que se registro la propuesta de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.monto_solicitado      IS 'Monto total solicitado en la propuesta de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.plazo_meses           IS 'Plazo solicitado en meses para la operacion de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.tasa_propuesta        IS 'Tasa de interes propuesta para la operacion de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.dictamen_credito      IS 'Dictamen o resolucion emitida por el comite de credito';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.estado_propuesta      IS 'Estado actual de la propuesta: PENDIENTE, APROBADA, RECHAZADA';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.usuario_creacion      IS 'Usuario que registro la propuesta en el sistema';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.observaciones         IS 'Notas adicionales o comentarios sobre la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/PLPCR.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/PLPCR (
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

CREATE INDEX HNEACOSTA1/IDX_PLPCR_C ON HNEACOSTA1/PLPCR (created_at);
