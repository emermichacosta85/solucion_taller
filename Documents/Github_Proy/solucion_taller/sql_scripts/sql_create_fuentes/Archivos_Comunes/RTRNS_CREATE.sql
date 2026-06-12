-- ==============================================================================
-- Nombre de la Tabla  : RTRNS
-- DESCRIPCION         : Historia de Tasas de Cambio. Registra el historico
--                       de todas las tasas de cambio aplicadas por banco,
--                       moneda y fecha, conservando la trazabilidad completa
--                       de la evolucion de cada par de divisas.
-- Objetivo            : Mantener el registro historico de tasas de cambio
--                       para auditoria, recalculo de operaciones en fechas
--                       pasadas y reporteria financiera historica.
-- Tipo de Tabla       : Historico de Tasas
-- Origen de los Datos : Migrado desde RATES al actualizar la tasa vigente;
--                       tambien por carga historica inicial
-- Permanencia de Datos: Permanente con historico indefinido
-- Uso de los datos    : Modulo Archivos Comunes - recalculo historico de
--                       operaciones; auditoria de cambios de tasa;
--                       tabla hija de RATES via (codigo_banco, codigo_moneda)
-- Restricciones       : PK compuesta (codigo_banco, codigo_moneda, fecha);
--                       FK a RATES (codigo_banco, codigo_moneda);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/RTRNS (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_moneda         FOR COLUMN CODMON   VARCHAR(20)    NOT NULL,
    fecha                 FOR COLUMN FECHA    DATE           NOT NULL,
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
    CONSTRAINT PK_RTRNS   PRIMARY KEY (codigo_banco, codigo_moneda, fecha),
    CONSTRAINT FK_RTRNS_RATES FOREIGN KEY (codigo_banco, codigo_moneda)
        REFERENCES HNEACOSTA1/RATES (codigo_banco, codigo_moneda)
)
RCDFMT RTRNSR;

RENAME TABLE HNEACOSTA1/RTRNS
    TO RTRNS FOR SYSTEM NAME RTRNS;

COMMENT ON TABLE HNEACOSTA1/RTRNS IS
    'Historia de Tasas de Cambio por Banco Moneda y Fecha - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/RTRNS IS
    'Historia Tasas de Cambio';

COMMENT ON COLUMN HNEACOSTA1/RTRNS.codigo_banco          IS 'Codigo del banco dueno de la tasa historica; parte de la PK y FK a RATES';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.codigo_moneda         IS 'Codigo ISO de la moneda de la tasa historica; parte de la PK y FK a RATES';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.fecha                 IS 'Fecha en que riguo esta tasa de cambio; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.descripcion           IS 'Descripcion de la tasa de cambio historica registrada';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.valor_texto           IS 'Nombre del par de divisas o fuente de la tasa historica';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.valor_numerico        IS 'Valor de la tasa de cambio en la fecha indicada';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.vigencia_desde        IS 'Fecha de inicio de vigencia de esta tasa historica';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.vigencia_hasta        IS 'Fecha de fin de vigencia de esta tasa historica';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.orden_visualizacion   IS 'Numero de orden para listado historico de tasas';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.usuario_creacion      IS 'Usuario o proceso que registro la tasa en el historico';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.observaciones         IS 'Notas sobre la tasa historica o circunstancias del cambio';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.created_at            IS 'Fecha y hora exacta de creacion del registro historico';
COMMENT ON COLUMN HNEACOSTA1/RTRNS.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/RTRNS (
    codigo_banco          TEXT IS 'Codigo Banco',
    codigo_moneda         TEXT IS 'Codigo Moneda',
    fecha                 TEXT IS 'Fecha Tasa',
    descripcion           TEXT IS 'Descripcion Tasa',
    valor_texto           TEXT IS 'Par de Divisas',
    valor_numerico        TEXT IS 'Tasa Historica',
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

CREATE INDEX HNEACOSTA1/IDX_RTRNS_F ON HNEACOSTA1/RTRNS (fecha);
CREATE INDEX HNEACOSTA1/IDX_RTRNS_C ON HNEACOSTA1/RTRNS (created_at);
