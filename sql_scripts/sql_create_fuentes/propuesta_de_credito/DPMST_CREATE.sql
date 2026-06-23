-- ==============================================================================
-- Nombre de la Tabla  : DPMST
-- DESCRIPCION         : Cabecera de la Declaracion Patrimonial de Personas
--                       Naturales. Almacena el encabezado de la declaracion
--                       financiera personal presentada por el cliente.
-- Objetivo            : Registrar la informacion resumen del patrimonio de
--                       personas naturales como parte del analisis de credito.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso manual por analista de credito o cliente
-- Permanencia de Datos: Permanente con historico por secuencia
-- Uso de los datos    : Modulo de Propuesta de Credito - analisis patrimonial
-- Restricciones       : PK compuesta (id_cliente, secuencia); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE DPMST (
    id_cliente            FOR COLUMN DPMSTCLI  VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN DPMSTSEQ  INT            NOT NULL,
    fecha_propuesta       FOR COLUMN DPMSTFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN DPMSTMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN DPMSTPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN DPMSTTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN DPMSTDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN DPMSTEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN DPMSTUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN DPMSTUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN DPMSTVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN DPMSTOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN DPMSTERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN DPMSTCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN DPMSTUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DPMST PRIMARY KEY (id_cliente, secuencia)
)
RCDFMT DPMSTR;

RENAME TABLE DPMST
    TO DPMST_TABLE FOR SYSTEM NAME DPMST;

COMMENT ON TABLE DPMST IS
    'Cabecera Declaracion Patrimonial Personas Naturales - Modulo 13 Taller IBM i';

LABEL ON TABLE DPMST IS
    'Declaracion Patrimonial PN';

COMMENT ON COLUMN DPMST.id_cliente            IS 'Identificacion unica del cliente persona natural';
COMMENT ON COLUMN DPMST.secuencia             IS 'Numero de secuencia de la declaracion patrimonial del cliente';
COMMENT ON COLUMN DPMST.fecha_propuesta       IS 'Fecha de presentacion de la declaracion patrimonial';
COMMENT ON COLUMN DPMST.monto_solicitado      IS 'Monto de credito solicitado en base a esta declaracion';
COMMENT ON COLUMN DPMST.plazo_meses           IS 'Plazo en meses vinculado a la solicitud de credito';
COMMENT ON COLUMN DPMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud';
COMMENT ON COLUMN DPMST.dictamen_credito      IS 'Dictamen del analista sobre la declaracion patrimonial';
COMMENT ON COLUMN DPMST.estado_propuesta      IS 'Estado de la declaracion: VIGENTE, ACTUALIZADA, VENCIDA';
COMMENT ON COLUMN DPMST.usuario_creacion      IS 'Usuario que registro la declaracion patrimonial';
COMMENT ON COLUMN DPMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN DPMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN DPMST.observaciones         IS 'Notas del analista sobre la declaracion patrimonial';
COMMENT ON COLUMN DPMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN DPMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN DPMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN DPMST (
    id_cliente            IS 'ID Cliente',
    secuencia             IS 'Secuencia',
    fecha_propuesta       IS 'Fec Declarac',
    monto_solicitado      IS 'Monto Solic',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Prop',
    dictamen_credito      IS 'Dictamen',
    estado_propuesta      IS 'Estado Declar',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN DPMST (
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

CREATE INDEX IDX_DPMST_C ON DPMST (created_at);
