-- ==============================================================================
-- Nombre de la Tabla  : IBSDD
-- DESCRIPCION         : Diccionario de Datos del sistema IBS. Contiene la definicion tecnica de cada campo, tabla y objeto del sistema, sirviendo como referencia centralizada para desarrollo y documentacion.
-- Objetivo            : Proveer una fuente centralizada de metadatos del sistema IBS para soporte tecnico, desarrollo y auditoria de estructura de datos.
-- Tipo de Tabla       : Catalogo / Metadatos del Sistema
-- Origen de los Datos : Carga y mantenimiento por equipo de arquitectura de datos
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - metadatos y diccionario de datos
-- Restricciones       : PK surrogate (id BIGINT autogenerado); estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE IBSDD (
    id                        FOR COLUMN IDDICT  BIGINT          GENERATED ALWAYS AS IDENTITY,
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
    CONSTRAINT PK_IBSDD PRIMARY KEY (id)
)
RCDFMT IBSDDR;

RENAME TABLE IBSDD
    TO IBSDD_TABLE FOR SYSTEM NAME IBSDD;

COMMENT ON TABLE IBSDD IS
    'Diccionario de Datos del IBS - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE IBSDD IS
    'Diccionario de Datos IBS';

COMMENT ON COLUMN IBSDD.id                        IS 'Identificador unico autogenerado del elemento del diccionario de datos';
COMMENT ON COLUMN IBSDD.descripcion               IS 'Descripcion del elemento o relacion registrada';
COMMENT ON COLUMN IBSDD.valor_texto               IS 'Valor de texto adicional asociado al registro';
COMMENT ON COLUMN IBSDD.valor_numerico            IS 'Valor numerico adicional asociado al registro si aplica';
COMMENT ON COLUMN IBSDD.vigencia_desde            IS 'Fecha desde la cual el registro es vigente';
COMMENT ON COLUMN IBSDD.vigencia_hasta            IS 'Fecha hasta la cual el registro es vigente';
COMMENT ON COLUMN IBSDD.orden_visualizacion       IS 'Numero de orden para presentacion del registro';
COMMENT ON COLUMN IBSDD.usuario_creacion          IS 'Usuario del sistema que creo el registro';
COMMENT ON COLUMN IBSDD.usuario_actualizacion     IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN IBSDD.version_registro          IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN IBSDD.observaciones             IS 'Notas adicionales sobre el registro';
COMMENT ON COLUMN IBSDD.estado_registro           IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN IBSDD.created_at                IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN IBSDD.updated_at                IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN IBSDD (
    id                        TEXT IS 'ID Diccionario',
    descripcion               TEXT IS 'Descripcion',
    valor_texto               TEXT IS 'Valor Texto',
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

CREATE INDEX IDX_IBSDD_C ON IBSDD (created_at);
