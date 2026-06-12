-- ================================================================
-- Nombre de la Tabla  : POSWF
-- DESCRIPCION         : Ordenes de Pago via Swift
-- Objetivo            : Registrar las ordenes de pago internacionales
--                       procesadas a traves de la red SWIFT, incluyendo
--                       los datos requeridos por los mensajes MT103/MT202
--                       y el seguimiento del estado hasta la confirmacion
--                       por el banco corresponsal destino.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de transferencias internacionales
--                       de clientes o propias del banco
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento SWIFT, corresponsalia bancaria,
--                       reportes de tesoreria internacional y auditoria
-- Restricciones       : FK hacia CUMST por id_cliente;
--                       FK hacia ACMST por numero_cuenta;
--                       UNIQUE sobre (banco, numero_referencia) para
--                       permitir referencia desde SWITF
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/POSWF (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN POSWFBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN POSWFMON,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN POSWFCLI,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN POSWFTRG,
    numero_cuenta            VARCHAR(24)    NOT NULL     FOR COLUMN POSWFCTA,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN POSWFREF,
    monto                    DECIMAL(18,2)  NOT NULL     FOR COLUMN POSWFMNT,
    tipo_mensaje_swift       VARCHAR(10)                 FOR COLUMN POSWFTMS,
    codigo_bic_destino       VARCHAR(20)                 FOR COLUMN POSWFBIC,
    codigo_iban_benefic      VARCHAR(50)                 FOR COLUMN POSWFIBA,
    fecha_solicitud          DATE                        FOR COLUMN POSWFFS,
    fecha_operacion          DATE                        FOR COLUMN POSWFFOP,
    fecha_valor              DATE                        FOR COLUMN POSWFFVA,
    comision                 DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN POSWFCMS,
    beneficiario             VARCHAR(80)    NOT NULL     FOR COLUMN POSWFBEN,
    direccion_beneficiario   VARCHAR(120)                FOR COLUMN POSWFDBE,
    banco_destino            VARCHAR(80)    NOT NULL     FOR COLUMN POSWFBDE,
    banco_intermediario      VARCHAR(80)                 FOR COLUMN POSWFBIM,
    codigo_bic_intermediario VARCHAR(20)                 FOR COLUMN POSWFBII,
    concepto_pago            VARCHAR(120)                FOR COLUMN POSWFCPA,
    codigo_gasto             VARCHAR(10)                 FOR COLUMN POSWFCGA,
    canal_pago               VARCHAR(20)    NOT NULL     FOR COLUMN POSWFCNL,
    numero_autorizacion      VARCHAR(50)                 FOR COLUMN POSWFNAU,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN POSWFEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN POSWFUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN POSWFUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN POSWFVRS,
    observaciones            VARCHAR(120)                FOR COLUMN POSWFOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN POSWFERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POSWFCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POSWFUAT,
    CONSTRAINT PK_POSWF     PRIMARY KEY (codigo_banco, codigo_moneda,
                                         id_cliente, tipo_registro,
                                         numero_cuenta, numero_referencia,
                                         monto),
    CONSTRAINT UQ_POSWF_REF UNIQUE      (codigo_banco, numero_referencia),
    CONSTRAINT FK_POSWF_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente),
    CONSTRAINT FK_POSWF_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT POSWFR;

RENAME TABLE HNEACOSTA1/POSWF
    TO POSWF FOR SYSTEM NAME POSWF;

COMMENT ON TABLE HNEACOSTA1/POSWF IS
    'Ordenes de Pago via Red SWIFT - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE HNEACOSTA1/POSWF
    IS 'Ordenes Pago SWIFT';

COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_banco IS
    'Codigo del banco que emite la orden de pago internacional via SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la orden SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.id_cliente IS
    'Identificador del cliente ordenante de la transferencia (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/POSWF.tipo_registro IS
    'Tipo de registro de la orden: ENVIO, RECIBO, COBERTURA';
