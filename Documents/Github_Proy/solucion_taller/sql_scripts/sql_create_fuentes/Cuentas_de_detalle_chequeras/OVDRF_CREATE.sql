-- ============================================================
-- Nombre de la Tabla  : OVDRF
-- DESCRIPCION         : Archivo diario de Sobregiros
-- Objetivo            : Registrar los sobregiros ocurridos en cuentas de
--                       detalle durante la jornada operativa para control
--                       y cobro de comisiones e intereses.
-- Tipo de Tabla       : Transaccional / Operativa Diaria
-- Origen de los Datos : Procesamiento de transacciones que generan saldo negativo
-- Permanencia de Datos: Diaria (se purga al cierre con traslado a historico)
-- Uso de los datos    : Cobro de intereses, alertas operativas y control de riesgo
-- Restricciones       : PK tecnica con id autogenerado; sin clave natural declarada
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE OVDRF (
    id                      FOR COLUMN OVDRFID BIGINT          NOT NULL    ,
    fecha_apertura          FOR COLUMN OVDRFFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN OVDRFFUT DATE                       ,
    saldo_actual            FOR COLUMN OVDRFSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN OVDRFSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN OVDRFLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN OVDRFESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN OVDRFUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN OVDRFUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN OVDRFVRS INT             NOT NULL
                                            DEFAULT 1  ,
    observaciones           FOR COLUMN OVDRFOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN OVDRFERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN OVDRFCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN OVDRFUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_OVDRF PRIMARY KEY (id)
)
RCDFMT OVDRFR;

RENAME TABLE OVDRF
    TO OVDRF_TABLE FOR SYSTEM NAME OVDRF;

COMMENT ON TABLE OVDRF IS
    'Archivo Diario de Sobregiros en Cuentas de Detalle - Modulo 3';

LABEL ON TABLE OVDRF
    IS 'Sobregiros Diarios';

COMMENT ON COLUMN OVDRF.id IS
    'Identificador tecnico unico autogenerado del registro de sobregiro';
COMMENT ON COLUMN OVDRF.fecha_apertura IS
    'Fecha de apertura de la cuenta que incurrio en sobregiro';
COMMENT ON COLUMN OVDRF.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con el sobregiro';
COMMENT ON COLUMN OVDRF.saldo_actual IS
    'Saldo negativo actual de la cuenta en sobregiro';
COMMENT ON COLUMN OVDRF.saldo_disponible IS
    'Saldo disponible de la cuenta (negativo cuando esta en sobregiro)';
COMMENT ON COLUMN OVDRF.limite_sobregiro IS
    'Limite maximo de sobregiro autorizado para la cuenta';
COMMENT ON COLUMN OVDRF.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro del sobregiro';
COMMENT ON COLUMN OVDRF.usuario_creacion IS
    'Usuario o proceso que registro el sobregiro en el sistema';
COMMENT ON COLUMN OVDRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro de sobregiro';
COMMENT ON COLUMN OVDRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN OVDRF.observaciones IS
    'Notas sobre la gestion del sobregiro o acuerdos de regularizacion';
COMMENT ON COLUMN OVDRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN OVDRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN OVDRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN OVDRF (
    id                       TEXT IS 'ID Sobregiro',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Cta',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IOVDRFFPK ON OVDRF (id);
CREATE INDEX IOVDRFCAT ON OVDRF (created_at);
