-- ============================================================
-- Nombre de la Tabla  : TDRCR
-- DESCRIPCION         : Maestro de Transacciones de Cajero
-- Objetivo            : Catalogar los tipos de transacciones que puede
--                       realizar un cajero, con sus parametros de control.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion del sistema por administracion
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Validacion y clasificacion de transacciones de caja
-- Restricciones       : PK por codigo de transaccion
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/TDRCR (
    codigo_de_transaccion   VARCHAR(20)     NOT NULL    FOR COLUMN TDRCRCTX,
    descripcion             VARCHAR(120)                FOR COLUMN TDRCRDSC,
    tipo_movimiento         CHAR(1)                     FOR COLUMN TDRCRTMV,
    afecta_saldo            CHAR(1)         NOT NULL
                                            DEFAULT 'S' FOR COLUMN TDRCRASM,
    requiere_autorizacion   CHAR(1)         NOT NULL
                                            DEFAULT 'N' FOR COLUMN TDRCRRAT,
    cuenta_contable_debito  VARCHAR(24)                 FOR COLUMN TDRCRCTD,
    cuenta_contable_credito VARCHAR(24)                 FOR COLUMN TDRCRCTC,
    fecha_apertura          DATE                        FOR COLUMN TDRCRFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN TDRCRFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN TDRCRSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN TDRCRSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN TDRCRLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN TDRCRESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN TDRCRUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN TDRCRUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN TDRCRVRS,
    observaciones           VARCHAR(120)                FOR COLUMN TDRCROBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN TDRCRERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN TDRCRCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN TDRCRUAT,
    CONSTRAINT PK_TDRCR PRIMARY KEY (codigo_de_transaccion)
)
RCDFMT TDRCR;

RENAME TABLE HNEACOSTA1/TDRCR
    TO TDRCR FOR SYSTEM NAME TDRCR;

COMMENT ON TABLE HNEACOSTA1/TDRCR IS
    'Catalogo de Transacciones de Cajero - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/TDRCR
    IS 'Catalogo Trans Cajero';

COMMENT ON COLUMN HNEACOSTA1/TDRCR.codigo_de_transaccion IS
    'Codigo unico que identifica el tipo de transaccion de cajero';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.descripcion IS
    'Descripcion legible del tipo de transaccion para operadores';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.tipo_movimiento IS
    'Tipo de movimiento que genera: D=Debito, C=Credito, A=Ambos';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.afecta_saldo IS
    'Indica si la transaccion impacta el saldo de la cuenta: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.requiere_autorizacion IS
    'Indica si la transaccion requiere autorizacion de supervisor: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.cuenta_contable_debito IS
    'Cuenta contable que se debita al procesar este tipo de transaccion';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.cuenta_contable_credito IS
    'Cuenta contable que se acredita al procesar este tipo de transaccion';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.fecha_apertura IS
    'Fecha desde la que esta vigente este tipo de transaccion';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.fecha_ultima_transaccion IS
    'Fecha del ultimo uso de este tipo de transaccion';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.saldo_actual IS
    'Campo de referencia operativa para control de saldo en catalogo';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.saldo_disponible IS
    'Campo de referencia operativa para control de disponible en catalogo';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.limite_sobregiro IS
    'Limite de sobregiro asociado a este tipo de transaccion si aplica';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.estado_cuenta IS
    'Estado del tipo de transaccion: ACTIVO, SUSPENDIDO, DEPRECADO';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.usuario_creacion IS
    'Usuario administrador que creo el tipo de transaccion en catalogo';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del catalogo';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.observaciones IS
    'Notas de configuracion o restricciones del tipo de transaccion';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/TDRCR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/TDRCR (
    codigo_de_transaccion    TEXT IS 'Cod Transacc',
    descripcion              TEXT IS 'Descripcion',
    tipo_movimiento          TEXT IS 'Tipo Movim',
    afecta_saldo             TEXT IS 'Afecta Saldo',
    requiere_autorizacion    TEXT IS 'Req Autoriz',
    cuenta_contable_debito   TEXT IS 'Cta Deb',
    cuenta_contable_credito  TEXT IS 'Cta Cre',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ITDRCRCAT ON HNEACOSTA1/TDRCR (created_at);
