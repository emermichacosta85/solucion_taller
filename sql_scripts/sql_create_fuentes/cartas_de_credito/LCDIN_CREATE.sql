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

CREATE OR REPLACE TABLE LCDIN (
    numero_carta_credito     FOR COLUMN LCDINNCC   VARCHAR(30)    NOT NULL,
    secuencia                FOR COLUMN LCDINSEQ   INT            NOT NULL,
    fecha_emision            FOR COLUMN LCDINFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCDINFVE   DATE,
    monto_original           FOR COLUMN LCDINMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCDINSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCDINBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCDINPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCDINEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCDINUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCDINUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCDINVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCDINOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCDINERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCDINCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCDINUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCDIN PRIMARY KEY (numero_carta_credito, secuencia)
)
RCDFMT LCDINR;

RENAME TABLE LCDIN
    TO LCDIN_TABLE FOR SYSTEM NAME LCDIN;

COMMENT ON TABLE LCDIN IS
    'Documentos Recibidos en Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCDIN
    IS 'Docs Recibidos LC';

COMMENT ON COLUMN LCDIN.numero_carta_credito IS
    'Numero de la carta de credito que recibe los documentos (FK LCMST)';
COMMENT ON COLUMN LCDIN.secuencia IS
    'Numero de secuencia del documento recibido dentro de la carta';
COMMENT ON COLUMN LCDIN.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCDIN.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCDIN.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCDIN.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCDIN.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCDIN.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCDIN.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCDIN.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCDIN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCDIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCDIN.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCDIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCDIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCDIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCDIN (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    secuencia                    TEXT IS 'Secuencia',
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

CREATE INDEX ILCDINNCC ON LCDIN (numero_carta_credito);

CREATE INDEX ILCDINCAT ON LCDIN (created_at);

-- =============================================================================
-- Fin de script: LCDIN_CREATE.sql
-- =============================================================================
