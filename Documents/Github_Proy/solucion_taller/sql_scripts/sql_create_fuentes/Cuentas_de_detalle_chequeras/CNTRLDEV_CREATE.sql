-- ============================================================
-- Nombre de la Tabla  : CNTRLDEV
-- DESCRIPCION         : Definicion de las Causales de Devolucion de Cheques
-- Objetivo            : Catalogar los motivos validos por los que un cheque
--                       puede ser devuelto, con su descripcion y parametros
--                       de penalidad asociados.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Normativa bancaria y regulacion del banco central
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Proceso de devolucion de cheques (DEVOL), reportes regulatorios
-- Restricciones       : PK por codigo de causal
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE CNTRLDEV (
    codigo_causal           FOR COLUMN CNTDVCAU VARCHAR(20)     NOT NULL    ,
    fecha_apertura          FOR COLUMN CNTDVFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CNTDVFUT DATE                       ,
    saldo_actual            FOR COLUMN CNTDVSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN CNTDVSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN CNTDVLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN CNTDVESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN CNTDVUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN CNTDVUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN CNTDVVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CNTDVOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN CNTDVERE CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN CNTDVCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CNTDVUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLDEV PRIMARY KEY (codigo_causal)
)
RCDFMT CNTRLDR;

RENAME TABLE CNTRLDEV
    TO CNTRLDEV_TABLE FOR SYSTEM NAME CNTRLDEV;

COMMENT ON TABLE CNTRLDEV IS
    'Causales de Devolucion de Cheques - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE CNTRLDEV
    IS 'Causales Devol Cheques';

COMMENT ON COLUMN CNTRLDEV.codigo_causal IS
    'Codigo unico que identifica la causal de devolucion del cheque';
COMMENT ON COLUMN CNTRLDEV.fecha_apertura IS
    'Fecha de alta de la causal en el catalogo del sistema';
COMMENT ON COLUMN CNTRLDEV.fecha_ultima_transaccion IS
    'Fecha de la ultima utilizacion o modificacion de la causal';
COMMENT ON COLUMN CNTRLDEV.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDEV.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDEV.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDEV.estado_cuenta IS
    'Estado de la causal en el catalogo: ACTIVA, DEROGADA, EN_REVISION';
COMMENT ON COLUMN CNTRLDEV.usuario_creacion IS
    'Usuario administrador que registro la causal en el sistema';
COMMENT ON COLUMN CNTRLDEV.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la causal';
COMMENT ON COLUMN CNTRLDEV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLDEV.observaciones IS
    'Notas sobre la aplicacion, restricciones o excepciones de la causal';
COMMENT ON COLUMN CNTRLDEV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLDEV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLDEV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLDEV (
    codigo_causal            TEXT IS 'Cod Causal',
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

CREATE INDEX ICNTDVCAT ON CNTRLDEV (created_at);
