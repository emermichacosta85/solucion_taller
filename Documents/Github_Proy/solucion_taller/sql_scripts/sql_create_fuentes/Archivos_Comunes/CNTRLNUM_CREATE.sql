-- ==============================================================================
-- Nombre de la Tabla  : CNTRLNUM
-- DESCRIPCION         : Control de Numeracion Automatica de Operaciones.
--                       Administra los contadores y secuencias de numeracion
--                       automatica utilizados por cada aplicacion y tipo de
--                       cuenta del sistema IBS.
-- Objetivo            : Garantizar la unicidad y continuidad de los numeros
--                       de operacion generados automaticamente por el sistema,
--                       controlando el ultimo numero asignado por aplicacion.
-- Tipo de Tabla       : Control de Secuencias
-- Origen de los Datos : Inicializado en despliegue; actualizado automaticamente
--                       por procesos de creacion de operaciones
-- Permanencia de Datos: Permanente; actualizacion concurrente controlada
-- Uso de los datos    : Modulo Archivos Comunes - numeracion automatica para
--                       todos los modulos del sistema
-- Restricciones       : PK compuesta (codigo_aplicacion, tipo_cuenta);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLNUM (
    codigo_aplicacion     FOR COLUMN CODAPL   VARCHAR(20)    NOT NULL,
    tipo_cuenta           FOR COLUMN TIPCTA   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_CNTRLNUM PRIMARY KEY (codigo_aplicacion, tipo_cuenta)
)
RCDFMT CNTRLNUMR;

RENAME TABLE HNEACOSTA1/CNTRLNUM
    TO CNTRLNUM FOR SYSTEM NAME CNTRLNUM;

COMMENT ON TABLE HNEACOSTA1/CNTRLNUM IS
    'Control de Numeracion Automatica de Operaciones - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/CNTRLNUM IS
    'Numeracion Automatica';

COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.codigo_aplicacion     IS 'Codigo del modulo o aplicacion que usa la numeracion automatica; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.tipo_cuenta           IS 'Tipo de cuenta u operacion para la que aplica la numeracion; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.descripcion           IS 'Descripcion de la secuencia de numeracion controlada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.valor_texto           IS 'Prefijo o patron del numero generado automaticamente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.valor_numerico        IS 'Ultimo numero asignado en la secuencia de numeracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.vigencia_desde        IS 'Fecha desde la cual la secuencia de numeracion es vigente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.vigencia_hasta        IS 'Fecha hasta la cual la secuencia de numeracion es vigente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.orden_visualizacion   IS 'Numero de orden para listado de secuencias del sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.usuario_creacion      IS 'Usuario administrador que configuro la secuencia de numeracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.usuario_actualizacion IS 'Usuario o proceso que realizo la ultima actualizacion del contador';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.observaciones         IS 'Notas sobre la secuencia de numeracion y su uso';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLNUM.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLNUM (
    codigo_aplicacion     TEXT IS 'Codigo Aplicacion',
    tipo_cuenta           TEXT IS 'Tipo de Cuenta',
    descripcion           TEXT IS 'Descripcion Secuencia',
    valor_texto           TEXT IS 'Prefijo Numero',
    valor_numerico        TEXT IS 'Ultimo Numero',
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

CREATE INDEX HNEACOSTA1/IDX_CNTRLNUM_C ON HNEACOSTA1/CNTRLNUM (created_at);
