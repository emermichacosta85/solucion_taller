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

CREATE OR REPLACE TABLE HNEACOSTA1/LCFMT (
    codigo_documento        VARCHAR(20)     NOT NULL    FOR COLUMN LCFMTCDO,
    secuencia_de_texto      VARCHAR(50)     NOT NULL    FOR COLUMN LCFMTSEQ,
    numero_linea            VARCHAR(30)     NOT NULL    FOR COLUMN LCFMTNLN,
    texto_linea             VARCHAR(200)                FOR COLUMN LCFMTTXT,
    tipo_campo              VARCHAR(20)                 FOR COLUMN LCFMTTCP,
    longitud_campo          INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN LCFMTLCA,
    fecha_emision           DATE                        FOR COLUMN LCFMTFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCFMTFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCFMTMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCFMTSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCFMTBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCFMTPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCFMTEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCFMTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCFMTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCFMTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCFMTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCFMTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCFMTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCFMTUAT,
    CONSTRAINT PK_LCFMT PRIMARY KEY (codigo_documento, secuencia_de_texto, numero_linea)
)
RCDFMT LCFMTR;

RENAME TABLE HNEACOSTA1/LCFMT
    TO LCFMT FOR SYSTEM NAME LCFMT;

COMMENT ON TABLE HNEACOSTA1/LCFMT IS
    'Formatos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCFMT
    IS 'Formatos LC';

COMMENT ON COLUMN HNEACOSTA1/LCFMT.codigo_documento IS
    'Codigo del documento al que pertenece este formato segun catalogo';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.secuencia_de_texto IS
    'Identificador de secuencia del texto dentro del documento';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.numero_linea IS
    'Numero de linea del formato dentro de la secuencia de texto';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.texto_linea IS
    'Contenido o plantilla de texto de la linea del formato';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.tipo_campo IS
    'Tipo del campo en la linea: FIJO, VARIABLE, NUMERICO, FECHA';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.longitud_campo IS
    'Longitud maxima del campo en la linea del formato';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCFMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCFMT (
    codigo_documento             TEXT IS 'Cod Doc',
    secuencia_de_texto           TEXT IS 'Secuencia',
    numero_linea                 TEXT IS 'No. Linea',
    texto_linea                  TEXT IS 'Texto',
    tipo_campo                   TEXT IS 'Tipo Campo',
    longitud_campo               TEXT IS 'Long Campo',
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

CREATE INDEX HNEACOSTA1/ILCFMTCAT ON HNEACOSTA1/LCFMT (created_at);
CREATE INDEX HNEACOSTA1/ILCFMTCDO ON HNEACOSTA1/LCFMT (codigo_documento);

-- =============================================================================
-- Fin de script: LCFMT_CREATE.sql
-- =============================================================================
