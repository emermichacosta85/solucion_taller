-- ==============================================================================
-- Nombre de la Tabla  : DPMST
-- DESCRIPCION         : Cabecera de la Declaracion Patrimonial de Personas
--                       Naturales. Almacena el encabezado de la declaracion
--                       financiera personal presentada por el cliente.
-- Objetivo            : Registrar la informacion resumen del patrimonio de
--                       personas naturales como parte del analisis de credito.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso manual por analista de credito o cliente
-- Permanencia de Datos: Permanente con histórico por secuencia
-- Uso de los datos    : Módulo de Propuesta de Crédito - análisis patrimonial
-- Restricciones       : PK compuesta (id_cliente, secuencia); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DPMST (
    id_cliente            FOR COLUMN IDCLI    VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
    fecha_propuesta       FOR COLUMN FECPROP  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN MONTSOL  DECIMAL(18, 2) NOT NULL DEFAULT 0,
    plazo_meses           FOR COLUMN PLZMESES INTEGER        NOT NULL DEFAULT 0,
    tasa_propuesta        FOR COLUMN TASAPROP DECIMAL(18, 2) NOT NULL DEFAULT 0,
    dictamen_credito      FOR COLUMN DICTCRED VARCHAR(120)   NOT NULL DEFAULT '',
    estado_propuesta      FOR COLUMN ESTPROP  VARCHAR(20)    NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DPMST  PRIMARY KEY (id_cliente, secuencia)
)
RCDFMT DPMSTR;

RENAME TABLE HNEACOSTA1/DPMST
    TO DPMST FOR SYSTEM NAME DPMST;

COMMENT ON TABLE HNEACOSTA1/DPMST IS
    'Cabecera Declaracion Patrimonial Personas Naturales - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/DPMST IS
    'Declaracion Patrimonial PN';

COMMENT ON COLUMN HNEACOSTA1/DPMST.id_cliente            IS 'Identificacion unica del cliente persona natural';
COMMENT ON COLUMN HNEACOSTA1/DPMST.secuencia             IS 'Numero de secuencia de la declaracion patrimonial del cliente';
COMMENT ON COLUMN HNEACOSTA1/DPMST.fecha_propuesta       IS 'Fecha de presentacion de la declaracion patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPMST.monto_solicitado      IS 'Monto de credito solicitado en base a esta declaracion';
COMMENT ON COLUMN HNEACOSTA1/DPMST.plazo_meses           IS 'Plazo en meses vinculado a la solicitud de credito';
COMMENT ON COLUMN HNEACOSTA1/DPMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud';
COMMENT ON COLUMN HNEACOSTA1/DPMST.dictamen_credito      IS 'Dictamen del analista sobre la declaracion patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPMST.estado_propuesta      IS 'Estado de la declaracion: VIGENTE, ACTUALIZADA, VENCIDA';
COMMENT ON COLUMN HNEACOSTA1/DPMST.usuario_creacion      IS 'Usuario que registro la declaracion patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN HNEACOSTA1/DPMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DPMST.observaciones         IS 'Notas del analista sobre la declaracion patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/DPMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DPMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DPMST (
    id_cliente            TEXT IS 'ID Cliente',
    secuencia             TEXT IS 'Secuencia Declaracion',
    fecha_propuesta       TEXT IS 'Fecha Declaracion',
    monto_solicitado      TEXT IS 'Monto Solicitado',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Propuesta',
    dictamen_credito      TEXT IS 'Dictamen Credito',
    estado_propuesta      TEXT IS 'Estado Declaracion',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_DPMST_C ON HNEACOSTA1/DPMST (created_at);
