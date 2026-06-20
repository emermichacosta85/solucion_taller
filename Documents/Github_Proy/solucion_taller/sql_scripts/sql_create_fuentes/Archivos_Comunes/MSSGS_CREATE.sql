-- ==============================================================================
-- Nombre de la Tabla  : MSSGS
-- DESCRIPCION         : Archivo de mensajes de errores del sistema. Almacena
--                       el catalogo de mensajes de error, advertencia e
--                       informacion generados por los programas del sistema
--                       IBS para su presentacion al usuario.
-- Objetivo            : Centralizar todos los mensajes del sistema en un
--                       catalogo unico, facilitando su mantenimiento y
--                       traduccion sin modificar el codigo fuente.
-- Tipo de Tabla       : Catalogo / Maestro de Mensajes
-- Origen de los Datos : Carga inicial y mantenimiento por equipo de desarrollo
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - mensajes de error,
--                       advertencia e informacion para todos los modulos
-- Restricciones       : PK surrogate (id BIGINT autogenerado);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE MSSGS (
    id                    FOR COLUMN IDMSG    BIGINT         NOT NULL GENERATED ALWAYS AS IDENTITY,
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
    CONSTRAINT PK_MSSGS   PRIMARY KEY (id)
)
RCDFMT MSSGSR;

RENAME TABLE MSSGS
    TO MSSGS_TABLE FOR SYSTEM NAME MSSGS;

COMMENT ON TABLE MSSGS IS
    'Catalogo de Mensajes de Errores del Sistema - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE MSSGS IS
    'Mensajes de Errores';

COMMENT ON COLUMN MSSGS.id                    IS 'Identificador unico autogenerado del mensaje de error; PK surrogate';
COMMENT ON COLUMN MSSGS.descripcion           IS 'Texto del mensaje de error o informacion del sistema';
COMMENT ON COLUMN MSSGS.valor_texto           IS 'Codigo o clave corta del mensaje para referencia en programas';
COMMENT ON COLUMN MSSGS.valor_numerico        IS 'Codigo numerico del mensaje si aplica para clasificacion';
COMMENT ON COLUMN MSSGS.vigencia_desde        IS 'Fecha desde la cual el mensaje es vigente en el sistema';
COMMENT ON COLUMN MSSGS.vigencia_hasta        IS 'Fecha hasta la cual el mensaje es vigente en el sistema';
COMMENT ON COLUMN MSSGS.orden_visualizacion   IS 'Numero de orden para listado de mensajes';
COMMENT ON COLUMN MSSGS.usuario_creacion      IS 'Usuario del sistema que creo el registro del mensaje';
COMMENT ON COLUMN MSSGS.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN MSSGS.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN MSSGS.observaciones         IS 'Notas adicionales sobre el mensaje o su uso en el sistema';
COMMENT ON COLUMN MSSGS.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN MSSGS.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN MSSGS.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN MSSGS (
    id                    TEXT IS 'ID Mensaje',
    descripcion           TEXT IS 'Descripcion Mensaje',
    valor_texto           TEXT IS 'Codigo Mensaje',
    valor_numerico        TEXT IS 'Codigo Numerico',
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

CREATE INDEX IDX_MSSGS_C ON MSSGS (created_at);
