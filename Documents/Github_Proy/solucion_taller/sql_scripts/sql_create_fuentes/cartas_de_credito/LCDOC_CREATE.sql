-- =============================================================================
-- Nombre de la Tabla  : LCDOC
-- DESCRIPCION         : Documentos de Cartas de Credito. Registra cada documento exigido
--                       o recibido dentro de una operacion de carta de credito.
-- Objetivo            : Controlar los documentos requeridos y presentados en cada carta de credito,
--                       permitiendo verificar conformidad documental y estado
--                       de cada documento dentro del proceso de negociacion.
-- Tipo de Tabla       : Detalle / Transaccional
-- Origen de los Datos : Registro de documentos al abrir y negociar cartas de credito
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Verificacion documental, conformidad, reporteria y auditoria de cumplimiento
-- Restricciones       : FK hacia LCMST por numero_carta_credito.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCDOC (
    numero_carta_credito    VARCHAR(30)     NOT NULL    FOR COLUMN LCDOCNCC,
    tipo_registro           VARCHAR(20)     NOT NULL    FOR COLUMN LCDOCTRG,
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN LCDOCBNK,
    codigo_documento        VARCHAR(20)     NOT NULL    FOR COLUMN LCDOCCDO,
    numero_linea            VARCHAR(30)     NOT NULL    FOR COLUMN LCDOCNLN,
    descripcion_documento   VARCHAR(120)                FOR COLUMN LCDOCDES,
    cantidad_requerida      INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCDOCQRQ,
    cantidad_recibida       INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN LCDOCQRC,
    estado_documento        VARCHAR(20)                 FOR COLUMN LCDOCEDO,
    fecha_emision           DATE                        FOR COLUMN LCDOCFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCDOCFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCDOCMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCDOCSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCDOCBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCDOCPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCDOCEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCDOCUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCDOCUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCDOCVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCDOCOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCDOCERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCDOCCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCDOCUAT,
    CONSTRAINT PK_LCDOC PRIMARY KEY (numero_carta_credito, tipo_registro,
                                     codigo_banco, codigo_documento, numero_linea),
    CONSTRAINT FK_LCDOC_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT LCDOCR;

RENAME TABLE HNEACOSTA1/LCDOC
    TO LCDOC FOR SYSTEM NAME LCDOC;

COMMENT ON TABLE HNEACOSTA1/LCDOC IS
    'Documentos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCDOC
    IS 'Docs Carta Credito';

COMMENT ON COLUMN HNEACOSTA1/LCDOC.numero_carta_credito IS
    'Numero de la carta de credito a la que pertenece el documento (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.tipo_registro IS
    'Tipo de registro documental: EXIGIDO, RECIBIDO, PENDIENTE, RECHAZADO';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.codigo_banco IS
    'Codigo del banco que valida o emite la exigencia del documento';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.codigo_documento IS
    'Codigo del tipo de documento segun catalogo de comercio exterior';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.numero_linea IS
    'Numero de linea o secuencia del documento dentro del tipo';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.descripcion_documento IS
    'Descripcion del documento requerido o recibido en la operacion';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.cantidad_requerida IS
    'Cantidad de originales o copias exigidas del documento';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.cantidad_recibida IS
    'Cantidad de originales o copias efectivamente recibidas';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.estado_documento IS
    'Estado del documento: PENDIENTE, RECIBIDO, CONFORME, NO_CONFORME';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCDOC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCDOC (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    tipo_registro                TEXT IS 'Tipo Reg',
    codigo_banco                 TEXT IS 'Banco',
    codigo_documento             TEXT IS 'Cod Doc',
    numero_linea                 TEXT IS 'No. Linea',
    descripcion_documento        TEXT IS 'Desc Documento',
    cantidad_requerida           TEXT IS 'Cant Requer',
    cantidad_recibida            TEXT IS 'Cant Recib',
    estado_documento             TEXT IS 'Estado Doc',
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

CREATE INDEX HNEACOSTA1/ILCDOCNCC ON HNEACOSTA1/LCDOC (numero_carta_credito);
CREATE INDEX HNEACOSTA1/ILCDOCCAT ON HNEACOSTA1/LCDOC (created_at);

-- =============================================================================
-- Fin de script: LCDOC_CREATE.sql
-- =============================================================================
