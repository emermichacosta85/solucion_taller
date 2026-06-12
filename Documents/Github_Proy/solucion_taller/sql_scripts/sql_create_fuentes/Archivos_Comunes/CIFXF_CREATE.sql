-- ==============================================================================
-- Nombre de la Tabla  : CIFXF
-- DESCRIPCION         : Relacion de operaciones con clientes. Vincula los distintos tipos de operaciones financieras registradas en el sistema con el cliente titular, consolidando la vista de relacion cliente-operacion.
-- Objetivo            : Mantener el vinculo entre clientes y sus operaciones activas en el sistema, facilitando la consulta integral del portafolio del cliente.
-- Tipo de Tabla       : Relacional Transaccional
-- Origen de los Datos : Generado automaticamente al crear operaciones de cliente
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo Archivos Comunes - relacion integral cliente-operaciones
-- Restricciones       : PK surrogate (id BIGINT autogenerado); estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CIFXF (
    id                        FOR COLUMN IDCIFX  BIGINT          GENERATED ALWAYS AS IDENTITY,
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
    CONSTRAINT PK_CIFXF PRIMARY KEY (id)
)
RCDFMT CIFXFR;

RENAME TABLE HNEACOSTA1/CIFXF
    TO CIFXF FOR SYSTEM NAME CIFXF;

COMMENT ON TABLE HNEACOSTA1/CIFXF IS
    'Relacion de Operaciones con Clientes - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/CIFXF IS
    'Operaciones de Clientes';

COMMENT ON COLUMN HNEACOSTA1/CIFXF.id                        IS 'Identificador unico autogenerado del registro de relacion cliente-operacion';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.descripcion               IS 'Descripcion del elemento o relacion registrada';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.valor_texto               IS 'Valor de texto adicional asociado al registro';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.valor_numerico            IS 'Valor numerico adicional asociado al registro si aplica';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.vigencia_desde            IS 'Fecha desde la cual el registro es vigente';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.vigencia_hasta            IS 'Fecha hasta la cual el registro es vigente';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.orden_visualizacion       IS 'Numero de orden para presentacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.usuario_creacion          IS 'Usuario del sistema que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.usuario_actualizacion     IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.version_registro          IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.observaciones             IS 'Notas adicionales sobre el registro';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.estado_registro           IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.created_at                IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CIFXF.updated_at                IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CIFXF (
    id                        TEXT IS 'ID Relacion',
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

CREATE INDEX HNEACOSTA1/IDX_CIFXF_C ON HNEACOSTA1/CIFXF (created_at);
