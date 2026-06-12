-- ================================================================
-- Nombre de la Tabla  : FIWRT
-- DESCRIPCION         : Transacciones Historicas de Pagos y Recibos
-- Objetivo            : Centralizar el historico consolidado de todas
--                       las transacciones de pagos y recibos procesadas
--                       por el banco, independientemente del canal
--                       (local, SWIFT, telex), sirviendo como registro
--                       definitivo e inmutable de toda la actividad
--                       de pagos para auditoria y conciliacion.
-- Tipo de Tabla       : Historica / Auditoria Consolidada
-- Origen de los Datos : Proceso de cierre o contabilizacion definitiva
--                       de operaciones desde POFED, POSWF y POTLX
-- Permanencia de Datos: Historica permanente (no se purga)
-- Uso de los datos    : Auditoria de pagos, conciliacion de tesoreria,
--                       reportes regulatorios y estadisticas
-- Restricciones       : PK compuesta por banco y numero_transferencia;
--                       tabla de consolidacion historica sin FK directas
--                       para mantener independencia de las tablas origen
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/FIWRT (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN FIWRTBNK,
    numero_transferencia     VARCHAR(30)    NOT NULL     FOR COLUMN FIWRTNTR,
    tipo_operacion           VARCHAR(20)                 FOR COLUMN FIWRTTOP,
    canal_origen             VARCHAR(20)                 FOR COLUMN FIWRTCOR,
    numero_referencia_origen VARCHAR(30)                 FOR COLUMN FIWRTNRO,
    id_cliente               VARCHAR(30)                 FOR COLUMN FIWRTCLI,
    numero_cuenta_debito     VARCHAR(24)                 FOR COLUMN FIWRTNCD,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN FIWRTMON,
    fecha_operacion          DATE           NOT NULL     FOR COLUMN FIWRTFOP,
    fecha_valor              DATE                        FOR COLUMN FIWRTFVA,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIWRTMNT,
    comision_cobrada         DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIWRTCMS,
    beneficiario             VARCHAR(80)    NOT NULL     FOR COLUMN FIWRTBEN,
    cuenta_beneficiario      VARCHAR(30)                 FOR COLUMN FIWRTCBE,
    banco_destino            VARCHAR(80)                 FOR COLUMN FIWRTBDE,
    codigo_banco_destino     VARCHAR(20)                 FOR COLUMN FIWRTCBD,
    concepto_pago            VARCHAR(120)                FOR COLUMN FIWRTCPA,
    canal_pago               VARCHAR(20)    NOT NULL     FOR COLUMN FIWRTCNL,
    numero_autorizacion      VARCHAR(50)                 FOR COLUMN FIWRTNAU,
    cuenta_contable_debito   VARCHAR(24)                 FOR COLUMN FIWRTCCD,
    cuenta_contable_credito  VARCHAR(24)                 FOR COLUMN FIWRTCCC,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN FIWRTEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN FIWRTUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN FIWRTUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN FIWRTVRS,
    observaciones            VARCHAR(120)                FOR COLUMN FIWRTOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN FIWRTERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN FIWRTCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN FIWRTUAT,
    CONSTRAINT PK_FIWRT PRIMARY KEY (codigo_banco, numero_transferencia)
)
RCDFMT FIWRTR;

RENAME TABLE HNEACOSTA1/FIWRT
    TO FIWRT FOR SYSTEM NAME FIWRT;

COMMENT ON TABLE HNEACOSTA1/FIWRT IS
    'Historico Consolidado de Pagos y Recibos - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE HNEACOSTA1/FIWRT
    IS 'Historico Pagos Recibos';

