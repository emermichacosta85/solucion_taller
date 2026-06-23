-- ==============================================================================
-- Nombre de la Tabla  : MLNOT
-- DESCRIPCION         : Archivo que contiene los datos a imprimir en la
--                       notificacion. Almacena los datos concretos de cada
--                       notificacion generada por banco, fecha de proceso,
--                       cuenta, codigo de notificacion y nivel.
-- Objetivo            : Registrar los datos variables de cada notificacion
--                       a imprimir o enviar al cliente, asociados al patron
--                       definido en MLNCT.
-- Tipo de Tabla       : Transaccional de Proceso
-- Origen de los Datos : Generado automaticamente por procesos batch de
--                       notificaciones del sistema
-- Permanencia de Datos: Temporal por ciclo de proceso; se archiva en HSNOT
-- Uso de los datos    : Modulo Archivos Comunes - impresion y envio de
--                       notificaciones; tabla hija logica de MLNCT via
--                       (codigo_banco, codigo_de_notificacion, nivel)
-- Restricciones       : PK compuesta (codigo_banco, fecha_proceso, numero_cuenta,
--                       codigo_de_notificacion, nivel);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE MLNOT (
    codigo_banco            FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    fecha_proceso           FOR COLUMN FECPRO   DATE           NOT NULL,
    numero_cuenta           FOR COLUMN NUMCTA   VARCHAR(24)    NOT NULL,
    codigo_de_notificacion  FOR COLUMN CODNOT   VARCHAR(20)    NOT NULL,
    nivel_de_notificacion   FOR COLUMN NIVEL    INTEGER        NOT NULL,
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
    CONSTRAINT PK_MLNOT     PRIMARY KEY (codigo_banco, fecha_proceso, numero_cuenta, codigo_de_notificacion, nivel),
    --CONSTRAINT FK_MLNOT_MLNCT FOREIGN KEY (codigo_banco, codigo_de_notificacion, nivel)
     --   REFERENCES MLNCT (codigo_banco, codigo_de_notificacion, nivel)
)
RCDFMT MNOTR;

RENAME TABLE MLNOT
    TO MLNOT_TABLE FOR SYSTEM NAME MLNOT;

COMMENT ON TABLE MLNOT IS
    'Datos a Imprimir en Notificaciones - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE MLNOT IS
    'Datos Notificaciones';

COMMENT ON COLUMN MLNOT.codigo_banco            IS 'Codigo del banco que genera la notificacion; parte de la PK';
COMMENT ON COLUMN MLNOT.fecha_proceso           IS 'Fecha del proceso batch que genero la notificacion; parte de la PK';
COMMENT ON COLUMN MLNOT.numero_cuenta           IS 'Numero de cuenta del cliente destinatario de la notificacion; parte de la PK';
COMMENT ON COLUMN MLNOT.codigo_de_notificacion  IS 'Codigo del tipo de notificacion referenciado en MLNCT; parte de la PK';
COMMENT ON COLUMN MLNOT.nivel                   IS 'Nivel jerarquico de la notificacion referenciado en MLNCT; parte de la PK';
COMMENT ON COLUMN MLNOT.descripcion             IS 'Descripcion del contenido de la notificacion generada';
COMMENT ON COLUMN MLNOT.valor_texto             IS 'Dato de texto variable a imprimir en la notificacion';
COMMENT ON COLUMN MLNOT.valor_numerico          IS 'Dato numerico variable a imprimir en la notificacion si aplica';
COMMENT ON COLUMN MLNOT.vigencia_desde          IS 'Fecha desde la cual el dato de notificacion es vigente';
COMMENT ON COLUMN MLNOT.vigencia_hasta          IS 'Fecha hasta la cual el dato de notificacion es vigente';
COMMENT ON COLUMN MLNOT.orden_visualizacion     IS 'Numero de orden de impresion del dato en la notificacion';
COMMENT ON COLUMN MLNOT.usuario_creacion        IS 'Usuario o proceso batch que genero el registro de notificacion';
COMMENT ON COLUMN MLNOT.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN MLNOT.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN MLNOT.observaciones           IS 'Notas adicionales sobre el dato de notificacion';
COMMENT ON COLUMN MLNOT.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN MLNOT.created_at              IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN MLNOT.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN MLNOT (
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

CREATE INDEX IDX_MLNOT_F ON MLNOT (fecha_proceso);
CREATE INDEX IDX_MLNOT_C ON MLNOT (created_at);
