-- ==============================================================================
-- Nombre de la Tabla  : TRANS
-- DESCRIPCION         : Archivo historico de transacciones. Almacena el
--                       registro permanente de todas las transacciones
--                       financieras procesadas por el sistema, con datos
--                       de cuenta, cliente, monto, saldos y estado.
--                       Es la tabla padre de TRDSC via numero_registro_relativo.
-- Objetivo            : Conservar el historico completo de movimientos
--                       financieros para auditoria, conciliacion, consultas
--                       historicas y generacion de estados de cuenta.
-- Tipo de Tabla       : Historico Transaccional
-- Origen de los Datos : Migrado desde TTRAN al cierre del dia operativo;
--                       tambien por ingreso directo de movimientos historicos
-- Permanencia de Datos: Permanente con historico indefinido
-- Uso de los datos    : Modulo Archivos Comunes - historico de transacciones
--                       para conciliacion, auditoria y estados de cuenta;
--                       tabla padre de TRDSC via numero_registro_relativo
-- Restricciones       : PK (id_transaccion BIGINT autogenerado);
--                       FK a GLMST (cuenta_contable),
--                       FK a ACMST (numero_cuenta),
--                       FK a CUMST (id_cliente);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/TRANS (
    id_transaccion          FOR COLUMN IDTRAN   BIGINT         NOT NULL GENERATED ALWAYS AS IDENTITY,
    numero_registro_relativo FOR COLUMN NUMREG  VARCHAR(30),
    codigo_banco            FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL DEFAULT '',
    codigo_sucursal         FOR COLUMN CODSUC   VARCHAR(20)    NOT NULL DEFAULT '',
    codigo_moneda           FOR COLUMN CODMON   VARCHAR(20)    NOT NULL DEFAULT '',
    cuenta_contable         FOR COLUMN CTACONT  VARCHAR(24),
    numero_cuenta           FOR COLUMN NUMCTA   VARCHAR(24),
    id_cliente              FOR COLUMN IDCLI    VARCHAR(30),
    fecha_operacion         FOR COLUMN FECOPE   DATE,
    fecha_valor             FOR COLUMN FECVAL   DATE,
    hora_operacion          FOR COLUMN HORAOPE  TIME,
    tipo_movimiento         FOR COLUMN TIPMOV   VARCHAR(20)    NOT NULL DEFAULT '',
    debito_credito          FOR COLUMN DEPCRED  CHAR(1)        NOT NULL DEFAULT '',
    monto                   FOR COLUMN MONTO    DECIMAL(18, 2) NOT NULL DEFAULT 0,
    saldo_anterior          FOR COLUMN SLDANT   DECIMAL(18, 2) NOT NULL DEFAULT 0,
    saldo_posterior         FOR COLUMN SLDPOS   DECIMAL(18, 2) NOT NULL DEFAULT 0,
    canal_origen            FOR COLUMN CANORIG  VARCHAR(20)    NOT NULL DEFAULT '',
    terminal_origen         FOR COLUMN TERMORIG VARCHAR(30)    NOT NULL DEFAULT '',
    referencia_externa      FOR COLUMN REFEXT   VARCHAR(40)    NOT NULL DEFAULT '',
    estado_transaccion      FOR COLUMN ESTTRAN  VARCHAR(20)    NOT NULL DEFAULT '',
    usuario_creacion        FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion   FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro        FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro         FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_TRANS     PRIMARY KEY (id_transaccion)
)
RCDFMT TRANSR;

RENAME TABLE HNEACOSTA1/TRANS
    TO TRANS FOR SYSTEM NAME TRANS;

COMMENT ON TABLE HNEACOSTA1/TRANS IS
    'Historico de Transacciones Financieras - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE HNEACOSTA1/TRANS IS
    'Historico Transacciones';

