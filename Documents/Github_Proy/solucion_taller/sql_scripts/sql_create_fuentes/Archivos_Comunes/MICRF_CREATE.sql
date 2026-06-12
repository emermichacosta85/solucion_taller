-- ==============================================================================
-- Nombre de la Tabla  : MICRF
-- DESCRIPCION         : Archivo que contiene los reportes salvados en
--                       Microficha. Registra el indice de reportes archivados
--                       en formato microficha por tipo de formulario, nombre
--                       de reporte y numero de secuencia.
-- Objetivo            : Mantener el indice de acceso a reportes historicos
--                       almacenados en microficha para consulta y recuperacion.
-- Tipo de Tabla       : Catalogo de Archivo Fisico
-- Origen de los Datos : Generado por proceso de archivado de reportes
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo Archivos Comunes - indice de microficha
-- Restricciones       : PK compuesta (tipo_formulario, nombre_reporte, secuencia);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/MICRF (
    tipo_formulario       FOR COLUMN TIPFORM  VARCHAR(50)    NOT NULL,
    nombre_reporte        FOR COLUMN NOMRPT   VARCHAR(50)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
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
    CONSTRAINT PK_MICRF   PRIMARY KEY (tipo_formulario, nombre_reporte, secuencia)
)
RCDFMT MICRFR;

RENAME TABLE HNEACOSTA1/MICRF
    TO MICRF FOR SYSTEM NAME MICRF;

COMMENT ON TABLE HNEACOSTA1/MICRF IS
    'Indice de Reportes Salvados en Microficha - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/MICRF IS
    'Reportes en Microficha';

COMMENT ON COLUMN HNEACOSTA1/MICRF.tipo_formulario       IS 'Tipo o categoria del formulario archivado en microficha; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MICRF.nombre_reporte        IS 'Nombre del reporte o documento archivado en microficha; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MICRF.secuencia             IS 'Numero de secuencia del reporte dentro del tipo y nombre; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/MICRF.descripcion           IS 'Descripcion del contenido del reporte archivado en microficha';
COMMENT ON COLUMN HNEACOSTA1/MICRF.valor_texto           IS 'Referencia de ubicacion fisica de la microficha';
COMMENT ON COLUMN HNEACOSTA1/MICRF.valor_numerico        IS 'Numero de rollo o posicion en el archivo de microficha';
COMMENT ON COLUMN HNEACOSTA1/MICRF.vigencia_desde        IS 'Fecha de inicio del periodo cubierto por el reporte';
COMMENT ON COLUMN HNEACOSTA1/MICRF.vigencia_hasta        IS 'Fecha de fin del periodo cubierto por el reporte';
COMMENT ON COLUMN HNEACOSTA1/MICRF.orden_visualizacion   IS 'Numero de orden para listado del indice de microficha';
COMMENT ON COLUMN HNEACOSTA1/MICRF.usuario_creacion      IS 'Usuario o proceso que registro el reporte en el indice';
COMMENT ON COLUMN HNEACOSTA1/MICRF.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/MICRF.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/MICRF.observaciones         IS 'Notas adicionales sobre el reporte archivado';
COMMENT ON COLUMN HNEACOSTA1/MICRF.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/MICRF.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/MICRF.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/MICRF (
    tipo_formulario       TEXT IS 'Tipo Formulario',
    nombre_reporte        TEXT IS 'Nombre Reporte',
    secuencia             TEXT IS 'Secuencia',
    descripcion           TEXT IS 'Descripcion Reporte',
    valor_texto           TEXT IS 'Ubicacion Microficha',
    valor_numerico        TEXT IS 'Numero Rollo',
    vigencia_desde        TEXT IS 'Periodo Desde',
    vigencia_hasta        TEXT IS 'Periodo Hasta',
    orden_visualizacion   TEXT IS 'Orden Visualizacion',
    usuario_creacion      TEXT IS 'Usuario Creacion',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro      TEXT IS 'Version Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_MICRF_C ON HNEACOSTA1/MICRF (created_at);
