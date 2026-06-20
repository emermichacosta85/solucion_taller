-- ==============================================================================
-- Nombre de la Tabla  : CNTRLCNT
-- DESCRIPCION         : Parametros Generales del Sistema. Almacena la
--                       configuracion de parametros globales por banco,
--                       incluyendo rutas IFS, tolerancias, versiones y
--                       datos de control del sistema IBS.
-- Objetivo            : Centralizar todos los parametros de configuracion
--                       del sistema por banco, permitiendo ajustes operativos
--                       sin modificacion del codigo fuente.
-- Tipo de Tabla       : Maestro de Parametros del Sistema
-- Origen de los Datos : Configuracion inicial y mantenimiento por
--                       administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - parametros globales para
--                       todos los modulos del sistema; tabla padre de CNTRLBRN
-- Restricciones       : PK (codigo_banco); estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE CNTRLCNT (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_CNTRLCNT PRIMARY KEY (codigo_banco)
)
RCDFMT CNTRLCNTR;

RENAME TABLE CNTRLCNT
    TO CNTRLCNT_TABLE FOR SYSTEM NAME CNTRLCNT;

COMMENT ON TABLE CNTRLCNT IS
    'Parametros Generales del Sistema por Banco - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE CNTRLCNT IS
    'Parametros Generales Sistema';

COMMENT ON COLUMN CNTRLCNT.codigo_banco          IS 'Codigo del banco al que aplican los parametros generales del sistema; PK';
COMMENT ON COLUMN CNTRLCNT.descripcion           IS 'Nombre o descripcion del parametro de sistema configurado';
COMMENT ON COLUMN CNTRLCNT.valor_texto           IS 'Valor de texto del parametro (ruta IFS, codigo, nombre, etc.)';
COMMENT ON COLUMN CNTRLCNT.valor_numerico        IS 'Valor numerico del parametro (tolerancia, limite, porcentaje, etc.)';
COMMENT ON COLUMN CNTRLCNT.vigencia_desde        IS 'Fecha desde la cual el parametro es vigente';
COMMENT ON COLUMN CNTRLCNT.vigencia_hasta        IS 'Fecha hasta la cual el parametro es vigente';
COMMENT ON COLUMN CNTRLCNT.orden_visualizacion   IS 'Numero de orden para presentacion de parametros del sistema';
COMMENT ON COLUMN CNTRLCNT.usuario_creacion      IS 'Usuario administrador que configuro el parametro del sistema';
COMMENT ON COLUMN CNTRLCNT.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN CNTRLCNT.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLCNT.observaciones         IS 'Notas sobre el parametro y su efecto en el sistema';
COMMENT ON COLUMN CNTRLCNT.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN CNTRLCNT.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN CNTRLCNT.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLCNT (
    codigo_banco          TEXT IS 'Codigo Banco',
    descripcion           TEXT IS 'Nombre Parametro',
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

CREATE INDEX IDX_CNTRLCNT_C ON CNTRLCNT (created_at);