COMMENT ON COLUMN HNEACOSTA1/FIWRT.codigo_banco IS
    'Codigo del banco que proceso la transaccion de pago o recibo';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.numero_transferencia IS
    'Numero de transferencia unico asignado al momento de la contabilizacion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.tipo_operacion IS
    'Tipo de operacion: PAGO_ENVIADO, PAGO_RECIBIDO, TRANSFERENCIA, COBRO';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.canal_origen IS
    'Canal que origino la transaccion: LOCAL, SWIFT, TELEX, ACH, RTGS';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.numero_referencia_origen IS
    'Numero de referencia original en la tabla origen (POFED, POSWF o POTLX)';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.id_cliente IS
    'Identificador del cliente ordenante o beneficiario de la operacion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.numero_cuenta_debito IS
    'Numero de cuenta del banco desde la que se proceso el debito';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.codigo_moneda IS
    'Codigo ISO de la moneda en que fue procesada la transaccion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.fecha_operacion IS
    'Fecha en que la transaccion fue procesada y contabilizada definitivamente';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.fecha_valor IS
    'Fecha de efectividad o liquidacion real del pago en los sistemas';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.monto IS
    'Monto de la transaccion en la moneda declarada';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.comision_cobrada IS
    'Comision cobrada por el banco al cliente por el servicio de pago';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.beneficiario IS
    'Nombre del beneficiario final o receptor del pago';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.cuenta_beneficiario IS
    'Numero de cuenta del beneficiario en el banco receptor';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.banco_destino IS
    'Nombre del banco receptor o corresponsal del pago';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.codigo_banco_destino IS
    'Codigo o numero de ruta del banco destino en el sistema de pagos';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.concepto_pago IS
    'Descripcion del concepto o motivo del pago para el beneficiario';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.canal_pago IS
    'Canal a traves del cual se proceso la transaccion definitivamente';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.numero_autorizacion IS
    'Numero de autorizacion o confirmacion del sistema de liquidacion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.cuenta_contable_debito IS
    'Cuenta contable debitada en el asiento generado por la transaccion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.cuenta_contable_credito IS
    'Cuenta contable acreditada en el asiento generado por la transaccion';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.estado_pago IS
    'Estado definitivo de la transaccion: LIQUIDADO, RECHAZADO, DEVUELTO, REVERSADO';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.usuario_creacion IS
    'Usuario o proceso de cierre que genero el registro historico definitivo';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.usuario_actualizacion IS
    'Usuario que realizo alguna correccion o nota sobre el registro historico';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.observaciones IS
    'Notas sobre la transaccion, su origen o incidencias de procesamiento';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/FIWRT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/FIWRT (
    codigo_banco             TEXT IS 'Banco',
    numero_transferencia     TEXT IS 'No. Transfer',
    tipo_operacion           TEXT IS 'Tipo Oper',
    canal_origen             TEXT IS 'Canal Orig',
    numero_referencia_origen TEXT IS 'Ref Origen',
    id_cliente               TEXT IS 'ID Cliente',
    numero_cuenta_debito     TEXT IS 'Cta Debito',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_operacion          TEXT IS 'Fec Oper',
    fecha_valor              TEXT IS 'Fec Valor',
    monto                    TEXT IS 'Monto',
    comision_cobrada         TEXT IS 'Comision',
    beneficiario             TEXT IS 'Beneficiario',
    cuenta_beneficiario      TEXT IS 'Cta Benefic',
    banco_destino            TEXT IS 'Banco Dest',
    codigo_banco_destino     TEXT IS 'Cod Banco Dest',
    concepto_pago            TEXT IS 'Concepto',
    canal_pago               TEXT IS 'Canal Pago',
    numero_autorizacion      TEXT IS 'No. Autoriz',
    cuenta_contable_debito   TEXT IS 'Cta Deb GL',
    cuenta_contable_credito  TEXT IS 'Cta Cre GL',
    estado_pago              TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IFIWRTCLI ON HNEACOSTA1/FIWRT (id_cliente);
CREATE INDEX HNEACOSTA1/IFIWRTFOP ON HNEACOSTA1/FIWRT (fecha_operacion);
CREATE INDEX HNEACOSTA1/IFIWRTCNL ON HNEACOSTA1/FIWRT (canal_pago);
CREATE INDEX HNEACOSTA1/IFIWRTEST ON HNEACOSTA1/FIWRT (estado_pago);
CREATE INDEX HNEACOSTA1/IFIWRTCAT ON HNEACOSTA1/FIWRT (created_at);