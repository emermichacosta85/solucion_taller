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
-- Uso de los datos    : Modulo de Propuesta de Credito - referencia para IFDTL
-- Restricciones       : PK (tipo_balance, codigo_cuenta); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE DPGLN (
    tipo_balance          FOR COLUMN DPGLNTBA  VARCHAR(20)    NOT NULL,
    codigo_cuenta         FOR COLUMN DPGLNCCT  VARCHAR(20)    NOT NULL,
    fecha_propuesta       FOR COLUMN DPGLNFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN DPGLNMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN DPGLNPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN DPGLNTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN DPGLNDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN DPGLNEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN DPGLNUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN DPGLNUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN DPGLNVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN DPGLNOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN DPGLNERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN DPGLNCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN DPGLNUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DPGLN PRIMARY KEY (tipo_balance, codigo_cuenta)
)
RCDFMT DPGLNR;

RENAME TABLE DPGLN
    TO DPGLN_TABLE FOR SYSTEM NAME DPGLN;

COMMENT ON TABLE DPGLN IS
    'Plan de Cuentas de Clientes para Declaracion Patrimonial - Modulo 13 Taller IBM i';

LABEL ON TABLE DPGLN IS
    'Plan de Cuentas Clientes';

COMMENT ON COLUMN DPGLN.tipo_balance          IS 'Tipo de balance o estado financiero al que pertenece la cuenta';
COMMENT ON COLUMN DPGLN.codigo_cuenta         IS 'Codigo unico de la cuenta dentro del plan de cuentas';
COMMENT ON COLUMN DPGLN.fecha_propuesta       IS 'Fecha de vigencia o incorporacion de la cuenta al plan';
COMMENT ON COLUMN DPGLN.monto_solicitado      IS 'Monto referencial o limite asociado a la cuenta si aplica';
COMMENT ON COLUMN DPGLN.plazo_meses           IS 'Plazo referencial en meses si la cuenta tiene vencimiento';
COMMENT ON COLUMN DPGLN.tasa_propuesta        IS 'Tasa de referencia asociada a la cuenta contable';
COMMENT ON COLUMN DPGLN.dictamen_credito      IS 'Descripcion o clasificacion de la cuenta en el plan';
COMMENT ON COLUMN DPGLN.estado_propuesta      IS 'Estado de la cuenta en el plan: VIGENTE, DEPRECADA';
COMMENT ON COLUMN DPGLN.usuario_creacion      IS 'Usuario que registro la cuenta en el plan';
COMMENT ON COLUMN DPGLN.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion a la cuenta';
COMMENT ON COLUMN DPGLN.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN DPGLN.observaciones         IS 'Notas adicionales sobre la cuenta del plan';
COMMENT ON COLUMN DPGLN.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN DPGLN.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN DPGLN.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN DPGLN (
    tipo_balance          IS 'Tipo Balance',
    codigo_cuenta         IS 'Cod Cuenta',
    fecha_propuesta       IS 'Fec Vigencia',
    monto_solicitado      IS 'Monto Ref',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Ref',
    dictamen_credito      IS 'Desc Cuenta',
    estado_propuesta      IS 'Estado Cuenta',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN DPGLN (
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

CREATE INDEX IDX_DPGLN_C ON DPGLN (created_at);
