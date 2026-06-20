-- ================================================================
-- Nombre de la Tabla  : FIWRT
-- DESCRIPCION         : Transacciones Historicas de Pagos y Recibos
-- Objetivo            : Centralizar el historico consolidado de las
--                       transacciones de pagos y recibos procesadas por
--                       el banco, sirviendo como registro definitivo para
--                       auditoria y conciliacion, conforme a la estructura
--                       definida en estructura_bd.md (Modulo 12).
-- Tipo de Tabla       : Historica / Auditoria Consolidada
-- Origen de los Datos : Proceso de cierre o contabilizacion definitiva
--                       de operaciones de pago
-- Permanencia de Datos: Historica permanente (no se purga)
-- Uso de los datos    : Auditoria de pagos, conciliacion de tesoreria
--                       y reportes regulatorios
-- Restricciones       : PK compuesta (codigo_banco, numero_transferencia).
--                       Sin FK segun estructura_bd.md (tabla independiente).
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE FIWRT (
    codigo_banco             FOR COLUMN FIWRTBNK   VARCHAR(20)    NOT NULL,
    numero_transferencia     FOR COLUMN FIWRTNTR   VARCHAR(30)    NOT NULL,
    fecha_operacion          FOR COLUMN FIWRTFOP   DATE           NOT NULL,
    monto                    FOR COLUMN FIWRTMNT   DECIMAL(18,2)  NOT NULL
                                                   WITH DEFAULT 0,
    beneficiario             FOR COLUMN FIWRTBEN   VARCHAR(80)    NOT NULL,
    banco_destino            FOR COLUMN FIWRTBDE   VARCHAR(80),
    canal_pago               FOR COLUMN FIWRTCNL   VARCHAR(20)    NOT NULL,
    estado_pago              FOR COLUMN FIWRTEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN FIWRTUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN FIWRTUSA   VARCHAR(30),
    version_registro         FOR COLUMN FIWRTVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN FIWRTOBS   VARCHAR(120),
    estado_registro          FOR COLUMN FIWRTERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN FIWRTCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN FIWRTUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_FIWRT PRIMARY KEY (codigo_banco, numero_transferencia)
)
RCDFMT FIWRTR;

RENAME TABLE FIWRT
    TO FIWRT_TABLE FOR SYSTEM NAME FIWRT;

COMMENT ON TABLE FIWRT IS
    'Historico Consolidado de Pagos y Recibos - Modulo 12 Pagos y Transferencias';

LABEL ON TABLE FIWRT
    IS 'Historico Pagos Recibos';

COMMENT ON COLUMN FIWRT.codigo_banco IS
    'Codigo del banco que proceso la transaccion de pago o recibo';
COMMENT ON COLUMN FIWRT.numero_transferencia IS
    'Numero de transferencia unico asignado al momento de la contabilizacion';
COMMENT ON COLUMN FIWRT.fecha_operacion IS
    'Fecha en que la transaccion fue procesada y contabilizada definitivamente';
COMMENT ON COLUMN FIWRT.monto IS
    'Monto de la transaccion en la moneda declarada';
COMMENT ON COLUMN FIWRT.beneficiario IS
    'Nombre del beneficiario final o receptor del pago';
COMMENT ON COLUMN FIWRT.banco_destino IS
    'Nombre del banco receptor o corresponsal del pago';
COMMENT ON COLUMN FIWRT.canal_pago IS
    'Canal a traves del cual se proceso la transaccion definitivamente';
COMMENT ON COLUMN FIWRT.estado_pago IS
    'Estado definitivo de la transaccion: LIQUIDADO, RECHAZADO, DEVUELTO, REVERSADO';
COMMENT ON COLUMN FIWRT.usuario_creacion IS
    'Usuario o proceso de cierre que genero el registro historico definitivo';
COMMENT ON COLUMN FIWRT.usuario_actualizacion IS
    'Usuario que realizo alguna correccion o nota sobre el registro historico';
COMMENT ON COLUMN FIWRT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN FIWRT.observaciones IS
    'Notas sobre la transaccion, su origen o incidencias de procesamiento';
COMMENT ON COLUMN FIWRT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN FIWRT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN FIWRT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN FIWRT (
    codigo_banco             IS 'Banco',
    numero_transferencia     IS 'No. Transfer',
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

LABEL ON COLUMN FIWRT (
    codigo_banco             TEXT IS 'Codigo del banco que proceso la transaccion',
    numero_transferencia     TEXT IS 'Numero de transferencia unico contabilizado',
    fecha_operacion          TEXT IS 'Fecha de procesamiento y contabilizacion',
    monto                    TEXT IS 'Monto de la transaccion en su moneda',
    beneficiario             TEXT IS 'Beneficiario final o receptor del pago',
    banco_destino            TEXT IS 'Banco receptor o corresponsal del pago',
    canal_pago               TEXT IS 'Canal por el que se proceso la transaccion',
    estado_pago              TEXT IS 'Estado definitivo de la transaccion',
    usuario_creacion         TEXT IS 'Usuario o proceso que genero el historico',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima correccion o nota',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas sobre la transaccion o incidencias',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IFIWRTCAT ON FIWRT (created_at);
