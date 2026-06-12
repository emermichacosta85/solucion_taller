-- ==============================================================================
-- Nombre de la Tabla  : IFMST
-- DESCRIPCION         : Cabecera de Declaracion Patrimonial de Personas
--                       Juridicas. Encabezado del estado financiero de
--                       empresas por año, mes y formato de balance.
-- Objetivo            : Almacenar la cabecera de los estados financieros de
--                       personas juridicas para el analisis de capacidad de
--                       pago y evaluacion crediticia.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por analista de credito corporativo
-- Permanencia de Datos: Permanente; historial por año/mes
-- Uso de los datos    : Módulo de Propuesta de Crédito - evaluacion empresarial
-- Restricciones       : PK (id_cliente, anio, mes, formato_balance); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/IFMST (
    id_cliente            FOR COLUMN IDCLI    VARCHAR(30)    NOT NULL,
    anio                  FOR COLUMN ANIO     INTEGER        NOT NULL,
    mes                   FOR COLUMN MES      INTEGER        NOT NULL,
    formato_balance       FOR COLUMN FMTBAL   VARCHAR(50)    NOT NULL,
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
    CONSTRAINT PK_IFMST  PRIMARY KEY (id_cliente, anio, mes, formato_balance)
)
RCDFMT IFMSTR;

RENAME TABLE HNEACOSTA1/IFMST
    TO IFMST FOR SYSTEM NAME IFMST;

COMMENT ON TABLE HNEACOSTA1/IFMST IS
    'Cabecera Declaracion Patrimonial Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/IFMST IS
    'Declaracion Patrimonial PJ';

COMMENT ON COLUMN HNEACOSTA1/IFMST.id_cliente            IS 'Identificacion unica del cliente persona juridica';
COMMENT ON COLUMN HNEACOSTA1/IFMST.anio                  IS 'Año fiscal al que corresponde el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFMST.mes                   IS 'Mes al que corresponde el estado financiero (1-12)';
COMMENT ON COLUMN HNEACOSTA1/IFMST.formato_balance       IS 'Formato o plantilla del balance utilizado (GAAP, NIIF, etc.)';
COMMENT ON COLUMN HNEACOSTA1/IFMST.fecha_propuesta       IS 'Fecha de presentacion del estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFMST.monto_solicitado      IS 'Monto de credito solicitado vinculado a este estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFMST.plazo_meses           IS 'Plazo en meses de la solicitud vinculada';
COMMENT ON COLUMN HNEACOSTA1/IFMST.tasa_propuesta        IS 'Tasa de interes propuesta para la solicitud vinculada';
COMMENT ON COLUMN HNEACOSTA1/IFMST.dictamen_credito      IS 'Dictamen del analista sobre el estado financiero presentado';
COMMENT ON COLUMN HNEACOSTA1/IFMST.estado_propuesta      IS 'Estado del estado financiero: VIGENTE, AUDITADO, PROVISIONAL';
COMMENT ON COLUMN HNEACOSTA1/IFMST.usuario_creacion      IS 'Usuario que registro el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFMST.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/IFMST.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/IFMST.observaciones         IS 'Notas del analista sobre el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFMST.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/IFMST.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/IFMST.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/IFMST (
    id_cliente            TEXT IS 'ID Cliente',
    anio                  TEXT IS 'Año Fiscal',
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

CREATE INDEX HNEACOSTA1/IDX_IFMST_C ON HNEACOSTA1/IFMST (created_at);
