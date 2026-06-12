-- ============================================================
-- Nombre de la Tabla  : CHSTS
-- DESCRIPCION         : Maestro de cambio de estatus a cuentas de detalle
-- Objetivo            : Registrar el historial de cambios de estado aplicados
--                       a cuentas de detalle (bloqueos, activaciones, cierres).
-- Tipo de Tabla       : Historica / Auditoria
-- Origen de los Datos : Operaciones de cambio de estado por operadores o procesos
-- Permanencia de Datos: Historica (auditoria regulatoria)
-- Uso de los datos    : Trazabilidad de estados de cuentas y auditoria
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CHSTS (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CHSTSBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN CHSTSSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN CHSTSMON,
    cuenta_contable         VARCHAR(24)     NOT NULL    FOR COLUMN CHSTSCTC,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN CHSTSCTA,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CHSTSSEQ,
    estado_anterior         VARCHAR(20)                 FOR COLUMN CHSTSEAN,
    estado_nuevo            VARCHAR(20)     NOT NULL    FOR COLUMN CHSTSENW,
    fecha_cambio            DATE            NOT NULL    FOR COLUMN CHSTSFCH,
    hora_cambio             TIME                        FOR COLUMN CHSTSHCH,
    motivo_cambio           VARCHAR(120)                FOR COLUMN CHSTSMOT,
    referencia_autorizacion VARCHAR(50)                 FOR COLUMN CHSTSREF,
    fecha_apertura          DATE                        FOR COLUMN CHSTSFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CHSTSFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CHSTSSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CHSTSSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CHSTSLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CHSTSESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CHSTSUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CHSTSUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CHSTSVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CHSTSOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CHSTSERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHSTSCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHSTSUAT,
    CONSTRAINT PK_CHSTS PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     numero_cuenta, secuencia),
    CONSTRAINT FK_CHSTS_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT CHSTSR;

RENAME TABLE HNEACOSTA1/CHSTS
    TO CHSTS FOR SYSTEM NAME CHSTS;

COMMENT ON TABLE HNEACOSTA1/CHSTS IS
    'Historial de Cambios de Estado de Cuentas de Detalle - Modulo 3';

LABEL ON TABLE HNEACOSTA1/CHSTS
    IS 'Cambios Estado Cuentas';

COMMENT ON COLUMN HNEACOSTA1/CHSTS.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta con cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.cuenta_contable IS
    'Cuenta contable del plan de cuentas asociada a la cuenta';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.numero_cuenta IS
    'Numero de cuenta cuyo estado fue modificado (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.secuencia IS
    'Numero de orden del cambio de estado para historial cronologico';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.estado_anterior IS
    'Estado que tenia la cuenta antes del cambio registrado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.estado_nuevo IS
    'Nuevo estado aplicado a la cuenta: ACTIVA, BLOQUEADA, CERRADA, etc.';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.fecha_cambio IS
    'Fecha en que se aplico el cambio de estado a la cuenta';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.hora_cambio IS
    'Hora exacta en que se realizo el cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.motivo_cambio IS
    'Descripcion del motivo o causa que origino el cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.referencia_autorizacion IS
    'Numero de referencia de la autorizacion que respalda el cambio';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.fecha_apertura IS
    'Fecha de apertura de la cuenta cuyo estado fue modificado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento previo al cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.saldo_actual IS
    'Saldo contable de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.limite_sobregiro IS
    'Limite de sobregiro de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.estado_cuenta IS
    'Estado resultante de la cuenta despues del cambio registrado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.usuario_creacion IS
    'Usuario del sistema que registro el cambio de estado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro historico';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.observaciones IS
    'Notas adicionales sobre el cambio de estado o su contexto';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CHSTS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CHSTS (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    numero_cuenta            TEXT IS 'No. Cuenta',
    secuencia                TEXT IS 'Secuencia',
    estado_anterior          TEXT IS 'Edo Anterior',
    estado_nuevo             TEXT IS 'Edo Nuevo',
    fecha_cambio             TEXT IS 'Fec Cambio',
    hora_cambio              TEXT IS 'Hora Cambio',
    motivo_cambio            TEXT IS 'Motivo',
    referencia_autorizacion  TEXT IS 'Ref Autoriz',
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

CREATE INDEX HNEACOSTA1/ICHSTSCTA ON HNEACOSTA1/CHSTS (numero_cuenta);
CREATE INDEX HNEACOSTA1/ICHSTSFCH ON HNEACOSTA1/CHSTS (fecha_cambio);
CREATE INDEX HNEACOSTA1/ICHSTSCAT ON HNEACOSTA1/CHSTS (created_at);