COMMENT ON COLUMN HNEACOSTA1/TRANS.id_transaccion          IS 'Identificador unico autogenerado de la transaccion historica; PK surrogate';
COMMENT ON COLUMN HNEACOSTA1/TRANS.numero_registro_relativo IS 'Numero de registro relativo del historico; referenciado por TRDSC como FK';
COMMENT ON COLUMN HNEACOSTA1/TRANS.codigo_banco            IS 'Codigo del banco en que se origino la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.codigo_sucursal         IS 'Codigo de la sucursal en que se origino la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.codigo_moneda           IS 'Codigo ISO de la moneda de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.cuenta_contable         IS 'Cuenta contable afectada por la transaccion; FK a GLMST';
COMMENT ON COLUMN HNEACOSTA1/TRANS.numero_cuenta           IS 'Numero de cuenta de detalle del cliente afectada; FK a ACMST';
COMMENT ON COLUMN HNEACOSTA1/TRANS.id_cliente              IS 'Identificacion del cliente titular de la operacion; FK a CUMST';
COMMENT ON COLUMN HNEACOSTA1/TRANS.fecha_operacion         IS 'Fecha en que se proceso la transaccion en el sistema';
COMMENT ON COLUMN HNEACOSTA1/TRANS.fecha_valor             IS 'Fecha valor efectiva de la transaccion para calculo de intereses';
COMMENT ON COLUMN HNEACOSTA1/TRANS.hora_operacion          IS 'Hora exacta en que se proceso la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.tipo_movimiento         IS 'Tipo de movimiento: DEPOSITO, RETIRO, TRANSFERENCIA, etc.';
COMMENT ON COLUMN HNEACOSTA1/TRANS.debito_credito          IS 'Signo contable de la transaccion: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/TRANS.monto                   IS 'Monto de la transaccion en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/TRANS.saldo_anterior          IS 'Saldo de la cuenta antes de aplicar esta transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.saldo_posterior         IS 'Saldo de la cuenta despues de aplicar esta transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.canal_origen            IS 'Canal por el que se origino la transaccion: CAJA, SWIFT, BATCH, etc.';
COMMENT ON COLUMN HNEACOSTA1/TRANS.terminal_origen         IS 'Identificador del terminal o proceso que origino la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.referencia_externa      IS 'Referencia externa o numero de documento asociado a la transaccion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.estado_transaccion      IS 'Estado de la transaccion: APLICADA, PENDIENTE, TRANSITO, REVERSADA';
COMMENT ON COLUMN HNEACOSTA1/TRANS.usuario_creacion        IS 'Usuario o proceso que registro la transaccion en el historico';
COMMENT ON COLUMN HNEACOSTA1/TRANS.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/TRANS.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/TRANS.observaciones           IS 'Notas adicionales sobre la transaccion historica';
COMMENT ON COLUMN HNEACOSTA1/TRANS.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/TRANS.created_at              IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/TRANS.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/TRANS (
    id_transaccion          TEXT IS 'ID Transaccion',
    numero_registro_relativo TEXT IS 'Num Registro Relativo',
    codigo_banco            TEXT IS 'Codigo Banco',
    codigo_sucursal         TEXT IS 'Codigo Sucursal',
    codigo_moneda           TEXT IS 'Codigo Moneda',
    cuenta_contable         TEXT IS 'Cuenta Contable',
    numero_cuenta           TEXT IS 'Numero Cuenta',
    id_cliente              TEXT IS 'ID Cliente',
    fecha_operacion         TEXT IS 'Fecha Operacion',
    fecha_valor             TEXT IS 'Fecha Valor',
    hora_operacion          TEXT IS 'Hora Operacion',
    tipo_movimiento         TEXT IS 'Tipo Movimiento',
    debito_credito          TEXT IS 'Debito Credito',
    monto                   TEXT IS 'Monto',
    saldo_anterior          TEXT IS 'Saldo Anterior',
    saldo_posterior         TEXT IS 'Saldo Posterior',
    canal_origen            TEXT IS 'Canal Origen',
    terminal_origen         TEXT IS 'Terminal Origen',
    referencia_externa      TEXT IS 'Referencia Externa',
    estado_transaccion      TEXT IS 'Estado Transaccion',
    usuario_creacion        TEXT IS 'Usuario Creacion',
    usuario_actualizacion   TEXT IS 'Usuario Actualizacion',
    version_registro        TEXT IS 'Version Registro',
    observaciones           TEXT IS 'Observaciones',
    estado_registro         TEXT IS 'Estado Registro',
    created_at              TEXT IS 'Fecha Creacion',
    updated_at              TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_TRANS_RR  ON HNEACOSTA1/TRANS (numero_registro_relativo);
CREATE INDEX HNEACOSTA1/IDX_TRANS_CF  ON HNEACOSTA1/TRANS (numero_cuenta,    fecha_operacion);
CREATE INDEX HNEACOSTA1/IDX_TRANS_CCF ON HNEACOSTA1/TRANS (cuenta_contable,  fecha_operacion);
CREATE INDEX HNEACOSTA1/IDX_TRANS_CLF ON HNEACOSTA1/TRANS (id_cliente,       fecha_operacion);
CREATE INDEX HNEACOSTA1/IDX_TRANS_C   ON HNEACOSTA1/TRANS (created_at);
