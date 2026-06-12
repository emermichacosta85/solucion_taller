-- ================================================================
-- Nombre de la Tabla  : CNTRLBAP
-- DESCRIPCION         : Control de Cuentas por Pagar - Otros Parametros
-- Objetivo            : Almacenar los parametros generales adicionales
--                       de configuracion del modulo de cuentas por pagar
--                       por banco y moneda, complementando los parametros
--                       de comisiones de CNTRLBAF con otros aspectos
--                       operativos como numeracion, plazos y politicas.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion del modulo por sistemas y contabilidad
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia en procesos del modulo CxP para
--                       aplicar parametros generales del banco
-- Restricciones       : PK compuesta por banco y moneda;
--                       tabla parametrica sin FK intramodulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLBAP (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CNTBPBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN CNTBPMON,
    descripcion              VARCHAR(120)                FOR COLUMN CNTBPDSC,
    ultimo_numero_cxp        VARCHAR(30)                 FOR COLUMN CNTBPUNCX,
    prefijo_numero_cxp       VARCHAR(10)                 FOR COLUMN CNTBPPNC,
    plazo_pago_defecto_dias  INT            NOT NULL
                                            DEFAULT 30   FOR COLUMN CNTBPPPD,
    dias_alerta_vencimiento  INT            NOT NULL
                                            DEFAULT 5    FOR COLUMN CNTBPDAV,
    cuenta_cxp_defecto       VARCHAR(24)                 FOR COLUMN CNTBPCXD,
    cuenta_anticipo          VARCHAR(24)                 FOR COLUMN CNTBPANT,
    cuenta_retencion_iva     VARCHAR(24)                 FOR COLUMN CNTBPRIV,
    cuenta_retencion_isr     VARCHAR(24)                 FOR COLUMN CNTBPRIS,
    permite_pago_anticipado  CHAR(1)        NOT NULL
                                            DEFAULT 'S'  FOR COLUMN CNTBPPPA,
    requiere_aprobacion      CHAR(1)        NOT NULL
                                            DEFAULT 'S'  FOR COLUMN CNTBPRAP,
    monto_aprobacion_auto    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTBPMAA,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN CNTBPNID,
    razon_social             VARCHAR(80)                 FOR COLUMN CNTBPRS,
    email                    VARCHAR(80)                 FOR COLUMN CNTBPEM,
    telefono                 VARCHAR(80)                 FOR COLUMN CNTBPTLF,
    monto_original           DECIMAL(18,2)               FOR COLUMN CNTBPMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN CNTBPSPD,
    fecha_emision            DATE                        FOR COLUMN CNTBPFE,
    fecha_vencimiento        DATE                        FOR COLUMN CNTBPFV,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN CNTBPEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CNTBPUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CNTBPUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNTBPVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CNTBPOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CNTBPERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTBPCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTBPUAT,
    CONSTRAINT PK_CNTRLBAP PRIMARY KEY (codigo_banco, codigo_moneda)
)
RCDFMT CNTBPR;

RENAME TABLE HNEACOSTA1/CNTRLBAP
    TO CNTRLBAP FOR SYSTEM NAME CNTRLBAP;

COMMENT ON TABLE HNEACOSTA1/CNTRLBAP IS
    'Control CxP - Otros Parametros por Banco y Moneda - Modulo 11';

LABEL ON TABLE HNEACOSTA1/CNTRLBAP
    IS 'Control CxP Parametros';

COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion general de CxP';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.codigo_moneda IS
    'Codigo ISO de la moneda a la que aplican estos parametros generales';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.descripcion IS
    'Descripcion de la configuracion para identificacion operativa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.ultimo_numero_cxp IS
    'Ultimo numero de cuenta por pagar asignado para continuar la numeracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.prefijo_numero_cxp IS
    'Prefijo que se antepone al numero de CxP en la numeracion automatica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.plazo_pago_defecto_dias IS
    'Plazo en dias aplicado por defecto cuando el proveedor no tiene plazo pactado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.dias_alerta_vencimiento IS
    'Numero de dias antes del vencimiento en que se genera alerta de pago';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.cuenta_cxp_defecto IS
    'Cuenta contable por defecto para el registro de las cuentas por pagar';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.cuenta_anticipo IS
    'Cuenta contable para el registro de anticipos a proveedores';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.cuenta_retencion_iva IS
    'Cuenta contable donde se acumula la retencion de IVA de proveedores';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.cuenta_retencion_isr IS
    'Cuenta contable donde se acumula la retencion de ISR de proveedores';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.permite_pago_anticipado IS
    'Indica si el modulo permite pagar cuentas antes de su vencimiento: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.requiere_aprobacion IS
    'Indica si los pagos requieren aprobacion antes de ejecutarse: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.monto_aprobacion_auto IS
    'Monto hasta el cual los pagos se aprueban automaticamente sin flujo de autorizacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.numero_identificacion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.razon_social IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.email IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.telefono IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.monto_original IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.saldo_pendiente IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.fecha_emision IS
    'Fecha de alta de la configuracion de parametros en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.fecha_vencimiento IS
    'Fecha de vigencia de la configuracion si aplica revision periodica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.estado_cxp IS
    'Estado de la configuracion: ACTIVA, INACTIVA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.usuario_creacion IS
    'Usuario administrador que registro la configuracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de los parametros';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.observaciones IS
    'Notas sobre la configuracion o cambios en los parametros del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLBAP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLBAP (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    descripcion              TEXT IS 'Descripcion',
    ultimo_numero_cxp        TEXT IS 'Ult No CxP',
    prefijo_numero_cxp       TEXT IS 'Prefijo CxP',
    plazo_pago_defecto_dias  TEXT IS 'Plazo Defecto',
    dias_alerta_vencimiento  TEXT IS 'Dias Alerta',
    cuenta_cxp_defecto       TEXT IS 'Cta CxP Def',
    cuenta_anticipo          TEXT IS 'Cta Anticipo',
    cuenta_retencion_iva     TEXT IS 'Cta Ret IVA',
    cuenta_retencion_isr     TEXT IS 'Cta Ret ISR',
    permite_pago_anticipado  TEXT IS 'Pago Anticip',
    requiere_aprobacion      TEXT IS 'Req Aprobac',
    monto_aprobacion_auto    TEXT IS 'Mto Auto',
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

CREATE INDEX HNEACOSTA1/ICNTBPCAT ON HNEACOSTA1/CNTRLBAP (created_at);
