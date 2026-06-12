-- ============================================================
-- Nombre de la Tabla  : TLMST
-- DESCRIPCION         : Maestro de Cajeros
-- Objetivo            : Registrar la informacion de los cajeros del banco,
--                       sus saldos por moneda y estado operativo.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Registro y configuracion de cajeros en sucursales
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Control de caja, cierre diario y auditoria de cajeros
-- Restricciones       : PK compuesta por codigo de cajero y moneda
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/TLMST (
    codigo_de_cajero        VARCHAR(20)     NOT NULL    FOR COLUMN TLMSTCAJ,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN TLMSTMON,
    nombre_cajero           VARCHAR(80)                 FOR COLUMN TLMSTNCA,
    codigo_sucursal         VARCHAR(20)                 FOR COLUMN TLMSTSUC,
    saldo_apertura_caja     DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN TLMSTSAC,
    saldo_actual_caja       DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN TLMSTSCA,
    fecha_apertura          DATE                        FOR COLUMN TLMSTFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN TLMSTFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN TLMSTSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN TLMSTSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN TLMSTLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN TLMSTESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN TLMSTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN TLMSTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN TLMSTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN TLMSTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN TLMSTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN TLMSTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN TLMSTUAT,
    CONSTRAINT PK_TLMST PRIMARY KEY (codigo_de_cajero, codigo_moneda)
)
RCDFMT TLMSTR;

RENAME TABLE HNEACOSTA1/TLMST
    TO TLMST FOR SYSTEM NAME TLMST;

COMMENT ON TABLE HNEACOSTA1/TLMST IS
    'Maestro de Cajeros del Banco - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/TLMST
    IS 'Maestro Cajeros';

COMMENT ON COLUMN HNEACOSTA1/TLMST.codigo_de_cajero IS
    'Identificador unico del cajero dentro del sistema bancario';
COMMENT ON COLUMN HNEACOSTA1/TLMST.codigo_moneda IS
    'Codigo ISO de la moneda que maneja el cajero en este registro';
COMMENT ON COLUMN HNEACOSTA1/TLMST.nombre_cajero IS
    'Nombre completo del funcionario asignado a la caja';
COMMENT ON COLUMN HNEACOSTA1/TLMST.codigo_sucursal IS
    'Codigo de la sucursal donde opera el cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.saldo_apertura_caja IS
    'Monto con que el cajero abre operaciones al inicio del dia';
COMMENT ON COLUMN HNEACOSTA1/TLMST.saldo_actual_caja IS
    'Saldo actual de efectivo en la caja del cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.fecha_apertura IS
    'Fecha en que el cajero fue dado de alta en el sistema';
COMMENT ON COLUMN HNEACOSTA1/TLMST.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado por este cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.saldo_actual IS
    'Saldo operativo actual del cajero en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/TLMST.saldo_disponible IS
    'Saldo disponible para operaciones del cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.limite_sobregiro IS
    'Limite maximo de sobregiro permitido en la caja del cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.estado_cuenta IS
    'Estado operativo del cajero: ACTIVO, CERRADO, SUSPENDIDO';
COMMENT ON COLUMN HNEACOSTA1/TLMST.usuario_creacion IS
    'Usuario del sistema que registro al cajero';
COMMENT ON COLUMN HNEACOSTA1/TLMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/TLMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/TLMST.observaciones IS
    'Notas adicionales sobre el cajero o su configuracion';
COMMENT ON COLUMN HNEACOSTA1/TLMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/TLMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/TLMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/TLMST (
    codigo_de_cajero         TEXT IS 'Cod Cajero',
    codigo_moneda            TEXT IS 'Moneda',
    nombre_cajero            TEXT IS 'Nombre Cajero',
    codigo_sucursal          TEXT IS 'Sucursal',
    saldo_apertura_caja      TEXT IS 'Saldo Apertura',
    saldo_actual_caja        TEXT IS 'Saldo Caja',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Caj',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ITLMSTCAT ON HNEACOSTA1/TLMST (created_at);
