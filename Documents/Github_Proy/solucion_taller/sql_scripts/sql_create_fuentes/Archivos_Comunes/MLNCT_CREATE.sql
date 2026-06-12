-- ==============================================================================
-- Nombre de la Tabla  : MLNCT
-- DESCRIPCION         : Archivo de patrones y formatos de Notificaciones a
--                       Clientes. Almacena las plantillas y configuraciones
--                       de notificaciones por banco, codigo de notificacion,
--                       nivel, idioma y secuencia.
-- Objetivo            : Centralizar los patrones de formato utilizados para
--                       generar notificaciones a clientes, permitiendo su
--                       configuracion por banco, idioma y nivel de detalle.
-- Tipo de Tabla       : Catalogo / Maestro de Configuracion
-- Origen de los Datos : Parametrizacion por administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - generacion de notificaciones;
--                       tabla padre logica de MLNOT via (codigo_banco, codigo_de_notificacion, nivel)
-- Restricciones       : PK compuesta (codigo_banco, codigo_de_notificacion, nivel, idioma, secuencia);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/MLNCT (
    codigo_banco            FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_de_notificacion  FOR COLUMN CODNOT   VARCHAR(20)    NOT NULL,
    nivel                   FOR COLUMN NIVEL    INTEGER        NOT NULL,
    idioma                  FOR COLUMN IDIOMA   VARCHAR(20)    NOT NULL,
    secuencia               FOR COLUMN SECUENC  INTEGER        NOT NULL,
    descripcion             FOR COLUMN DESCRIP  VARCHAR(120)   NOT NULL DEFAULT '',
    valor_texto             FOR COLUMN VALTXT   VARCHAR(50)    NOT NULL DEFAULT '',
    valor_numerico          FOR COLUMN VALNUM   DECIMAL(18, 2),
    vigencia_desde          FOR COLUMN VIGDES   DATE,
    vigencia_hasta          FOR COLUMN VIGHST   DATE,
    orden_visualizacion     FOR COLUMN ORDVIS   INTEGER        NOT NULL DEFAULT 0,
    usuario_creacion        FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion   FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro        FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro         FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_MLNCT     PRIMARY KEY (codigo_banco, codigo_de_notificacion, nivel, idioma, secuencia)
)
RCDFMT MLNCTR;

RENAME TABLE HNEACOSTA1/MLNCT
    TO MLNCT FOR SYSTEM NAME MLNCT;

COMMENT ON TABLE HNEACOSTA1/MLNCT IS
    'Patrones de Notificaciones a Clientes - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/MLNCT IS
    'Patrones Notificaciones';

COMMENT ON COLUMN HNEACOSTA1/MLNCT.codigo_banco            IS 'Codigo del banco dueno del patron de notificacion; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.codigo_de_notificacion  IS 'Codigo identificador del tipo de notificacion; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.nivel                   IS 'Nivel jerarquico de la notificacion dentro del tipo; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.idioma                  IS 'Idioma del patron de notificacion (ES, EN); parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.secuencia               IS 'Numero de secuencia del patron dentro del nivel e idioma; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.descripcion             IS 'Descripcion del patron o formato de notificacion';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.valor_texto             IS 'Texto del patron o plantilla de la notificacion';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.valor_numerico          IS 'Valor numerico asociado al patron si aplica';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.vigencia_desde          IS 'Fecha desde la cual el patron de notificacion es vigente';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.vigencia_hasta          IS 'Fecha hasta la cual el patron de notificacion es vigente';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.orden_visualizacion     IS 'Numero de orden para presentacion del patron';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.usuario_creacion        IS 'Usuario del sistema que creo el registro del patron';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.observaciones           IS 'Notas adicionales sobre el patron de notificacion';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.created_at              IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/MLNCT.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/MLNCT (
    codigo_banco            TEXT IS 'Codigo Banco',
    codigo_de_notificacion  TEXT IS 'Codigo Notificacion',
    nivel                   TEXT IS 'Nivel',
    idioma                  TEXT IS 'Idioma',
    secuencia               TEXT IS 'Secuencia',
    descripcion             TEXT IS 'Descripcion',
    valor_texto             TEXT IS 'Valor Texto',
    valor_numerico          TEXT IS 'Valor Numerico',
    vigencia_desde          TEXT IS 'Vigencia Desde',
    vigencia_hasta          TEXT IS 'Vigencia Hasta',
    orden_visualizacion     TEXT IS 'Orden Visualizacion',
    usuario_creacion        TEXT IS 'Usuario Creacion',
    usuario_actualizacion   TEXT IS 'Usuario Actualizacion',
    version_registro        TEXT IS 'Version Registro',
    observaciones           TEXT IS 'Observaciones',
    estado_registro         TEXT IS 'Estado Registro',
    created_at              TEXT IS 'Fecha Creacion',
    updated_at              TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_MLNCT_C ON HNEACOSTA1/MLNCT (created_at);
