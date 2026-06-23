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

CREATE OR REPLACE TABLE BAVEN (
    numero_proveedor         FOR COLUMN BAVENPR    VARCHAR(30)   NOT NULL,
    numero_identificacion    FOR COLUMN BAVENID    VARCHAR(30)   NOT NULL,
    razon_social             FOR COLUMN BAVENRS    VARCHAR(80)   NOT NULL,
    email                    FOR COLUMN BAVENEM    VARCHAR(80),
    telefono                 FOR COLUMN BAVENTLF   VARCHAR(80),
    monto_original           FOR COLUMN BAVENMOR   DECIMAL(18,2) NOT NULL DEFAULT 0,
    saldo_pendiente          FOR COLUMN BAVENSPD   DECIMAL(18,2) NOT NULL DEFAULT 0,
    fecha_emision            FOR COLUMN BAVENFE    DATE,
    fecha_vencimiento        FOR COLUMN BAVENFV    DATE,
    estado_cxp               FOR COLUMN BAVENEST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN BAVENUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BAVENUSA   VARCHAR(30),
    version_registro         FOR COLUMN BAVENVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BAVENOBS   VARCHAR(120),
    estado_registro          FOR COLUMN BAVENERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BAVENCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BAVENUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BAVEN     PRIMARY KEY (numero_proveedor)
    --CONSTRAINT UQ_BAVEN_NID UNIQUE      (numero_identificacion)
)
RCDFMT BAVENR;

RENAME TABLE BAVEN
    TO BAVEN_TABLE FOR SYSTEM NAME BAVEN;

COMMENT ON TABLE BAVEN IS
    'Maestro de Proveedores del Banco - Modulo 11 Proveedores y CxP';

LABEL ON TABLE BAVEN
    IS 'Maestro Proveedores';

COMMENT ON COLUMN BAVEN.numero_proveedor IS
    'Numero unico del proveedor asignado por el banco al momento del alta';
COMMENT ON COLUMN BAVEN.numero_identificacion IS
    'Numero de identificacion fiscal del proveedor (RTN, NIT, RUC, RIF, etc.)';
COMMENT ON COLUMN BAVEN.razon_social IS
    'Nombre legal o razon social del proveedor segun escritura de constitucion';
COMMENT ON COLUMN BAVEN.email IS
    'Correo electronico principal del proveedor para envio de ordenes y facturas';
COMMENT ON COLUMN BAVEN.telefono IS
    'Numero telefonico principal del proveedor';
COMMENT ON COLUMN BAVEN.saldo_pendiente IS
    'Saldo total pendiente de pago al proveedor en todas las cuentas por pagar';
COMMENT ON COLUMN BAVEN.fecha_emision IS
    'Fecha del alta o registro del proveedor en el sistema';
COMMENT ON COLUMN BAVEN.fecha_vencimiento IS
    'Fecha de vencimiento del contrato o convenio con el proveedor si aplica';
COMMENT ON COLUMN BAVEN.estado_cxp IS
    'Estado del proveedor: ACTIVO, INACTIVO, SUSPENDIDO, BLOQUEADO';
COMMENT ON COLUMN BAVEN.usuario_creacion IS
    'Usuario del sistema que registro al proveedor';
COMMENT ON COLUMN BAVEN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN BAVEN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BAVEN.observaciones IS
    'Notas sobre el proveedor, sus condiciones especiales o historial';
COMMENT ON COLUMN BAVEN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BAVEN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BAVEN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BAVEN (
    numero_proveedor       IS 'No. Proveedor',
    numero_identificacion  IS 'No. Identif',
    razon_social           IS 'Razon Social',
    email                  IS 'Email',
    telefono               IS 'Telefono',
    monto_original         IS 'Monto Orig',
    saldo_pendiente        IS 'Saldo Pend',
    fecha_emision          IS 'Fec Alta',
    fecha_vencimiento      IS 'Fec Vencim',
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
LABEL ON COLUMN BAVEN (
    numero_proveedor       TEXT IS 'Numero unico del proveedor asignado por el banco',
    numero_identificacion  TEXT IS 'Numero de identificacion fiscal del proveedor',
    razon_social           TEXT IS 'Nombre legal o razon social del proveedor segun',
    email                  TEXT IS 'Correo electronico principal del proveedor para',
    telefono               TEXT IS 'Numero telefonico principal del proveedor',   
    monto_original         TEXT IS 'Monto total de obligaciones originadas con el',
    saldo_pendiente        TEXT IS 'Saldo total pendiente de pago al proveedor en',
    fecha_emision          TEXT IS 'Fecha del alta o registro del proveedor en el',
    fecha_vencimiento      TEXT IS 'Fecha de vencimiento del contrato o convenio con',
    estado_cxp             TEXT IS 'Estado del proveedor: ACTIVO, INACTIVO,',
    usuario_creacion       TEXT IS 'Usuario del sistema que registro al proveedor',
    usuario_actualizacion  TEXT IS 'Usuario del sistema que realizo la ultima',
    version_registro       TEXT IS 'Version del registro para control de concurrencia',
    observaciones          TEXT IS 'Notas sobre el proveedor, sus condiciones',
    estado_registro        TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at             TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at             TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX IBAVENCAT ON BAVEN (created_at);
CREATE INDEX IBAVENPRO ON BAVEN (numero_proveedor);