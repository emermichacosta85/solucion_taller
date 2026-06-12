-- ==============================================================================
-- Nombre de la Tabla  : UT500
-- DESCRIPCION         : Agenda Personalizada de Usuarios. Almacena las
--                       entradas de agenda y recordatorios personales de
--                       cada usuario del sistema, organizadas por codigo
--                       de usuario y fecha.
-- Objetivo            : Proporcionar a cada usuario del sistema una agenda
--                       personalizada para registro de compromisos,
--                       recordatorios y anotaciones de gestion.
-- Tipo de Tabla       : Maestro de Agenda de Usuario
-- Origen de los Datos : Ingreso directo por cada usuario del sistema
-- Permanencia de Datos: Permanente; administrado por cada usuario
-- Uso de los datos    : Modulo Archivos Comunes - agenda y recordatorios
--                       de usuarios; tabla padre logica de UT510
-- Restricciones       : PK compuesta (codigo_usuario, fecha);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/UT500 (
    codigo_usuario        FOR COLUMN CODUSR   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_UT500   PRIMARY KEY (codigo_usuario, fecha)
)
RCDFMT UT500R;

RENAME TABLE HNEACOSTA1/UT500
    TO UT500 FOR SYSTEM NAME UT500;

COMMENT ON TABLE HNEACOSTA1/UT500 IS
    'Agenda Personalizada de Usuarios - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/UT500 IS
    'Agenda Personalizada';

COMMENT ON COLUMN HNEACOSTA1/UT500.codigo_usuario        IS 'Codigo del usuario propietario de la entrada de agenda; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/UT500.fecha                 IS 'Fecha del compromiso o recordatorio en la agenda; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/UT500.descripcion           IS 'Descripcion del compromiso, recordatorio o anotacion del usuario';
COMMENT ON COLUMN HNEACOSTA1/UT500.valor_texto           IS 'Tipo o categoria de la entrada de agenda: REUNION, TAREA, RECORDATORIO';
COMMENT ON COLUMN HNEACOSTA1/UT500.valor_numerico        IS 'Valor numerico asociado a la entrada de agenda si aplica';
COMMENT ON COLUMN HNEACOSTA1/UT500.vigencia_desde        IS 'Fecha de inicio de vigencia o relevancia del compromiso';
COMMENT ON COLUMN HNEACOSTA1/UT500.vigencia_hasta        IS 'Fecha de fin de vigencia o expiracion del compromiso';
COMMENT ON COLUMN HNEACOSTA1/UT500.orden_visualizacion   IS 'Numero de orden para presentacion en la agenda del usuario';
COMMENT ON COLUMN HNEACOSTA1/UT500.usuario_creacion      IS 'Usuario que creo la entrada en la agenda';
COMMENT ON COLUMN HNEACOSTA1/UT500.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/UT500.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/UT500.observaciones         IS 'Notas adicionales sobre el compromiso de agenda';
COMMENT ON COLUMN HNEACOSTA1/UT500.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/UT500.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/UT500.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/UT500 (
    codigo_usuario        TEXT IS 'Codigo Usuario',
    fecha                 TEXT IS 'Fecha Agenda',
    descripcion           TEXT IS 'Descripcion Compromiso',
    valor_texto           TEXT IS 'Tipo Entrada',
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

CREATE INDEX HNEACOSTA1/IDX_UT500_F ON HNEACOSTA1/UT500 (fecha);
CREATE INDEX HNEACOSTA1/IDX_UT500_C ON HNEACOSTA1/UT500 (created_at);
