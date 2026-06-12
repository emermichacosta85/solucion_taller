-- ================================================================
-- Nombre de la Tabla  : BAPRC
-- DESCRIPCION         : Maestro de Cuentas por Pagar
-- Objetivo            : Registrar cada obligacion de pago del banco
--                       hacia proveedores y clientes, con el detalle
--                       de origen, monto, vencimiento y estado de pago,
--                       siendo la entidad central del modulo desde la
--                       que se generan amortizaciones, historico y
--                       transacciones contables.
-- Tipo de Tabla       : Maestra / Transaccional
-- Origen de los Datos : Recepcion de facturas, liquidaciones y
--                       obligaciones generadas por otros modulos
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Control de pagos, vencimientos, conciliacion
--                       y generacion de asientos contables
-- Restricciones       : FK hacia BAVEN por numero_proveedor;
--                       FK hacia CUMST por id_cliente
--                       (segun ERD: BAVEN ||--o{ BAPRC)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BAPRC (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCSUC,
    origen_cuenta            VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCORG,
    tipo_cuenta              VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCTCU,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN BAPRCCLI,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN BAPRCREF,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCTGR,
    numero_proveedor         VARCHAR(30)                 FOR COLUMN BAPRCPRO,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN BAPRCNID,
    razon_social             VARCHAR(80)                 FOR COLUMN BAPRCRS,
    email                    VARCHAR(80)                 FOR COLUMN BAPRCEM,
    telefono                 VARCHAR(80)                 FOR COLUMN BAPRCTLF,
    numero_factura           VARCHAR(50)                 FOR COLUMN BAPRCNFA,
    fecha_factura            DATE                        FOR COLUMN BAPRCFFA,
    concepto_pago            VARCHAR(120)                FOR COLUMN BAPRCCPG,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN BAPRCMON,
    monto_original           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCMOR,
    monto_retencion_iva      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCMIV,
    monto_retencion_isr      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCMIS,
    monto_descuento          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCDSC,
    monto_neto               DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCMNE,
    saldo_pendiente          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAPRCSPD,
    fecha_emision            DATE                        FOR COLUMN BAPRCFE,
    fecha_vencimiento        DATE                        FOR COLUMN BAPRCFV,
    fecha_pago               DATE                        FOR COLUMN BAPRCFP,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN BAPRCEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BAPRCULC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BAPRCUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAPRCVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BAPRCOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BAPRCERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAPRCCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAPRCUAT,
    CONSTRAINT PK_BAPRC PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     origen_cuenta, tipo_cuenta,
                                     id_cliente, numero_referencia,
                                     tipo_registro),
    CONSTRAINT FK_BAPRC_BAVEN FOREIGN KEY (numero_proveedor)
        REFERENCES HNEACOSTA1/BAVEN (numero_proveedor),
    CONSTRAINT FK_BAPRC_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente)
)
RCDFMT BAPRCR;

RENAME TABLE HNEACOSTA1/BAPRC
    TO BAPRC FOR SYSTEM NAME BAPRC;

COMMENT ON TABLE HNEACOSTA1/BAPRC IS
    'Maestro de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE HNEACOSTA1/BAPRC
    IS 'Maestro Cuentas x Pagar';

COMMENT ON COLUMN HNEACOSTA1/BAPRC.codigo_banco IS
    'Codigo del banco que registra y administra la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.codigo_sucursal IS
    'Codigo de la sucursal responsable de la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.origen_cuenta IS
    'Origen que genero la cuenta por pagar: FACTURA, CONTRATO, NOMINA, OTRO';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.tipo_cuenta IS
    'Clasificacion de la cuenta por pagar: PROVEEDOR, CLIENTE, INTERNO, FISCAL';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.id_cliente IS
    'Identificador del cliente o contraparte de la obligacion (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.numero_referencia IS
    'Numero de referencia unico de la cuenta por pagar en el banco';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.tipo_registro IS
    'Tipo de registro dentro de la cuenta: CABECERA, DETALLE, AJUSTE';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.numero_proveedor IS
    'Numero del proveedor al que corresponde la cuenta por pagar (FK BAVEN)';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.numero_identificacion IS
    'Numero de identificacion fiscal del beneficiario del pago';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.razon_social IS
    'Nombre o razon social del beneficiario del pago';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.email IS
    'Correo electronico del beneficiario para notificaciones de pago';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.telefono IS
    'Telefono del beneficiario para contacto sobre la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.numero_factura IS
    'Numero de factura o documento comercial que origina la obligacion';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.fecha_factura IS
    'Fecha de emision de la factura o documento que origina la obligacion';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.concepto_pago IS
    'Descripcion del concepto o servicio que origina la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.monto_original IS
    'Monto bruto de la cuenta por pagar antes de retenciones y descuentos';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.monto_retencion_iva IS
    'Monto de retencion de IVA aplicada sobre la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.monto_retencion_isr IS
    'Monto de retencion de ISR o impuesto sobre la renta aplicada';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.monto_descuento IS
    'Monto de descuento por pronto pago u otras condiciones pactadas';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.monto_neto IS
    'Monto neto a pagar despues de retenciones y descuentos aplicados';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.saldo_pendiente IS
    'Saldo aun pendiente de pago de la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.fecha_emision IS
    'Fecha de registro o emision de la cuenta por pagar en el sistema';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.fecha_vencimiento IS
    'Fecha limite para el pago de la cuenta segun condiciones pactadas';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.fecha_pago IS
    'Fecha en que fue efectivamente pagada la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.estado_cxp IS
    'Estado de la cuenta: PENDIENTE, PARCIAL, PAGADA, VENCIDA, ANULADA';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.usuario_creacion IS
    'Usuario del sistema que registro la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.observaciones IS
    'Notas sobre la cuenta, condiciones de pago o historial de gestion';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BAPRC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BAPRC (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    origen_cuenta            TEXT IS 'Origen',
    tipo_cuenta              TEXT IS 'Tipo Cta',
    id_cliente               TEXT IS 'ID Cliente',
    numero_referencia        TEXT IS 'No. Referenc',
    tipo_registro            TEXT IS 'Tipo Reg',
    numero_proveedor         TEXT IS 'No. Proveedor',
    numero_identificacion    TEXT IS 'No. Identif',
    razon_social             TEXT IS 'Razon Social',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    numero_factura           TEXT IS 'No. Factura',
    fecha_factura            TEXT IS 'Fec Factura',
    concepto_pago            TEXT IS 'Concepto',
    codigo_moneda            TEXT IS 'Moneda',
    monto_original           TEXT IS 'Monto Orig',
    monto_retencion_iva      TEXT IS 'Ret IVA',
    monto_retencion_isr      TEXT IS 'Ret ISR',
    monto_descuento          TEXT IS 'Descuento',
    monto_neto               TEXT IS 'Monto Neto',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    fecha_pago               TEXT IS 'Fec Pago',
    estado_cxp               TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IBAPRCPRO ON HNEACOSTA1/BAPRC (numero_proveedor);
CREATE INDEX HNEACOSTA1/IBAPRCCLI ON HNEACOSTA1/BAPRC (id_cliente);
CREATE INDEX HNEACOSTA1/IBAPRCFV  ON HNEACOSTA1/BAPRC (fecha_vencimiento);
CREATE INDEX HNEACOSTA1/IBAPRCEST ON HNEACOSTA1/BAPRC (estado_cxp);
CREATE INDEX HNEACOSTA1/IBAPRCCAT ON HNEACOSTA1/BAPRC (created_at);
