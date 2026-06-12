-- =============================================================================
-- Nombre de la Tabla  : CDRTE
-- DESCRIPCION         : Tabla de Tasas de Depositos.
--                       Catalogo de tasas de interes aplicables a productos
--                       de deposito y captacion por numero de tabla, fecha y moneda.
-- Objetivo            : Centralizar las tasas de interes vigentes para certificados
--                       de deposito, cuentas de ahorro y otros productos pasivos,
--                       permitiendo consultas historicas por fecha y moneda.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion de tasas por la gerencia de tesoreria
-- Permanencia de Datos: Permanente (con historial por tabla, fecha y moneda)
-- Uso de los datos    : Calculo de intereses en captaciones, certificados y
--                       depositos a plazo; reporteria de rendimientos
-- Restricciones       : PK compuesta por numero_tabla, fecha y codigo_moneda.
--                       Tabla independiente sin FK en este modulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CDRTE (
    numero_tabla            VARCHAR(30)     NOT NULL    FOR COLUMN CDRTETBL,
    fecha                   DATE            NOT NULL    FOR COLUMN CDRTEFEC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN CDRTEMONE,
    descripcion_tabla       VARCHAR(80)                 FOR COLUMN CDRTEDSC,
    tasa_nominal            DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTETNM,
    tasa_efectiva           DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTETEM,
    plazo_minimo_dias       INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEPMN,
    plazo_maximo_dias       INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEPMX,
    monto_minimo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEMMN,
    monto_maximo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEMMX,
    vigente_hasta           DATE                        FOR COLUMN CDRTEVIA,
    fecha_desembolso        DATE                        FOR COLUMN CDRTEFDS,
    fecha_vencimiento       DATE                        FOR COLUMN CDRTEFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTESAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTETSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CDRTEDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN CDRTEEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CDRTEUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CDRTEUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CDRTEVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CDRTEOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CDRTEERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CDRTECAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CDRTEUAT,
    CONSTRAINT PK_CDRTE PRIMARY KEY (numero_tabla, fecha, codigo_moneda)
)
RCDFMT CDRTER;

RENAME TABLE HNEACOSTA1/CDRTE
    TO CDRTE FOR SYSTEM NAME CDRTE;

COMMENT ON TABLE HNEACOSTA1/CDRTE IS
    'Tabla de Tasas de Depositos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/CDRTE
    IS 'Tasas Depositos';

COMMENT ON COLUMN HNEACOSTA1/CDRTE.numero_tabla IS
    'Numero identificador de la tabla de tasas definida por el banco';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.fecha IS
    'Fecha desde la que rigen las tasas de esta tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.codigo_moneda IS
    'Codigo ISO de la moneda para la que aplican estas tasas';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.descripcion_tabla IS
    'Descripcion del producto o segmento al que aplica la tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.tasa_nominal IS
    'Tasa nominal anual del deposito expresada como porcentaje';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.tasa_efectiva IS
    'Tasa efectiva anual equivalente considerando capitalizacion';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.plazo_minimo_dias IS
    'Plazo minimo en dias para acceder a esta tasa';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.plazo_maximo_dias IS
    'Plazo maximo en dias para acceder a esta tasa';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.monto_minimo IS
    'Monto minimo del deposito para aplicar esta tasa';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.monto_maximo IS
    'Monto maximo del deposito para aplicar esta tasa';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.vigente_hasta IS
    'Fecha hasta la que esta vigente esta tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.fecha_desembolso IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.fecha_vencimiento IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.monto_original IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.saldo_actual IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.tasa_interes IS
    'Tasa de referencia operativa del catalogo';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.plazo_meses IS
    'Plazo de referencia operativa del catalogo en meses';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.dias_mora IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.estado_operacion IS
    'Estado de la tabla de tasas: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.usuario_creacion IS
    'Usuario administrador que registro la tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.observaciones IS
    'Notas sobre la aplicacion o condiciones especiales de la tabla';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CDRTE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CDRTE (
    numero_tabla             TEXT IS 'No. Tabla',
    fecha                    TEXT IS 'Fecha Vigencia',
    codigo_moneda            TEXT IS 'Moneda',
    descripcion_tabla        TEXT IS 'Descripcion',
    tasa_nominal             TEXT IS 'Tasa Nominal',
    tasa_efectiva            TEXT IS 'Tasa Efectiva',
    plazo_minimo_dias        TEXT IS 'Plazo Min Dias',
    plazo_maximo_dias        TEXT IS 'Plazo Max Dias',
    monto_minimo             TEXT IS 'Monto Min',
    monto_maximo             TEXT IS 'Monto Max',
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

CREATE INDEX HNEACOSTA1/ICDRTEFEC ON HNEACOSTA1/CDRTE (fecha);
CREATE INDEX HNEACOSTA1/ICDRTECAT ON HNEACOSTA1/CDRTE (created_at);

-- =============================================================================
-- Fin de script: CDRTE_CREATE.sql
-- =============================================================================
