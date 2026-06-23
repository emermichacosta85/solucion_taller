-- ==============================================================================
-- Nombre de la Tabla  : IFMST
-- DESCRIPCION         : Cabecera de Declaracion Patrimonial de Personas
--                       Juridicas. Encabezado del estado financiero de
--                       empresas por anio, mes y formato de balance.
-- Objetivo            : Almacenar la cabecera de los estados financieros de
--                       personas juridicas para el analisis de capacidad de
--                       pago y evaluacion crediticia.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por analista de credito corporativo
-- Permanencia de Datos: Permanente; historial por anio/mes
-- Uso de los datos    : Modulo de Propuesta de Credito - evaluacion empresarial
-- Restricciones       : PK (id_cliente, anio, mes, formato_balance); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE IFMST (
    id_cliente            FOR COLUMN IFMSTCLI  VARCHAR(30)    NOT NULL,
    anio                  FOR COLUMN IFMSTANO  INT            NOT NULL,
    mes                   FOR COLUMN IFMSTMES  INT            NOT NULL,
    formato_balance       FOR COLUMN IFMSTFBA  VARCHAR(50)    NOT NULL,
    fecha_propuesta       FOR COLUMN IFMSTFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN IFMSTMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN IFMSTPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN IFMSTTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN IFMSTDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN IFMSTEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN IFMSTUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN IFMSTUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN IFMSTVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN IFMSTOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN IFMSTERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN IFMSTCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN IFMSTUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_IFMST PRIMARY KEY (id_cliente, anio, mes, formato_balance)
)
RCDFMT IFMSTR;

RENAME TABLE IFMST
    TO IFMST_TABLE FOR SYSTEM NAME IFMST;

COMMENT ON TABLE IFMST IS
    'Cabecera Declaracion Patrimonial Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE IFMST IS
    'Declaracion Patrimonial PJ';

COMMENT ON COLUMN IFMST.id_cliente            IS 'Identificacion unica del cliente persona juridica';
COMMENT ON COLUMN IFMST.anio                  IS 'Anio fiscal al que corresponde el estado financiero';
COMMENT ON COLUMN IFMST.mes                   IS 'Mes al que corresponde el estado financiero (1-12)';
COMMENT ON COLUMN IFMST.formato_balance       IS 'Formato o plantilla del balance utilizado (GAAP, NIIF, etc.)';
COMMENT ON COLUMN IFMST.fecha_propuesta       IS 'Fecha de presentacion del estado financiero';
COMMENT ON COLUMN IFMST.monto_solicitado      IS 'Monto de credito solicitado vinculado a este estado financiero';
COMMENT ON COLUMN IFMST.plazo_meses           IS 'Plazo en meses de la solicitud vinculada';
COMMENT ON COLUMN IFMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud vinculada';
COMMENT ON COLUMN IFMST.dictamen_credito      IS 'Dictamen del analista sobre el estado financiero presentado';
COMMENT ON COLUMN IFMST.estado_propuesta      IS 'Estado del estado financiero: VIGENTE, AUDITADO, PROVISIONAL';
COMMENT ON COLUMN IFMST.usuario_creacion      IS 'Usuario que registro el estado financiero';
COMMENT ON COLUMN IFMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN IFMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN IFMST.observaciones         IS 'Notas del analista sobre el estado financiero';
COMMENT ON COLUMN IFMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN IFMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN IFMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN IFMST (
    id_cliente            IS 'ID Cliente',
    anio                  IS 'Anio Fiscal',
    mes                   IS 'Mes',
    formato_balance       IS 'Formato Bal',
    fecha_propuesta       IS 'Fec Edo Fin',
    monto_solicitado      IS 'Monto Solic',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Prop',
    dictamen_credito      IS 'Dictamen',
    estado_propuesta      IS 'Estado EF',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN IFMST (
    id_cliente            TEXT IS 'ID Cliente',
    anio                  TEXT IS 'Anio Fiscal',
    mes                   TEXT IS 'Mes',
    formato_balance       TEXT IS 'Formato de Balance',
    fecha_propuesta       TEXT IS 'Fecha Estado Financiero',
    monto_solicitado      TEXT IS 'Monto Solicitado',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Propuesta',
    dictamen_credito      TEXT IS 'Dictamen Credito',
    estado_propuesta      TEXT IS 'Estado Estado Financiero',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_IFMST_C ON IFMST (created_at);
