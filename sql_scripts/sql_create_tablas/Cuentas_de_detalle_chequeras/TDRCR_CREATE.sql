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

CREATE OR REPLACE TABLE TDRCR (
    codigo_de_transaccion   FOR COLUMN TDRCRCTX VARCHAR(20)     NOT NULL    ,
    fecha_apertura          FOR COLUMN TDRCRFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN TDRCRFUT DATE                       ,
    saldo_actual            FOR COLUMN TDRCRSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN TDRCRSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN TDRCRLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN TDRCRESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN TDRCRUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN TDRCRUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN TDRCRVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN TDRCROBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN TDRCRERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN TDRCRCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN TDRCRUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_TDRCR PRIMARY KEY (codigo_de_transaccion)
)
RCDFMT TDRCR;

RENAME TABLE TDRCR
    TO TDRCR_TABLE FOR SYSTEM NAME TDRCR;

COMMENT ON TABLE TDRCR IS
    'Catalogo de Transacciones de Cajero - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE TDRCR
    IS 'Catalogo Trans Cajero';

COMMENT ON COLUMN TDRCR.codigo_de_transaccion IS
    'Codigo unico que identifica el tipo de transaccion de cajero';
COMMENT ON COLUMN TDRCR.fecha_apertura IS
    'Fecha desde la que esta vigente este tipo de transaccion';
COMMENT ON COLUMN TDRCR.fecha_ultima_transaccion IS
    'Fecha del ultimo uso de este tipo de transaccion';
COMMENT ON COLUMN TDRCR.saldo_actual IS
    'Campo de referencia operativa para control de saldo en catalogo';
COMMENT ON COLUMN TDRCR.saldo_disponible IS
    'Campo de referencia operativa para control de disponible en catalogo';
COMMENT ON COLUMN TDRCR.limite_sobregiro IS
    'Limite de sobregiro asociado a este tipo de transaccion si aplica';
COMMENT ON COLUMN TDRCR.estado_cuenta IS
    'Estado del tipo de transaccion: ACTIVO, SUSPENDIDO, DEPRECADO';
COMMENT ON COLUMN TDRCR.usuario_creacion IS
    'Usuario administrador que creo el tipo de transaccion en catalogo';
COMMENT ON COLUMN TDRCR.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del catalogo';
COMMENT ON COLUMN TDRCR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN TDRCR.observaciones IS
    'Notas de configuracion o restricciones del tipo de transaccion';
COMMENT ON COLUMN TDRCR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN TDRCR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN TDRCR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN TDRCR (
    codigo_de_transaccion    TEXT IS 'Cod Transacc',
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

CREATE INDEX ITDRCRCAT ON TDRCR (created_at);
CREATE INDEX ITDRCRPK ON TDRCR (codigo_de_transaccion);