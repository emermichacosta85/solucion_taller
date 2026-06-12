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

CREATE OR REPLACE TABLE HNEACOSTA1/OVDRF (
    id                      BIGINT          NOT NULL    FOR COLUMN OVDRFID,
    numero_cuenta           VARCHAR(24)                 FOR COLUMN OVDRFCTA,
    codigo_banco            VARCHAR(20)                 FOR COLUMN OVDRFBNK,
    codigo_sucursal         VARCHAR(20)                 FOR COLUMN OVDRFSUC,
    codigo_moneda           VARCHAR(20)                 FOR COLUMN OVDRFMON,
    monto_sobregiro         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN OVDRFMSO,
    tasa_interes_diaria     DECIMAL(10,6)               FOR COLUMN OVDRFTID,
    interes_generado        DECIMAL(18,2)               FOR COLUMN OVDRFIG,
    fecha_sobregiro         DATE                        FOR COLUMN OVDRFFSO,
    dias_acumulados         INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN OVDRFDAC,
    estado_sobregiro        VARCHAR(20)                 FOR COLUMN OVDRFEST,
    fecha_apertura          DATE                        FOR COLUMN OVDRFFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN OVDRFFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN OVDRFSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN OVDRFSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN OVDRFLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN OVDRFESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN OVDRFUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN OVDRFUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN OVDRFVRS,
    observaciones           VARCHAR(120)                FOR COLUMN OVDRFOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN OVDRFERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN OVDRFCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN OVDRFUAT,
    CONSTRAINT PK_OVDRF PRIMARY KEY (id)
)
RCDFMT OVDRFR;

RENAME TABLE HNEACOSTA1/OVDRF
    TO OVDRF FOR SYSTEM NAME OVDRF;

COMMENT ON TABLE HNEACOSTA1/OVDRF IS
    'Archivo Diario de Sobregiros en Cuentas de Detalle - Modulo 3';

LABEL ON TABLE HNEACOSTA1/OVDRF
    IS 'Sobregiros Diarios';

COMMENT ON COLUMN HNEACOSTA1/OVDRF.id IS
    'Identificador tecnico unico autogenerado del registro de sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.numero_cuenta IS
    'Numero de cuenta corriente que incurrio en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.codigo_moneda IS
    'Codigo ISO de la moneda en la que se registra el sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.monto_sobregiro IS
    'Monto del saldo negativo incurrido en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.tasa_interes_diaria IS
    'Tasa de interes diaria aplicable al monto en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.interes_generado IS
    'Monto de interes calculado por el sobregiro en el dia';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.fecha_sobregiro IS
    'Fecha en que se origino o registro el sobregiro en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.dias_acumulados IS
    'Numero de dias consecutivos con saldo en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.estado_sobregiro IS
    'Estado del sobregiro: ACTIVO, REGULARIZADO, EN_COBRO';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.fecha_apertura IS
    'Fecha de apertura de la cuenta que incurrio en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con el sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.saldo_actual IS
    'Saldo negativo actual de la cuenta en sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.saldo_disponible IS
    'Saldo disponible de la cuenta (negativo cuando esta en sobregiro)';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.limite_sobregiro IS
    'Limite maximo de sobregiro autorizado para la cuenta';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro del sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.usuario_creacion IS
    'Usuario o proceso que registro el sobregiro en el sistema';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro de sobregiro';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.observaciones IS
    'Notas sobre la gestion del sobregiro o acuerdos de regularizacion';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/OVDRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/OVDRF (
    id                       TEXT IS 'ID Sobregiro',
    numero_cuenta            TEXT IS 'No. Cuenta',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    monto_sobregiro          TEXT IS 'Monto Sobr',
    tasa_interes_diaria      TEXT IS 'Tasa Diaria',
    interes_generado         TEXT IS 'Interes Gen',
    fecha_sobregiro          TEXT IS 'Fec Sobregir',
    dias_acumulados          TEXT IS 'Dias Acum',
    estado_sobregiro         TEXT IS 'Estado Sobr',
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

CREATE INDEX HNEACOSTA1/IOVDRFCTA ON HNEACOSTA1/OVDRF (numero_cuenta);
CREATE INDEX HNEACOSTA1/IOVDRFFSO ON HNEACOSTA1/OVDRF (fecha_sobregiro);
CREATE INDEX HNEACOSTA1/IOVDRFCAT ON HNEACOSTA1/OVDRF (created_at);
