-- ================================================================
-- Nombre de la Tabla  : BAPRC
-- DESCRIPCION         : Maestro de Cuentas por Pagar
-- Objetivo            : Registrar cada obligacion de pago del banco
--                       hacia proveedores y clientes, con el detalle
--                       de origen, monto, vencimiento y estado de pago,
--                       siendo la entidad central del modulo desde la
--                       que se generan amortizaciones, historico y
--                       transacciones contables.
-- Tipo de Tabla       : Maestra / Transaccional
-- Origen de los Datos : Recepcion de facturas, liquidaciones y
--                       obligaciones generadas por otros modulos
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Control de pagos, vencimientos, conciliacion
--                       y generacion de asientos contables
-- Restricciones       : FK hacia BAVEN por numero_proveedor;
--                       FK hacia CUMST por id_cliente
--                       (segun ERD: BAVEN ||--o{ BAPRC)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE BAPRC (
    codigo_banco             FOR COLUMN BAPRCBNK   VARCHAR(20)   NOT NULL,
    codigo_sucursal          FOR COLUMN BAPRCSUC   VARCHAR(20)   NOT NULL,
    origen_cuenta            FOR COLUMN BAPRCORG   VARCHAR(20)   NOT NULL,
    tipo_cuenta              FOR COLUMN BAPRCTCU   VARCHAR(20)   NOT NULL,
    id_cliente               FOR COLUMN BAPRCCLI   VARCHAR(30)   NOT NULL,
    numero_referencia        FOR COLUMN BAPRCREF   VARCHAR(30)   NOT NULL,
    tipo_registro            FOR COLUMN BAPRCTGR   VARCHAR(20)   NOT NULL,
    numero_identificacion    FOR COLUMN BAPRCNID   VARCHAR(30),
    razon_social             FOR COLUMN BAPRCRS    VARCHAR(80),
    email                    FOR COLUMN BAPRCEM    VARCHAR(80),
    telefono                 FOR COLUMN BAPRCTLF   VARCHAR(80),
    monto_original           FOR COLUMN BAPRCMOR   DECIMAL(18,2) NOT NULL DEFAULT 0,
    saldo_pendiente          FOR COLUMN BAPRCSPD   DECIMAL(18,2) NOT NULL DEFAULT 0,
    fecha_emision            FOR COLUMN BAPRCFE    DATE,
    fecha_vencimiento        FOR COLUMN BAPRCFV    DATE,
    fecha_pago               FOR COLUMN BAPRCFP    DATE,
    estado_cxp               FOR COLUMN BAPRCEST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN BAPRCULC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BAPRCUSA   VARCHAR(30),
    version_registro         FOR COLUMN BAPRCVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BAPRCOBS   VARCHAR(120),
    estado_registro          FOR COLUMN BAPRCERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BAPRCCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BAPRCUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BAPRC PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     origen_cuenta, tipo_cuenta,
                                     id_cliente, numero_referencia,
                                     tipo_registro)
    --CONSTRAINT FK_BAPRC_BAVEN FOREIGN KEY (numero_proveedor)
    --    REFERENCES BAVEN (numero_proveedor),
    --CONSTRAINT FK_BAPRC_CUMST FOREIGN KEY (id_cliente)
    --    REFERENCES CUMST (id_cliente)
)
RCDFMT BAPRCR;

RENAME TABLE BAPRC
    TO BAPRC_TABLE FOR SYSTEM NAME BAPRC;

COMMENT ON TABLE BAPRC IS
    'Maestro de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE BAPRC
    IS 'Maestro Cuentas x Pagar';

COMMENT ON COLUMN BAPRC.codigo_banco IS
    'Codigo del banco que registra y administra la cuenta por pagar';
COMMENT ON COLUMN BAPRC.codigo_sucursal IS
    'Codigo de la sucursal responsable de la cuenta por pagar';
COMMENT ON COLUMN BAPRC.origen_cuenta IS
    'Origen que genero la cuenta por pagar: FACTURA, CONTRATO, NOMINA, OTRO';
COMMENT ON COLUMN BAPRC.tipo_cuenta IS
    'Clasificacion de la cuenta por pagar: PROVEEDOR, CLIENTE, INTERNO, FISCAL';
COMMENT ON COLUMN BAPRC.id_cliente IS
    'Identificador del cliente o contraparte de la obligacion (FK CUMST)';
COMMENT ON COLUMN BAPRC.numero_referencia IS
    'Numero de referencia unico de la cuenta por pagar en el banco';
COMMENT ON COLUMN BAPRC.tipo_registro IS
    'Tipo de registro dentro de la cuenta: CABECERA, DETALLE, AJUSTE';
