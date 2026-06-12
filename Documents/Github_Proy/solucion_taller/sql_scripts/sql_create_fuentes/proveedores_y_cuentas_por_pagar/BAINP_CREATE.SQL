-- ================================================================
-- Nombre de la Tabla  : BAINP
-- DESCRIPCION         : Transacciones Contables Diarias de Cuentas por Pagar
-- Objetivo            : Registrar los asientos contables generados por
--                       las operaciones del dia en el modulo de cuentas
--                       por pagar (pagos realizados, provisiones, ajustes),
--                       para su posterior traspaso al modulo de contabilidad
--                       (GLMST/INPUT) en el proceso de cierre diario.
-- Tipo de Tabla       : Transaccional / Puente Contable
-- Origen de los Datos : Proceso de pago y gestion de cuentas por pagar
-- Permanencia de Datos: Transitoria durante el dia; historica post-cierre
-- Uso de los datos    : Generacion de asientos en INPUT, conciliacion
--                       contable de pagos del dia
-- Restricciones       : FK hacia BAPRC por numero_referencia
--                       (segun ERD: BAPRC ||--o{ BAINP)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BAINP (
    numero_batch             VARCHAR(30)    NOT NULL     FOR COLUMN BAINPBAT,
    secuencia                INT            NOT NULL     FOR COLUMN BAINPSEQ,
    numero_referencia        VARCHAR(30)                 FOR COLUMN BAINPREF,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN BAINPBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN BAINPSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN BAINPMON,
    cuenta_contable          VARCHAR(24)                 FOR COLUMN BAINPCTC,
    tipo_movimiento          CHAR(1)        NOT NULL     FOR COLUMN BAINPTMV,
    fecha_asiento            DATE           NOT NULL     FOR COLUMN BAINPFA,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAINPMNT,
    tipo_transaccion         VARCHAR(20)                 FOR COLUMN BAINPTTR,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN BAINPNID,
    razon_social             VARCHAR(80)                 FOR COLUMN BAINPRS,
    email                    VARCHAR(80)                 FOR COLUMN BAINPEM,
    telefono                 VARCHAR(80)                 FOR COLUMN BAINPTLF,
    monto_original           DECIMAL(18,2)               FOR COLUMN BAINPMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN BAINPSPD,
    fecha_emision            DATE                        FOR COLUMN BAINPFE,
    fecha_vencimiento        DATE                        FOR COLUMN BAINPFV,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN BAINPEST,
    estado_asiento           VARCHAR(20)    NOT NULL     FOR COLUMN BAINPEAS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BAINPUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BAINPUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAINPVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BAINPOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BAINPERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAINPCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAINPUAT,
    CONSTRAINT PK_BAINP PRIMARY KEY (numero_batch, secuencia)
)
RCDFMT BAINPR;

RENAME TABLE HNEACOSTA1/BAINP
    TO BAINP FOR SYSTEM NAME BAINP;

COMMENT ON TABLE HNEACOSTA1/BAINP IS
    'Transacciones Contables Diarias de Cuentas por Pagar - Modulo 11';

LABEL ON TABLE HNEACOSTA1/BAINP
    IS 'Trans Contab Diarias CxP';

COMMENT ON COLUMN HNEACOSTA1/BAINP.numero_batch IS
    'Identificador del lote de transacciones contables del modulo CxP del dia';
COMMENT ON COLUMN HNEACOSTA1/BAINP.secuencia IS
    'Numero de secuencia del asiento dentro del lote de transacciones';
COMMENT ON COLUMN HNEACOSTA1/BAINP.numero_referencia IS
    'Numero de referencia de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.codigo_banco IS
    'Codigo del banco al que pertenece la transaccion contable';
COMMENT ON COLUMN HNEACOSTA1/BAINP.codigo_sucursal IS
    'Codigo de la sucursal que genero la transaccion contable';
COMMENT ON COLUMN HNEACOSTA1/BAINP.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.cuenta_contable IS
    'Numero de cuenta contable afectada por el asiento de cuentas por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAINP.tipo_movimiento IS
    'Naturaleza del movimiento contable: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/BAINP.fecha_asiento IS
    'Fecha contable del asiento generado por la transaccion de CxP';
COMMENT ON COLUMN HNEACOSTA1/BAINP.monto IS
    'Monto del movimiento contable generado por la transaccion de CxP';
COMMENT ON COLUMN HNEACOSTA1/BAINP.tipo_transaccion IS
    'Tipo de operacion que origino el asiento: PAGO, PROVISION, AJUSTE, REVERSO';
COMMENT ON COLUMN HNEACOSTA1/BAINP.numero_identificacion IS
    'Numero de identificacion del proveedor o beneficiario del pago';
COMMENT ON COLUMN HNEACOSTA1/BAINP.razon_social IS
    'Nombre del proveedor o beneficiario del pago contabilizado';
COMMENT ON COLUMN HNEACOSTA1/BAINP.email IS
    'Correo del proveedor o beneficiario (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/BAINP.telefono IS
    'Telefono del proveedor o beneficiario (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/BAINP.monto_original IS
    'Monto original de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar al momento del asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.fecha_emision IS
    'Fecha de emision de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.estado_cxp IS
    'Estado de la cuenta por pagar al momento de generar el asiento';
COMMENT ON COLUMN HNEACOSTA1/BAINP.estado_asiento IS
    'Estado del asiento contable: PENDIENTE, CONTABILIZADO, REVERSADO, ERROR';
COMMENT ON COLUMN HNEACOSTA1/BAINP.usuario_creacion IS
    'Usuario o proceso que genero el asiento contable de CxP';
COMMENT ON COLUMN HNEACOSTA1/BAINP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/BAINP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BAINP.observaciones IS
    'Notas sobre el asiento, su origen o condiciones especiales de contabilizacion';
COMMENT ON COLUMN HNEACOSTA1/BAINP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BAINP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BAINP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BAINP (
    numero_batch             TEXT IS 'No. Batch',
    secuencia                TEXT IS 'Secuencia',
    numero_referencia        TEXT IS 'No. Referenc',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    tipo_movimiento          TEXT IS 'D/C',
    fecha_asiento            TEXT IS 'Fec Asiento',
    monto                    TEXT IS 'Monto',
    tipo_transaccion         TEXT IS 'Tipo Transac',
    numero_identificacion    TEXT IS 'No. Identif',
    razon_social             TEXT IS 'Razon Social',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_cxp               TEXT IS 'Estado CxP',
    estado_asiento           TEXT IS 'Estado Asient',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IBAINPREF ON HNEACOSTA1/BAINP (numero_referencia);
CREATE INDEX HNEACOSTA1/IBAINPFA  ON HNEACOSTA1/BAINP (fecha_asiento);
CREATE INDEX HNEACOSTA1/IBAINPCAT ON HNEACOSTA1/BAINP (created_at);
CREATE INDEX HNEACOSTA1/IBAINPEAS ON HNEACOSTA1/BAINP (estado_asiento);
