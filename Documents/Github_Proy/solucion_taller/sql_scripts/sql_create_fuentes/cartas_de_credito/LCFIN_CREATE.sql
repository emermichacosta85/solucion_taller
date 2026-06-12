-- =============================================================================
-- Nombre de la Tabla  : LCFIN
-- DESCRIPCION         : Indice de Formatos de Cartas de Credito. Catalogo de plantillas
--                       y textos estandar utilizados en la documentacion.
-- Objetivo            : Centralizar el indice de formatos y plantillas de texto aplicables
--                       a los distintos documentos de cartas de credito,
--                       organizados por nivel, codigo y secuencia.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion de formatos por el area de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Generacion automatica de textos en documentos de cartas de credito
-- Restricciones       : PK compuesta por nivel, codigo_documento y secuencia_de_texto.
--                       Tabla de catalogo independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCFIN (
    nivel                   INT             NOT NULL    FOR COLUMN LCFINNIV,
    codigo_documento        VARCHAR(20)     NOT NULL    FOR COLUMN LCFINCDO,
    secuencia_de_texto      VARCHAR(50)     NOT NULL    FOR COLUMN LCFINSEQ,
    descripcion             VARCHAR(120)                FOR COLUMN LCFINDSC,
    tipo_formato            VARCHAR(20)                 FOR COLUMN LCFINTFO,
    idioma                  VARCHAR(10)     NOT NULL
                                            DEFAULT 'ES' FOR COLUMN LCFINIDM,
    fecha_emision           DATE                        FOR COLUMN LCFINFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCFINFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCFINMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCFINSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCFINBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCFINPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCFINEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCFINUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCFINUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCFINVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCFINOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCFINERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCFINCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCFINUAT,
    CONSTRAINT PK_LCFIN PRIMARY KEY (nivel, codigo_documento, secuencia_de_texto)
)
RCDFMT LCFINR;

RENAME TABLE HNEACOSTA1/LCFIN
    TO LCFIN FOR SYSTEM NAME LCFIN;

COMMENT ON TABLE HNEACOSTA1/LCFIN IS
    'Indice de Formatos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCFIN
    IS 'Indice Formatos LC';

COMMENT ON COLUMN HNEACOSTA1/LCFIN.nivel IS
    'Nivel jerarquico del formato dentro del indice de cartas de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.codigo_documento IS
    'Codigo del documento al que pertenece este formato segun catalogo';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.secuencia_de_texto IS
    'Identificador de secuencia del texto dentro del nivel y documento';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.descripcion IS
    'Descripcion del formato o plantilla de texto indexado';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.tipo_formato IS
    'Tipo de formato: APERTURA, ENMIENDA, PAGO, NOTIFICACION, RECHAZO';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.idioma IS
    'Codigo del idioma del formato: ES=Espanol, EN=Ingles';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCFIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCFIN (
    nivel                        TEXT IS 'Nivel',
    codigo_documento             TEXT IS 'Cod Doc',
    secuencia_de_texto           TEXT IS 'Secuencia',
    descripcion                  TEXT IS 'Descripcion',
    tipo_formato                 TEXT IS 'Tipo Formato',
    idioma                       TEXT IS 'Idioma',
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

CREATE INDEX HNEACOSTA1/ILCFINCAT ON HNEACOSTA1/LCFIN (created_at);
CREATE INDEX HNEACOSTA1/ILCFINCDO ON HNEACOSTA1/LCFIN (codigo_documento);

-- =============================================================================
-- Fin de script: LCFIN_CREATE.sql
-- =============================================================================
