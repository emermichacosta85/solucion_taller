-- ================================================================
-- Nombre de la Tabla  : POTLX
-- DESCRIPCION         : Ordenes de Pago via Telex
-- Objetivo            : Registrar las ordenes de pago internacionales
--                       procesadas a traves del canal telex, alternativo
--                       al SWIFT para corresponsales sin conectividad SWIFT,
--                       con el mismo ciclo de vida desde la solicitud
--                       hasta la confirmacion de liquidacion.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de transferencias via telex
--                       a corresponsales especificos
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento de pagos via telex, reportes de
--                       corresponsalia y auditoria de transferencias
-- Restricciones       : FK hacia CUMST por id_cliente;
--                       FK hacia ACMST por numero_cuenta
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/POTLX (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN POTLXBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN POTLXMON,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN POTLXCLI,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN POTLXTRG,
    numero_cuenta            VARCHAR(24)    NOT NULL     FOR COLUMN POTLXCTA,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN POTLXREF,
    numero_telex             VARCHAR(50)                 FOR COLUMN POTLXNTLX,
    fecha_solicitud          DATE                        FOR COLUMN POTLXFS,
    fecha_operacion          DATE                        FOR COLUMN POTLXFOP,
    fecha_valor              DATE                        FOR COLUMN POTLXFVA,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN POTLXMNT,
    comision                 DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN POTLXCMS,
    beneficiario             VARCHAR(80)    NOT NULL     FOR COLUMN POTLXBEN,
    cuenta_beneficiario      VARCHAR(30)                 FOR COLUMN POTLXCBE,
    banco_destino            VARCHAR(80)    NOT NULL     FOR COLUMN POTLXBDE,
    codigo_telex_destino     VARCHAR(30)                 FOR COLUMN POTLXCTD,
    concepto_pago            VARCHAR(120)                FOR COLUMN POTLXCPA,
    canal_pago               VARCHAR(20)    NOT NULL     FOR COLUMN POTLXCNL,
    numero_autorizacion      VARCHAR(50)                 FOR COLUMN POTLXNAU,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN POTLXEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN POTLXUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN POTLXUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN POTLXVRS,
    observaciones            VARCHAR(120)                FOR COLUMN POTLXOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN POTLXERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POTLXCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POTLXUAT,
    CONSTRAINT PK_POTLX PRIMARY KEY (codigo_banco, codigo_moneda,
                                     id_cliente, tipo_registro,
                                     numero_cuenta, numero_referencia),
    CONSTRAINT FK_POTLX_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente),
    CONSTRAINT FK_POTLX_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT POTLXR;

RENAME TABLE HNEACOSTA1/POTLX
    TO POTLX FOR SYSTEM NAME POTLX;

COMMENT ON TABLE HNEACOSTA1/POTLX IS
    'Ordenes de Pago via Telex - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE HNEACOSTA1/POTLX
    IS 'Ordenes Pago Telex';

COMMENT ON COLUMN HNEACOSTA1/POTLX.codigo_banco IS
    'Codigo del banco que emite la orden de pago via telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la orden de pago telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.id_cliente IS
    'Identificador del cliente que solicita la transferencia via telex (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/POTLX.tipo_registro IS
    'Tipo de registro de la orden de pago telex: ENVIO, RECIBO';
COMMENT ON COLUMN HNEACOSTA1/POTLX.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita la transferencia (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/POTLX.numero_referencia IS
    'Numero de referencia unico de la orden de pago telex en el banco';
COMMENT ON COLUMN HNEACOSTA1/POTLX.numero_telex IS
    'Numero de telex del banco corresponsal destino';
COMMENT ON COLUMN HNEACOSTA1/POTLX.fecha_solicitud IS
    'Fecha en que el cliente solicito la transferencia via telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.fecha_operacion IS
    'Fecha de envio del mensaje telex al banco corresponsal';
COMMENT ON COLUMN HNEACOSTA1/POTLX.fecha_valor IS
    'Fecha de valor acordada para la liquidacion del pago en el corresponsal';
COMMENT ON COLUMN HNEACOSTA1/POTLX.monto IS
    'Monto de la transferencia en la moneda de la orden';
COMMENT ON COLUMN HNEACOSTA1/POTLX.comision IS
    'Comision cobrada al cliente por el servicio de pago via telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.beneficiario IS
    'Nombre del beneficiario de la transferencia via telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.cuenta_beneficiario IS
    'Numero de cuenta del beneficiario en el banco corresponsal';
COMMENT ON COLUMN HNEACOSTA1/POTLX.banco_destino IS
    'Nombre del banco corresponsal que recibe y acredita el pago';
COMMENT ON COLUMN HNEACOSTA1/POTLX.codigo_telex_destino IS
    'Numero o codigo de telex del banco corresponsal destino';
COMMENT ON COLUMN HNEACOSTA1/POTLX.concepto_pago IS
    'Motivo o concepto del pago transmitido en el mensaje telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.canal_pago IS
    'Canal de procesamiento: TELEX, CABLE, OTRO';
COMMENT ON COLUMN HNEACOSTA1/POTLX.numero_autorizacion IS
    'Numero de autorizacion o acuse de recibo del banco corresponsal';
COMMENT ON COLUMN HNEACOSTA1/POTLX.estado_pago IS
    'Estado de la orden: PENDIENTE, ENVIADO, CONFIRMADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN HNEACOSTA1/POTLX.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago telex';
COMMENT ON COLUMN HNEACOSTA1/POTLX.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/POTLX.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/POTLX.observaciones IS
    'Notas sobre la orden telex, instrucciones especiales o incidencias';
COMMENT ON COLUMN HNEACOSTA1/POTLX.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/POTLX.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/POTLX.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/POTLX (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    id_cliente               TEXT IS 'ID Cliente',
    tipo_registro            TEXT IS 'Tipo Reg',
    numero_cuenta            TEXT IS 'No. Cuenta',
    numero_referencia        TEXT IS 'No. Referenc',
    numero_telex             TEXT IS 'No. Telex',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_operacion          TEXT IS 'Fec Oper',
    fecha_valor              TEXT IS 'Fec Valor',
    monto                    TEXT IS 'Monto',
    comision                 TEXT IS 'Comision',
    beneficiario             TEXT IS 'Beneficiario',
    cuenta_beneficiario      TEXT IS 'Cta Benefic',
    banco_destino            TEXT IS 'Banco Dest',
    codigo_telex_destino     TEXT IS 'Cod Telex Dest',
    concepto_pago            TEXT IS 'Concepto',
    canal_pago               TEXT IS 'Canal',
    numero_autorizacion      TEXT IS 'No. Autoriz',
    estado_pago              TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IPOTLXCLI ON HNEACOSTA1/POTLX (id_cliente);
CREATE INDEX HNEACOSTA1/IPOTLXCTA ON HNEACOSTA1/POTLX (numero_cuenta);
CREATE INDEX HNEACOSTA1/IPOTLXEST ON HNEACOSTA1/POTLX (estado_pago);
CREATE INDEX HNEACOSTA1/IPOTLXCAT ON HNEACOSTA1/POTLX (created_at);
