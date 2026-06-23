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

CREATE OR REPLACE TABLE BAHIS (
    codigo_banco             FOR COLUMN BAHISBNK   VARCHAR(20)   NOT NULL,
    origen_cuenta            FOR COLUMN BAHISORG   VARCHAR(20)   NOT NULL,
    tipo_cuenta              FOR COLUMN BAHISTCU   VARCHAR(20)   NOT NULL,
    id_cliente               FOR COLUMN BAHISCLI   VARCHAR(30)   NOT NULL,
    numero_referencia        FOR COLUMN BAHISREF   VARCHAR(30)   NOT NULL,
    fecha                    FOR COLUMN BAHISFEC   DATE          NOT NULL,
    numero_identificacion    FOR COLUMN BAHISNID   VARCHAR(30),
    razon_social             FOR COLUMN BAHISRS    VARCHAR(80),
    email                    FOR COLUMN BAHISEM    VARCHAR(80),
    telefono                 FOR COLUMN BAHISTLF   VARCHAR(80),
    codigo_moneda            FOR COLUMN BAHISMON   VARCHAR(20),
    monto_movimiento         FOR COLUMN BAHISMOV   DECIMAL(18,2) NOT NULL DEFAULT 0,
    monto_original           FOR COLUMN BAHISMOR   DECIMAL(18,2),
    saldo_pendiente          FOR COLUMN BAHISSPD   DECIMAL(18,2),
    fecha_emision            FOR COLUMN BAHISFE    DATE,
    fecha_vencimiento        FOR COLUMN BAHISFV    DATE,
    estado_anterior          FOR COLUMN BAHISEAN   VARCHAR(20),
    estado_cxp               FOR COLUMN BAHISEST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN BAHISUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BAHISUSA   VARCHAR(30),
    version_registro         FOR COLUMN BAHISVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BAHISOBS   VARCHAR(120),
    estado_registro          FOR COLUMN BAHISERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BAHISCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BAHISUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BAHIS PRIMARY KEY (codigo_banco, origen_cuenta,
                                     tipo_cuenta, id_cliente,
                                     numero_referencia, fecha, secuencia)
)
RCDFMT BAHISR;

RENAME TABLE BAHIS
    TO BAHIS_TABLE FOR SYSTEM NAME BAHIS;

COMMENT ON TABLE BAHIS IS
    'Historico de Movimientos de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE BAHIS
    IS 'Historico CxP';

COMMENT ON COLUMN BAHIS.codigo_banco IS
    'Codigo del banco al que pertenece el registro historico';
COMMENT ON COLUMN BAHIS.origen_cuenta IS
    'Origen de la cuenta por pagar registrada en el historico';
COMMENT ON COLUMN BAHIS.tipo_cuenta IS
    'Tipo de la cuenta por pagar a la que corresponde el movimiento historico';
COMMENT ON COLUMN BAHIS.id_cliente IS
    'Identificador del cliente o contraparte del movimiento historico';
COMMENT ON COLUMN BAHIS.numero_referencia IS
    'Numero de referencia de la cuenta por pagar en el historico';
COMMENT ON COLUMN BAHIS.fecha IS
    'Fecha en que ocurrio el movimiento o cambio de estado registrado';
COMMENT ON COLUMN BAHIS.numero_identificacion IS
    'Numero de identificacion del beneficiario al momento del movimiento';
COMMENT ON COLUMN BAHIS.razon_social IS
    'Nombre del beneficiario al momento del movimiento historico';
COMMENT ON COLUMN BAHIS.email IS
    'Correo del beneficiario al momento del movimiento';
COMMENT ON COLUMN BAHIS.telefono IS
    'Telefono del beneficiario al momento del movimiento';
COMMENT ON COLUMN BAHIS.codigo_moneda IS
    'Moneda de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN BAHIS.monto_movimiento IS
    'Monto del movimiento o evento registrado en el historico';
COMMENT ON COLUMN BAHIS.monto_original IS
    'Monto original de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN BAHIS.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar despues del movimiento';
COMMENT ON COLUMN BAHIS.fecha_emision IS
    'Fecha de emision de la cuenta por pagar a la que corresponde el movimiento';