COMMENT ON COLUMN BAPRC.numero_identificacion IS
    'Numero de identificacion fiscal del beneficiario del pago';
COMMENT ON COLUMN BAPRC.razon_social IS
    'Nombre o razon social del beneficiario del pago';
COMMENT ON COLUMN BAPRC.email IS
    'Correo electronico del beneficiario para notificaciones de pago';
COMMENT ON COLUMN BAPRC.telefono IS
    'Telefono del beneficiario para contacto sobre la cuenta por pagar';
COMMENT ON COLUMN BAPRC.monto_original IS
    'Monto bruto de la cuenta por pagar antes de retenciones y descuentos';
COMMENT ON COLUMN BAPRC.saldo_pendiente IS
    'Saldo aun pendiente de pago de la cuenta por pagar';
COMMENT ON COLUMN BAPRC.fecha_emision IS
    'Fecha de registro o emision de la cuenta por pagar en el sistema';
COMMENT ON COLUMN BAPRC.fecha_vencimiento IS
    'Fecha limite para el pago de la cuenta segun condiciones pactadas';
COMMENT ON COLUMN BAPRC.fecha_pago IS
    'Fecha en que fue efectivamente pagada la cuenta por pagar';
COMMENT ON COLUMN BAPRC.estado_cxp IS
    'Estado de la cuenta: PENDIENTE, PARCIAL, PAGADA, VENCIDA, ANULADA';
COMMENT ON COLUMN BAPRC.usuario_creacion IS
    'Usuario del sistema que registro la cuenta por pagar';
COMMENT ON COLUMN BAPRC.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN BAPRC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BAPRC.observaciones IS
    'Notas sobre la cuenta, condiciones de pago o historial de gestion';
COMMENT ON COLUMN BAPRC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BAPRC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BAPRC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BAPRC (
    codigo_banco           IS 'Banco',
    codigo_sucursal        IS 'Sucursal',
    origen_cuenta          IS 'Origen',
    tipo_cuenta            IS 'Tipo Cta',
    id_cliente             IS 'ID Cliente',
    numero_referencia      IS 'No. Referenc',
    tipo_registro          IS 'Tipo Reg',
    numero_identificacion  IS 'No. Identif',
    razon_social           IS 'Razon Social',
    email                  IS 'Email',
    telefono               IS 'Telefono',
    monto_original         IS 'Monto Orig',
    saldo_pendiente        IS 'Saldo Pend',
    fecha_emision          IS 'Fec Emision',
    fecha_vencimiento      IS 'Fec Vencim',
    fecha_pago             IS 'Fec Pago',
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
LABEL ON COLUMN BAPRC (
    codigo_banco           TEXT IS 'Codigo del banco que registra y administra la',
    codigo_sucursal        TEXT IS 'Codigo de la sucursal responsable de la cuenta',
    origen_cuenta          TEXT IS 'Origen que genero la cuenta por pagar: FACTURA,',
    tipo_cuenta            TEXT IS 'Clasificacion de la cuenta por pagar: PROVEEDOR,',
    id_cliente             TEXT IS 'Identificador del cliente o contraparte de la',
    numero_referencia      TEXT IS 'Numero de referencia unico de la cuenta por pagar',
    tipo_registro          TEXT IS 'Tipo de registro dentro de la cuenta: CABECERA,',
    numero_identificacion  TEXT IS 'Numero de identificacion fiscal del beneficiario',
    razon_social           TEXT IS 'Nombre o razon social del beneficiario del pago',
    email                  TEXT IS 'Correo electronico del beneficiario para',
    telefono               TEXT IS 'Telefono del beneficiario para contacto sobre la',
    monto_original         TEXT IS 'Monto bruto de la cuenta por pagar antes de',
    saldo_pendiente        TEXT IS 'Saldo aun pendiente de pago de la cuenta por pagar',
    fecha_emision          TEXT IS 'Fecha de registro o emision de la cuenta por',
    fecha_vencimiento      TEXT IS 'Fecha limite para el pago de la cuenta segun',
    fecha_pago             TEXT IS 'Fecha en que fue efectivamente pagada la cuenta',
    estado_cxp             TEXT IS 'Estado de la cuenta: PENDIENTE, PARCIAL, PAGADA,',
    usuario_creacion       TEXT IS 'Usuario del sistema que registro la cuenta por',
    usuario_actualizacion  TEXT IS 'Usuario que realizo la ultima modificacion del',
    version_registro       TEXT IS 'Version del registro para control de concurrencia',
    observaciones          TEXT IS 'Notas sobre la cuenta, condiciones de pago o',
    estado_registro        TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at             TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at             TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX IBAPRCCSU ON BAPRC (codigo_banco, codigo_sucursal);
CREATE INDEX IBAPRCCAT ON BAPRC (created_at);
