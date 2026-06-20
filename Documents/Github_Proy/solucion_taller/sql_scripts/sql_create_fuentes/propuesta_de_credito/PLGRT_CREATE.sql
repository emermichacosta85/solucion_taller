-- ==============================================================================
-- Nombre de la Tabla  : PLGRT
-- DESCRIPCION         : Garantias asociadas a las propuestas de credito.
--                       Registra cada bien o instrumento ofrecido como
--                       respaldo a la propuesta.
-- Objetivo            : Documentar y controlar las garantias presentadas por
--                       el cliente para respaldar cada propuesta de credito.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso por oficial de credito o analista de garantias
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo de Propuesta de Credito - evaluacion de riesgo
-- Restricciones       : FK a PLPCR.numero_propuesta; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE PLGRT (
    numero_propuesta      FOR COLUMN PLGRTNPR  VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN PLGRTSEQ  INT            NOT NULL,
    fecha_propuesta       FOR COLUMN PLGRTFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN PLGRTMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN PLGRTPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN PLGRTTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN PLGRTDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN PLGRTEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN PLGRTUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN PLGRTUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN PLGRTVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN PLGRTOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN PLGRTERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN PLGRTCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN PLGRTUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PLGRT PRIMARY KEY (numero_propuesta, secuencia)
    --CONSTRAINT FK_PLGRT_PLPCR FOREIGN KEY (numero_propuesta)
    --    REFERENCES PLPCR (numero_propuesta)
)
RCDFMT PLGRTR;

RENAME TABLE PLGRT
    TO PLGRT_TABLE FOR SYSTEM NAME PLGRT;

COMMENT ON TABLE PLGRT IS
    'Garantias Asociadas a Propuestas de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE PLGRT IS
    'Garantias de Propuesta Credito';

COMMENT ON COLUMN PLGRT.numero_propuesta      IS 'Numero de propuesta a la que pertenece la garantia (FK PLPCR)';
COMMENT ON COLUMN PLGRT.secuencia             IS 'Numero de secuencia de la garantia dentro de la propuesta';
COMMENT ON COLUMN PLGRT.fecha_propuesta       IS 'Fecha de registro de la garantia en la propuesta';
COMMENT ON COLUMN PLGRT.monto_solicitado      IS 'Valor estimado o de cobertura de la garantia ofrecida';
COMMENT ON COLUMN PLGRT.plazo_meses           IS 'Plazo en meses de vigencia de la garantia';
COMMENT ON COLUMN PLGRT.tasa_propuesta        IS 'Tasa de referencia asociada a la valoracion de la garantia';
COMMENT ON COLUMN PLGRT.dictamen_credito      IS 'Resultado de la evaluacion de la garantia por analista';
COMMENT ON COLUMN PLGRT.estado_propuesta      IS 'Estado de la garantia: PRESENTADA, ACEPTADA, RECHAZADA';
COMMENT ON COLUMN PLGRT.usuario_creacion      IS 'Usuario que registro la garantia en el sistema';
COMMENT ON COLUMN PLGRT.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion a la garantia';
COMMENT ON COLUMN PLGRT.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN PLGRT.observaciones         IS 'Notas adicionales sobre la garantia registrada';
COMMENT ON COLUMN PLGRT.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN PLGRT.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN PLGRT.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN PLGRT (
    numero_propuesta      IS 'No. Propuesta',
    secuencia             IS 'Secuencia',
    fecha_propuesta       IS 'Fec Propuesta',
    monto_solicitado      IS 'Valor Garant',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Ref',
    dictamen_credito      IS 'Dictamen',
    estado_propuesta      IS 'Estado Garant',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN PLGRT (
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

CREATE INDEX IDX_PLGRT_C ON PLGRT (created_at);
