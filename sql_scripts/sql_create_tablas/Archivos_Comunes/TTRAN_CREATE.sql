-- ==============================================================================
-- Nombre de la Tabla  : TTRAN
-- DESCRIPCION         : Archivo Maestro de Transacciones del Dia. Almacena
--                       las transacciones intradiarias en proceso del dia
--                       operativo actual. Al cierre del dia, los registros
--                       se migran al historico TRANS. Puede referenciar
--                       un registro de TRANS via numero_registro_relativo
--                       cuando la transaccion ya fue parcialmente procesada.
-- Objetivo            : Gestionar las transacciones del dia en tiempo real,
--                       permitiendo consultas de saldo actualizadas y
--                       control de movimientos pendientes de cierre diario.
-- Tipo de Tabla       : Transaccional Intradiaria
-- Origen de los Datos : Ingreso en linea por operadores, procesos batch
--                       intradiarios y transacciones de canal electronico
-- Permanencia de Datos: Temporal; se purga al cierre del dia operativo
--                       despues de migrar a TRANS
-- Uso de los datos    : Modulo Archivos Comunes - control de transacciones
--                       del dia operativo actual; fuente para conciliacion
--                       intradiaria junto con TRANS
-- Restricciones       : PK (id_transaccion_dia BIGINT autogenerado);
--                       numero_registro_relativo referencia TRANS (no FK fisica
--                       dado que puede no existir en TRANS aun);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE TTRAN (
    id_transaccion_dia      FOR COLUMN IDTDIA   BIGINT         NOT NULL GENERATED ALWAYS AS IDENTITY,
    numero_registro_relativo FOR COLUMN NUMREG  VARCHAR(30),
    codigo_banco            FOR COLUMN CODBCO   VARCHAR(20)    NOT NULL,
    codigo_sucursal         FOR COLUMN CODSUC   VARCHAR(20)    NOT NULL,
    codigo_moneda           FOR COLUMN CODMON   VARCHAR(20)    NOT NULL,
    cuenta_contable         FOR COLUMN CTACONT  VARCHAR(24)    NOT NULL,
    numero_cuenta           FOR COLUMN NUMCTA   VARCHAR(24)    NOT NULL,
    id_cliente              FOR COLUMN IDCLI    VARCHAR(30),
    fecha_transaccion       FOR COLUMN FECHA    DATE           NOT NULL,
    fecha_valor             FOR COLUMN FECVAL   DATE,
    hora_operacion          FOR COLUMN HORAOPE  TIME,
    tipo_movimiento         FOR COLUMN TIPMOV   VARCHAR(20)    NOT NULL DEFAULT '',
    debito_credito          FOR COLUMN DEPCRED  CHAR(1)        NOT NULL DEFAULT '',
    monto_transaccion       FOR COLUMN MONTO    DECIMAL(18, 2) NOT NULL DEFAULT 0,
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
    CONSTRAINT PK_TTRAN     PRIMARY KEY (id_transaccion_dia)
)
RCDFMT TTRANR;

RENAME TABLE TTRAN
    TO TTRAN_TABLE FOR SYSTEM NAME TTRAN;

COMMENT ON TABLE TTRAN IS
    'Transacciones del Dia Operativo Actual - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE TTRAN IS
    'Transacciones del Dia';

