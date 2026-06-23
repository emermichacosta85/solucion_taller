-- ================================================================
-- Nombre de la Tabla  : POSWF
-- DESCRIPCION         : Ordenes de Pago via Swift
-- Objetivo            : Registrar las ordenes de pago internacionales
--                       procesadas a traves de la red SWIFT, conforme a
--                       la estructura definida en estructura_bd.md
--                       (Modulo 12).
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de transferencias internacionales
--                       de clientes o propias del banco
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento SWIFT, corresponsalia bancaria,
--                       reportes de tesoreria internacional y auditoria
-- Restricciones       : PK compuesta (codigo_banco, codigo_moneda,
--                       id_cliente, tipo_registro, numero_cuenta,
--                       numero_referencia, monto). Sin FK segun
--                       estructura_bd.md.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE POSWF (
    codigo_banco             FOR COLUMN POSWFBNK   VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN POSWFMON   VARCHAR(20)    NOT NULL,
    id_cliente               FOR COLUMN POSWFCLI   VARCHAR(30)    NOT NULL,
    tipo_registro            FOR COLUMN POSWFTRG   VARCHAR(20)    NOT NULL,
    numero_cuenta            FOR COLUMN POSWFCTA   VARCHAR(24)    NOT NULL,
    numero_referencia        FOR COLUMN POSWFREF   VARCHAR(30)    NOT NULL,
    monto                    FOR COLUMN POSWFMNT   DECIMAL(18,2)  NOT NULL,
    fecha_operacion          FOR COLUMN POSWFFOP   DATE,
    beneficiario             FOR COLUMN POSWFBEN   VARCHAR(80)    NOT NULL,
    banco_destino            FOR COLUMN POSWFBDE   VARCHAR(80)    NOT NULL,
    canal_pago               FOR COLUMN POSWFCNL   VARCHAR(20)    NOT NULL,
    estado_pago              FOR COLUMN POSWFEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN POSWFUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN POSWFUSA   VARCHAR(30),
    version_registro         FOR COLUMN POSWFVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN POSWFOBS   VARCHAR(120),
    estado_registro          FOR COLUMN POSWFERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN POSWFCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN POSWFUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_POSWF PRIMARY KEY (codigo_banco, codigo_moneda,
                                     id_cliente, tipo_registro,
                                     numero_cuenta, numero_referencia,
                                     monto)
)
RCDFMT POSWFR;

RENAME TABLE POSWF
    TO POSWF_TABLE FOR SYSTEM NAME POSWF;

COMMENT ON TABLE POSWF IS
    'Ordenes de Pago via Red SWIFT - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE POSWF
    IS 'Ordenes Pago SWIFT';

COMMENT ON COLUMN POSWF.codigo_banco IS
    'Codigo del banco que emite la orden de pago internacional via SWIFT';
COMMENT ON COLUMN POSWF.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la orden SWIFT';
COMMENT ON COLUMN POSWF.id_cliente IS
    'Identificador del cliente ordenante de la transferencia';
COMMENT ON COLUMN POSWF.tipo_registro IS
    'Tipo de registro de la orden: ENVIO, RECIBO, COBERTURA';
COMMENT ON COLUMN POSWF.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita el envio';
COMMENT ON COLUMN POSWF.numero_referencia IS
    'Numero de referencia unico asignado por el banco a la transferencia SWIFT';
COMMENT ON COLUMN POSWF.monto IS
    'Monto de la transferencia en la moneda declarada';
COMMENT ON COLUMN POSWF.fecha_operacion IS
    'Fecha de procesamiento y envio del mensaje SWIFT';
COMMENT ON COLUMN POSWF.beneficiario IS
    'Nombre completo del beneficiario de la transferencia internacional';
COMMENT ON COLUMN POSWF.banco_destino IS
    'Nombre del banco corresponsal o destino de la transferencia';
COMMENT ON COLUMN POSWF.canal_pago IS
    'Canal de procesamiento: SWIFT_MT103, SWIFT_MT202, SWIFT_MT202COV';
COMMENT ON COLUMN POSWF.estado_pago IS
    'Estado de la transferencia: PENDIENTE, ENVIADO, CONFIRMADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN POSWF.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago SWIFT';
COMMENT ON COLUMN POSWF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN POSWF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN POSWF.observaciones IS
    'Notas sobre la transferencia, instrucciones especiales o incidencias';
COMMENT ON COLUMN POSWF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN POSWF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN POSWF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN POSWF (
    codigo_banco             IS 'Banco',
    codigo_moneda            IS 'Moneda',
    id_cliente               IS 'ID Cliente',
    tipo_registro            IS 'Tipo Reg',
    numero_cuenta            IS 'No. Cuenta',
    numero_referencia        IS 'No. Referenc',
    monto                    IS 'Monto',
    fecha_operacion          IS 'Fec Oper',
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

LABEL ON COLUMN POSWF (
    codigo_banco             TEXT IS 'Banco emisor de la orden SWIFT',
    codigo_moneda            TEXT IS 'Moneda de la orden SWIFT',
    id_cliente               TEXT IS 'Cliente ordenante de la transferencia',
    tipo_registro            TEXT IS 'Tipo de registro de la orden',
    numero_cuenta            TEXT IS 'Cuenta del cliente que se debita',
    numero_referencia        TEXT IS 'Referencia unica de la transferencia SWIFT',
    monto                    TEXT IS 'Monto de la transferencia en su moneda',
    fecha_operacion          TEXT IS 'Fecha de envio del mensaje SWIFT',
    beneficiario             TEXT IS 'Beneficiario de la transferencia',
    banco_destino            TEXT IS 'Banco corresponsal o destino',
    canal_pago               TEXT IS 'Canal de procesamiento SWIFT',
    estado_pago              TEXT IS 'Estado de la transferencia',
    usuario_creacion         TEXT IS 'Usuario que registro la orden SWIFT',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas o instrucciones especiales',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IPOSWFCAT ON POSWF (created_at);
