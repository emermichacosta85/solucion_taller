-- =============================================================================
-- Nombre de la Tabla  : LCFMT
-- DESCRIPCION         : Formatos de Cartas de Credito. Almacena el contenido linea a
--                       linea de cada plantilla de formato documental.
-- Objetivo            : Registrar el detalle de cada linea de texto de los formatos de
--                       documentos de cartas de credito, permitiendo
--                       la generacion automatica de documentos estandar.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion de plantillas de formato por comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Impresion y generacion de documentos de cartas de credito
-- Restricciones       : PK compuesta por codigo_documento, secuencia_de_texto y numero_linea.
--                       Tabla de catalogo independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE LCFMT (
    codigo_documento         FOR COLUMN LCFMTCDO   VARCHAR(20)    NOT NULL,
    secuencia_de_texto       FOR COLUMN LCFMTSEQ   VARCHAR(50)    NOT NULL,
    numero_linea             FOR COLUMN LCFMTNLN   VARCHAR(30)    NOT NULL,
    fecha_emision            FOR COLUMN LCFMTFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCFMTFVE   DATE,
    monto_original           FOR COLUMN LCFMTMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCFMTSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCFMTBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCFMTPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCFMTEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCFMTUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCFMTUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCFMTVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCFMTOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCFMTERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCFMTCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCFMTUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCFMT PRIMARY KEY (codigo_documento, secuencia_de_texto, numero_linea)
)
RCDFMT LCFMTR;

RENAME TABLE LCFMT
    TO LCFMT_TABLE FOR SYSTEM NAME LCFMT;

COMMENT ON TABLE LCFMT IS
    'Formatos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCFMT
    IS 'Formatos LC';

COMMENT ON COLUMN LCFMT.codigo_documento IS
    'Codigo del documento al que pertenece este formato segun catalogo';
COMMENT ON COLUMN LCFMT.secuencia_de_texto IS
    'Identificador de secuencia del texto dentro del documento';
COMMENT ON COLUMN LCFMT.numero_linea IS
    'Numero de linea del formato dentro de la secuencia de texto';
COMMENT ON COLUMN LCFMT.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCFMT.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCFMT.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCFMT.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCFMT.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCFMT.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCFMT.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCFMT.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCFMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCFMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCFMT.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCFMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCFMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCFMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCFMT (
    codigo_documento             TEXT IS 'Cod Doc',
    secuencia_de_texto           TEXT IS 'Secuencia',
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

CREATE INDEX ILCFMTCAT ON LCFMT (created_at);
CREATE INDEX ILCFMTCDO ON LCFMT (codigo_documento);

-- =============================================================================
-- Fin de script: LCFMT_CREATE.sql
-- =============================================================================
