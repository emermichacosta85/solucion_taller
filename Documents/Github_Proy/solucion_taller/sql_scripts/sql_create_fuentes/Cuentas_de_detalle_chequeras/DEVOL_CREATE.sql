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

CREATE OR REPLACE TABLE DEVOL (
    numero_cuenta           FOR COLUMN DEVOLCTA VARCHAR(24)     NOT NULL    ,
    numero_cheque           FOR COLUMN DEVOLCHE VARCHAR(30)     NOT NULL    ,
    fecha_apertura          FOR COLUMN DEVOLFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN DEVOLFUT DATE                       ,
    saldo_actual            FOR COLUMN DEVOLSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN DEVOLSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN DEVOLLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN DEVOLESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN DEVOLUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN DEVOLUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN DEVOLVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN DEVOLOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN DEVOLERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN DEVOLCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                       ,
    updated_at              FOR COLUMN DEVOLUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
    --CONSTRAINT PK_DEVOL PRIMARY KEY (numero_cuenta, numero_cheque, secuencia),
    --CONSTRAINT FK_DEVOL_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta),
    --CONSTRAINT FK_DEVOL_CNTRLDEV FOREIGN KEY (codigo_causal)
    --    REFERENCES CNTRLDEV (codigo_causal)
)
RCDFMT DEVOLR;

RENAME TABLE DEVOL
    TO DEVOL_TABLE FOR SYSTEM NAME DEVOL;

COMMENT ON TABLE DEVOL IS
    'Detalle de Cheques Devueltos - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE DEVOL
    IS 'Detalle Cheques Devuel';

COMMENT ON COLUMN DEVOL.numero_cuenta IS
    'Numero de cuenta corriente del librador del cheque devuelto (FK ACMST)';
COMMENT ON COLUMN DEVOL.numero_cheque IS
    'Numero del cheque que fue devuelto sin pago';
COMMENT ON COLUMN DEVOL.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente del librador';
COMMENT ON COLUMN DEVOL.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con la devolucion';
COMMENT ON COLUMN DEVOL.saldo_actual IS
    'Saldo de la cuenta al momento de la devolucion del cheque';
COMMENT ON COLUMN DEVOL.saldo_disponible IS
    'Saldo disponible de la cuenta al momento de la devolucion';
COMMENT ON COLUMN DEVOL.limite_sobregiro IS
    'Limite de sobregiro de la cuenta al momento de la devolucion';
COMMENT ON COLUMN DEVOL.estado_cuenta IS
    'Estado operativo de la cuenta al momento de la devolucion';
COMMENT ON COLUMN DEVOL.usuario_creacion IS
    'Usuario o proceso que registro la devolucion del cheque';
COMMENT ON COLUMN DEVOL.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN DEVOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DEVOL.observaciones IS
    'Notas sobre la devolucion, gestiones de cobro o acuerdos de pago';
COMMENT ON COLUMN DEVOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DEVOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DEVOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DEVOL (
    numero_cuenta            TEXT IS 'No. Cuenta',
    numero_cheque            TEXT IS 'No. Cheque',
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

CREATE INDEX IDEVOLCTA ON DEVOL (numero_cheque, numero_cuenta);
CREATE INDEX IDEVOLCAT ON DEVOL (created_at);