COMMENT ON COLUMN BAHIS.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar al momento del movimiento';
COMMENT ON COLUMN BAHIS.estado_anterior IS
    'Estado de la cuenta por pagar antes del cambio registrado';
COMMENT ON COLUMN BAHIS.estado_cxp IS
    'Estado de la cuenta por pagar despues del movimiento registrado';
COMMENT ON COLUMN BAHIS.usuario_creacion IS
    'Usuario o proceso que genero el registro historico';
COMMENT ON COLUMN BAHIS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro historico';
COMMENT ON COLUMN BAHIS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BAHIS.observaciones IS
    'Notas sobre el movimiento historico o condiciones del evento';
COMMENT ON COLUMN BAHIS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BAHIS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BAHIS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BAHIS (
    codigo_banco           IS 'Banco',
    origen_cuenta          IS 'Origen',
    tipo_cuenta            IS 'Tipo Cta',
    id_cliente             IS 'ID Cliente',
    numero_referencia      IS 'No. Referenc',
    fecha                  IS 'Fecha',
    numero_identificacion  IS 'No. Identif',
    razon_social           IS 'Razon Social',
    email                  IS 'Email',
    telefono               IS 'Telefono',
    codigo_moneda          IS 'Moneda',
    monto_movimiento       IS 'Mto Movim',
    monto_original         IS 'Monto Orig',
    saldo_pendiente        IS 'Saldo',
    fecha_emision          IS 'Fec Emision',
    fecha_vencimiento      IS 'Fec Vencim',
    estado_anterior        IS 'Edo Anterior',
    estado_cxp             IS 'Estado',
    usuario_creacion       IS 'Usr Creacion',
    usuario_actualizacion  IS 'Usr Actualiz',
    version_registro       IS 'Version Reg',
    observaciones          IS 'Observacion',
    estado_registro        IS 'Estado Reg',
    created_at             IS 'Fec Creacion',
    updated_at             IS 'Fec Actualiz'
);

-- ================================================================
-- Etiquetas de descripcion larga por columna (TEXT)
-- ================================================================
LABEL ON COLUMN BAHIS (
    codigo_banco           TEXT IS 'Codigo del banco al que pertenece el registro',
    origen_cuenta          TEXT IS 'Origen de la cuenta por pagar registrada en el',
    tipo_cuenta            TEXT IS 'Tipo de la cuenta por pagar a la que corresponde',
    id_cliente             TEXT IS 'Identificador del cliente o contraparte del',
    numero_referencia      TEXT IS 'Numero de referencia de la cuenta por pagar en el',
    fecha                  TEXT IS 'Fecha en que ocurrio el movimiento o cambio de',
    numero_identificacion  TEXT IS 'Numero de identificacion del beneficiario al',
    razon_social           TEXT IS 'Nombre del beneficiario al momento del movimiento',
    email                  TEXT IS 'Correo del beneficiario al momento del movimiento',
    telefono               TEXT IS 'Telefono del beneficiario al momento del',
    codigo_moneda          TEXT IS 'Moneda de la cuenta por pagar al momento del',
    monto_movimiento       TEXT IS 'Monto del movimiento o evento registrado en el',
    monto_original         TEXT IS 'Monto original de la cuenta por pagar al momento',
    saldo_pendiente        TEXT IS 'Saldo pendiente de la cuenta por pagar despues',
    fecha_emision          TEXT IS 'Fecha de emision de la cuenta por pagar a la que',
    fecha_vencimiento      TEXT IS 'Fecha de vencimiento de la cuenta por pagar al',
    estado_anterior        TEXT IS 'Estado de la cuenta por pagar antes del cambio',
    estado_cxp             TEXT IS 'Estado de la cuenta por pagar despues del',
    usuario_creacion       TEXT IS 'Usuario o proceso que genero el registro historico',
    usuario_actualizacion  TEXT IS 'Usuario que realizo la ultima modificacion del',
    version_registro       TEXT IS 'Version del registro para control de concurrencia',
    observaciones          TEXT IS 'Notas sobre el movimiento historico o condiciones',
    estado_registro        TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at             TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at             TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX IBAHISCOR ON BAHIS (codigo_banco, origen_cuenta);
CREATE INDEX IBAHISFEC ON BAHIS (fecha);