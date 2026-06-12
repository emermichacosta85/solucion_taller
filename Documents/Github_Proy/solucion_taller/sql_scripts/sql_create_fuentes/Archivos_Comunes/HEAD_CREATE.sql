-- ==============================================================================
-- Nombre de la Tabla  : HEAD
-- DESCRIPCION         : Archivo de titulos de reportes. Almacena los
--                       encabezados y titulos configurados para cada
--                       Printer File del sistema por nombre de archivo
--                       de impresion y numero de secuencia.
-- Objetivo            : Centralizar la parametrizacion de titulos y
--                       encabezados de todos los reportes impresos del
--                       sistema, permitiendo su mantenimiento sin cambios
--                       en el codigo fuente.
-- Tipo de Tabla       : Catalogo / Maestro de Configuracion
-- Origen de los Datos : Parametrizacion inicial y mantenimiento por
--                       administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - titulos de reportes
--                       impresos por todos los modulos del sistema IBS
-- Restricciones       : PK compuesta (nombre_printer_file, secuencia);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/HEAD (
    nombre_printer_file   FOR COLUMN NOMPRT   VARCHAR(50)    NOT NULL,
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
    CONSTRAINT PK_HEAD    PRIMARY KEY (nombre_printer_file, secuencia)
)
RCDFMT HEADR;

RENAME TABLE HNEACOSTA1/HEAD
    TO HEAD FOR SYSTEM NAME HEAD;

COMMENT ON TABLE HNEACOSTA1/HEAD IS
    'Titulos de Reportes por Printer File - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/HEAD IS
    'Titulos de Reportes';

COMMENT ON COLUMN HNEACOSTA1/HEAD.nombre_printer_file   IS 'Nombre del Printer File de IBM i al que corresponde el titulo; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/HEAD.secuencia             IS 'Numero de secuencia del titulo o linea de encabezado del reporte; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/HEAD.descripcion           IS 'Descripcion funcional del titulo o encabezado del reporte';
COMMENT ON COLUMN HNEACOSTA1/HEAD.valor_texto           IS 'Texto del titulo o encabezado a imprimir en el reporte';
COMMENT ON COLUMN HNEACOSTA1/HEAD.valor_numerico        IS 'Valor numerico asociado al encabezado si aplica';
COMMENT ON COLUMN HNEACOSTA1/HEAD.vigencia_desde        IS 'Fecha desde la cual el titulo del reporte es vigente';
COMMENT ON COLUMN HNEACOSTA1/HEAD.vigencia_hasta        IS 'Fecha hasta la cual el titulo del reporte es vigente';
COMMENT ON COLUMN HNEACOSTA1/HEAD.orden_visualizacion   IS 'Numero de orden de impresion del titulo en el reporte';
COMMENT ON COLUMN HNEACOSTA1/HEAD.usuario_creacion      IS 'Usuario del sistema que creo el registro de titulo';
COMMENT ON COLUMN HNEACOSTA1/HEAD.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/HEAD.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/HEAD.observaciones         IS 'Notas adicionales sobre el titulo del reporte';
COMMENT ON COLUMN HNEACOSTA1/HEAD.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/HEAD.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/HEAD.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/HEAD (
    nombre_printer_file   TEXT IS 'Nombre Printer File',
    secuencia             TEXT IS 'Secuencia',
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

CREATE INDEX HNEACOSTA1/IDX_HEAD_C ON HNEACOSTA1/HEAD (created_at);
