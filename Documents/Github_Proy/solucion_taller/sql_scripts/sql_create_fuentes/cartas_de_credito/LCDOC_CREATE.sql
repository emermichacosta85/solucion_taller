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

CREATE OR REPLACE TABLE LCDOC (
    numero_carta_credito     FOR COLUMN LCDOCNCC   VARCHAR(30)    NOT NULL,
    tipo_registro            FOR COLUMN LCDOCTRG   VARCHAR(20)    NOT NULL,
    codigo_banco             FOR COLUMN LCDOCBNK   VARCHAR(20)    NOT NULL,
    codigo_documento         FOR COLUMN LCDOCCDO   VARCHAR(20)    NOT NULL,
    numero_linea             FOR COLUMN LCDOCNLN   VARCHAR(30)    NOT NULL,
    fecha_emision            FOR COLUMN LCDOCFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCDOCFVE   DATE,
    monto_original           FOR COLUMN LCDOCMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCDOCSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCDOCBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCDOCPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCDOCEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCDOCUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCDOCUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCDOCVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCDOCOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCDOCERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCDOCCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCDOCUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCDOC PRIMARY KEY (numero_carta_credito, tipo_registro,
                                     codigo_banco, codigo_documento, numero_linea)
)
RCDFMT LCDOCR;

RENAME TABLE LCDOC
    TO LCDOC_TABLE FOR SYSTEM NAME LCDOC;

COMMENT ON TABLE LCDOC IS
    'Documentos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCDOC
    IS 'Docs Carta Credito';

COMMENT ON COLUMN LCDOC.numero_carta_credito IS
    'Numero de la carta de credito a la que pertenece el documento (FK LCMST)';
COMMENT ON COLUMN LCDOC.tipo_registro IS
    'Tipo de registro documental: EXIGIDO, RECIBIDO, PENDIENTE, RECHAZADO';
COMMENT ON COLUMN LCDOC.codigo_banco IS
    'Codigo del banco que valida o emite la exigencia del documento';
COMMENT ON COLUMN LCDOC.codigo_documento IS
    'Codigo del tipo de documento segun catalogo de comercio exterior';
COMMENT ON COLUMN LCDOC.numero_linea IS
    'Numero de linea o secuencia del documento dentro del tipo';
COMMENT ON COLUMN LCDOC.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCDOC.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCDOC.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCDOC.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCDOC.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCDOC.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCDOC.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCDOC.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCDOC.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCDOC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCDOC.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCDOC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCDOC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCDOC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCDOC (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    tipo_registro                TEXT IS 'Tipo Reg',
    codigo_banco                 TEXT IS 'Banco',
    codigo_documento             TEXT IS 'Cod Doc',
    numero_linea                 TEXT IS 'No. Linea',
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

CREATE INDEX ILCDOCNCC ON LCDOC (numero_carta_credito);
CREATE INDEX ILCDOCCAT ON LCDOC (created_at);

-- =============================================================================
-- Fin de script: LCDOC_CREATE.sql
-- =============================================================================
