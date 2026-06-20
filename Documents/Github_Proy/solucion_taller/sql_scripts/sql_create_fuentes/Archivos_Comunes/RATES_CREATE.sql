-- ==============================================================================
-- Nombre de la Tabla  : RATES
-- DESCRIPCION         : Archivo de Tasas de Cambio (Posicion / Contra Valor).
--                       Almacena la tasa de cambio vigente por banco y moneda.
--                       Es la tabla padre del historico de tasas RTRNS.
-- Objetivo            : Mantener la tasa de cambio activa para cada par
--                       banco/moneda, utilizada en la conversion de montos
--                       y calculo de contra valores en operaciones financieras.
-- Tipo de Tabla       : Maestro de Tasas Vigentes
-- Origen de los Datos : Actualizacion diaria por proceso de mercado de cambios
--                       o ingreso manual por oficial de tesoreria
-- Permanencia de Datos: Permanente; un registro vigente por banco/moneda;
--                       el historico se mantiene en RTRNS
-- Uso de los datos    : Modulo Archivos Comunes - conversion de monedas para
--                       todos los modulos del sistema; tabla padre de RTRNS
-- Restricciones       : PK compuesta (codigo_banco, codigo_moneda);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE RATES (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_moneda         FOR COLUMN CODMON   VARCHAR(20)    NOT NULL,
    descripcion           FOR COLUMN DESCRIP  VARCHAR(120)   NOT NULL DEFAULT '',
    valor_texto           FOR COLUMN VALTXT   VARCHAR(50)    NOT NULL DEFAULT '',
    valor_numerico        FOR COLUMN VALNUM   DECIMAL(18, 2),
    vigencia_desde        FOR COLUMN VIGDES   DATE,
    vigencia_hasta        FOR COLUMN VIGHST   DATE,
    orden_visualizacion   FOR COLUMN ORDVIS   INTEGER        NOT NULL DEFAULT 0,
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_RATES   PRIMARY KEY (codigo_banco, codigo_moneda)
)
RCDFMT RATESR;

RENAME TABLE RATES
    TO RATES_TABLE FOR SYSTEM NAME RATES;

COMMENT ON TABLE RATES IS
    'Tasas de Cambio Vigentes por Banco y Moneda - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE RATES IS
    'Tasas de Cambio';

COMMENT ON COLUMN RATES.codigo_banco          IS 'Codigo del banco dueno de la tasa de cambio; parte de la PK';
COMMENT ON COLUMN RATES.codigo_moneda         IS 'Codigo ISO de la moneda a la que aplica la tasa; parte de la PK';
COMMENT ON COLUMN RATES.descripcion           IS 'Descripcion de la moneda y la tasa de cambio vigente';
COMMENT ON COLUMN RATES.valor_texto           IS 'Nombre completo de la moneda o par de divisas';
COMMENT ON COLUMN RATES.valor_numerico        IS 'Valor de la tasa de cambio vigente frente a la moneda base';
COMMENT ON COLUMN RATES.vigencia_desde        IS 'Fecha desde la cual la tasa de cambio es vigente';
COMMENT ON COLUMN RATES.vigencia_hasta        IS 'Fecha hasta la cual la tasa de cambio es vigente';
COMMENT ON COLUMN RATES.orden_visualizacion   IS 'Numero de orden para presentacion en tablas de tasas';
COMMENT ON COLUMN RATES.usuario_creacion      IS 'Usuario o proceso que registro la tasa de cambio';
COMMENT ON COLUMN RATES.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima actualizacion de tasa';
COMMENT ON COLUMN RATES.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN RATES.observaciones         IS 'Notas sobre la tasa de cambio o su fuente de informacion';
COMMENT ON COLUMN RATES.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN RATES.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN RATES.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN RATES (
    codigo_banco          TEXT IS 'Codigo Banco',
    codigo_moneda         TEXT IS 'Codigo Moneda',
    descripcion           TEXT IS 'Descripcion Moneda',
    valor_texto           TEXT IS 'Par de Divisas',
    valor_numerico        TEXT IS 'Tasa de Cambio',
    vigencia_desde        TEXT IS 'Vigencia Desde',
    vigencia_hasta        TEXT IS 'Vigencia Hasta',
    orden_visualizacion   TEXT IS 'Orden Visualizacion',
    usuario_creacion      TEXT IS 'Usuario Creacion',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro      TEXT IS 'Version Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_RATES_C ON RATES (created_at);
