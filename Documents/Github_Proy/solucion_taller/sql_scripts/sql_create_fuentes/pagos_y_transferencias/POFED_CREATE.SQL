-- ================================================================
-- Nombre de la Tabla  : POFED
-- DESCRIPCION         : Ordenes de Pago (Canal Local / Federal)
-- Objetivo            : Registrar las ordenes de pago emitidas por
--                       clientes del banco mediante canales locales
--                       o interbancarios nacionales (ACH, RTGS, cheques
--                       de gerencia, transferencias locales), desde
--                       su solicitud hasta su liquidacion definitiva.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Solicitudes de clientes via banca en linea,
--                       sucursal o banca telefonica
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Procesamiento de pagos, control de limites,
--                       reportes de tesoreria y auditoria
-- Restricciones       : FK hacia CUMST por id_cliente;
--                       FK hacia ACMST por numero_cuenta
--                       (relaciones funcionales del dominio bancario)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/POFED (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN POFEDBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN POFEDMON,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN POFEDCLI,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN POFEDTRG,
    numero_cuenta            VARCHAR(24)    NOT NULL     FOR COLUMN POFEDCTA,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN POFEDREF,
    tipo_pago                VARCHAR(20)                 FOR COLUMN POFEDTPA,
    fecha_solicitud          DATE                        FOR COLUMN POFEDFS,
    fecha_operacion          DATE                        FOR COLUMN POFEDFOP,
    fecha_valor              DATE                        FOR COLUMN POFEDFVA,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN POFEDMNT,
    comision                 DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN POFEDCMS,
    beneficiario             VARCHAR(80)    NOT NULL     FOR COLUMN POFEDBEN,
    identificacion_benefic   VARCHAR(50)                 FOR COLUMN POFEDINB,
    cuenta_beneficiario      VARCHAR(30)                 FOR COLUMN POFEDCBE,
    banco_destino            VARCHAR(80)                 FOR COLUMN POFEDBDE,
    codigo_banco_destino     VARCHAR(20)                 FOR COLUMN POFEDCBD,
    concepto_pago            VARCHAR(120)                FOR COLUMN POFEDCPA,
    canal_pago               VARCHAR(20)    NOT NULL     FOR COLUMN POFEDCNL,
    numero_autorizacion      VARCHAR(50)                 FOR COLUMN POFEDNAU,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN POFEDEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN POFEDUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN POFEDUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN POFEDVRS,
    observaciones            VARCHAR(120)                FOR COLUMN POFEDOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN POFEDERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POFEDCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN POFEDUAT,
    CONSTRAINT PK_POFED PRIMARY KEY (codigo_banco, codigo_moneda,
                                     id_cliente, tipo_registro,
                                     numero_cuenta, numero_referencia),
    CONSTRAINT FK_POFED_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente),
    CONSTRAINT FK_POFED_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT POFEDR;

RENAME TABLE HNEACOSTA1/POFED
    TO POFED FOR SYSTEM NAME POFED;

COMMENT ON TABLE HNEACOSTA1/POFED IS
    'Ordenes de Pago Canal Local - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE HNEACOSTA1/POFED
    IS 'Ordenes de Pago Local';

COMMENT ON COLUMN HNEACOSTA1/POFED.codigo_banco IS
    'Codigo del banco que procesa la orden de pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la orden de pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.id_cliente IS
    'Identificador del cliente ordenante del pago (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/POFED.tipo_registro IS
    'Tipo de registro de la orden: DEBITO, CREDITO, NOTA, AJUSTE';
COMMENT ON COLUMN HNEACOSTA1/POFED.numero_cuenta IS
    'Numero de cuenta del cliente desde la que se debita el pago (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/POFED.numero_referencia IS
    'Numero de referencia unico de la orden de pago en el banco';
COMMENT ON COLUMN HNEACOSTA1/POFED.tipo_pago IS
    'Tipo de instrumento de pago: ACH, RTGS, CHEQUE_GERENCIA, TRANSFERENCIA';