COMMENT ON COLUMN HNEACOSTA1/POSWF.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita el envio (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/POSWF.numero_referencia IS
    'Numero de referencia unico asignado por el banco a la transferencia SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.monto IS
    'Monto de la transferencia en la moneda declarada';
COMMENT ON COLUMN HNEACOSTA1/POSWF.tipo_mensaje_swift IS
    'Tipo de mensaje SWIFT utilizado: MT103 (cliente), MT202 (banco a banco)';
COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_bic_destino IS
    'Codigo BIC/SWIFT del banco beneficiario o destino de la transferencia';
COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_iban_benefic IS
    'IBAN o numero de cuenta internacional del beneficiario cuando aplica';
COMMENT ON COLUMN HNEACOSTA1/POSWF.fecha_solicitud IS
    'Fecha en que el cliente solicito la transferencia internacional';
COMMENT ON COLUMN HNEACOSTA1/POSWF.fecha_operacion IS
    'Fecha de procesamiento y envio del mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.fecha_valor IS
    'Fecha de valor pactada con el banco corresponsal para la liquidacion';
COMMENT ON COLUMN HNEACOSTA1/POSWF.comision IS
    'Comision cobrada al cliente por el servicio de transferencia SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.beneficiario IS
    'Nombre completo del beneficiario de la transferencia internacional';
COMMENT ON COLUMN HNEACOSTA1/POSWF.direccion_beneficiario IS
    'Direccion postal del beneficiario requerida en ciertos mensajes SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.banco_destino IS
    'Nombre del banco corresponsal o destino de la transferencia';
COMMENT ON COLUMN HNEACOSTA1/POSWF.banco_intermediario IS
    'Nombre del banco intermediario cuando la ruta requiere un banco adicional';
COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_bic_intermediario IS
    'Codigo BIC del banco intermediario en rutas con mas de dos bancos';
COMMENT ON COLUMN HNEACOSTA1/POSWF.concepto_pago IS
    'Motivo o concepto del pago incluido en el campo 70 del mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.codigo_gasto IS
    'Instruccion de gastos SWIFT: OUR=paga ordenante, SHA=compartido, BEN=beneficiario';
COMMENT ON COLUMN HNEACOSTA1/POSWF.canal_pago IS
    'Canal de procesamiento: SWIFT_MT103, SWIFT_MT202, SWIFT_MT202COV';
COMMENT ON COLUMN HNEACOSTA1/POSWF.numero_autorizacion IS
    'Numero de UETR (Unique End-to-end Transaction Reference) u otra referencia';
COMMENT ON COLUMN HNEACOSTA1/POSWF.estado_pago IS
    'Estado de la transferencia: PENDIENTE, ENVIADO, CONFIRMADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN HNEACOSTA1/POSWF.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago SWIFT';
COMMENT ON COLUMN HNEACOSTA1/POSWF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/POSWF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/POSWF.observaciones IS
    'Notas sobre la transferencia, instrucciones especiales o incidencias';
COMMENT ON COLUMN HNEACOSTA1/POSWF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/POSWF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/POSWF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/POSWF (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    id_cliente               TEXT IS 'ID Cliente',
    tipo_registro            TEXT IS 'Tipo Reg',
    numero_cuenta            TEXT IS 'No. Cuenta',
    numero_referencia        TEXT IS 'No. Referenc',
    monto                    TEXT IS 'Monto',
    tipo_mensaje_swift       TEXT IS 'Tipo Msg',
    codigo_bic_destino       TEXT IS 'BIC Destino',
    codigo_iban_benefic      TEXT IS 'IBAN Benefic',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_operacion          TEXT IS 'Fec Oper',
    fecha_valor              TEXT IS 'Fec Valor',
    comision                 TEXT IS 'Comision',
    beneficiario             TEXT IS 'Beneficiario',
    direccion_beneficiario   TEXT IS 'Dir Benefic',
    banco_destino            TEXT IS 'Banco Dest',
    banco_intermediario      TEXT IS 'Banco Interm',
    codigo_bic_intermediario TEXT IS 'BIC Interm',
    concepto_pago            TEXT IS 'Concepto',
    codigo_gasto             TEXT IS 'Cod Gasto',
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

CREATE INDEX HNEACOSTA1/IPOSWFCLI ON HNEACOSTA1/POSWF (id_cliente);
CREATE INDEX HNEACOSTA1/IPOSWFCTA ON HNEACOSTA1/POSWF (numero_cuenta);
CREATE INDEX HNEACOSTA1/IPOSWFEST ON HNEACOSTA1/POSWF (estado_pago);
CREATE INDEX HNEACOSTA1/IPOSWFFOP ON HNEACOSTA1/POSWF (fecha_operacion);
CREATE INDEX HNEACOSTA1/IPOSWFCAT ON HNEACOSTA1/POSWF (created_at);