COMMENT ON COLUMN TTRAN.id_transaccion_dia      IS 'Identificador unico autogenerado de la transaccion del dia; PK surrogate';
COMMENT ON COLUMN TTRAN.numero_registro_relativo IS 'Referencia al registro relativo de TRANS si la transaccion ya migro parcialmente';
COMMENT ON COLUMN TTRAN.codigo_banco            IS 'Codigo del banco en que se origino la transaccion del dia; parte de la PK funcional';
COMMENT ON COLUMN TTRAN.codigo_sucursal         IS 'Codigo de la sucursal en que se origino la transaccion del dia; parte de la PK funcional';
COMMENT ON COLUMN TTRAN.codigo_moneda           IS 'Codigo ISO de la moneda de la transaccion del dia; parte de la PK funcional';
COMMENT ON COLUMN TTRAN.cuenta_contable         IS 'Cuenta contable afectada; parte de la PK funcional; referencia a GLMST';
COMMENT ON COLUMN TTRAN.numero_cuenta           IS 'Numero de cuenta de detalle afectada; parte de la PK funcional; referencia a ACMST';
COMMENT ON COLUMN TTRAN.id_cliente              IS 'Identificacion del cliente de la operacion; referencia a CUMST';
COMMENT ON COLUMN TTRAN.fecha_transaccion       IS 'Fecha del dia operativo de la transaccion; parte de la PK funcional';
COMMENT ON COLUMN TTRAN.fecha_valor             IS 'Fecha valor efectiva de la transaccion del dia';
COMMENT ON COLUMN TTRAN.hora_operacion          IS 'Hora exacta del procesamiento de la transaccion del dia';
COMMENT ON COLUMN TTRAN.tipo_movimiento         IS 'Tipo de movimiento intradiario: DEPOSITO, RETIRO, TRANSFERENCIA, AJUSTE, etc.';
COMMENT ON COLUMN TTRAN.debito_credito          IS 'Signo contable de la transaccion del dia: D=Debito, C=Credito';
COMMENT ON COLUMN TTRAN.monto_transaccion       IS 'Monto de la transaccion del dia en la moneda indicada';
COMMENT ON COLUMN TTRAN.saldo_anterior          IS 'Saldo de la cuenta antes de aplicar la transaccion del dia';
COMMENT ON COLUMN TTRAN.saldo_posterior         IS 'Saldo de la cuenta despues de aplicar la transaccion del dia';
COMMENT ON COLUMN TTRAN.canal_origen            IS 'Canal de origen de la transaccion del dia: CAJA, SWIFT, BATCH, ATM, etc.';
COMMENT ON COLUMN TTRAN.terminal_origen         IS 'Identificador del terminal o proceso que origino la transaccion';
COMMENT ON COLUMN TTRAN.referencia_externa      IS 'Referencia externa o numero de documento de la transaccion del dia';
COMMENT ON COLUMN TTRAN.estado_transaccion      IS 'Estado de la transaccion del dia: APLICADA, PENDIENTE, TRANSITO, REVERSADA';
COMMENT ON COLUMN TTRAN.usuario_creacion        IS 'Usuario u proceso que registro la transaccion del dia';
COMMENT ON COLUMN TTRAN.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN TTRAN.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN TTRAN.observaciones           IS 'Notas adicionales sobre la transaccion del dia';
COMMENT ON COLUMN TTRAN.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN TTRAN.created_at              IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN TTRAN.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN TTRAN (
    id_transaccion_dia      TEXT IS 'ID Transaccion Dia',
    numero_registro_relativo TEXT IS 'Num Registro Relativo',
    codigo_banco            TEXT IS 'Codigo Banco',
    codigo_sucursal         TEXT IS 'Codigo Sucursal',
    codigo_moneda           TEXT IS 'Codigo Moneda',
    cuenta_contable         TEXT IS 'Cuenta Contable',
    numero_cuenta           TEXT IS 'Numero Cuenta',
    id_cliente              TEXT IS 'ID Cliente',
    fecha_transaccion       TEXT IS 'Fecha Operacion',
    fecha_valor             TEXT IS 'Fecha Valor',
    hora_operacion          TEXT IS 'Hora Operacion',
    tipo_movimiento         TEXT IS 'Tipo Movimiento',
    debito_credito          TEXT IS 'Debito Credito',
    monto_transaccion       TEXT IS 'Monto',
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

CREATE INDEX IDX_TTRAN_RR  ON TTRAN (numero_registro_relativo);
CREATE INDEX IDX_TTRAN_CF  ON TTRAN (numero_cuenta,   fecha_transaccion);
CREATE INDEX IDX_TTRAN_CCF ON TTRAN (cuenta_contable, fecha_transaccion);
CREATE INDEX IDX_TTRAN_CLF ON TTRAN (id_cliente,      fecha_transaccion);
CREATE INDEX IDX_TTRAN_F   ON TTRAN (fecha_transaccion);
CREATE INDEX IDX_TTRAN_C   ON TTRAN (created_at);
