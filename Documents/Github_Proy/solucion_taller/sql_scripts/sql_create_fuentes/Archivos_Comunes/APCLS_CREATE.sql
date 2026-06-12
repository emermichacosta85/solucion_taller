-- ==============================================================================
-- Nombre de la Tabla  : APCLS
-- DESCRIPCION         : Archivo Maestro de Productos. Catalogo de todos los
--                       productos financieros ofrecidos por el banco, con
--                       su codificacion, descripcion y parametros asociados.
-- Objetivo            : Centralizar la definicion de productos financieros
--                       del sistema IBS, sirviendo como referencia para
--                       la creacion de operaciones, contratos y cuentas.
-- Tipo de Tabla       : Catalogo / Maestro de Productos
-- Origen de los Datos : Parametrizacion inicial y mantenimiento por
--                       gerencia de productos bancarios
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - referencia de productos
--                       para todos los modulos de operaciones del sistema
-- Restricciones       : PK compuesta (codigo_banco, codigo_de_producto);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/APCLS (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_de_producto    FOR COLUMN CODPRD   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_APCLS   PRIMARY KEY (codigo_banco, codigo_de_producto)
)
RCDFMT APCLSR;

RENAME TABLE HNEACOSTA1/APCLS
    TO APCLS FOR SYSTEM NAME APCLS;

COMMENT ON TABLE HNEACOSTA1/APCLS IS
    'Maestro de Productos Bancarios - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/APCLS IS
    'Maestro de Productos';

COMMENT ON COLUMN HNEACOSTA1/APCLS.codigo_banco          IS 'Codigo del banco dueno del producto financiero; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/APCLS.codigo_de_producto    IS 'Codigo unico del producto financiero dentro del banco; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/APCLS.descripcion           IS 'Nombre y descripcion completa del producto financiero';
COMMENT ON COLUMN HNEACOSTA1/APCLS.valor_texto           IS 'Categoria o tipo del producto: AHORRO, CORRIENTE, CREDITO, etc.';
COMMENT ON COLUMN HNEACOSTA1/APCLS.valor_numerico        IS 'Valor numerico asociado al producto si aplica';
COMMENT ON COLUMN HNEACOSTA1/APCLS.vigencia_desde        IS 'Fecha desde la cual el producto esta vigente y disponible';
COMMENT ON COLUMN HNEACOSTA1/APCLS.vigencia_hasta        IS 'Fecha hasta la cual el producto esta vigente y disponible';
COMMENT ON COLUMN HNEACOSTA1/APCLS.orden_visualizacion   IS 'Numero de orden para presentacion en catalogos de productos';
COMMENT ON COLUMN HNEACOSTA1/APCLS.usuario_creacion      IS 'Usuario del sistema que creo el producto en el catalogo';
COMMENT ON COLUMN HNEACOSTA1/APCLS.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/APCLS.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/APCLS.observaciones         IS 'Notas adicionales sobre el producto bancario';
COMMENT ON COLUMN HNEACOSTA1/APCLS.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/APCLS.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/APCLS.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/APCLS (
    codigo_banco          TEXT IS 'Codigo Banco',
    codigo_de_producto    TEXT IS 'Codigo Producto',
    descripcion           TEXT IS 'Descripcion Producto',
    valor_texto           TEXT IS 'Tipo Producto',
    valor_numerico        TEXT IS 'Valor Numerico',
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

CREATE INDEX HNEACOSTA1/IDX_APCLS_C ON HNEACOSTA1/APCLS (created_at);
