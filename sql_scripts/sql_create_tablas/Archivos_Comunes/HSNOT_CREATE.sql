-- ==============================================================================
-- Nombre de la Tabla  : HSNOT
-- DESCRIPCION         : Historico de Datos impresos en las Notificaciones.
--                       Conserva el registro permanente de todas las
--                       notificaciones generadas y enviadas a clientes,
--                       con la misma estructura de MLNOT pero con
--                       permanencia historica indefinida.
-- Objetivo            : Mantener la trazabilidad historica completa de las
--                       notificaciones enviadas a clientes, soportando
--                       auditorias y consultas de periodos anteriores.
-- Tipo de Tabla       : Historico
-- Origen de los Datos : Migrado desde MLNOT al cierre del ciclo de proceso
-- Permanencia de Datos: Permanente con historico indefinido
-- Uso de los datos    : Modulo Archivos Comunes - auditoria y consulta de
--                       notificaciones historicas; replica de MLNOT con
--                       misma estructura y relacion logica a MLNCT
-- Restricciones       : PK compuesta (codigo_banco, fecha_proceso, numero_cuenta,
--                       codigo_de_notificacion, nivel);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HSNOT (
    codigo_banco            FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    fecha_proceso           FOR COLUMN FECPRO   DATE           NOT NULL,
    numero_cuenta           FOR COLUMN NUMCTA   VARCHAR(24)    NOT NULL,
    codigo_de_notificacion  FOR COLUMN CODNOT   VARCHAR(20)    NOT NULL,
    nivel_notificacion      FOR COLUMN NIVEL    INTEGER        NOT NULL,
    descripcion             FOR COLUMN DESCRIP  VARCHAR(120)   NOT NULL DEFAULT '',
    valor_texto             FOR COLUMN VALTXT   VARCHAR(50)    NOT NULL DEFAULT '',
    valor_numerico          FOR COLUMN VALNUM   DECIMAL(18, 2),
    vigencia_desde          FOR COLUMN VIGDES   DATE,
    vigencia_hasta          FOR COLUMN VIGHST   DATE,
    orden_visualizacion     FOR COLUMN ORDVIS   INTEGER        NOT NULL DEFAULT 0,
    usuario_creacion        FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion   FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro        FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro         FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_HSNOT     PRIMARY KEY (codigo_banco, fecha_proceso, numero_cuenta, codigo_de_notificacion, nivel)
)
RCDFMT HSNOTR;

RENAME TABLE HSNOT
    TO HSNOT_TABLE FOR SYSTEM NAME HSNOT;

COMMENT ON TABLE HSNOT IS
    'Historico Datos Impresos en Notificaciones - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HSNOT IS
    'Historico Notificaciones';

COMMENT ON COLUMN HSNOT.codigo_banco            IS 'Codigo del banco que genero la notificacion historica; parte de la PK';
COMMENT ON COLUMN HSNOT.fecha_proceso           IS 'Fecha del proceso que genero la notificacion; parte de la PK';
COMMENT ON COLUMN HSNOT.numero_cuenta           IS 'Numero de cuenta del cliente destinatario; parte de la PK';
COMMENT ON COLUMN HSNOT.codigo_de_notificacion  IS 'Codigo del tipo de notificacion enviada; parte de la PK';
COMMENT ON COLUMN HSNOT.nivel                   IS 'Nivel jerarquico de la notificacion enviada; parte de la PK';
COMMENT ON COLUMN HSNOT.descripcion             IS 'Descripcion del contenido de la notificacion historica';
COMMENT ON COLUMN HSNOT.valor_texto             IS 'Dato de texto impreso en la notificacion historica';
COMMENT ON COLUMN HSNOT.valor_numerico          IS 'Dato numerico impreso en la notificacion historica si aplica';
COMMENT ON COLUMN HSNOT.vigencia_desde          IS 'Fecha de inicio de vigencia de la notificacion historica';
COMMENT ON COLUMN HSNOT.vigencia_hasta          IS 'Fecha de fin de vigencia de la notificacion historica';
COMMENT ON COLUMN HSNOT.orden_visualizacion     IS 'Numero de orden de impresion del dato en la notificacion';
COMMENT ON COLUMN HSNOT.usuario_creacion        IS 'Usuario o proceso que migro el registro al historico';
COMMENT ON COLUMN HSNOT.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion al historico';
COMMENT ON COLUMN HSNOT.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HSNOT.observaciones           IS 'Notas adicionales sobre la notificacion historica';
COMMENT ON COLUMN HSNOT.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HSNOT.created_at              IS 'Fecha y hora exacta de creacion del registro en el historico';
COMMENT ON COLUMN HSNOT.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HSNOT (
    codigo_banco            TEXT IS 'Codigo Banco',
    fecha_proceso           TEXT IS 'Fecha Proceso',
    numero_cuenta           TEXT IS 'Numero Cuenta',
    codigo_de_notificacion  TEXT IS 'Codigo Notificacion',
    nivel                   TEXT IS 'Nivel',
    descripcion             TEXT IS 'Descripcion',
    valor_texto             TEXT IS 'Valor Texto',
    valor_numerico          TEXT IS 'Valor Numerico',
    vigencia_desde          TEXT IS 'Vigencia Desde',
    vigencia_hasta          TEXT IS 'Vigencia Hasta',
    orden_visualizacion     TEXT IS 'Orden Visualizacion',
    usuario_creacion        TEXT IS 'Usuario Creacion',
    usuario_actualizacion   TEXT IS 'Usuario Actualizacion',
    version_registro        TEXT IS 'Version Registro',
    observaciones           TEXT IS 'Observaciones',
    estado_registro         TEXT IS 'Estado Registro',
    created_at              TEXT IS 'Fecha Creacion',
    updated_at              TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_HSNOT_F ON HSNOT (fecha_proceso);
CREATE INDEX IDX_HSNOT_C ON HSNOT (created_at);
