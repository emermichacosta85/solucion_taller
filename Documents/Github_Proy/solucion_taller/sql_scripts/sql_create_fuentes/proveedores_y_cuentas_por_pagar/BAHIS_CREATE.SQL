-- ================================================================
-- Nombre de la Tabla  : BAHIS
-- DESCRIPCION         : Historico de Cuentas por Pagar
-- Objetivo            : Almacenar el historial completo de movimientos
--                       y cambios de estado de las cuentas por pagar,
--                       registrando cada evento significativo para
--                       trazabilidad, auditoria y conciliacion
--                       de obligaciones canceladas o vencidas.
-- Tipo de Tabla       : Historica / Auditoria
-- Origen de los Datos : Proceso de cierre de cuentas por pagar y
--                       cambios de estado registrados en BAPRC
-- Permanencia de Datos: Historica (retener segun politica de auditoria)
-- Uso de los datos    : Auditoria interna, reportes regulatorios y
--                       conciliacion historica de obligaciones
-- Restricciones       : FK hacia BAPRC por clave parcial
--                       (segun ERD: BAPRC ||--o{ BAHIS)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BAHIS (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN BAHISBNK,
    origen_cuenta            VARCHAR(20)    NOT NULL     FOR COLUMN BAHISORG,
    tipo_cuenta              VARCHAR(20)    NOT NULL     FOR COLUMN BAHISTCU,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN BAHISCLI,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN BAHISREF,
    fecha                    DATE           NOT NULL     FOR COLUMN BAHISFEC,
    secuencia                INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAHISSEQ,
    tipo_movimiento          VARCHAR(20)                 FOR COLUMN BAHISTRY,
    codigo_sucursal          VARCHAR(20)                 FOR COLUMN BAHISSUC,
    numero_identificacion    VARCHAR(30)                 FOR COLUMN BAHISNID,
    razon_social             VARCHAR(80)                 FOR COLUMN BAHISRS,
    email                    VARCHAR(80)                 FOR COLUMN BAHISEM,
    telefono                 VARCHAR(80)                 FOR COLUMN BAHISTLF,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN BAHISMON,
    monto_movimiento         DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAHISMOV,
    monto_original           DECIMAL(18,2)               FOR COLUMN BAHISMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN BAHISSPD,
    fecha_emision            DATE                        FOR COLUMN BAHISFE,
    fecha_vencimiento        DATE                        FOR COLUMN BAHISFV,
    estado_anterior          VARCHAR(20)                 FOR COLUMN BAHISEAN,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN BAHISEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BAHISUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BAHISUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAHISVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BAHISOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BAHISERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAHISCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAHISUAT,
    CONSTRAINT PK_BAHIS PRIMARY KEY (codigo_banco, origen_cuenta,
                                     tipo_cuenta, id_cliente,
                                     numero_referencia, fecha, secuencia)
)
RCDFMT BAHISR;

RENAME TABLE HNEACOSTA1/BAHIS
    TO BAHIS FOR SYSTEM NAME BAHIS;

COMMENT ON TABLE HNEACOSTA1/BAHIS IS
    'Historico de Movimientos de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE HNEACOSTA1/BAHIS
    IS 'Historico CxP';

COMMENT ON COLUMN HNEACOSTA1/BAHIS.codigo_banco IS
    'Codigo del banco al que pertenece el registro historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.origen_cuenta IS
    'Origen de la cuenta por pagar registrada en el historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.tipo_cuenta IS
    'Tipo de la cuenta por pagar a la que corresponde el movimiento historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.id_cliente IS
    'Identificador del cliente o contraparte del movimiento historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.numero_referencia IS
    'Numero de referencia de la cuenta por pagar en el historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.fecha IS
    'Fecha en que ocurrio el movimiento o cambio de estado registrado';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.secuencia IS
    'Numero de secuencia para multiples movimientos en la misma fecha';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.tipo_movimiento IS
    'Tipo de evento historico: CREACION, PAGO, AJUSTE, CAMBIO_ESTADO, CIERRE';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.codigo_sucursal IS
    'Codigo de la sucursal que proceso el movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.numero_identificacion IS
    'Numero de identificacion del beneficiario al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.razon_social IS
    'Nombre del beneficiario al momento del movimiento historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.email IS
    'Correo del beneficiario al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.telefono IS
    'Telefono del beneficiario al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.codigo_moneda IS
    'Moneda de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.monto_movimiento IS
    'Monto del movimiento o evento registrado en el historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.monto_original IS
    'Monto original de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar despues del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.fecha_emision IS
    'Fecha de emision de la cuenta por pagar a la que corresponde el movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.estado_anterior IS
    'Estado de la cuenta por pagar antes del cambio registrado';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.estado_cxp IS
    'Estado de la cuenta por pagar despues del movimiento registrado';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.usuario_creacion IS
    'Usuario o proceso que genero el registro historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro historico';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.observaciones IS
    'Notas sobre el movimiento historico o condiciones del evento';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BAHIS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BAHIS (
    codigo_banco             TEXT IS 'Banco',
    origen_cuenta            TEXT IS 'Origen',
    tipo_cuenta              TEXT IS 'Tipo Cta',
    id_cliente               TEXT IS 'ID Cliente',
    numero_referencia        TEXT IS 'No. Referenc',
    fecha                    TEXT IS 'Fecha',
    secuencia                TEXT IS 'Secuencia',
    tipo_movimiento          TEXT IS 'Tipo Movim',
    codigo_sucursal          TEXT IS 'Sucursal',
    numero_identificacion    TEXT IS 'No. Identif',
    razon_social             TEXT IS 'Razon Social',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    codigo_moneda            TEXT IS 'Moneda',
    monto_movimiento         TEXT IS 'Mto Movim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_anterior          TEXT IS 'Edo Anterior',
    estado_cxp               TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IBAHISFEC ON HNEACOSTA1/BAHIS (fecha);
CREATE INDEX HNEACOSTA1/IBAHISCLI ON HNEACOSTA1/BAHIS (id_cliente);
CREATE INDEX HNEACOSTA1/IBAHISCAT ON HNEACOSTA1/BAHIS (created_at);
CREATE INDEX HNEACOSTA1/IBAHISEST ON HNEACOSTA1/BAHIS (estado_cxp);