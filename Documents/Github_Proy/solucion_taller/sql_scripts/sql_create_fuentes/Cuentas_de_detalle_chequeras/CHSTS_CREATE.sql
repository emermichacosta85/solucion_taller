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

CREATE OR REPLACE TABLE CHSTS (
    codigo_banco            FOR COLUMN CHSTSBNK VARCHAR(20)     NOT NULL DEFAULT ''  ,
    codigo_sucursal         FOR COLUMN CHSTSSUC VARCHAR(20)     NOT NULL DEFAULT ''  ,
    codigo_moneda           FOR COLUMN CHSTSMON VARCHAR(20)     NOT NULL DEFAULT ''  ,
    cuenta_contable         FOR COLUMN CHSTSCTC VARCHAR(24)     NOT NULL DEFAULT ' '  ,
    numero_cuenta           FOR COLUMN CHSTSCTA VARCHAR(24)     NOT NULL DEFAULT ' '  ,
    secuencia               FOR COLUMN CHSTSSEQ INT  NOT NULL DEFAULT 1,
    estado_anterior         FOR COLUMN CHSTSEAN VARCHAR(20)  NOT NULL
                                            DEFAULT 'ACTIVA' ,
    estado_nuevo            FOR COLUMN CHSTSENW VARCHAR(20)    NOT NULL
                                            DEFAULT 'ACTIVA' ,
    fecha_cambio            FOR COLUMN CHSTSFCH DATE                ,
    hora_cambio             FOR COLUMN CHSTSHCH TIME                        ,
    motivo_cambio           FOR COLUMN CHSTSMOT VARCHAR(120) NOT NULL
                                            DEFAULT ' ' ,
    referencia_autorizacion FOR COLUMN CHSTSREF VARCHAR(50) NOT NULL
                                            DEFAULT ' ' ,
    fecha_apertura          FOR COLUMN CHSTSFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CHSTSFUT DATE                       ,
    saldo_actual            FOR COLUMN CHSTSSAL DECIMAL(18,2) NOT NULL
                                            DEFAULT 0.00 ,
    saldo_disponible        FOR COLUMN CHSTSSDP DECIMAL(18,2) NO NULL
                                            DEFAULT 0.00 ,
    limite_sobregiro        FOR COLUMN CHSTSLSO DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0.00 ,
    estado_cuenta           FOR COLUMN CHSTSESC VARCHAR(20) NOT NULL
                                            DEFAULT 'ACTIVA' ,
    usuario_creacion        FOR COLUMN CHSTSUSC VARCHAR(30) NOT NULL
                                            DEFAULT ' ' ,
    usuario_actualizacion   FOR COLUMN CHSTSUSA VARCHAR(30) NOT NULL
                                            DEFAULT ' ' ,
    version_registro        FOR COLUMN CHSTSVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CHSTSOBS VARCHAR(120) NOT NULL
                                            DEFAULT ' ' ,
    estado_registro         FOR COLUMN CHSTSERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN CHSTSCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN CHSTSUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
                                                        
    CONSTRAINT PK_CHSTS PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     numero_cuenta, secuencia)
    --CONSTRAINT FK_CHSTS_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT CHSTSR;

RENAME TABLE CHSTS
    TO CHSTS_TABLE FOR SYSTEM NAME CHSTS;

COMMENT ON TABLE CHSTS IS
    'Historial de Cambios de Estado de Cuentas de Detalle - Modulo 3';

LABEL ON TABLE CHSTS
    IS 'Cambios Estado Cuentas';

COMMENT ON COLUMN CHSTS.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta con cambio de estado';
COMMENT ON COLUMN CHSTS.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN CHSTS.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta';
COMMENT ON COLUMN CHSTS.cuenta_contable IS
    'Cuenta contable del plan de cuentas asociada a la cuenta';
COMMENT ON COLUMN CHSTS.numero_cuenta IS
    'Numero de cuenta cuyo estado fue modificado (FK ACMST)';
COMMENT ON COLUMN CHSTS.secuencia IS
    'Numero de orden del cambio de estado para historial cronologico';
COMMENT ON COLUMN CHSTS.estado_anterior IS
    'Estado que tenia la cuenta antes del cambio registrado';
COMMENT ON COLUMN CHSTS.estado_nuevo IS
    'Nuevo estado aplicado a la cuenta: ACTIVA, BLOQUEADA, CERRADA, etc.';
COMMENT ON COLUMN CHSTS.fecha_cambio IS
    'Fecha en que se aplico el cambio de estado a la cuenta';
COMMENT ON COLUMN CHSTS.hora_cambio IS
    'Hora exacta en que se realizo el cambio de estado';
COMMENT ON COLUMN CHSTS.motivo_cambio IS
    'Descripcion del motivo o causa que origino el cambio de estado';
COMMENT ON COLUMN CHSTS.referencia_autorizacion IS
    'Numero de referencia de la autorizacion que respalda el cambio';
COMMENT ON COLUMN CHSTS.fecha_apertura IS
    'Fecha de apertura de la cuenta cuyo estado fue modificado';
COMMENT ON COLUMN CHSTS.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento previo al cambio de estado';
COMMENT ON COLUMN CHSTS.saldo_actual IS
    'Saldo contable de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN CHSTS.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN CHSTS.limite_sobregiro IS
    'Limite de sobregiro de la cuenta al momento del cambio de estado';
COMMENT ON COLUMN CHSTS.estado_cuenta IS
    'Estado resultante de la cuenta despues del cambio registrado';
COMMENT ON COLUMN CHSTS.usuario_creacion IS
    'Usuario del sistema que registro el cambio de estado';
COMMENT ON COLUMN CHSTS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro historico';
COMMENT ON COLUMN CHSTS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CHSTS.observaciones IS
    'Notas adicionales sobre el cambio de estado o su contexto';
COMMENT ON COLUMN CHSTS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CHSTS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CHSTS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CHSTS (
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

CREATE INDEX ICHSTSCTA ON CHSTS (numero_cuenta);
CREATE INDEX ICHSTSFCH ON CHSTS (fecha_cambio);
CREATE INDEX ICHSTSCAT ON CHSTS (created_at);
