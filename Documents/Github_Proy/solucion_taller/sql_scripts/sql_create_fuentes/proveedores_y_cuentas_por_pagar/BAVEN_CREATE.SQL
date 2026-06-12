-- ================================================================
-- Nombre de la Tabla  : BAVEN
-- DESCRIPCION         : Maestro de Proveedores
-- Objetivo            : Registrar y administrar el catalogo de proveedores
--                       del banco, almacenando su informacion de identificacion,
--                       contacto, condiciones comerciales y estado, siendo
--                       la entidad raiz del modulo de cuentas por pagar
--                       desde la que se originan todas las obligaciones.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Alta de proveedores por el area de compras
--                       o cuentas por pagar del banco
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Generacion de cuentas por pagar, consulta de
--                       condiciones de pago y reportes de obligaciones
-- Restricciones       : PK por numero_proveedor; UNIQUE sobre
--                       numero_identificacion para evitar duplicados;
--                       tabla raiz del modulo, debe crearse primero
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/BAVEN (
    numero_proveedor         VARCHAR(30)    NOT NULL     FOR COLUMN BAVENPR,
    numero_identificacion    VARCHAR(30)    NOT NULL     FOR COLUMN BAVENID,
    tipo_identificacion      VARCHAR(20)                 FOR COLUMN BAVENTID,
    razon_social             VARCHAR(80)    NOT NULL     FOR COLUMN BAVENRS,
    nombre_comercial         VARCHAR(80)                 FOR COLUMN BAVENNC,
    tipo_persona             VARCHAR(20)                 FOR COLUMN BAVENTP,
    tipo_proveedor           VARCHAR(20)                 FOR COLUMN BAVENTPV,
    email                    VARCHAR(80)                 FOR COLUMN BAVENEM,
    telefono                 VARCHAR(80)                 FOR COLUMN BAVENTLF,
    direccion                VARCHAR(120)                FOR COLUMN BAVENDIR,
    ciudad                   VARCHAR(50)                 FOR COLUMN BAVENCIU,
    pais                     VARCHAR(50)                 FOR COLUMN BAVENPAS,
    codigo_banco_pago        VARCHAR(20)                 FOR COLUMN BAVENCBP,
    numero_cuenta_pago       VARCHAR(24)                 FOR COLUMN BAVENNCP,
    tipo_cuenta_pago         VARCHAR(20)                 FOR COLUMN BAVENTCP,
    moneda_pago              VARCHAR(20)                 FOR COLUMN BAVENMON,
    plazo_pago_dias          INT            NOT NULL
                                            DEFAULT 30   FOR COLUMN BAVENPPD,
    descuento_pronto_pago    DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAVENDPP,
    retencion_iva_pct        DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAVENRIV,
    retencion_isr_pct        DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAVENRIS,
    monto_original           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAVENMOR,
    saldo_pendiente          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN BAVENSPD,
    fecha_emision            DATE                        FOR COLUMN BAVENFE,
    fecha_vencimiento        DATE                        FOR COLUMN BAVENFV,
    estado_cxp               VARCHAR(20)    NOT NULL     FOR COLUMN BAVENEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN BAVENUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN BAVENUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN BAVENVRS,
    observaciones            VARCHAR(120)                FOR COLUMN BAVENOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN BAVENERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAVENCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN BAVENUAT,
    CONSTRAINT PK_BAVEN     PRIMARY KEY (numero_proveedor),
    CONSTRAINT UQ_BAVEN_NID UNIQUE      (numero_identificacion)
)
RCDFMT BAVENR;

RENAME TABLE HNEACOSTA1/BAVEN
    TO BAVEN FOR SYSTEM NAME BAVEN;

COMMENT ON TABLE HNEACOSTA1/BAVEN IS
    'Maestro de Proveedores del Banco - Modulo 11 Proveedores y CxP';

LABEL ON TABLE HNEACOSTA1/BAVEN
    IS 'Maestro Proveedores';

