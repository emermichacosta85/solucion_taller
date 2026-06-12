-- ==============================================================================
-- Nombre de la Tabla  : HLHIS
-- DESCRIPCION         : Archivo historico de Cambios en Retenciones. Registra
--                       el historico de todas las modificaciones aplicadas
--                       a las retenciones del sistema.
-- Objetivo            : Mantener trazabilidad completa de los cambios en
--                       retenciones para auditoria y consulta historica.
-- Tipo de Tabla       : Historico
-- Origen de los Datos : Generado automaticamente por procesos de retencion
-- Permanencia de Datos: Permanente con historico indefinido
-- Uso de los datos    : Modulo Archivos Comunes - auditoria de retenciones
-- Restricciones       : PK surrogate (id BIGINT autogenerado);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/HLHIS (
    id                    FOR COLUMN IDHLH    BIGINT         NOT NULL GENERATED ALWAYS AS IDENTITY,
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
    CONSTRAINT PK_HLHIS   PRIMARY KEY (id)
)
RCDFMT HLHISR;

RENAME TABLE HNEACOSTA1/HLHIS
    TO HLHIS FOR SYSTEM NAME HLHIS;

COMMENT ON TABLE HNEACOSTA1/HLHIS IS
    'Historico de Cambios en Retenciones - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/HLHIS IS
    'Historico Cambios Retenciones';

COMMENT ON COLUMN HNEACOSTA1/HLHIS.id                    IS 'Identificador unico autogenerado del registro historico de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.descripcion           IS 'Descripcion del cambio de retencion registrado';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.valor_texto           IS 'Tipo o motivo del cambio de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.valor_numerico        IS 'Monto o porcentaje de la retencion modificada';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.vigencia_desde        IS 'Fecha desde la cual aplica el cambio de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.vigencia_hasta        IS 'Fecha hasta la cual aplica el cambio de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.orden_visualizacion   IS 'Numero de orden para listado historico de retenciones';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.usuario_creacion      IS 'Usuario o proceso que registro el cambio de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.observaciones         IS 'Notas adicionales sobre el cambio de retencion';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/HLHIS.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/HLHIS (
    id                    TEXT IS 'ID Retencion',
    descripcion           TEXT IS 'Descripcion Cambio',
    valor_texto           TEXT IS 'Tipo Cambio',
    valor_numerico        TEXT IS 'Valor Retencion',
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

CREATE INDEX HNEACOSTA1/IDX_HLHIS_C ON HNEACOSTA1/HLHIS (created_at);
