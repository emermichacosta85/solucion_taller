-- ==============================================================================
-- Nombre de la Tabla  : UT510
-- DESCRIPCION         : Mensajes de Usuarios. Almacena los mensajes enviados
--                       y recibidos entre usuarios del sistema, organizados
--                       por codigo de usuario y fecha. Comparte la misma
--                       clave de agrupacion que UT500 (agenda personalizada).
-- Objetivo            : Facilitar la comunicacion interna entre usuarios del
--                       sistema IBS mediante un mecanismo de mensajeria
--                       integrado, complementando la agenda de UT500.
-- Tipo de Tabla       : Maestro de Mensajeria de Usuario
-- Origen de los Datos : Ingreso por usuarios del sistema al enviar mensajes
-- Permanencia de Datos: Permanente; administrado por cada usuario
-- Uso de los datos    : Modulo Archivos Comunes - mensajeria interna entre
--                       usuarios; relacionada a UT500 via (codigo_usuario, fecha)
-- Restricciones       : PK compuesta (codigo_usuario, fecha);
--                       FK a UT500 (codigo_usuario, fecha);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/UT510 (
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
    CONSTRAINT PK_UT510   PRIMARY KEY (codigo_usuario, fecha),
    CONSTRAINT FK_UT510_UT500 FOREIGN KEY (codigo_usuario, fecha)
        REFERENCES HNEACOSTA1/UT500 (codigo_usuario, fecha)
)
RCDFMT UT510R;

RENAME TABLE HNEACOSTA1/UT510
    TO UT510 FOR SYSTEM NAME UT510;

COMMENT ON TABLE HNEACOSTA1/UT510 IS
    'Mensajes Internos de Usuarios - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/UT510 IS
    'Mensajes de Usuarios';

COMMENT ON COLUMN HNEACOSTA1/UT510.codigo_usuario        IS 'Codigo del usuario destinatario o remitente del mensaje; parte de la PK y FK a UT500';
COMMENT ON COLUMN HNEACOSTA1/UT510.fecha                 IS 'Fecha del mensaje o comunicado interno; parte de la PK y FK a UT500';
COMMENT ON COLUMN HNEACOSTA1/UT510.descripcion           IS 'Contenido o asunto del mensaje enviado entre usuarios';
COMMENT ON COLUMN HNEACOSTA1/UT510.valor_texto           IS 'Tipo de mensaje: AVISO, ALERTA, INFORMATIVO, URGENTE';
COMMENT ON COLUMN HNEACOSTA1/UT510.valor_numerico        IS 'Valor numerico asociado al mensaje si aplica';
COMMENT ON COLUMN HNEACOSTA1/UT510.vigencia_desde        IS 'Fecha desde la cual el mensaje es visible para el destinatario';
COMMENT ON COLUMN HNEACOSTA1/UT510.vigencia_hasta        IS 'Fecha de expiracion o vencimiento del mensaje';
COMMENT ON COLUMN HNEACOSTA1/UT510.orden_visualizacion   IS 'Numero de orden para presentacion en la bandeja de mensajes';
COMMENT ON COLUMN HNEACOSTA1/UT510.usuario_creacion      IS 'Usuario remitente que envio el mensaje';
COMMENT ON COLUMN HNEACOSTA1/UT510.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/UT510.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/UT510.observaciones         IS 'Notas adicionales sobre el mensaje interno';
COMMENT ON COLUMN HNEACOSTA1/UT510.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/UT510.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/UT510.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/UT510 (
    codigo_usuario        TEXT IS 'Codigo Usuario',
    fecha                 TEXT IS 'Fecha Mensaje',
    descripcion           TEXT IS 'Contenido Mensaje',
    valor_texto           TEXT IS 'Tipo Mensaje',
    valor_numerico        TEXT IS 'Valor Numerico',
    vigencia_desde        TEXT IS 'Vigencia Desde',
    vigencia_hasta        TEXT IS 'Vigencia Hasta',
    orden_visualizacion   TEXT IS 'Orden Visualizacion',
    usuario_creacion      TEXT IS 'Usuario Remitente',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro      TEXT IS 'Version Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_UT510_F ON HNEACOSTA1/UT510 (fecha);
CREATE INDEX HNEACOSTA1/IDX_UT510_C ON HNEACOSTA1/UT510 (created_at);
