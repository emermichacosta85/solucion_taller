-- ================================================================
-- Nombre de la Tabla  : BAMOR
-- DESCRIPCION         : Amortizaciones de Cuentas por Pagar
-- Objetivo            : Registrar el detalle de cada pago parcial o
--                       amortizacion realizada sobre una cuenta por pagar,
--                       permitiendo el seguimiento cronologico de la
--                       cancelacion de obligaciones y la conciliacion
--                       de pagos con los registros bancarios.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Proceso de pago o abono parcial a cuentas por pagar
-- Permanencia de Datos: Historica
-- Uso de los datos    : Conciliacion de pagos, auditoria y reportes
--                       de obligaciones canceladas o en proceso
-- Restricciones       : FK hacia BAPRC por clave compuesta
--                       (segun ERD: BAPRC ||--o{ BAMOR)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BAMOR (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN BAMORBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN BAMORSUC,
    origen_cuenta            VARCHAR(20)    NOT NULL     FOR COLUMN BAMORORG,
    tipo_cuenta              VARCHAR(20)    NOT NULL     FOR COLUMN BAMORTCU,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN BAMORCLI,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN BAMORREF,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN BAMORTGR,
    secuencia_amortizacion   INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAMORSEQ,
    fecha_amortizacion       DATE           NOT NULL     FOR COLUMN BAMORFA,
    tipo_pago                VARCHAR(20)                 FOR COLUMN BAMORTPA,
    numero_documento_pago    VARCHAR(50)                 FOR COLUMN BAMORNDO,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN BAMORMON,
    monto_amortizado         DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAMORMAM,
    monto_descuento_aplicado DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAMORMDSC,
    monto_retencion_aplicada DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAMORMRET,
    saldo_despues_pago       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAMORSDP,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN BAMORNID,
    razon_social             VARCHAR(80)                 FOR COLUMN BAMORRS,
    email                    VARCHAR(80)                 FOR COLUMN BAMOREM,
    telefono                 VARCHAR(80)                 FOR COLUMN BAMORTLF,
    monto_original           DECIMAL(18,2)               FOR COLUMN BAMORMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN BAMORSPD,
    fecha_emision            DATE                        FOR COLUMN BAMORFE,
    fecha_vencimiento        DATE                        FOR COLUMN BAMORFV,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN BAMOREST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BAMORUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BAMORUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAMORVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BAMOROBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BAMORERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAMORCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAMORUAT,
    CONSTRAINT PK_BAMOR PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     origen_cuenta, tipo_cuenta,
                                     id_cliente, numero_referencia,
                                     tipo_registro, secuencia_amortizacion),
    CONSTRAINT FK_BAMOR_BAPRC FOREIGN KEY (codigo_banco, codigo_sucursal,
                                            origen_cuenta, tipo_cuenta,
                                            id_cliente, numero_referencia,
                                            tipo_registro)
        REFERENCES HNEACOSTA1/BAPRC (codigo_banco, codigo_sucursal,
                                    origen_cuenta, tipo_cuenta,
                                    id_cliente, numero_referencia,
                                    tipo_registro)
)
RCDFMT BAMORR;

RENAME TABLE HNEACOSTA1/BAMOR
    TO BAMOR FOR SYSTEM NAME BAMOR;

COMMENT ON TABLE HNEACOSTA1/BAMOR IS
    'Amortizaciones de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE HNEACOSTA1/BAMOR
    IS 'Amortizaciones CxP';

COMMENT ON COLUMN HNEACOSTA1/BAMOR.codigo_banco IS
    'Codigo del banco que registra la amortizacion de la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.codigo_sucursal IS
    'Codigo de la sucursal que proceso el pago o amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.origen_cuenta IS
    'Origen de la cuenta por pagar sobre la que se aplica la amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.tipo_cuenta IS
    'Tipo de la cuenta por pagar amortizada (FK BAPRC)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.id_cliente IS
    'Identificador del cliente o contraparte de la cuenta amortizada (FK BAPRC)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.numero_referencia IS
    'Numero de referencia de la cuenta por pagar que se amortiza (FK BAPRC)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.tipo_registro IS
    'Tipo de registro de la cuenta por pagar padre (FK BAPRC)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.secuencia_amortizacion IS
    'Numero de secuencia del pago parcial dentro de la cuenta por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.fecha_amortizacion IS
    'Fecha en que se proceso el pago o amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.tipo_pago IS
    'Forma en que se realizo el pago: TRANSFERENCIA, CHEQUE, EFECTIVO, ACH';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.numero_documento_pago IS
    'Numero de cheque, transferencia u otro documento de respaldo del pago';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.codigo_moneda IS
    'Codigo ISO de la moneda en que se realizo el pago';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.monto_amortizado IS
    'Monto del pago o abono aplicado a la cuenta por pagar en esta amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.monto_descuento_aplicado IS
    'Descuento por pronto pago u otro concepto aplicado en este pago';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.monto_retencion_aplicada IS
    'Total de retenciones fiscales descontadas en este pago';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.saldo_despues_pago IS
    'Saldo pendiente de la cuenta por pagar despues de aplicar esta amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.numero_identificacion IS
    'Numero de identificacion del beneficiario del pago (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.razon_social IS
    'Nombre del beneficiario del pago en esta amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.email IS
    'Correo del beneficiario para notificaciones de confirmacion de pago';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.telefono IS
    'Telefono del beneficiario para contacto sobre el pago realizado';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.monto_original IS
    'Monto original de la cuenta por pagar padre (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar antes de esta amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.fecha_emision IS
    'Fecha de emision de la cuenta por pagar padre (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar padre';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.estado_cxp IS
    'Estado de la amortizacion: APLICADA, REVERSADA, ANULADA, EN_PROCESO';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.usuario_creacion IS
    'Usuario del sistema que proceso la amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro de amortizacion';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.observaciones IS
    'Notas sobre el pago, condiciones especiales o instrucciones del proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BAMOR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BAMOR (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    origen_cuenta            TEXT IS 'Origen',
    tipo_cuenta              TEXT IS 'Tipo Cta',
    id_cliente               TEXT IS 'ID Cliente',
    numero_referencia        TEXT IS 'No. Referenc',
    tipo_registro            TEXT IS 'Tipo Reg',
    secuencia_amortizacion   TEXT IS 'Secuencia',
    fecha_amortizacion       TEXT IS 'Fec Amort',
    tipo_pago                TEXT IS 'Tipo Pago',
    numero_documento_pago    TEXT IS 'No. Doc Pago',
    codigo_moneda            TEXT IS 'Moneda',
    monto_amortizado         TEXT IS 'Mto Amort',
    monto_descuento_aplicado TEXT IS 'Descuento',
    monto_retencion_aplicada TEXT IS 'Retencion',
    saldo_despues_pago       TEXT IS 'Sdo Desp Pago',
    numero_identificacion    TEXT IS 'No. Identif',
    razon_social             TEXT IS 'Razon Social',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Prev',
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

CREATE INDEX HNEACOSTA1/IBAMORFA  ON HNEACOSTA1/BAMOR (fecha_amortizacion);
CREATE INDEX HNEACOSTA1/IBAMORCLI ON HNEACOSTA1/BAMOR (id_cliente);
CREATE INDEX HNEACOSTA1/IBAMORCAT ON HNEACOSTA1/BAMOR (created_at);
CREATE INDEX HNEACOSTA1/IBAMOREST ON HNEACOSTA1/BAMOR (estado_cxp);