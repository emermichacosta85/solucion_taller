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

CREATE OR REPLACE TABLE TLMST (
    codigo_de_cajero        FOR COLUMN TLMSTCAJ VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN TLMSTMON VARCHAR(20)     NOT NULL    ,
    fecha_apertura          FOR COLUMN TLMSTFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN TLMSTFUT DATE                       ,
    saldo_actual            FOR COLUMN TLMSTSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN TLMSTSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN TLMSTLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN TLMSTESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN TLMSTUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN TLMSTUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN TLMSTVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN TLMSTOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN TLMSTERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN TLMSTCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN TLMSTUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_TLMST PRIMARY KEY (codigo_de_cajero, codigo_moneda)
)
RCDFMT TLMSTR;

RENAME TABLE TLMST
    TO TLMST_TABLE FOR SYSTEM NAME TLMST;

COMMENT ON TABLE TLMST IS
    'Maestro de Cajeros del Banco - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE TLMST
    IS 'Maestro Cajeros';

COMMENT ON COLUMN TLMST.codigo_de_cajero IS
    'Identificador unico del cajero dentro del sistema bancario';
COMMENT ON COLUMN TLMST.codigo_moneda IS
    'Codigo ISO de la moneda que maneja el cajero en este registro';
COMMENT ON COLUMN TLMST.fecha_apertura IS
    'Fecha en que el cajero fue dado de alta en el sistema';
COMMENT ON COLUMN TLMST.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado por este cajero';
COMMENT ON COLUMN TLMST.saldo_actual IS
    'Saldo operativo actual del cajero en la moneda indicada';
COMMENT ON COLUMN TLMST.saldo_disponible IS
    'Saldo disponible para operaciones del cajero';
COMMENT ON COLUMN TLMST.limite_sobregiro IS
    'Limite maximo de sobregiro permitido en la caja del cajero';
COMMENT ON COLUMN TLMST.estado_cuenta IS
    'Estado operativo del cajero: ACTIVO, CERRADO, SUSPENDIDO';
COMMENT ON COLUMN TLMST.usuario_creacion IS
    'Usuario del sistema que registro al cajero';
COMMENT ON COLUMN TLMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN TLMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN TLMST.observaciones IS
    'Notas adicionales sobre el cajero o su configuracion';
COMMENT ON COLUMN TLMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN TLMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN TLMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN TLMST (
    codigo_de_cajero         TEXT IS 'Cod Cajero',
    codigo_moneda            TEXT IS 'Moneda',
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

CREATE INDEX ITLMSTCAT ON TLMST (created_at);
CREATE INDEX ITLMSTPK ON TLMST (codigo_de_cajero, codigo_moneda);
