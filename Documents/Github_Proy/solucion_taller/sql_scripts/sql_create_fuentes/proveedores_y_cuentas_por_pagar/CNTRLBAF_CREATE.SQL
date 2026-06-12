-- ================================================================
-- Nombre de la Tabla  : CNTRLBAF
-- DESCRIPCION         : Control de Cuentas por Pagar - Seccion Comisiones
-- Objetivo            : Almacenar los parametros de configuracion para
--                       el calculo y retencion de comisiones en el modulo
--                       de cuentas por pagar, incluyendo tasas, limites
--                       y cuentas contables por banco y moneda.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion inicial del modulo por el area
--                       de sistemas y contabilidad
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Calculo automatico de comisiones al procesar
--                       cuentas por pagar en el modulo
-- Restricciones       : PK compuesta por banco y moneda;
--                       tabla parametrica sin FK intramodulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLBAF (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CNTBFBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN CNTBFMON,
    descripcion              VARCHAR(120)                FOR COLUMN CNTBFDSC,
    porcentaje_comision_cxp  DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTBFPCX,
    cuenta_comision          VARCHAR(24)                 FOR COLUMN CNTBFCCO,
    cuenta_proveedor_defecto VARCHAR(24)                 FOR COLUMN CNTBFCPD,
    monto_minimo_comision    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTBFMMI,
    monto_maximo_comision    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTBFMMA,
    aplica_iva_comision      CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN CNTBFAIV,
    porcentaje_iva           DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTBFPIV,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN CNTBFNID,
    razon_social             VARCHAR(80)                 FOR COLUMN CNTBFRS,
    email                    VARCHAR(80)                 FOR COLUMN CNTBFEM,
    telefono                 VARCHAR(80)                 FOR COLUMN CNTBFTLF,
    monto_original           DECIMAL(18,2)               FOR COLUMN CNTBFMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN CNTBFSPD,
    fecha_emision            DATE                        FOR COLUMN CNTBFFE,
    fecha_vencimiento        DATE                        FOR COLUMN CNTBFFV,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN CNTBFEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CNTBFUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CNTBFUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNTBFVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CNTBFOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CNTBFERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTBFCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTBFUAT,
    CONSTRAINT PK_CNTRLBAF PRIMARY KEY (codigo_banco, codigo_moneda)
)
RCDFMT CNTBFR;

RENAME TABLE HNEACOSTA1/CNTRLBAF
    TO CNTRLBAF FOR SYSTEM NAME CNTRLBAF;

COMMENT ON TABLE HNEACOSTA1/CNTRLBAF IS
    'Control CxP - Parametros de Comisiones por Banco y Moneda - Modulo 11';

LABEL ON TABLE HNEACOSTA1/CNTRLBAF
    IS 'Control CxP Comisiones';

COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de comisiones de CxP';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.codigo_moneda IS
    'Codigo ISO de la moneda a la que aplican estos parametros de comisiones';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.descripcion IS
    'Descripcion de la configuracion de comisiones para identificacion operativa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.porcentaje_comision_cxp IS
    'Porcentaje de comision aplicado sobre el monto de cuentas por pagar';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.cuenta_comision IS
    'Cuenta contable donde se registra el gasto por comisiones de CxP';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.cuenta_proveedor_defecto IS
    'Cuenta contable por defecto para proveedores sin asignacion especifica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.monto_minimo_comision IS
    'Monto minimo de comision cobrado aunque el porcentaje resulte menor';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.monto_maximo_comision IS
    'Monto maximo de comision cobrado aunque el porcentaje resulte mayor';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.aplica_iva_comision IS
    'Indica si sobre la comision se calcula IVA: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.porcentaje_iva IS
    'Porcentaje de IVA aplicable sobre el monto de comision cuando corresponde';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.numero_identificacion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.razon_social IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.email IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.telefono IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.monto_original IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.saldo_pendiente IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.fecha_emision IS
    'Fecha de alta de la configuracion de comisiones en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.fecha_vencimiento IS
    'Fecha de vigencia de los parametros de comision si aplica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.estado_cxp IS
    'Estado de la configuracion: ACTIVA, INACTIVA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.usuario_creacion IS
    'Usuario administrador que registro la configuracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.observaciones IS
    'Notas sobre la configuracion de comisiones o condiciones especiales';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLBAF (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    descripcion              TEXT IS 'Descripcion',
    porcentaje_comision_cxp  TEXT IS 'Porc Comis',
    cuenta_comision          TEXT IS 'Cta Comision',
    cuenta_proveedor_defecto TEXT IS 'Cta Prov Def',
    monto_minimo_comision    TEXT IS 'Mto Min',
    monto_maximo_comision    TEXT IS 'Mto Max',
    aplica_iva_comision      TEXT IS 'Apl IVA',
    porcentaje_iva           TEXT IS 'Porc IVA',
    numero_identificacion    TEXT IS 'No. Identif',
    razon_social             TEXT IS 'Razon Social',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_cxp               TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTBFCAT ON HNEACOSTA1/CNTRLBAF (created_at);