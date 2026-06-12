-- =============================================================================
-- Nombre de la Tabla  : CNTRLDLS
-- DESCRIPCION         : Tabla de Tasas para Control de Prestamos.
--                       Catalogo de tasas y parametros de control aplicables
--                       a los productos de credito por banco, tabla y producto.
-- Objetivo            : Centralizar las tasas activas, maximas y minimas de los
--                       productos de prestamo del banco, permitiendo controlar
--                       que las tasas aplicadas en cada operacion esten dentro
--                       de los rangos autorizados por la gerencia y regulacion.
-- Tipo de Tabla       : Catalogo / Control
-- Origen de los Datos : Configuracion de productos crediticios por la gerencia
-- Permanencia de Datos: Permanente (con historial por producto y tabla)
-- Uso de los datos    : Validacion de tasas en originacion, reporteria regulatoria,
--                       control de margenes y auditoria de condiciones de credito
-- Restricciones       : PK compuesta por banco, numero_tabla y tipo_producto.
--                       Tabla de control independiente sin FK en este modulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLDLS (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CNTDLBNK,
    numero_tabla            VARCHAR(30)     NOT NULL    FOR COLUMN CNTDLTBL,
    tipo_producto           VARCHAR(20)     NOT NULL    FOR COLUMN CNTDLTPR,
    descripcion_tabla       VARCHAR(80)                 FOR COLUMN CNTDLDSC,
    tasa_minima             DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLTMN,
    tasa_maxima             DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLTMX,
    tasa_referencia         DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLTRF,
    plazo_minimo_meses      INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLPMN,
    plazo_maximo_meses      INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLPMX,
    monto_minimo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLMMN,
    monto_maximo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLMMX,
    vigente_desde           DATE                        FOR COLUMN CNTDLVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTDLVHA,
    fecha_desembolso        DATE                        FOR COLUMN CNTDLFDS,
    fecha_vencimiento       DATE                        FOR COLUMN CNTDLFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDLDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN CNTDLEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTDLUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTDLUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTDLVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTDLOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTDLERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTDLCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTDLUAT,
    CONSTRAINT PK_CNTRLDLS PRIMARY KEY (codigo_banco, numero_tabla, tipo_producto)
)
RCDFMT CNTDLSR;

RENAME TABLE HNEACOSTA1/CNTRLDLS
    TO CNTRLDLS FOR SYSTEM NAME CNTRLDLS;

COMMENT ON TABLE HNEACOSTA1/CNTRLDLS IS
    'Tabla de Tasas para Control de Prestamos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/CNTRLDLS
    IS 'Control Tasas Prestamos';

COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de control de tasas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.numero_tabla IS
    'Numero identificador de la tabla de tasas de prestamos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.tipo_producto IS
    'Tipo de producto de credito al que aplica la tabla de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.descripcion_tabla IS
    'Descripcion del producto crediticio y proposito de la tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.tasa_minima IS
    'Tasa de interes minima permitida para el producto en este banco';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.tasa_maxima IS
    'Tasa de interes maxima permitida segun politica y regulacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.tasa_referencia IS
    'Tasa de referencia o tasa base utilizada para calculos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.plazo_minimo_meses IS
    'Plazo minimo en meses permitido para el producto';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.plazo_maximo_meses IS
    'Plazo maximo en meses permitido para el producto';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.monto_minimo IS
    'Monto minimo del prestamo para aplicar esta tabla de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.monto_maximo IS
    'Monto maximo del prestamo segun politica de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.vigente_desde IS
    'Fecha desde la que rigen estos parametros de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.vigente_hasta IS
    'Fecha hasta la que son validos estos parametros, nula si indefinida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.fecha_desembolso IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.fecha_vencimiento IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.monto_original IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.saldo_actual IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.tasa_interes IS
    'Tasa de referencia operativa del catalogo de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.plazo_meses IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.dias_mora IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.estado_operacion IS
    'Estado de la tabla de control: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.usuario_creacion IS
    'Usuario administrador que registro la tabla de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.observaciones IS
    'Notas sobre la aplicacion o excepciones de la tabla de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDLS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLDLS (
    codigo_banco             TEXT IS 'Banco',
    numero_tabla             TEXT IS 'No. Tabla',
    tipo_producto            TEXT IS 'Tipo Prod',
    descripcion_tabla        TEXT IS 'Descripcion',
    tasa_minima              TEXT IS 'Tasa Min',
    tasa_maxima              TEXT IS 'Tasa Max',
    tasa_referencia          TEXT IS 'Tasa Ref',
    plazo_minimo_meses       TEXT IS 'Plazo Min',
    plazo_maximo_meses       TEXT IS 'Plazo Max',
    monto_minimo             TEXT IS 'Monto Min',
    monto_maximo             TEXT IS 'Monto Max',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
    fecha_desembolso         TEXT IS 'Fec Desemb',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_actual             TEXT IS 'Saldo Actual',
    tasa_interes             TEXT IS 'Tasa',
    plazo_meses              TEXT IS 'Plazo Meses',
    dias_mora                TEXT IS 'Dias Mora',
    estado_operacion         TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTDLCAT ON HNEACOSTA1/CNTRLDLS (created_at);

-- =============================================================================
-- Fin de script: CNTRLDLS_CREATE.sql
-- =============================================================================
