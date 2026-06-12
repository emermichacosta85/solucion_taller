-- ==============================================================================
-- Nombre de la Tabla  : PLGRT
-- DESCRIPCION         : Garantias asociadas a las propuestas de credito.
--                       Registra cada bien o instrumento ofrecido como
--                       respaldo a la propuesta.
-- Objetivo            : Documentar y controlar las garantias presentadas por
--                       el cliente para respaldar cada propuesta de credito.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso por oficial de credito o analista de garantias
-- Permanencia de Datos: Permanente con histórico
-- Uso de los datos    : Módulo de Propuesta de Crédito - evaluacion de riesgo
-- Restricciones       : FK a PLPCR.numero_propuesta; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/PLGRT (
    numero_propuesta      FOR COLUMN NUMPROP  VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
    fecha_propuesta       FOR COLUMN FECPROP  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN MONTSOL  DECIMAL(18, 2) NOT NULL DEFAULT 0,
    plazo_meses           FOR COLUMN PLZMESES INTEGER        NOT NULL DEFAULT 0,
    tasa_propuesta        FOR COLUMN TASAPROP DECIMAL(18, 2) NOT NULL DEFAULT 0,
    dictamen_credito      FOR COLUMN DICTCRED VARCHAR(120)   NOT NULL DEFAULT '',
    estado_propuesta      FOR COLUMN ESTPROP  VARCHAR(20)    NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PLGRT  PRIMARY KEY (numero_propuesta, secuencia),
    CONSTRAINT FK_PLGRT_PLPCR FOREIGN KEY (numero_propuesta)
        REFERENCES HNEACOSTA1/PLPCR (numero_propuesta)
)
RCDFMT PLGRTR;

RENAME TABLE HNEACOSTA1/PLGRT
    TO PLGRT FOR SYSTEM NAME PLGRT;

COMMENT ON TABLE HNEACOSTA1/PLGRT IS
    'Garantias Asociadas a Propuestas de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/PLGRT IS
    'Garantias de Propuesta Credito';

COMMENT ON COLUMN HNEACOSTA1/PLGRT.numero_propuesta      IS 'Numero de propuesta a la que pertenece la garantia (FK PLPCR)';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.secuencia             IS 'Numero de secuencia de la garantia dentro de la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.fecha_propuesta       IS 'Fecha de registro de la garantia en la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.monto_solicitado      IS 'Valor estimado o de cobertura de la garantia ofrecida';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.plazo_meses           IS 'Plazo en meses de vigencia de la garantia';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.tasa_propuesta        IS 'Tasa de referencia asociada a la valoracion de la garantia';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.dictamen_credito      IS 'Resultado de la evaluacion de la garantia por analista';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.estado_propuesta      IS 'Estado de la garantia: PRESENTADA, ACEPTADA, RECHAZADA';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.usuario_creacion      IS 'Usuario que registro la garantia en el sistema';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion a la garantia';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.observaciones         IS 'Notas adicionales sobre la garantia registrada';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/PLGRT.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/PLGRT (
    numero_propuesta      TEXT IS 'Numero de Propuesta',
    secuencia             TEXT IS 'Secuencia Garantia',
    fecha_propuesta       TEXT IS 'Fecha de Propuesta',
    monto_solicitado      TEXT IS 'Valor Garantia',
    plazo_meses           TEXT IS 'Plazo Vigencia Meses',
    tasa_propuesta        TEXT IS 'Tasa de Referencia',
    dictamen_credito      TEXT IS 'Dictamen Garantia',
    estado_propuesta      TEXT IS 'Estado Garantia',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_PLGRT_C ON HNEACOSTA1/PLGRT (created_at);
