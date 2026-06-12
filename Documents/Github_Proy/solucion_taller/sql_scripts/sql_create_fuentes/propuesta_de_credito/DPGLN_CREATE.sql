-- ==============================================================================
-- Nombre de la Tabla  : DPGLN
-- DESCRIPCION         : Plan de Cuentas de los Clientes. Catalogo de cuentas
--                       contables utilizado por los clientes en sus
--                       declaraciones patrimoniales.
-- Objetivo            : Mantener el catalogo de cuentas contables de referencia
--                       para la codificacion de las declaraciones patrimoniales
--                       de personas juridicas.
-- Tipo de Tabla       : Catalogo / Maestro de Referencia
-- Origen de los Datos : Configuracion por administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Módulo de Propuesta de Crédito - referencia para IFDTL
-- Restricciones       : PK (tipo_balance, codigo_cuenta); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DPGLN (
    tipo_balance          FOR COLUMN TIPBAL   VARCHAR(20)    NOT NULL,
    codigo_cuenta         FOR COLUMN CODCTA   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_DPGLN  PRIMARY KEY (tipo_balance, codigo_cuenta)
)
RCDFMT DPGLNR;

RENAME TABLE HNEACOSTA1/DPGLN
    TO DPGLN FOR SYSTEM NAME DPGLN;

COMMENT ON TABLE HNEACOSTA1/DPGLN IS
    'Plan de Cuentas de Clientes para Declaracion Patrimonial - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/DPGLN IS
    'Plan de Cuentas Clientes';

COMMENT ON COLUMN HNEACOSTA1/DPGLN.tipo_balance          IS 'Tipo de balance o estado financiero al que pertenece la cuenta';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.codigo_cuenta         IS 'Codigo unico de la cuenta dentro del plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.fecha_propuesta       IS 'Fecha de vigencia o incorporacion de la cuenta al plan';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.monto_solicitado      IS 'Monto referencial o limite asociado a la cuenta si aplica';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.plazo_meses           IS 'Plazo referencial en meses si la cuenta tiene vencimiento';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.tasa_propuesta        IS 'Tasa de referencia asociada a la cuenta contable';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.dictamen_credito      IS 'Descripcion o clasificacion de la cuenta en el plan';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.estado_propuesta      IS 'Estado de la cuenta en el plan: VIGENTE, DEPRECADA';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.usuario_creacion      IS 'Usuario que registro la cuenta en el plan';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion a la cuenta';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.observaciones         IS 'Notas adicionales sobre la cuenta del plan';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DPGLN.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DPGLN (
    tipo_balance          TEXT IS 'Tipo de Balance',
    codigo_cuenta         TEXT IS 'Codigo de Cuenta',
    fecha_propuesta       TEXT IS 'Fecha Vigencia',
    monto_solicitado      TEXT IS 'Monto Referencial',
    plazo_meses           TEXT IS 'Plazo Referencial Meses',
    tasa_propuesta        TEXT IS 'Tasa Referencial',
    dictamen_credito      TEXT IS 'Descripcion Cuenta',
    estado_propuesta      TEXT IS 'Estado Cuenta',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_DPGLN_C ON HNEACOSTA1/DPGLN (created_at);
