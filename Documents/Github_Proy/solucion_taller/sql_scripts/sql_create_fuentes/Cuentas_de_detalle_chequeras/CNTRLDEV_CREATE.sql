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

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLDEV (
    codigo_causal           VARCHAR(20)     NOT NULL    FOR COLUMN CNTDVCAU,
    descripcion_causal      VARCHAR(120)    NOT NULL    FOR COLUMN CNTDVDSC,
    codigo_regulatorio      VARCHAR(20)                 FOR COLUMN CNTDVCRG,
    aplica_penalidad        CHAR(1)         NOT NULL
                                            DEFAULT 'N' FOR COLUMN CNTDVAPL,
    monto_penalidad         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDVMPE,
    porcentaje_penalidad    DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTDVPPE,
    impacta_historial       CHAR(1)         NOT NULL
                                            DEFAULT 'S' FOR COLUMN CNTDVIMP,
    vigente_desde           DATE                        FOR COLUMN CNTDVVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTDVVHA,
    fecha_apertura          DATE                        FOR COLUMN CNTDVFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CNTDVFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CNTDVSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CNTDVSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CNTDVLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CNTDVESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTDVUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTDVUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTDVVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTDVOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTDVERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTDVCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTDVUAT,
    CONSTRAINT PK_CNTRLDEV PRIMARY KEY (codigo_causal)
)
RCDFMT CNTRLDR;

RENAME TABLE HNEACOSTA1/CNTRLDEV
    TO CNTRLDEV FOR SYSTEM NAME CNTRLDEV;

COMMENT ON TABLE HNEACOSTA1/CNTRLDEV IS
    'Causales de Devolucion de Cheques - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/CNTRLDEV
    IS 'Causales Devol Cheques';

COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.codigo_causal IS
    'Codigo unico que identifica la causal de devolucion del cheque';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.descripcion_causal IS
    'Descripcion completa de la causal de devolucion segun normativa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.codigo_regulatorio IS
    'Codigo asignado por el banco central o entidad reguladora a la causal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.aplica_penalidad IS
    'Indica si esta causal conlleva cobro de penalidad al librador: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.monto_penalidad IS
    'Monto fijo de penalidad cobrado al librador por esta causal de devolucion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.porcentaje_penalidad IS
    'Porcentaje sobre el monto del cheque que se cobra como penalidad';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.impacta_historial IS
    'Indica si la devolucion por esta causal afecta el historial crediticio: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.vigente_desde IS
    'Fecha desde la que esta causal de devolucion esta vigente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.vigente_hasta IS
    'Fecha de vigencia final de la causal, nula si es indefinida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.fecha_apertura IS
    'Fecha de alta de la causal en el catalogo del sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.fecha_ultima_transaccion IS
    'Fecha de la ultima utilizacion o modificacion de la causal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.estado_cuenta IS
    'Estado de la causal en el catalogo: ACTIVA, DEROGADA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.usuario_creacion IS
    'Usuario administrador que registro la causal en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la causal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.observaciones IS
    'Notas sobre la aplicacion, restricciones o excepciones de la causal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLDEV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLDEV (
    codigo_causal            TEXT IS 'Cod Causal',
    descripcion_causal       TEXT IS 'Desc Causal',
    codigo_regulatorio       TEXT IS 'Cod Reg',
    aplica_penalidad         TEXT IS 'Apl Penal',
    monto_penalidad          TEXT IS 'Monto Penal',
    porcentaje_penalidad     TEXT IS 'Porc Penal',
    impacta_historial        TEXT IS 'Imp Histor',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
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

CREATE INDEX HNEACOSTA1/ICNTDVCAT ON HNEACOSTA1/CNTRLDEV (created_at);
