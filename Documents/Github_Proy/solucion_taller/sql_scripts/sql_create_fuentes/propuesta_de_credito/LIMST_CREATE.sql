-- ==============================================================================
-- Nombre de la Tabla  : LIMST
-- DESCRIPCION         : Cabecera de Declaracion Legal de Personas Juridicas.
--                       Registra la informacion legal y estatutaria del
--                       cliente empresa requerida para el analisis de credito.
-- Objetivo            : Almacenar la informacion legal formal de personas
--                       juridicas como parte del expediente de propuesta de
--                       credito.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por oficial de credito corporativo
-- Permanencia de Datos: Permanente; un registro por cliente
-- Uso de los datos    : Modulo de Propuesta de Credito - expediente legal PJ
-- Restricciones       : PK (id_cliente) unico; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE LIMST (
    id_cliente            FOR COLUMN LIMSTCLI  VARCHAR(30)    NOT NULL,
    fecha_propuesta       FOR COLUMN LIMSTFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN LIMSTMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN LIMSTPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN LIMSTTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN LIMSTDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN LIMSTEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN LIMSTUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN LIMSTUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN LIMSTVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN LIMSTOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN LIMSTERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN LIMSTCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN LIMSTUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LIMST PRIMARY KEY (id_cliente)
)
RCDFMT LIMSTR;

RENAME TABLE LIMST
    TO LIMST_TABLE FOR SYSTEM NAME LIMST;

COMMENT ON TABLE LIMST IS
    'Cabecera Declaracion Legal Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE LIMST IS
    'Declaracion Legal PJ';

COMMENT ON COLUMN LIMST.id_cliente            IS 'Identificacion unica del cliente persona juridica';
COMMENT ON COLUMN LIMST.fecha_propuesta       IS 'Fecha de presentacion de la declaracion legal';
COMMENT ON COLUMN LIMST.monto_solicitado      IS 'Monto de credito solicitado vinculado a esta declaracion legal';
COMMENT ON COLUMN LIMST.plazo_meses           IS 'Plazo en meses de la solicitud de credito vinculada';
COMMENT ON COLUMN LIMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud';
COMMENT ON COLUMN LIMST.dictamen_credito      IS 'Resultado del analisis legal del cliente';
COMMENT ON COLUMN LIMST.estado_propuesta      IS 'Estado de la declaracion legal: COMPLETA, PENDIENTE, VENCIDA';
COMMENT ON COLUMN LIMST.usuario_creacion      IS 'Usuario que registro la declaracion legal';
COMMENT ON COLUMN LIMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN LIMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN LIMST.observaciones         IS 'Notas del analista legal sobre el cliente';
COMMENT ON COLUMN LIMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN LIMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN LIMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN LIMST (
    id_cliente            IS 'ID Cliente',
    fecha_propuesta       IS 'Fec Declarac',
    monto_solicitado      IS 'Monto Solic',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Prop',
    dictamen_credito      IS 'Dictamen Leg',
    estado_propuesta      IS 'Estado Declar',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN LIMST (
    id_cliente            TEXT IS 'ID Cliente',
    fecha_propuesta       TEXT IS 'Fecha Declaracion Legal',
    monto_solicitado      TEXT IS 'Monto Solicitado',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Propuesta',
    dictamen_credito      TEXT IS 'Dictamen Legal',
    estado_propuesta      TEXT IS 'Estado Declaracion',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_LIMST_C ON LIMST (created_at);
