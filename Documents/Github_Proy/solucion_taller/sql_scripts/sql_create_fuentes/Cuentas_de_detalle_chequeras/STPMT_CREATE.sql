-- ============================================================
-- Nombre de la Tabla  : STPMT
-- DESCRIPCION         : Ordenes de No Pago de Cheques
-- Objetivo            : Registrar instrucciones de suspension de pago
--                       sobre cheques emitidos por cuentahabientes.
-- Tipo de Tabla       : Transaccional
-- Origen de los Datos : Solicitudes de cuentahabientes y mandatos legales
-- Permanencia de Datos: Historica
-- Uso de los datos    : Control y consulta de cheques bloqueados
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/STPMT (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN STPMTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN STPMTSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN STPMTMON,
    cuenta_contable         VARCHAR(24)     NOT NULL    FOR COLUMN STPMTCTC,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN STPMTCTA,
    secuencia               INT             NOT NULL    FOR COLUMN STPMTSEQ,
    numero_cheque           VARCHAR(30)                 FOR COLUMN STPMTCHE,
    monto_cheque            DECIMAL(18,2)               FOR COLUMN STPMTMNT,
    fecha_solicitud         DATE                        FOR COLUMN STPMTFSO,
    fecha_vencimiento       DATE                        FOR COLUMN STPMTFVE,
    motivo_suspension       VARCHAR(120)                FOR COLUMN STPMTMOT,
    estado_orden            VARCHAR(20)                 FOR COLUMN STPMTEST,
    fecha_apertura          DATE                        FOR COLUMN STPMTFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN STPMTFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN STPMTSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN STPMTSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN STPMTLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN STPMTESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN STPMTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN STPMTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN STPMTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN STPMTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN STPMTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN STPMTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN STPMTUAT,
    CONSTRAINT PK_STPMT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     numero_cuenta, secuencia),
    CONSTRAINT FK_STPMT_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT STPMTR;

RENAME TABLE HNEACOSTA1/STPMT
    TO STPMT FOR SYSTEM NAME STPMT;

COMMENT ON TABLE HNEACOSTA1/STPMT IS
    'Ordenes de No Pago de Cheques - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/STPMT
    IS 'Ordenes No Pago Cheques';

COMMENT ON COLUMN HNEACOSTA1/STPMT.codigo_banco IS
    'Codigo del banco emisor de la orden de suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.codigo_sucursal IS
    'Codigo de la sucursal que registra la orden de suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta asociada';
COMMENT ON COLUMN HNEACOSTA1/STPMT.cuenta_contable IS
    'Cuenta contable del plan de cuentas asociada a la cuenta';
COMMENT ON COLUMN HNEACOSTA1/STPMT.numero_cuenta IS
    'Numero de cuenta bancaria sobre la que aplica la suspension (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/STPMT.secuencia IS
    'Numero de secuencia para permitir multiples ordenes por cuenta';
COMMENT ON COLUMN HNEACOSTA1/STPMT.numero_cheque IS
    'Numero del cheque especifico sobre el que aplica la suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.monto_cheque IS
    'Monto del cheque bloqueado en la moneda de la cuenta';
COMMENT ON COLUMN HNEACOSTA1/STPMT.fecha_solicitud IS
    'Fecha en que el cuentahabiente solicito la suspension de pago';
COMMENT ON COLUMN HNEACOSTA1/STPMT.fecha_vencimiento IS
    'Fecha hasta la que la orden de suspension tiene vigencia';
COMMENT ON COLUMN HNEACOSTA1/STPMT.motivo_suspension IS
    'Descripcion del motivo declarado para la suspension del cheque';
COMMENT ON COLUMN HNEACOSTA1/STPMT.estado_orden IS
    'Estado actual de la orden: ACTIVA, VENCIDA, LEVANTADA, PAGADA';
COMMENT ON COLUMN HNEACOSTA1/STPMT.fecha_apertura IS
    'Fecha de apertura de la cuenta asociada (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/STPMT.fecha_ultima_transaccion IS
    'Fecha de la ultima transaccion sobre la orden de suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.saldo_actual IS
    'Saldo actual de la cuenta al momento del registro de la orden';
COMMENT ON COLUMN HNEACOSTA1/STPMT.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del bloqueo';
COMMENT ON COLUMN HNEACOSTA1/STPMT.limite_sobregiro IS
    'Limite de sobregiro vigente en la cuenta al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/STPMT.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro de la orden';
COMMENT ON COLUMN HNEACOSTA1/STPMT.usuario_creacion IS
    'Usuario del sistema que registro la orden de suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/STPMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/STPMT.observaciones IS
    'Notas libres adicionales sobre la orden de suspension';
COMMENT ON COLUMN HNEACOSTA1/STPMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/STPMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/STPMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/STPMT (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    numero_cuenta            TEXT IS 'No. Cuenta',
    secuencia                TEXT IS 'Secuencia',
    numero_cheque            TEXT IS 'No. Cheque',
    monto_cheque             TEXT IS 'Monto Cheque',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    motivo_suspension        TEXT IS 'Motivo',
    estado_orden             TEXT IS 'Estado Orden',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Cta',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ISTPMTCTA ON HNEACOSTA1/STPMT (numero_cuenta);
CREATE INDEX HNEACOSTA1/ISTPMTCAT ON HNEACOSTA1/STPMT (created_at);
