-- ==============================================================================
-- Nombre de la Tabla  : CNOFT
-- DESCRIPCION         : Archivo Maestro de Tablas de Datos Comunes. Define
--                       los encabezados de cada tabla de codigos del sistema,
--                       por codigo de tabla e idioma. Sirve como catalogo
--                       raiz que agrupa los registros de CNOFC.
-- Objetivo            : Centralizar la definicion de todas las tablas de
--                       codigos del sistema IBS, proporcionando descripcion,
--                       vigencia e informacion de visualizacion por idioma.
-- Tipo de Tabla       : Catalogo / Maestro de Referencia
-- Origen de los Datos : Parametrizacion inicial y mantenimiento por
--                       administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - referencia global para
--                       todos los catalogos del sistema; tabla padre de CNOFC
-- Restricciones       : PK compuesta (codigo_tabla, idioma);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNOFT (
    codigo_tabla          FOR COLUMN CODTBL   VARCHAR(20)    NOT NULL,
    idioma                FOR COLUMN IDIOMA   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_CNOFT   PRIMARY KEY (codigo_tabla, idioma)
)
RCDFMT CNOFTR;

RENAME TABLE HNEACOSTA1/CNOFT
    TO CNOFT FOR SYSTEM NAME CNOFT;

COMMENT ON TABLE HNEACOSTA1/CNOFT IS
    'Maestro de Tablas de Datos Comunes - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/CNOFT IS
    'Maestro Tablas Datos Comunes';

COMMENT ON COLUMN HNEACOSTA1/CNOFT.codigo_tabla          IS 'Codigo identificador unico de la tabla de datos comunes; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.idioma                IS 'Idioma del registro de tabla (ES=Espanol, EN=Ingles); parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.descripcion           IS 'Descripcion funcional de la tabla de datos comunes';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.valor_texto           IS 'Valor de texto asociado a la definicion de la tabla';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.valor_numerico        IS 'Valor numerico asociado a la definicion de la tabla si aplica';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.vigencia_desde        IS 'Fecha desde la cual la tabla de datos comunes es vigente';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.vigencia_hasta        IS 'Fecha hasta la cual la tabla de datos comunes es vigente';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.orden_visualizacion   IS 'Numero de orden para presentacion en pantallas y reportes';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.usuario_creacion      IS 'Usuario del sistema que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.observaciones         IS 'Notas adicionales sobre la tabla de datos comunes';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CNOFT.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNOFT (
    codigo_tabla          TEXT IS 'Codigo de Tabla',
    idioma                TEXT IS 'Idioma',
    descripcion           TEXT IS 'Descripcion',
    valor_texto           TEXT IS 'Valor Texto',
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

CREATE INDEX HNEACOSTA1/IDX_CNOFT_C ON HNEACOSTA1/CNOFT (created_at);
