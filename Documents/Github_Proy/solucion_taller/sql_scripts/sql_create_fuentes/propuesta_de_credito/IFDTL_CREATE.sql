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
-- Permanencia de Datos: Permanente con histórico
-- Uso de los datos    : Módulo de Propuesta de Crédito - analisis financiero PJ
-- Restricciones       : FK a IFMST(id_cliente,anio,mes,formato_balance); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/IFDTL (
    id_cliente            FOR COLUMN IDCLI    VARCHAR(30)    NOT NULL,
    anio                  FOR COLUMN ANIO     INTEGER        NOT NULL,
    mes                   FOR COLUMN MES      INTEGER        NOT NULL,
    formato_balance       FOR COLUMN FMTBAL   VARCHAR(50)    NOT NULL,
    codigo_linea          FOR COLUMN CODLIN   VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_IFDTL  PRIMARY KEY (id_cliente, anio, mes, formato_balance, codigo_linea, codigo_cuenta),
    CONSTRAINT FK_IFDTL_IFMST FOREIGN KEY (id_cliente, anio, mes, formato_balance)
        REFERENCES HNEACOSTA1/IFMST (id_cliente, anio, mes, formato_balance)
)
RCDFMT IFDTLR;

RENAME TABLE HNEACOSTA1/IFDTL
    TO IFDTL FOR SYSTEM NAME IFDTL;

COMMENT ON TABLE HNEACOSTA1/IFDTL IS
    'Detalle Declaracion Patrimonial Personas Juridicas - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/IFDTL IS
    'Detalle Declaracion Patr. PJ';

COMMENT ON COLUMN HNEACOSTA1/IFDTL.id_cliente            IS 'Identificacion del cliente PJ - parte de FK a IFMST';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.anio                  IS 'Año fiscal - parte de FK a IFMST';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.mes                   IS 'Mes del estado financiero - parte de FK a IFMST';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.formato_balance       IS 'Formato de balance - parte de FK a IFMST';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.codigo_linea          IS 'Codigo de la linea dentro del estado financiero (seccion)';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.codigo_cuenta         IS 'Codigo de cuenta contable del plan de cuentas del cliente';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.fecha_propuesta       IS 'Fecha de registro de esta linea del estado financiero';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.monto_solicitado      IS 'Valor monetario de la cuenta contable en el periodo';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.plazo_meses           IS 'Plazo en meses si la cuenta tiene vencimiento';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.tasa_propuesta        IS 'Tasa de interes o costo asociado a la cuenta';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.dictamen_credito      IS 'Observacion del analista sobre esta linea contable';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.estado_propuesta      IS 'Estado de la linea: CONFIRMADA, ESTIMADA, AJUSTADA';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.usuario_creacion      IS 'Usuario que registro la linea contable';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.observaciones         IS 'Notas adicionales sobre la linea contable';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/IFDTL.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/IFDTL (
    id_cliente            TEXT IS 'ID Cliente',
    anio                  TEXT IS 'Año Fiscal',
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

CREATE INDEX HNEACOSTA1/IDX_IFDTL_C ON HNEACOSTA1/IFDTL (created_at);
