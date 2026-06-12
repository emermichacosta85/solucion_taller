-- ============================================================
-- Nombre de la Tabla  : ACMST
-- DESCRIPCION         : Archivo Maestro de Cuentas de Detalle
-- Objetivo            : Almacenar la informacion maestra de todas las
--                       cuentas de detalle (ahorro, corriente, etc.)
--                       incluyendo saldos, estado y trazabilidad.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Apertura de cuentas bancarias
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Consulta y mantenimiento de cuentas de clientes
-- Restricciones       : Clave primaria tecnica (id BIGINT);
--                       FK hacia CUMST por numero de cliente.
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/ACMST (
    id                      BIGINT          NOT NULL    FOR COLUMN ACMSTID,
    id_cliente              VARCHAR(30)     NOT NULL    FOR COLUMN ACMSTCLI,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN ACMSTCTA,
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN ACMSTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN ACMSTSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN ACMSTMON,
    cuenta_contable         VARCHAR(24)     NOT NULL    FOR COLUMN ACMSTCTC,
    tipo_producto           VARCHAR(20)     NOT NULL    FOR COLUMN ACMSTPRD,
    fecha_apertura          DATE                        FOR COLUMN ACMSTFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN ACMSTFUT,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN ACMSTSAL,
    saldo_disponible        DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN ACMSTSDP,
    limite_sobregiro        DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN ACMSTLSO,
    estado_cuenta           VARCHAR(20)     NOT NULL    FOR COLUMN ACMSTESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN ACMSTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN ACMSTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN ACMSTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN ACMSTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN ACMSTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN ACMSTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN ACMSTUAT,
    CONSTRAINT PK_ACMST PRIMARY KEY (id)
)
RCDFMT ACMSTR;

RENAME TABLE HNEACOSTA1/ACMST
    TO ACMST FOR SYSTEM NAME ACMST;

COMMENT ON TABLE HNEACOSTA1/ACMST IS
    'Archivo Maestro de Cuentas de Detalle - Modulo 3 Cuentas/Chequeras';

LABEL ON TABLE HNEACOSTA1/ACMST
    IS 'Maestro Cuentas Detalle';

COMMENT ON COLUMN HNEACOSTA1/ACMST.id IS
    'Identificador tecnico unico autoincremental de la cuenta de detalle';
COMMENT ON COLUMN HNEACOSTA1/ACMST.id_cliente IS
    'Identificador del cliente titular de la cuenta (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/ACMST.numero_cuenta IS
    'Numero de cuenta bancaria unico asignado al momento de apertura';
COMMENT ON COLUMN HNEACOSTA1/ACMST.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.codigo_sucursal IS
    'Codigo de la sucursal donde fue abierta la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta (ej: HNL, USD)';
COMMENT ON COLUMN HNEACOSTA1/ACMST.cuenta_contable IS
    'Codigo de cuenta contable asociada para registros GL';
COMMENT ON COLUMN HNEACOSTA1/ACMST.tipo_producto IS
    'Tipo de producto bancario (ahorro, corriente, etc.)';
COMMENT ON COLUMN HNEACOSTA1/ACMST.fecha_apertura IS
    'Fecha en que fue abierta la cuenta en el sistema';
COMMENT ON COLUMN HNEACOSTA1/ACMST.fecha_ultima_transaccion IS
    'Fecha de la ultima transaccion registrada en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.saldo_actual IS
    'Saldo contable actual de la cuenta en la moneda de la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.saldo_disponible IS
    'Saldo disponible para retiro descontando retenciones y reservas';
COMMENT ON COLUMN HNEACOSTA1/ACMST.limite_sobregiro IS
    'Limite maximo autorizado de sobregiro en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.estado_cuenta IS
    'Estado operativo de la cuenta (ACTIVA, INACTIVA, BLOQUEADA, CERRADA)';
COMMENT ON COLUMN HNEACOSTA1/ACMST.usuario_creacion IS
    'Usuario del sistema que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/ACMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/ACMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/ACMST.observaciones IS
    'Notas libres o anotaciones operativas sobre la cuenta';
COMMENT ON COLUMN HNEACOSTA1/ACMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/ACMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/ACMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/ACMST (
    id                       TEXT IS 'ID Cuenta',
    id_cliente               TEXT IS 'ID Cliente',
    numero_cuenta            TEXT IS 'No. Cuenta',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    tipo_producto            TEXT IS 'Tipo Producto',
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

CREATE INDEX HNEACOSTA1/IACMSTCLI ON HNEACOSTA1/ACMST (id_cliente);
CREATE INDEX HNEACOSTA1/IACMSTCTA ON HNEACOSTA1/ACMST (numero_cuenta);
CREATE INDEX HNEACOSTA1/IACMSTCAT ON HNEACOSTA1/ACMST (created_at);