COMMENT ON COLUMN HNEACOSTA1/BAVEN.numero_proveedor IS
    'Numero unico del proveedor asignado por el banco al momento del alta';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.numero_identificacion IS
    'Numero de identificacion fiscal del proveedor (RTN, NIT, RUC, RIF, etc.)';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.tipo_identificacion IS
    'Tipo de documento de identificacion fiscal del proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.razon_social IS
    'Nombre legal o razon social del proveedor segun escritura de constitucion';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.nombre_comercial IS
    'Nombre comercial o marca bajo la que opera el proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.tipo_persona IS
    'Naturaleza juridica del proveedor: NATURAL, JURIDICA';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.tipo_proveedor IS
    'Clasificacion del proveedor: BIENES, SERVICIOS, TECNOLOGIA, INFRAESTRUCTURA, OTRO';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.email IS
    'Correo electronico principal del proveedor para envio de ordenes y facturas';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.telefono IS
    'Numero telefonico principal del proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.direccion IS
    'Direccion fiscal completa del proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.ciudad IS
    'Ciudad donde esta domiciliado el proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.pais IS
    'Pais de domicilio fiscal del proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.codigo_banco_pago IS
    'Codigo del banco donde el proveedor recibe los pagos';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.numero_cuenta_pago IS
    'Numero de cuenta bancaria del proveedor para recibir pagos';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.tipo_cuenta_pago IS
    'Tipo de cuenta del proveedor: CORRIENTE, AHORRO, u otro segun banco';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.moneda_pago IS
    'Codigo ISO de la moneda preferida por el proveedor para recibir pagos';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.plazo_pago_dias IS
    'Plazo en dias para el pago de facturas segun condiciones pactadas';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.descuento_pronto_pago IS
    'Porcentaje de descuento aplicado si se paga antes del vencimiento';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.retencion_iva_pct IS
    'Porcentaje de retencion de IVA aplicable a este proveedor por normativa';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.retencion_isr_pct IS
    'Porcentaje de retencion de ISR o impuesto sobre la renta aplicable';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.monto_original IS
    'Monto total de obligaciones originadas con el proveedor (referencia acumulada)';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.saldo_pendiente IS
    'Saldo total pendiente de pago al proveedor en todas las cuentas por pagar';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.fecha_emision IS
    'Fecha del alta o registro del proveedor en el sistema';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.fecha_vencimiento IS
    'Fecha de vencimiento del contrato o convenio con el proveedor si aplica';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.estado_cxp IS
    'Estado del proveedor: ACTIVO, INACTIVO, SUSPENDIDO, BLOQUEADO';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.usuario_creacion IS
    'Usuario del sistema que registro al proveedor';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.observaciones IS
    'Notas sobre el proveedor, sus condiciones especiales o historial';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/BAVEN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/BAVEN (
    numero_proveedor         TEXT IS 'No. Proveedor',
    numero_identificacion    TEXT IS 'No. Identif',
    tipo_identificacion      TEXT IS 'Tipo ID',
    razon_social             TEXT IS 'Razon Social',
    nombre_comercial         TEXT IS 'Nom Comercial',
    tipo_persona             TEXT IS 'Tipo Persona',
    tipo_proveedor           TEXT IS 'Tipo Prov',
    email                    TEXT IS 'Email',
    telefono                 TEXT IS 'Telefono',
    direccion                TEXT IS 'Direccion',
    ciudad                   TEXT IS 'Ciudad',
    pais                     TEXT IS 'Pais',
    codigo_banco_pago        TEXT IS 'Banco Pago',
    numero_cuenta_pago       TEXT IS 'Cta Pago',
    tipo_cuenta_pago         TEXT IS 'Tipo Cta',
    moneda_pago              TEXT IS 'Moneda Pago',
    plazo_pago_dias          TEXT IS 'Plazo Pago',
    descuento_pronto_pago    TEXT IS 'Desc PP',
    retencion_iva_pct        TEXT IS 'Ret IVA',
    retencion_isr_pct        TEXT IS 'Ret ISR',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    fecha_emision            TEXT IS 'Fec Alta',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_cxp               TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IBAVENCAT ON HNEACOSTA1/BAVEN (created_at);
CREATE INDEX HNEACOSTA1/IBAVENNID ON HNEACOSTA1/BAVEN (numero_identificacion);
CREATE INDEX HNEACOSTA1/IBAVENEST ON HNEACOSTA1/BAVEN (estado_cxp);
CREATE INDEX HNEACOSTA1/IBAVENTPV ON HNEACOSTA1/BAVEN (tipo_proveedor);
