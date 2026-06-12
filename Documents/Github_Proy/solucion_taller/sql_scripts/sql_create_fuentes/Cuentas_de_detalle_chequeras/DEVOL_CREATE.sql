-- ============================================================
-- Nombre de la Tabla  : DEVOL
-- DESCRIPCION         : Detalle de Cheques Devueltos
-- Objetivo            : Registrar los cheques que fueron presentados y
--                       devueltos por el banco, con sus causales de devolucion.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Proceso de camara de compensacion y devolucion en caja
-- Permanencia de Datos: Historica (ciclo regulatorio)
-- Uso de los datos    : Control de devolucion, cobro de penalidades y auditoria
-- Restricciones       : FK hacia ACMST por numero_cuenta;
--                       FK hacia CNTRLDEV por codigo_causal
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DEVOL (
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN DEVOLCTA,
    numero_cheque           VARCHAR(30)     NOT NULL    FOR COLUMN DEVOLCHE,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DEVOLSEQ,
    codigo_causal           VARCHAR(20)                 FOR COLUMN DEVOLCAU,
    monto_cheque            DECIMAL(18,2)               FOR COLUMN DEVOLMNT,
    codigo_moneda           VARCHAR(20)                 FOR COLUMN DEVOLMON,
    fecha_devolucion        DATE                        FOR COLUMN DEVOLFDV,
    banco_presentador       VARCHAR(50)                 FOR COLUMN DEVOLBNP,
    penalidad_aplicada      DECIMAL(18,2)               FOR COLUMN DEVOLPEN,
    estado_devolucion       VARCHAR(20)                 FOR COLUMN DEVOLEST,
    fecha_apertura          DATE                        FOR COLUMN DEVOLFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN DEVOLFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN DEVOLSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN DEVOLSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN DEVOLLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN DEVOLESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DEVOLUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DEVOLUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DEVOLVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DEVOLOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DEVOLERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DEVOLCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DEVOLUAT,
    CONSTRAINT PK_DEVOL PRIMARY KEY (numero_cuenta, numero_cheque, secuencia),
    CONSTRAINT FK_DEVOL_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta),
    CONSTRAINT FK_DEVOL_CNTRLDEV FOREIGN KEY (codigo_causal)
        REFERENCES HNEACOSTA1/CNTRLDEV (codigo_causal)
)
RCDFMT DEVOLR;

RENAME TABLE HNEACOSTA1/DEVOL
    TO DEVOL FOR SYSTEM NAME DEVOL;

COMMENT ON TABLE HNEACOSTA1/DEVOL IS
    'Detalle de Cheques Devueltos - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/DEVOL
    IS 'Detalle Cheques Devuel';

COMMENT ON COLUMN HNEACOSTA1/DEVOL.numero_cuenta IS
    'Numero de cuenta corriente del librador del cheque devuelto (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.numero_cheque IS
    'Numero del cheque que fue devuelto sin pago';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.secuencia IS
    'Numero de secuencia para multiples devoluciones del mismo cheque';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.codigo_causal IS
    'Codigo de la causal de devolucion segun catalogo CNTRLDEV (FK)';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.monto_cheque IS
    'Valor monetario del cheque devuelto';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominado el cheque devuelto';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.fecha_devolucion IS
    'Fecha en que se proceso la devolucion del cheque';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.banco_presentador IS
    'Nombre o codigo del banco que presento el cheque al cobro';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.penalidad_aplicada IS
    'Monto de la penalidad cobrada al librador por el cheque devuelto';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.estado_devolucion IS
    'Estado de la devolucion: PROCESADA, NOTIFICADA, REGULARIZADA';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente del librador';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con la devolucion';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.saldo_actual IS
    'Saldo de la cuenta al momento de la devolucion del cheque';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.saldo_disponible IS
    'Saldo disponible de la cuenta al momento de la devolucion';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.limite_sobregiro IS
    'Limite de sobregiro de la cuenta al momento de la devolucion';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.estado_cuenta IS
    'Estado operativo de la cuenta al momento de la devolucion';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.usuario_creacion IS
    'Usuario o proceso que registro la devolucion del cheque';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.observaciones IS
    'Notas sobre la devolucion, gestiones de cobro o acuerdos de pago';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DEVOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DEVOL (
    numero_cuenta            TEXT IS 'No. Cuenta',
    numero_cheque            TEXT IS 'No. Cheque',
    secuencia                TEXT IS 'Secuencia',
    codigo_causal            TEXT IS 'Cod Causal',
    monto_cheque             TEXT IS 'Monto Cheque',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_devolucion         TEXT IS 'Fec Devol',
    banco_presentador        TEXT IS 'Banco Pres',
    penalidad_aplicada       TEXT IS 'Penalidad',
    estado_devolucion        TEXT IS 'Edo Devol',
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

CREATE INDEX HNEACOSTA1/IDEVOLCTA ON HNEACOSTA1/DEVOL (numero_cuenta);
CREATE INDEX HNEACOSTA1/IDEVOLFDV ON HNEACOSTA1/DEVOL (fecha_devolucion);
CREATE INDEX HNEACOSTA1/IDEVOLCAT ON HNEACOSTA1/DEVOL (created_at);
