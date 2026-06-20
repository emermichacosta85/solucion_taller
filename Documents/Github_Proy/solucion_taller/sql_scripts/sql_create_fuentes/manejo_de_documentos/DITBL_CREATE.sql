-- ==============================================================================
-- Nombre de la Tabla  : DITBL
-- DESCRIPCION         : Tablas de Tipos de Documentos. Catalogo maestro que
--                       define los distintos tipos de documentos requeridos
--                       por tipo de operacion o producto bancario, con su
--                       descripcion, obligatoriedad y fechas de control.
-- Objetivo            : Centralizar la definicion de tipos de documentos
--                       aceptados por el sistema, sirviendo como referencia
--                       para el inventario de documentos (DIMST) y garantizando
--                       consistencia en la clasificacion documental.
-- Tipo de Tabla       : Catalogo / Maestro de Referencia
-- Origen de los Datos : Configuracion por administrador del sistema o
--                       parametrizacion inicial del proyecto
-- Permanencia de Datos: Permanente; actualizacion controlada por versiones
-- Uso de los datos    : Modulo de Manejo de Documentos - referencia para DIMST;
--                       validacion de tipos documentales en expedientes
-- Restricciones       : PK compuesta (numero_tabla, secuencia);
--                       estado_registro en ('A','I');
--                       tabla padre de DIMST via numero_tabla
-- Hecho por           : Taller IBM i - Equipo Manejo de Documentos
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE DITBL (
    numero_tabla          FOR COLUMN NUMTBL   VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
    tipo_documento        FOR COLUMN TIPDOC   VARCHAR(20)    NOT NULL DEFAULT '',
    descripcion_documento FOR COLUMN DESCDOC  VARCHAR(120)   NOT NULL DEFAULT '',
    obligatorio           FOR COLUMN OBLIG    CHAR(1)        NOT NULL DEFAULT 'N',
    fecha_recepcion       FOR COLUMN FECREC   DATE,
    fecha_vencimiento     FOR COLUMN FECVENC  DATE,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DITBL   PRIMARY KEY (numero_tabla, secuencia)
)
RCDFMT DITBLR;

RENAME TABLE DITBL
    TO DITBL_TABLE FOR SYSTEM NAME DITBL;

COMMENT ON TABLE DITBL IS
    'Catalogo de Tipos de Documentos - Modulo 14 Manejo de Documentos Taller IBM i';

LABEL ON TABLE DITBL IS
    'Tipos de Documentos';

COMMENT ON COLUMN DITBL.numero_tabla          IS 'Numero o codigo de la tabla de tipos de documentos; forma parte de la PK';
COMMENT ON COLUMN DITBL.secuencia             IS 'Numero de secuencia del tipo de documento dentro de la tabla; forma parte de la PK';
COMMENT ON COLUMN DITBL.tipo_documento        IS 'Codigo que clasifica el tipo de documento (IDENTIDAD, CONTRATO, GARANTIA, etc.)';
COMMENT ON COLUMN DITBL.descripcion_documento IS 'Descripcion completa del tipo de documento para despliegue en pantallas y reportes';
COMMENT ON COLUMN DITBL.obligatorio           IS 'Indica si el documento es obligatorio para el tipo de operacion: S=Si, N=No';
COMMENT ON COLUMN DITBL.fecha_recepcion       IS 'Fecha referencial de recepcion del tipo de documento si aplica al catalogo';
COMMENT ON COLUMN DITBL.fecha_vencimiento     IS 'Fecha de vencimiento o expiracion de la vigencia del tipo de documento';
COMMENT ON COLUMN DITBL.observaciones         IS 'Notas adicionales o instrucciones sobre el manejo del tipo de documento';
COMMENT ON COLUMN DITBL.usuario_creacion      IS 'Usuario del sistema que creo el registro en el catalogo';
COMMENT ON COLUMN DITBL.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion al registro';
COMMENT ON COLUMN DITBL.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN DITBL.estado_registro       IS 'Estado logico del registro en el catalogo: A=Activo, I=Inactivo';
COMMENT ON COLUMN DITBL.created_at            IS 'Fecha y hora exacta de creacion del registro en la base de datos';
COMMENT ON COLUMN DITBL.updated_at            IS 'Fecha y hora de la ultima actualizacion registrada en la base de datos';

LABEL ON COLUMN DITBL (
    numero_tabla          TEXT IS 'Numero de Tabla',
    secuencia             TEXT IS 'Secuencia',
    tipo_documento        TEXT IS 'Tipo de Documento',
    descripcion_documento TEXT IS 'Descripcion Documento',
    obligatorio           TEXT IS 'Obligatorio S/N',
    fecha_recepcion       TEXT IS 'Fecha de Recepcion',
    fecha_vencimiento     TEXT IS 'Fecha de Vencimiento',
    observaciones         TEXT IS 'Observaciones',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_DITBL_C ON DITBL (created_at);
CREATE INDEX IDX_DITBL_NSEC ON DITBL (numero_tabla, secuencia);