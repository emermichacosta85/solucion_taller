-- ================================================================
-- Nombre de la Tabla  : BAINP
-- DESCRIPCION         : Transacciones Contables Diarias de Cuentas por Pagar
-- Objetivo            : Registrar los asientos contables generados por
--                       las operaciones del dia en el modulo de cuentas
--                       por pagar (pagos realizados, provisiones, ajustes),
--                       para su posterior traspaso al modulo de contabilidad
--                       (GLMST/INPUT) en el proceso de cierre diario.
-- Tipo de Tabla       : Transaccional / Puente Contable
-- Origen de los Datos : Proceso de pago y gestion de cuentas por pagar
-- Permanencia de Datos: Transitoria durante el dia; historica post-cierre
-- Uso de los datos    : Generacion de asientos en INPUT, conciliacion
--                       contable de pagos del dia
-- Restricciones       : FK hacia BAPRC por numero_referencia
--                       (segun ERD: BAPRC ||--o{ BAINP)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE BAINP (
    numero_batch             FOR COLUMN BAINPBAT   VARCHAR(30)   NOT NULL,
    secuencia                FOR COLUMN BAINPSEQ   INT           NOT NULL,
    numero_identificacion    FOR COLUMN BAINPNID   VARCHAR(30),
    razon_social             FOR COLUMN BAINPRS    VARCHAR(80),
    email                    FOR COLUMN BAINPEM    VARCHAR(80),
    telefono                 FOR COLUMN BAINPTLF   VARCHAR(80),
    monto_original           FOR COLUMN BAINPMOR   DECIMAL(18,2),
    saldo_pendiente          FOR COLUMN BAINPSPD   DECIMAL(18,2),
    fecha_emision            FOR COLUMN BAINPFE    DATE,
    fecha_vencimiento        FOR COLUMN BAINPFV    DATE,
    estado_cxp               FOR COLUMN BAINPEST   VARCHAR(20)   NOT NULL,
    estado_asiento           FOR COLUMN BAINPEAS   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN BAINPUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BAINPUSA   VARCHAR(30),
    version_registro         FOR COLUMN BAINPVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BAINPOBS   VARCHAR(120),
    estado_registro          FOR COLUMN BAINPERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BAINPCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BAINPUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BAINP PRIMARY KEY (numero_batch)
)
RCDFMT BAINPR;

RENAME TABLE BAINP
    TO BAINP_TABLE FOR SYSTEM NAME BAINP;

COMMENT ON TABLE BAINP IS
    'Transacciones Contables Diarias de Cuentas por Pagar - Modulo 11';

LABEL ON TABLE BAINP
    IS 'Trans Contab Diarias CxP';

COMMENT ON COLUMN BAINP.numero_batch IS
    'Identificador del lote de transacciones contables del modulo CxP del dia';
COMMENT ON COLUMN BAINP.secuencia IS
    'Numero de secuencia del asiento dentro del lote de transacciones';
COMMENT ON COLUMN BAINP.numero_identificacion IS
    'Numero de identificacion del proveedor o beneficiario del pago';
COMMENT ON COLUMN BAINP.razon_social IS
    'Nombre del proveedor o beneficiario del pago contabilizado';
COMMENT ON COLUMN BAINP.email IS
    'Correo del proveedor o beneficiario (referencia informativa)';
COMMENT ON COLUMN BAINP.telefono IS
    'Telefono del proveedor o beneficiario (referencia informativa)';
COMMENT ON COLUMN BAINP.monto_original IS
    'Monto original de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN BAINP.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar al momento del asiento';
COMMENT ON COLUMN BAINP.fecha_emision IS
    'Fecha de emision de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN BAINP.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar que origina el asiento';
COMMENT ON COLUMN BAINP.estado_cxp IS
    'Estado de la cuenta por pagar al momento de generar el asiento';
COMMENT ON COLUMN BAINP.estado_asiento IS
    'Estado del asiento contable: PENDIENTE, CONTABILIZADO, REVERSADO, ERROR';
COMMENT ON COLUMN BAINP.usuario_creacion IS
    'Usuario o proceso que genero el asiento contable de CxP';
COMMENT ON COLUMN BAINP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN BAINP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BAINP.observaciones IS
    'Notas sobre el asiento, su origen o condiciones especiales de contabilizacion';
COMMENT ON COLUMN BAINP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BAINP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BAINP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BAINP (
    numero_batch           IS 'No. Batch',
    secuencia              IS 'Secuencia',
    numero_identificacion  IS 'No. Identif',
    razon_social           IS 'Razon Social',
    email                  IS 'Email',
    telefono               IS 'Telefono',
    monto_original         IS 'Monto Orig',
    saldo_pendiente        IS 'Saldo Pend',
    fecha_emision          IS 'Fec Emision',
    fecha_vencimiento      IS 'Fec Vencim',
    estado_cxp             IS 'Estado CxP',
    estado_asiento         IS 'Estado Asient',
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
LABEL ON COLUMN BAINP (
    numero_batch           TEXT IS 'Identificador del lote de transacciones contables',
    secuencia              TEXT IS 'Numero de secuencia del asiento dentro del lote',
    numero_identificacion  TEXT IS 'Numero de identificacion del proveedor o',
    razon_social           TEXT IS 'Nombre del proveedor o beneficiario del pago',
    email                  TEXT IS 'Correo del proveedor o beneficiario (referencia',
    telefono               TEXT IS 'Telefono del proveedor o beneficiario (referencia',
    monto_original         TEXT IS 'Monto original de la cuenta por pagar que origina',
    saldo_pendiente        TEXT IS 'Saldo pendiente de la cuenta por pagar al momento',
    fecha_emision          TEXT IS 'Fecha de emision de la cuenta por pagar que',
    fecha_vencimiento      TEXT IS 'Fecha de vencimiento de la cuenta por pagar que',
    estado_cxp             TEXT IS 'Estado de la cuenta por pagar al momento de',
    estado_asiento         TEXT IS 'Estado del asiento contable: PENDIENTE,',
    usuario_creacion       TEXT IS 'Usuario o proceso que genero el asiento contable',
    usuario_actualizacion  TEXT IS 'Usuario que realizo la ultima modificacion del',
    version_registro       TEXT IS 'Version del registro para control de concurrencia',
    observaciones          TEXT IS 'Notas sobre el asiento, su origen o condiciones',
    estado_registro        TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at             TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at             TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX IBAINPBASE ON BAINP (numero_batch, secuencia);
CREATE INDEX IBAINPCAT ON BAINP (created_at);
