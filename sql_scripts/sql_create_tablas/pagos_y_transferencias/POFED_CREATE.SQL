-- ================================================================
-- Nombre de la Tabla  : POFED
-- DESCRIPCION         : Ordenes de Pago
-- Objetivo            : Registrar las ordenes de pago emitidas por
--                       clientes del banco mediante canales locales o
--                       interbancarios, desde su solicitud hasta su
--                       liquidacion, conforme a la estructura definida
--                       en estructura_bd.md (Modulo 12).
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de clientes via banca en linea,
--                       sucursal o banca telefonica
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento de pagos, control de limites,
--                       reportes de tesoreria y auditoria
-- Restricciones       : PK compuesta (codigo_banco, codigo_moneda,
--                       id_cliente, tipo_registro, numero_cuenta,
--                       numero_referencia). Sin FK segun estructura_bd.md.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE POFED (
    codigo_banco             FOR COLUMN POFEDBNK   VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN POFEDMON   VARCHAR(20)    NOT NULL,
    id_cliente               FOR COLUMN POFEDCLI   VARCHAR(30)    NOT NULL,
    tipo_registro            FOR COLUMN POFEDTRG   VARCHAR(20)    NOT NULL,
    numero_cuenta            FOR COLUMN POFEDCTA   VARCHAR(24)    NOT NULL,
    numero_referencia        FOR COLUMN POFEDREF   VARCHAR(30)    NOT NULL,
    fecha_operacion          FOR COLUMN POFEDFOP   DATE,
    monto                    FOR COLUMN POFEDMNT   DECIMAL(18,2)  NOT NULL
                                                   WITH DEFAULT 0,
    beneficiario             FOR COLUMN POFEDBEN   VARCHAR(80)    NOT NULL,
    banco_destino            FOR COLUMN POFEDBDE   VARCHAR(80),
    canal_pago               FOR COLUMN POFEDCNL   VARCHAR(20)    NOT NULL,
    estado_pago              FOR COLUMN POFEDEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN POFEDUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN POFEDUSA   VARCHAR(30),
    version_registro         FOR COLUMN POFEDVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN POFEDOBS   VARCHAR(120),
    estado_registro          FOR COLUMN POFEDERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN POFEDCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN POFEDUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_POFED PRIMARY KEY (codigo_banco, codigo_moneda,
                                     id_cliente, tipo_registro,
                                     numero_cuenta, numero_referencia)
)
RCDFMT POFEDR;

RENAME TABLE POFED
    TO POFED_TABLE FOR SYSTEM NAME POFED;

COMMENT ON TABLE POFED IS
    'Ordenes de Pago Canal Local - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE POFED
    IS 'Ordenes de Pago Local';

COMMENT ON COLUMN POFED.codigo_banco IS
    'Codigo del banco que procesa la orden de pago';
COMMENT ON COLUMN POFED.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la orden de pago';
COMMENT ON COLUMN POFED.id_cliente IS
    'Identificador del cliente ordenante del pago';
COMMENT ON COLUMN POFED.tipo_registro IS
    'Tipo de registro de la orden: DEBITO, CREDITO, NOTA, AJUSTE';
COMMENT ON COLUMN POFED.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita el pago';
COMMENT ON COLUMN POFED.numero_referencia IS
    'Numero de referencia unico de la orden de pago en el banco';
COMMENT ON COLUMN POFED.fecha_operacion IS
    'Fecha de registro y procesamiento de la orden en el sistema';
COMMENT ON COLUMN POFED.monto IS
    'Monto del pago en la moneda de la orden';
COMMENT ON COLUMN POFED.beneficiario IS
    'Nombre del beneficiario que recibe el pago';
COMMENT ON COLUMN POFED.banco_destino IS
    'Nombre del banco donde se acredita el pago al beneficiario';
COMMENT ON COLUMN POFED.canal_pago IS
    'Canal por el que se procesa el pago: ACH, RTGS, BANCA_EN_LINEA, SUCURSAL';
COMMENT ON COLUMN POFED.estado_pago IS
    'Estado de la orden: PENDIENTE, EN_PROCESO, LIQUIDADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN POFED.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago';
COMMENT ON COLUMN POFED.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN POFED.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN POFED.observaciones IS
    'Notas sobre la orden de pago o instrucciones especiales';
COMMENT ON COLUMN POFED.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN POFED.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN POFED.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN POFED (
    codigo_banco             IS 'Banco',
    codigo_moneda            IS 'Moneda',
    id_cliente               IS 'ID Cliente',
    tipo_registro            IS 'Tipo Reg',
    numero_cuenta            IS 'No. Cuenta',
    numero_referencia        IS 'No. Referenc',
    fecha_operacion          IS 'Fec Oper',
    monto                    IS 'Monto',
    beneficiario             IS 'Beneficiario',
    banco_destino            IS 'Banco Dest',
    canal_pago               IS 'Canal Pago',
    estado_pago              IS 'Estado',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN POFED (
    codigo_banco             TEXT IS 'Codigo del banco que procesa la orden',
    codigo_moneda            TEXT IS 'Moneda de la orden de pago',
    id_cliente               TEXT IS 'Cliente ordenante del pago',
    tipo_registro            TEXT IS 'Tipo de registro de la orden',
    numero_cuenta            TEXT IS 'Cuenta del cliente que se debita',
    numero_referencia        TEXT IS 'Referencia unica de la orden de pago',
    fecha_operacion          TEXT IS 'Fecha de registro y procesamiento',
    monto                    TEXT IS 'Monto del pago en su moneda',
    beneficiario             TEXT IS 'Beneficiario que recibe el pago',
    banco_destino            TEXT IS 'Banco donde se acredita el pago',
    canal_pago               TEXT IS 'Canal por el que se procesa el pago',
    estado_pago              TEXT IS 'Estado de la orden de pago',
    usuario_creacion         TEXT IS 'Usuario que registro la orden',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas o instrucciones especiales',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IPOFEDCAT ON POFED (created_at);
