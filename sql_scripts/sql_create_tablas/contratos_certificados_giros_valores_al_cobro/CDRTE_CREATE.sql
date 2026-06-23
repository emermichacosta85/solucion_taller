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

CREATE OR REPLACE TABLE CDRTE (
    numero_tabla            FOR COLUMN CDRTETBL VARCHAR(30)     NOT NULL,
    fecha                   FOR COLUMN CDRTEFEC DATE            NOT NULL,
    codigo_moneda           FOR COLUMN CDRTEMONE VARCHAR(20)    NOT NULL,
    fecha_desembolso        FOR COLUMN CDRTEFDS DATE,
    fecha_vencimiento       FOR COLUMN CDRTEFVE DATE,
    monto_original          FOR COLUMN CDRTEMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN CDRTESAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN CDRTETSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN CDRTEPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN CDRTEDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN CDRTEEST VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN CDRTEUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN CDRTEUSA VARCHAR(30),
    version_registro        FOR COLUMN CDRTEVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN CDRTEOBS VARCHAR(120),
    estado_registro         FOR COLUMN CDRTEERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CDRTECAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CDRTEUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CDRTE PRIMARY KEY (numero_tabla,codigo_moneda)
)
RCDFMT CDRTER;

RENAME TABLE CDRTE
    TO CDRTE_TABLE FOR SYSTEM NAME CDRTE;

COMMENT ON TABLE CDRTE IS
    'Tabla de Tasas de Depositos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE CDRTE
    IS 'Tasas Depositos';

COMMENT ON COLUMN CDRTE.numero_tabla IS
    'Numero identificador de la tabla de tasas definida por el banco';
COMMENT ON COLUMN CDRTE.fecha IS
    'Fecha desde la que rigen las tasas de esta tabla';
COMMENT ON COLUMN CDRTE.codigo_moneda IS
    'Codigo ISO de la moneda para la que aplican estas tasas';
COMMENT ON COLUMN CDRTE.fecha_desembolso IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CDRTE.fecha_vencimiento IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CDRTE.monto_original IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CDRTE.saldo_actual IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CDRTE.tasa_interes IS
    'Tasa de referencia operativa del catalogo';
COMMENT ON COLUMN CDRTE.plazo_meses IS
    'Plazo de referencia operativa del catalogo en meses';
COMMENT ON COLUMN CDRTE.dias_mora IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CDRTE.estado_operacion IS
    'Estado de la tabla de tasas: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN CDRTE.usuario_creacion IS
    'Usuario administrador que registro la tabla de tasas';
COMMENT ON COLUMN CDRTE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla';
COMMENT ON COLUMN CDRTE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CDRTE.observaciones IS
    'Notas sobre la aplicacion o condiciones especiales de la tabla';
COMMENT ON COLUMN CDRTE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CDRTE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CDRTE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CDRTE (
    numero_tabla             TEXT IS 'No. Tabla',
    fecha                    TEXT IS 'Fecha Vigencia',
    codigo_moneda            TEXT IS 'Moneda',
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

CREATE INDEX ICDRTEFEC ON CDRTE (fecha);
CREATE INDEX ICDRTECAT ON CDRTE (created_at);

-- =============================================================================
-- Fin de script: CDRTE_CREATE.sql
-- =============================================================================
