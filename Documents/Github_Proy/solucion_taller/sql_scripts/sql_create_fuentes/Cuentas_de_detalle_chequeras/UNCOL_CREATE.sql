-- ============================================================
-- Nombre de la Tabla  : UNCOL
-- DESCRIPCION         : Maestro de Retenciones sobre Cuentas
-- Objetivo            : Registrar y controlar las retenciones aplicadas
--                       sobre saldos de cuentas de detalle por diferentes
--                       conceptos (judiciales, garantias, embargos).
-- Tipo de Tabla       : Maestra / Operativa
-- Origen de los Datos : Ordenes judiciales, garantias y controles internos
-- Permanencia de Datos: Permanente mientras la retencion este vigente
-- Uso de los datos    : Calculo de saldo disponible en cuentas
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/UNCOL (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN UNCOLBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN UNCOLSUC,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN UNCOLCTA,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN UNCOLSEQ,
    tipo_retencion          VARCHAR(20)                 FOR COLUMN UNCOLTRT,
    monto_retencion         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN UNCOLMRT,
    fecha_inicio            DATE                        FOR COLUMN UNCOLFI,
    fecha_fin               DATE                        FOR COLUMN UNCOLFF,
    referencia_legal        VARCHAR(80)                 FOR COLUMN UNCOLREF,
    estado_retencion        VARCHAR(20)                 FOR COLUMN UNCOLEST,
    fecha_apertura          DATE                        FOR COLUMN UNCOLFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN UNCOLFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN UNCOLSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN UNCOLSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN UNCOLLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN UNCOLESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN UNCOLUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN UNCOLUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN UNCOLVRS,
    observaciones           VARCHAR(120)                FOR COLUMN UNCOLOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN UNCOLERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN UNCOLCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN UNCOLUAT,
    CONSTRAINT PK_UNCOL PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     numero_cuenta, secuencia),
    CONSTRAINT FK_UNCOL_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT UNCOLR;

RENAME TABLE HNEACOSTA1/UNCOL
    TO UNCOL FOR SYSTEM NAME UNCOL;

COMMENT ON TABLE HNEACOSTA1/UNCOL IS
    'Maestro de Retenciones sobre Cuentas de Detalle - Modulo 3';

LABEL ON TABLE HNEACOSTA1/UNCOL
    IS 'Maestro Retenciones';

COMMENT ON COLUMN HNEACOSTA1/UNCOL.codigo_banco IS
    'Codigo del banco donde esta radicada la cuenta con retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.numero_cuenta IS
    'Numero de cuenta bancaria sobre la que aplica la retencion (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.secuencia IS
    'Numero de secuencia para multiples retenciones sobre la misma cuenta';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.tipo_retencion IS
    'Clasificacion de la retencion: JUDICIAL, GARANTIA, EMBARGO, INTERNA';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.monto_retencion IS
    'Valor monetario retenido en la cuenta en la moneda de la misma';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.fecha_inicio IS
    'Fecha desde la cual rige la retencion sobre la cuenta';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.fecha_fin IS
    'Fecha hasta la que esta vigente la retencion, nula si es indefinida';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.referencia_legal IS
    'Numero de expediente, resolucion o referencia legal que origina la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.estado_retencion IS
    'Estado actual de la retencion: VIGENTE, LEVANTADA, VENCIDA';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.fecha_apertura IS
    'Fecha de apertura de la cuenta sobre la que se aplica la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion o movimiento relacionado con la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.saldo_actual IS
    'Saldo contable de la cuenta al momento de registrar la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.saldo_disponible IS
    'Saldo disponible de la cuenta despues de descontar la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.limite_sobregiro IS
    'Limite de sobregiro vigente de la cuenta al registrar la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro de la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.usuario_creacion IS
    'Usuario del sistema que registro la retencion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.observaciones IS
    'Notas adicionales sobre la retencion o su origen legal';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/UNCOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/UNCOL (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    numero_cuenta            TEXT IS 'No. Cuenta',
    secuencia                TEXT IS 'Secuencia',
    tipo_retencion           TEXT IS 'Tipo Retenc',
    monto_retencion          TEXT IS 'Monto Retenc',
    fecha_inicio             TEXT IS 'Fec Inicio',
    fecha_fin                TEXT IS 'Fec Fin',
    referencia_legal         TEXT IS 'Ref Legal',
    estado_retencion         TEXT IS 'Estado Ret',
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

CREATE INDEX HNEACOSTA1/IUNCOLCTA ON HNEACOSTA1/UNCOL (numero_cuenta);
CREATE INDEX HNEACOSTA1/IUNCOLCAT ON HNEACOSTA1/UNCOL (created_at);
