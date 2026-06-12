-- ==============================================================================
-- Nombre de la Tabla  : HOLYD
-- DESCRIPCION         : Archivo de Feriados. Registra los dias no habiles
--                       por moneda y fecha, utilizados para el calculo de
--                       fechas valor, vencimientos y procesamiento de
--                       operaciones financieras.
-- Objetivo            : Mantener el calendario de dias feriados por moneda,
--                       permitiendo al sistema determinar correctamente las
--                       fechas habiles para el procesamiento de operaciones.
-- Tipo de Tabla       : Catalogo de Calendario
-- Origen de los Datos : Carga anual por administrador del sistema segun
--                       calendario oficial de cada plaza financiera
-- Permanencia de Datos: Permanente; carga anual anticipada
-- Uso de los datos    : Modulo Archivos Comunes - calculo de fechas valor,
--                       vencimientos y dias habiles en todos los modulos
-- Restricciones       : PK compuesta (codigo_moneda, fecha);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/HOLYD (
    codigo_moneda         FOR COLUMN CODMON   VARCHAR(20)    NOT NULL,
    fecha                 FOR COLUMN FECHA    DATE           NOT NULL,
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
    CONSTRAINT PK_HOLYD   PRIMARY KEY (codigo_moneda, fecha)
)
RCDFMT HOLYDR;

RENAME TABLE HNEACOSTA1/HOLYD
    TO HOLYD FOR SYSTEM NAME HOLYD;

COMMENT ON TABLE HNEACOSTA1/HOLYD IS
    'Calendario de Feriados por Moneda - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/HOLYD IS
    'Feriados por Moneda';

COMMENT ON COLUMN HNEACOSTA1/HOLYD.codigo_moneda         IS 'Codigo de moneda o plaza financiera a la que aplica el feriado; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.fecha                 IS 'Fecha del dia feriado o no habil; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.descripcion           IS 'Nombre o descripcion oficial del dia feriado';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.valor_texto           IS 'Tipo de feriado: NACIONAL, LOCAL, BANCARIO, etc.';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.valor_numerico        IS 'Valor numerico asociado al feriado si aplica';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.vigencia_desde        IS 'Fecha desde la cual aplica la definicion del feriado';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.vigencia_hasta        IS 'Fecha hasta la cual aplica la definicion del feriado';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.orden_visualizacion   IS 'Numero de orden para listado del calendario de feriados';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.usuario_creacion      IS 'Usuario del sistema que registro el feriado';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.observaciones         IS 'Notas adicionales sobre el feriado registrado';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/HOLYD.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/HOLYD (
    codigo_moneda         TEXT IS 'Codigo Moneda',
    fecha                 TEXT IS 'Fecha Feriado',
    descripcion           TEXT IS 'Descripcion Feriado',
    valor_texto           TEXT IS 'Tipo Feriado',
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

CREATE INDEX HNEACOSTA1/IDX_HOLYD_F ON HNEACOSTA1/HOLYD (fecha);
CREATE INDEX HNEACOSTA1/IDX_HOLYD_C ON HNEACOSTA1/HOLYD (created_at);
