-- ==============================================================================
-- Nombre de la Tabla  : CNTRLBRN
-- DESCRIPCION         : Archivo de Sucursales. Catalogo de todas las
--                       sucursales del banco con su configuracion,
--                       descripcion y datos operativos. Tabla hija de
--                       CNTRLCNT, agrupada por codigo de banco.
-- Objetivo            : Mantener el registro oficial de todas las sucursales
--                       del banco, sirviendo como referencia para filtros,
--                       reportes y procesos batch de todos los modulos.
-- Tipo de Tabla       : Catalogo / Maestro de Sucursales
-- Origen de los Datos : Configuracion por administrador del sistema al
--                       habilitar nuevas sucursales
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - referencia de sucursales
--                       para todos los modulos; tabla hija de CNTRLCNT
-- Restricciones       : PK compuesta (codigo_banco, codigo_sucursal);
--                       FK a CNTRLCNT (codigo_banco);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLBRN (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_sucursal       FOR COLUMN CODSUC   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_CNTRLBRN  PRIMARY KEY (codigo_banco, codigo_sucursal),
    CONSTRAINT FK_CNTRLBRN_CNTRLCNT FOREIGN KEY (codigo_banco)
        REFERENCES HNEACOSTA1/CNTRLCNT (codigo_banco)
)
RCDFMT CNTRLBRNR;

RENAME TABLE HNEACOSTA1/CNTRLBRN
    TO CNTRLBRN FOR SYSTEM NAME CNTRLBRN;

COMMENT ON TABLE HNEACOSTA1/CNTRLBRN IS
    'Catalogo de Sucursales del Banco - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/CNTRLBRN IS
    'Sucursales del Banco';

COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.codigo_banco          IS 'Codigo del banco al que pertenece la sucursal; parte de la PK y FK a CNTRLCNT';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.codigo_sucursal       IS 'Codigo unico de la sucursal dentro del banco; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.descripcion           IS 'Nombre completo y descripcion de la sucursal bancaria';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.valor_texto           IS 'Nombre corto o abreviatura oficial de la sucursal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.valor_numerico        IS 'Valor numerico asociado a la sucursal si aplica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.vigencia_desde        IS 'Fecha desde la cual la sucursal esta operativa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.vigencia_hasta        IS 'Fecha hasta la cual la sucursal esta operativa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.orden_visualizacion   IS 'Numero de orden para presentacion en catalogos de sucursales';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.usuario_creacion      IS 'Usuario administrador que registro la sucursal en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.observaciones         IS 'Notas operativas adicionales sobre la sucursal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBRN.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLBRN (
    codigo_banco          TEXT IS 'Codigo Banco',
    codigo_sucursal       TEXT IS 'Codigo Sucursal',
    descripcion           TEXT IS 'Nombre Sucursal',
    valor_texto           TEXT IS 'Nombre Corto',
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

CREATE INDEX HNEACOSTA1/IDX_CNTRLBRN_C ON HNEACOSTA1/CNTRLBRN (created_at);
