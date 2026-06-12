-- ==============================================================================
-- Nombre de la Tabla  : IBTBL
-- DESCRIPCION         : Archivo de Referencias Cruzadas para manejo de Intersucursales. Almacena las relaciones y equivalencias entre codigos de distintas sucursales del sistema IBS.
-- Objetivo            : Mantener las referencias cruzadas necesarias para el procesamiento de operaciones entre sucursales del sistema bancario.
-- Tipo de Tabla       : Catalogo / Referencias Cruzadas
-- Origen de los Datos : Configuracion por administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - referencias intersucursales
-- Restricciones       : PK surrogate (id BIGINT autogenerado); estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/IBTBL (
    id                        FOR COLUMN IDITBL  BIGINT          GENERATED ALWAYS AS IDENTITY,
    descripcion               FOR COLUMN DESCRIP VARCHAR(120)    NOT NULL DEFAULT '',
    valor_texto               FOR COLUMN VALTXT  VARCHAR(50)     NOT NULL DEFAULT '',
    valor_numerico            FOR COLUMN VALNUM  DECIMAL(18,2)   ,
    vigencia_desde            FOR COLUMN VIGDES  DATE            ,
    vigencia_hasta            FOR COLUMN VIGHST  DATE            ,
    orden_visualizacion       FOR COLUMN ORDVIS  INTEGER         NOT NULL DEFAULT 0,
    usuario_creacion          FOR COLUMN USRCREA VARCHAR(30)     NOT NULL DEFAULT '',
    usuario_actualizacion     FOR COLUMN USRACT  VARCHAR(30)     NOT NULL DEFAULT '',
    version_registro          FOR COLUMN VERSREG INTEGER         NOT NULL DEFAULT 1,
    observaciones             FOR COLUMN OBSERVACVARCHAR(120)    NOT NULL DEFAULT '',
    estado_registro           FOR COLUMN ESTREG  CHAR(1)         NOT NULL DEFAULT 'A',
    created_at                FOR COLUMN CRTDAT  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                FOR COLUMN UPDDAT  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_IBTBL PRIMARY KEY (id)
)
RCDFMT IBTBLR;

RENAME TABLE HNEACOSTA1/IBTBL
    TO IBTBL FOR SYSTEM NAME IBTBL;

COMMENT ON TABLE HNEACOSTA1/IBTBL IS
    'Referencias Cruzadas para Intersucursales - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/IBTBL IS
    'Referencias Intersucursales';

COMMENT ON COLUMN HNEACOSTA1/IBTBL.id                        IS 'Identificador unico autogenerado del registro de referencia intersucursal';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.descripcion               IS 'Descripcion del elemento o relacion registrada';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.valor_texto               IS 'Valor de texto adicional asociado al registro';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.valor_numerico            IS 'Valor numerico adicional asociado al registro si aplica';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.vigencia_desde            IS 'Fecha desde la cual el registro es vigente';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.vigencia_hasta            IS 'Fecha hasta la cual el registro es vigente';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.orden_visualizacion       IS 'Numero de orden para presentacion del registro';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.usuario_creacion          IS 'Usuario del sistema que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.usuario_actualizacion     IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.version_registro          IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.observaciones             IS 'Notas adicionales sobre el registro';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.estado_registro           IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.created_at                IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/IBTBL.updated_at                IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/IBTBL (
    id                        TEXT IS 'ID Referencia',
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

CREATE INDEX HNEACOSTA1/IDX_IBTBL_C ON HNEACOSTA1/IBTBL (created_at);
