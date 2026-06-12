-- =============================================================================
-- Nombre de la Tabla  : LCDIN
-- DESCRIPCION         : Documentos Recibidos en Cartas de Credito. Registra cada
--                       documento fisico recibido en el proceso de negociacion.
-- Objetivo            : Controlar la recepcion, revision y conformidad de los documentos
--                       presentados por el beneficiario en el marco de cada
--                       carta de credito, registrando discrepancias si las hay.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Recepcion fisica de documentos en el area de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Revision de conformidad documental, gestion de discrepancias y auditoria
-- Restricciones       : FK hacia LCMST por numero_carta_credito.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCDIN (
    numero_carta_credito    VARCHAR(30)     NOT NULL    FOR COLUMN LCDINNCC,
    secuencia               INT             NOT NULL    FOR COLUMN LCDINSEQ,
    tipo_documento          VARCHAR(20)                 FOR COLUMN LCDINTDO,
    descripcion_documento   VARCHAR(120)                FOR COLUMN LCDINDES,
    fecha_recepcion         DATE                        FOR COLUMN LCDINFRE,
    fecha_presentacion      DATE                        FOR COLUMN LCDINFPR,
    estado_documento        VARCHAR(20)                 FOR COLUMN LCDINEDO,
    discrepancia            CHAR(1)         NOT NULL
                                            DEFAULT 'N' FOR COLUMN LCDINDIS,
    descripcion_discrepancia VARCHAR(200)               FOR COLUMN LCDINDDP,
    fecha_emision           DATE                        FOR COLUMN LCDINFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCDINFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCDINMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCDINSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCDINBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCDINPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCDINEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCDINUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCDINUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCDINVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCDINOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCDINERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCDINCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCDINUAT,
    CONSTRAINT PK_LCDIN PRIMARY KEY (numero_carta_credito, secuencia),
    CONSTRAINT FK_LCDIN_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT LCDINR;

RENAME TABLE HNEACOSTA1/LCDIN
    TO LCDIN FOR SYSTEM NAME LCDIN;

COMMENT ON TABLE HNEACOSTA1/LCDIN IS
    'Documentos Recibidos en Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCDIN
    IS 'Docs Recibidos LC';

COMMENT ON COLUMN HNEACOSTA1/LCDIN.numero_carta_credito IS
    'Numero de la carta de credito que recibe los documentos (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.secuencia IS
    'Numero de secuencia del documento recibido dentro de la carta';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.tipo_documento IS
    'Tipo de documento recibido: CONOCIMIENTO, FACTURA, POLIZA, CERTIFICADO';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.descripcion_documento IS
    'Descripcion del documento recibido para identificacion operativa';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.fecha_recepcion IS
    'Fecha en que el banco recibio fisicamente el documento';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.fecha_presentacion IS
    'Fecha de presentacion formal del documento ante el banco';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.estado_documento IS
    'Estado del documento: RECIBIDO, REVISADO, CONFORME, CON_DISCREPANCIA';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.discrepancia IS
    'Indica si el documento presenta discrepancias: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.descripcion_discrepancia IS
    'Descripcion detallada de las discrepancias encontradas en el documento';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCDIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCDIN (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    secuencia                    TEXT IS 'Secuencia',
    tipo_documento               TEXT IS 'Tipo Doc',
    descripcion_documento        TEXT IS 'Desc Doc',
    fecha_recepcion              TEXT IS 'Fec Recepcion',
    fecha_presentacion           TEXT IS 'Fec Presentac',
    estado_documento             TEXT IS 'Estado Doc',
    discrepancia                 TEXT IS 'Discrepancia',
    descripcion_discrepancia     TEXT IS 'Desc Discrepan',
    fecha_emision                TEXT IS 'Fec Emision',
    fecha_vencimiento            TEXT IS 'Fec Vencim',
    monto_original               TEXT IS 'Monto Orig',
    saldo_actual                 TEXT IS 'Saldo Actual',
    banco_corresponsal           TEXT IS 'Banco Corresp',
    pais_destino                 TEXT IS 'Pais Destino',
    estado_carta                 TEXT IS 'Estado Carta',
    usuario_creacion             TEXT IS 'Usr Creacion',
    usuario_actualizacion        TEXT IS 'Usr Actualiz',
    version_registro             TEXT IS 'Version Reg',
    observaciones                TEXT IS 'Observacion',
    estado_registro              TEXT IS 'Estado Reg',
    created_at                   TEXT IS 'Fec Creacion',
    updated_at                   TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ILCDINNCC ON HNEACOSTA1/LCDIN (numero_carta_credito);
CREATE INDEX HNEACOSTA1/ILCDINFRE ON HNEACOSTA1/LCDIN (fecha_recepcion);
CREATE INDEX HNEACOSTA1/ILCDINCAT ON HNEACOSTA1/LCDIN (created_at);

-- =============================================================================
-- Fin de script: LCDIN_CREATE.sql
-- =============================================================================
