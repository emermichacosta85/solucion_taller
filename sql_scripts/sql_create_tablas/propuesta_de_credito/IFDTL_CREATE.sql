-- ==============================================================================
-- Nombre de la Tabla  : IFDTL
-- DESCRIPCION         : Detalle de Declaracion Patrimonial de Personas
--                       Juridicas. Contiene cada linea del estado financiero
--                       por codigo de cuenta contable.
-- Objetivo            : Registrar el detalle contable linea a linea del
--                       estado financiero de personas juridicas para analisis
--                       crediticio.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso manual o carga desde sistema contable
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo de Propuesta de Credito - analisis financiero PJ
-- Restricciones       : FK a IFMST(id_cliente,anio,mes,formato_balance); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE IFDTL (
    id_cliente            FOR COLUMN IFDTLCLI  VARCHAR(30)    NOT NULL,
    anio                  FOR COLUMN IFDTLANO  INT            NOT NULL,
    mes                   FOR COLUMN IFDTLMES  INT            NOT NULL,
    formato_balance       FOR COLUMN IFDTLFBA  VARCHAR(50)    NOT NULL,
    codigo_linea          FOR COLUMN IFDTLCLN  VARCHAR(20)    NOT NULL,
    codigo_cuenta         FOR COLUMN IFDTLCCT  VARCHAR(20)    NOT NULL,
    fecha_propuesta       FOR COLUMN IFDTLFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN IFDTLMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN IFDTLPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN IFDTLTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN IFDTLDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN IFDTLEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN IFDTLUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN IFDTLUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN IFDTLVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN IFDTLOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN IFDTLERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN IFDTLCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN IFDTLUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_IFDTL PRIMARY KEY (id_cliente, anio, mes, formato_balance, codigo_linea, codigo_cuenta)
    --CONSTRAINT FK_IFDTL_IFMST FOREIGN KEY (id_cliente, anio, mes, formato_balance)
    --    REFERENCES IFMST (id_cliente, anio, mes, formato_balance)
)
RCDFMT IFDTLR;

RENAME TABLE IFDTL
    TO IFDTL_TABLE FOR SYSTEM NAME IFDTL;

COMMENT ON TABLE IFDTL IS
    'Detalle Declaracion Patrimonial Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE IFDTL IS
    'Detalle Declaracion Patr. PJ';

COMMENT ON COLUMN IFDTL.id_cliente            IS 'Identificacion del cliente PJ - parte de FK a IFMST';
COMMENT ON COLUMN IFDTL.anio                  IS 'Anio fiscal - parte de FK a IFMST';
COMMENT ON COLUMN IFDTL.mes                   IS 'Mes del estado financiero - parte de FK a IFMST';
COMMENT ON COLUMN IFDTL.formato_balance       IS 'Formato de balance - parte de FK a IFMST';
COMMENT ON COLUMN IFDTL.codigo_linea          IS 'Codigo de la linea dentro del estado financiero (seccion)';
COMMENT ON COLUMN IFDTL.codigo_cuenta         IS 'Codigo de cuenta contable del plan de cuentas del cliente';
COMMENT ON COLUMN IFDTL.fecha_propuesta       IS 'Fecha de registro de esta linea del estado financiero';
COMMENT ON COLUMN IFDTL.monto_solicitado      IS 'Valor monetario de la cuenta contable en el periodo';
COMMENT ON COLUMN IFDTL.plazo_meses           IS 'Plazo en meses si la cuenta tiene vencimiento';
COMMENT ON COLUMN IFDTL.tasa_propuesta        IS 'Tasa de interes o costo asociado a la cuenta';
COMMENT ON COLUMN IFDTL.dictamen_credito      IS 'Observacion del analista sobre esta linea contable';
COMMENT ON COLUMN IFDTL.estado_propuesta      IS 'Estado de la linea: CONFIRMADA, ESTIMADA, AJUSTADA';
COMMENT ON COLUMN IFDTL.usuario_creacion      IS 'Usuario que registro la linea contable';
COMMENT ON COLUMN IFDTL.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN IFDTL.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN IFDTL.observaciones         IS 'Notas adicionales sobre la linea contable';
COMMENT ON COLUMN IFDTL.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN IFDTL.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN IFDTL.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN IFDTL (
    id_cliente            IS 'ID Cliente',
    anio                  IS 'Anio Fiscal',
    mes                   IS 'Mes',
    formato_balance       IS 'Formato Bal',
    codigo_linea          IS 'Cod Linea',
    codigo_cuenta         IS 'Cod Cuenta',
    fecha_propuesta       IS 'Fec Linea',
    monto_solicitado      IS 'Valor Cuenta',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Ref',
    dictamen_credito      IS 'Obs Analista',
    estado_propuesta      IS 'Estado Linea',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN IFDTL (
    id_cliente            TEXT IS 'ID Cliente',
    anio                  TEXT IS 'Anio Fiscal',
    mes                   TEXT IS 'Mes',
    formato_balance       TEXT IS 'Formato de Balance',
    codigo_linea          TEXT IS 'Codigo de Linea',
    codigo_cuenta         TEXT IS 'Codigo de Cuenta',
    fecha_propuesta       TEXT IS 'Fecha Linea Contable',
    monto_solicitado      TEXT IS 'Valor Cuenta',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Referencia',
    dictamen_credito      TEXT IS 'Observacion Analista',
    estado_propuesta      TEXT IS 'Estado Linea',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_IFDTL_C ON IFDTL (created_at);
