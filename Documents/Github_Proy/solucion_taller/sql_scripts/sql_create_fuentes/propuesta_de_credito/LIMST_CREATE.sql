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
-- Uso de los datos    : Módulo de Propuesta de Crédito - expediente legal PJ
-- Restricciones       : PK (id_cliente) unico; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LIMST (
    id_cliente            FOR COLUMN IDCLI    VARCHAR(30)    NOT NULL,
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
    CONSTRAINT PK_LIMST  PRIMARY KEY (id_cliente)
)
RCDFMT LIMSTR;

RENAME TABLE HNEACOSTA1/LIMST
    TO LIMST FOR SYSTEM NAME LIMST;

COMMENT ON TABLE HNEACOSTA1/LIMST IS
    'Cabecera Declaracion Legal Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/LIMST IS
    'Declaracion Legal PJ';

COMMENT ON COLUMN HNEACOSTA1/LIMST.id_cliente            IS 'Identificacion unica del cliente persona juridica';
COMMENT ON COLUMN HNEACOSTA1/LIMST.fecha_propuesta       IS 'Fecha de presentacion de la declaracion legal';
COMMENT ON COLUMN HNEACOSTA1/LIMST.monto_solicitado      IS 'Monto de credito solicitado vinculado a esta declaracion legal';
COMMENT ON COLUMN HNEACOSTA1/LIMST.plazo_meses           IS 'Plazo en meses de la solicitud de credito vinculada';
COMMENT ON COLUMN HNEACOSTA1/LIMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud';
COMMENT ON COLUMN HNEACOSTA1/LIMST.dictamen_credito      IS 'Resultado del analisis legal del cliente';
COMMENT ON COLUMN HNEACOSTA1/LIMST.estado_propuesta      IS 'Estado de la declaracion legal: COMPLETA, PENDIENTE, VENCIDA';
COMMENT ON COLUMN HNEACOSTA1/LIMST.usuario_creacion      IS 'Usuario que registro la declaracion legal';
COMMENT ON COLUMN HNEACOSTA1/LIMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al registro';
COMMENT ON COLUMN HNEACOSTA1/LIMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LIMST.observaciones         IS 'Notas del analista legal sobre el cliente';
COMMENT ON COLUMN HNEACOSTA1/LIMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/LIMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/LIMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LIMST (
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

CREATE INDEX HNEACOSTA1/IDX_LIMST_C ON HNEACOSTA1/LIMST (created_at);