COMMENT ON COLUMN HNEACOSTA1/POFED.fecha_solicitud IS
    'Fecha en que el cliente solicito la orden de pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.fecha_operacion IS
    'Fecha de registro y procesamiento de la orden en el sistema';
COMMENT ON COLUMN HNEACOSTA1/POFED.fecha_valor IS
    'Fecha de efectividad o liquidacion del pago en los sistemas interbancarios';
COMMENT ON COLUMN HNEACOSTA1/POFED.monto IS
    'Monto del pago en la moneda de la orden';
COMMENT ON COLUMN HNEACOSTA1/POFED.comision IS
    'Comision cobrada al cliente por el procesamiento de la orden de pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.beneficiario IS
    'Nombre del beneficiario que recibe el pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.identificacion_benefic IS
    'Numero de identificacion fiscal del beneficiario del pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.cuenta_beneficiario IS
    'Numero de cuenta bancaria del beneficiario en el banco destino';
COMMENT ON COLUMN HNEACOSTA1/POFED.banco_destino IS
    'Nombre del banco donde se acredita el pago al beneficiario';
COMMENT ON COLUMN HNEACOSTA1/POFED.codigo_banco_destino IS
    'Codigo o numero de ruta del banco destino en el sistema interbancario';
COMMENT ON COLUMN HNEACOSTA1/POFED.concepto_pago IS
    'Descripcion del concepto o motivo del pago para el beneficiario';
COMMENT ON COLUMN HNEACOSTA1/POFED.canal_pago IS
    'Canal por el que se procesa el pago: ACH, RTGS, BANCA_EN_LINEA, SUCURSAL';
COMMENT ON COLUMN HNEACOSTA1/POFED.numero_autorizacion IS
    'Numero de autorizacion o confirmacion del sistema de pagos interbancario';
COMMENT ON COLUMN HNEACOSTA1/POFED.estado_pago IS
    'Estado de la orden: PENDIENTE, EN_PROCESO, LIQUIDADO, RECHAZADO, REVERSADO';
COMMENT ON COLUMN HNEACOSTA1/POFED.usuario_creacion IS
    'Usuario del sistema que registro la orden de pago';
COMMENT ON COLUMN HNEACOSTA1/POFED.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/POFED.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/POFED.observaciones IS
    'Notas sobre la orden de pago o instrucciones especiales';
COMMENT ON COLUMN HNEACOSTA1/POFED.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/POFED.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/POFED.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/POFED (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    id_cliente               TEXT IS 'ID Cliente',
    tipo_registro            TEXT IS 'Tipo Reg',
    numero_cuenta            TEXT IS 'No. Cuenta',
    numero_referencia        TEXT IS 'No. Referenc',
    tipo_pago                TEXT IS 'Tipo Pago',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_operacion          TEXT IS 'Fec Oper',
    fecha_valor              TEXT IS 'Fec Valor',
    monto                    TEXT IS 'Monto',
    comision                 TEXT IS 'Comision',
    beneficiario             TEXT IS 'Beneficiario',
    identificacion_benefic   TEXT IS 'ID Benefic',
    cuenta_beneficiario      TEXT IS 'Cta Benefic',
    banco_destino            TEXT IS 'Banco Dest',
    codigo_banco_destino     TEXT IS 'Cod Banco Dest',
    concepto_pago            TEXT IS 'Concepto',
    canal_pago               TEXT IS 'Canal Pago',
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

CREATE INDEX HNEACOSTA1/IPOFEDCLI ON HNEACOSTA1/POFED (id_cliente);
CREATE INDEX HNEACOSTA1/IPOFEDCTA ON HNEACOSTA1/POFED (numero_cuenta);
CREATE INDEX HNEACOSTA1/IPOFEDEST ON HNEACOSTA1/POFED (estado_pago);
CREATE INDEX HNEACOSTA1/IPOFEDFOP ON HNEACOSTA1/POFED (fecha_operacion);
CREATE INDEX HNEACOSTA1/IPOFEDCAT ON HNEACOSTA1/POFED (created_at);