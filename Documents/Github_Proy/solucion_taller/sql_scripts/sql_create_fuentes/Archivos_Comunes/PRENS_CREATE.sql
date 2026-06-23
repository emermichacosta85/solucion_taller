-- ==============================================================================
-- Nombre de la Tabla  : PRENS
-- DESCRIPCION         : Archivo de Descripciones de Programas en Espanol. Almacena el nombre y descripcion en idioma espanol de cada programa del sistema IBS para documentacion y soporte tecnico.
-- Objetivo            : Mantener la documentacion tecnica de programas en idioma espanol, facilitando la consulta y soporte a usuarios de habla hispana.
-- Tipo de Tabla       : Catalogo / Documentacion Tecnica
-- Origen de los Datos : Carga y mantenimiento por equipo de desarrollo
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - documentacion de programas en espanol
-- Restricciones       : PK (nombre_programa); estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE PRENS (
    nombre_programa           FOR COLUMN NOMPGM  VARCHAR(50)     NOT NULL,
    descripcion               FOR COLUMN DESCRIP VARCHAR(120)    NOT NULL DEFAULT '',
    valor_texto               FOR COLUMN VALTXT  VARCHAR(50)     NOT NULL DEFAULT '',
    valor_numerico            FOR COLUMN VALNUM  DECIMAL(18,2)   ,
    vigencia_desde            FOR COLUMN VIGDES  DATE            ,
    vigencia_hasta            FOR COLUMN VIGHST  DATE            ,
    orden_visualizacion       FOR COLUMN ORDVIS  INTEGER         NOT NULL DEFAULT 0,
    usuario_creacion          FOR COLUMN USRCREA VARCHAR(30)     NOT NULL DEFAULT '',
    usuario_actualizacion     FOR COLUMN USRACT  VARCHAR(30)     NOT NULL DEFAULT '',
    version_registro          FOR COLUMN VERSREG INTEGER         NOT NULL DEFAULT 1,
    observaciones             FOR COLUMN OBSERVAC VARCHAR(120)    NOT NULL DEFAULT '',
    estado_registro           FOR COLUMN ESTREG  CHAR(1)         NOT NULL DEFAULT 'A',
    created_at                FOR COLUMN CRTDAT  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                FOR COLUMN UPDDAT  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PRENS PRIMARY KEY (nombre_programa)
)
RCDFMT PRENSR;

RENAME TABLE PRENS
    TO PRENS_TABLE FOR SYSTEM NAME PRENS;

COMMENT ON TABLE PRENS IS
    'Descripciones de Programas en Espanol - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE PRENS IS
    'Descripciones Programas ES';

COMMENT ON COLUMN PRENS.nombre_programa           IS 'Nombre del programa IBM i en espanol; PK del catalogo de descripciones';
COMMENT ON COLUMN PRENS.descripcion               IS 'Descripcion funcional del programa en idioma espanol';
COMMENT ON COLUMN PRENS.valor_texto               IS 'Modulo o subsistema al que pertenece el programa';
COMMENT ON COLUMN PRENS.valor_numerico            IS 'Valor numerico asociado si aplica';
COMMENT ON COLUMN PRENS.vigencia_desde            IS 'Fecha desde la cual la descripcion es vigente';
COMMENT ON COLUMN PRENS.vigencia_hasta            IS 'Fecha hasta la cual la descripcion es vigente';
COMMENT ON COLUMN PRENS.orden_visualizacion       IS 'Numero de orden para listado de programas';
COMMENT ON COLUMN PRENS.usuario_creacion          IS 'Usuario del sistema que creo el registro';
COMMENT ON COLUMN PRENS.usuario_actualizacion     IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN PRENS.version_registro          IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN PRENS.observaciones             IS 'Notas adicionales sobre el programa';
COMMENT ON COLUMN PRENS.estado_registro           IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN PRENS.created_at                IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN PRENS.updated_at                IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN PRENS (
    nombre_programa           TEXT IS 'Nombre Programa',
    descripcion               TEXT IS 'Descripcion ES',
    valor_texto               TEXT IS 'Modulo',
    valor_numerico            TEXT IS 'Valor Numerico',
    vigencia_desde            TEXT IS 'Vigencia Desde',
    vigencia_hasta            TEXT IS 'Vigencia Hasta',
    orden_visualizacion       TEXT IS 'Orden Visualizacion',
    usuario_creacion          TEXT IS 'Usuario Creacion',
    usuario_actualizacion     TEXT IS 'Usuario Actualizacion',
    version_registro          TEXT IS 'Version Registro',
    observaciones             TEXT IS 'Observaciones',
    estado_registro           TEXT IS 'Estado Registro',
    created_at                TEXT IS 'Fecha Creacion',
    updated_at                TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_PRENS_C ON PRENS (created_at);
