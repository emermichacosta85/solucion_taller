-- ================================================================
-- Nombre de la Tabla  : POTLX
-- DESCRIPCION         : Ordenes de Pago via Telex
-- Objetivo            : Registrar las ordenes de pago internacionales
--                       procesadas a traves del canal telex, alternativo
--                       al SWIFT, conforme a la estructura definida en
--                       estructura_bd.md (Modulo 12).
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de transferencias via telex
--                       a corresponsales especificos
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento de pagos via telex, reportes de
--                       corresponsalia y auditoria de transferencias
-- Restricciones       : PK compuesta (codigo_banco, codigo_moneda,
--                       id_cliente, tipo_registro, numero_cuenta,
--                       numero_referencia). Sin FK segun estructura_bd.md.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE POTLX (
    codigo_banco             FOR COLUMN POTLXBNK   VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN POTLXMON   VARCHAR(20)    NOT NULL,
    id_cliente               FOR COLUMN POTLXCLI   VARCHAR(30)    NOT NULL,
    tipo_registro            FOR COLUMN POTLXTRG   VARCHAR(20)    NOT NULL,
    numero_cuenta            FOR COLUMN POTLXCTA   VARCHAR(24)    NOT NULL,
    numero_referencia        FOR COLUMN POTLXREF   VARCHAR(30)    NOT NULL,
    fecha_operacion          FOR COLUMN POTLXFOP   DATE,
    monto                    FOR COLUMN POTLXMNT   DECIMAL(18,2)  NOT NULL
                                                   WITH DEFAULT 0,
    beneficiario             FOR COLUMN POTLXBEN   VARCHAR(80)    NOT NULL,
    banco_destino            FOR COLUMN POTLXBDE   VARCHAR(80)    NOT NULL,
    canal_pago               FOR COLUMN POTLXCNL   VARCHAR(20)    NOT NULL,
    estado_pago              FOR COLUMN POTLXEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN POTLXUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN POTLXUSA   VARCHAR(30),
    version_registro         FOR COLUMN POTLXVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN POTLXOBS   VARCHAR(120),
    estado_registro          FOR COLUMN POTLXERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN POTLXCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN POTLXUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_POTLX PRIMARY KEY (codigo_banco, codigo_moneda,
                                     id_cliente, tipo_registro,
                                     numero_cuenta, numero_referencia)
)
RCDFMT POTLXR;

RENAME TABLE POTLX
    TO POTLX_TABLE FOR SYSTEM NAME POTLX;

COMMENT ON TABLE POTLX IS
    'Ordenes de Pago via Telex - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE POTLX
    IS 'Ordenes Pago Telex';

COMMENT ON COLUMN POTLX.codigo_banco IS
    'Codigo del banco que emite la orden de pago via telex';
COMMENT ON COLUMN POTLX.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la orden de pago telex';
COMMENT ON COLUMN POTLX.id_cliente IS
    'Identificador del cliente que solicita la transferencia via telex';
COMMENT ON COLUMN POTLX.tipo_registro IS
    'Tipo de registro de la orden de pago telex: ENVIO, RECIBO';
COMMENT ON COLUMN POTLX.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita la transferencia';
COMMENT ON COLUMN POTLX.numero_referencia IS
    'Numero de referencia unico de la orden de pago telex en el banco';
COMMENT ON COLUMN POTLX.fecha_operacion IS
    'Fecha de envio del mensaje telex al banco corresponsal';
COMMENT ON COLUMN POTLX.monto IS
    'Monto de la transferencia en la moneda de la orden';
COMMENT ON COLUMN POTLX.beneficiario IS
    'Nombre del beneficiario de la transferencia via telex';
COMMENT ON COLUMN POTLX.banco_destino IS
    'Nombre del banco corresponsal que recibe y acredita el pago';
COMMENT ON COLUMN POTLX.canal_pago IS
    'Canal de procesamiento: TELEX, CABLE, OTRO';
COMMENT ON COLUMN POTLX.estado_pago IS
    'Estado de la orden: PENDIENTE, ENVIADO, CONFIRMADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN POTLX.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago telex';
COMMENT ON COLUMN POTLX.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN POTLX.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN POTLX.observaciones IS
    'Notas sobre la orden telex, instrucciones especiales o incidencias';
COMMENT ON COLUMN POTLX.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN POTLX.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN POTLX.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN POTLX (
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
    canal_pago               IS 'Canal',
    estado_pago              IS 'Estado',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN POTLX (
    codigo_banco             TEXT IS 'Banco emisor de la orden telex',
    codigo_moneda            TEXT IS 'Moneda de la orden de pago telex',
    id_cliente               TEXT IS 'Cliente que solicita la transferencia',
    tipo_registro            TEXT IS 'Tipo de registro de la orden telex',
    numero_cuenta            TEXT IS 'Cuenta del cliente que se debita',
    numero_referencia        TEXT IS 'Referencia unica de la orden telex',
    fecha_operacion          TEXT IS 'Fecha de envio del mensaje telex',
    monto                    TEXT IS 'Monto de la transferencia en su moneda',
    beneficiario             TEXT IS 'Beneficiario de la transferencia',
    banco_destino            TEXT IS 'Banco corresponsal que acredita el pago',
    canal_pago               TEXT IS 'Canal de procesamiento telex',
    estado_pago              TEXT IS 'Estado de la orden de pago',
    usuario_creacion         TEXT IS 'Usuario que registro la orden telex',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas o instrucciones especiales',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IPOTLXCAT ON POTLX (created_at);
