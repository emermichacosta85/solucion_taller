-- ==============================================================================
-- Nombre de la Tabla  : CNTRLTAX
-- DESCRIPCION         : Definiciones para el manejo de cobro de impuestos.
--                       Almacena la parametrizacion de cada tipo de impuesto
--                       aplicable por banco, incluyendo tasas, bases de
--                       calculo y condiciones de aplicacion.
-- Objetivo            : Centralizar la configuracion fiscal del banco,
--                       permitiendo el calculo automatico y consistente
--                       de impuestos en todas las operaciones del sistema.
-- Tipo de Tabla       : Catalogo / Parametros Fiscales
-- Origen de los Datos : Configuracion por administrador del sistema segun
--                       normativa fiscal vigente
-- Permanencia de Datos: Permanente; actualizable ante cambios regulatorios
-- Uso de los datos    : Modulo Archivos Comunes - parametros fiscales para
--                       calculo de impuestos en todos los modulos
-- Restricciones       : PK compuesta (codigo_banco, codigo_impuesto);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE CNTRLTAX (
    codigo_banco          FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_impuesto       FOR COLUMN CODIMP   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_CNTRLTAX PRIMARY KEY (codigo_banco, codigo_impuesto)
)
RCDFMT CNTRLTAXR;

RENAME TABLE CNTRLTAX
    TO CNTRLTAX_TABLE FOR SYSTEM NAME CNTRLTAX;

COMMENT ON TABLE CNTRLTAX IS
    'Definiciones de Cobro de Impuestos por Banco - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE CNTRLTAX IS
    'Parametros de Impuestos';

COMMENT ON COLUMN CNTRLTAX.codigo_banco          IS 'Codigo del banco al que aplica la definicion de impuesto; parte de la PK';
COMMENT ON COLUMN CNTRLTAX.codigo_impuesto       IS 'Codigo identificador unico del tipo de impuesto; parte de la PK';
COMMENT ON COLUMN CNTRLTAX.descripcion           IS 'Nombre y descripcion completa del impuesto parametrizado';
COMMENT ON COLUMN CNTRLTAX.valor_texto           IS 'Tipo de impuesto: IVA, ISR, TIMBRE, MUNICIPAL, etc.';
COMMENT ON COLUMN CNTRLTAX.valor_numerico        IS 'Tasa o porcentaje del impuesto parametrizado';
COMMENT ON COLUMN CNTRLTAX.vigencia_desde        IS 'Fecha desde la cual la definicion fiscal es vigente';
COMMENT ON COLUMN CNTRLTAX.vigencia_hasta        IS 'Fecha hasta la cual la definicion fiscal es vigente';
COMMENT ON COLUMN CNTRLTAX.orden_visualizacion   IS 'Numero de orden para presentacion del catalogo fiscal';
COMMENT ON COLUMN CNTRLTAX.usuario_creacion      IS 'Usuario administrador que configuro el impuesto';
COMMENT ON COLUMN CNTRLTAX.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN CNTRLTAX.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLTAX.observaciones         IS 'Notas sobre la definicion fiscal y su marco legal';
COMMENT ON COLUMN CNTRLTAX.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN CNTRLTAX.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN CNTRLTAX.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLTAX (
    codigo_banco          TEXT IS 'Codigo Banco',
    codigo_impuesto       TEXT IS 'Codigo Impuesto',
    descripcion           TEXT IS 'Nombre Impuesto',
    valor_texto           TEXT IS 'Tipo Impuesto',
    valor_numerico        TEXT IS 'Tasa Impuesto',
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

CREATE INDEX IDX_CNTRLTAX_C ON CNTRLTAX (created_at);
