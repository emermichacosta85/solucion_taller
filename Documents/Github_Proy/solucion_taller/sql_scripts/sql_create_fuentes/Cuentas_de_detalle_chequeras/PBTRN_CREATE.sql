-- ============================================================
-- Nombre de la Tabla  : PBTRN
-- DESCRIPCION         : Transacciones de Libretas de Ahorro
-- Objetivo            : Registrar el historial de movimientos impresos
--                       en libretas de ahorro fisicas de los clientes.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Transacciones de ahorro procesadas en caja y canales
-- Permanencia de Datos: Historica (retener segun politica de archivo)
-- Uso de los datos    : Impresion de libretas, consulta de movimientos
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE PBTRN (
    numero_cuenta           FOR COLUMN PBTRNRTA VARCHAR(24)     NOT NULL    ,
    fecha                   FOR COLUMN PBTRNFEC DATE            NOT NULL    ,
    hora                    FOR COLUMN PBTRNHRA TIME            NOT NULL    ,
    fecha_apertura          FOR COLUMN PBTRNFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN PBTRNFUT DATE                       ,
    saldo_actual            FOR COLUMN PBTRNSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN PBTRNSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN PBTRNLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN PBTRNESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN PBTRNUS VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN PBTRNUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN PBTRNVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN PBTRNOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN PBTRNERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN PBTRNCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN PBTRNUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_PBTRN PRIMARY KEY (numero_cuenta)
    --CONSTRAINT FK_PBTRN_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT PBTRNR;

RENAME TABLE PBTRN
    TO PBTRN_TABLE FOR SYSTEM NAME PBTRN;

COMMENT ON TABLE PBTRN IS
    'Transacciones de Libretas de Ahorro - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE PBTRN
    IS 'Transac Libretas Ahorro';

COMMENT ON COLUMN PBTRN.numero_cuenta IS
    'Numero de cuenta de ahorro a la que corresponde la transaccion (FK ACMST)';
COMMENT ON COLUMN PBTRN.fecha IS
    'Fecha de la transaccion procesada en la libreta';
COMMENT ON COLUMN PBTRN.hora IS
    'Hora exacta del procesamiento de la transaccion';
COMMENT ON COLUMN PBTRN.fecha_apertura IS
    'Fecha de apertura de la cuenta de ahorro asociada';
COMMENT ON COLUMN PBTRN.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado en la cuenta';
COMMENT ON COLUMN PBTRN.saldo_actual IS
    'Saldo contable actual de la cuenta en el momento del movimiento';
COMMENT ON COLUMN PBTRN.saldo_disponible IS
    'Saldo disponible para retiro en el momento de la transaccion';
COMMENT ON COLUMN PBTRN.limite_sobregiro IS
    'Limite de sobregiro de la cuenta vigente al momento del movimiento';
COMMENT ON COLUMN PBTRN.estado_cuenta IS
    'Estado operativo de la cuenta al momento del movimiento';
COMMENT ON COLUMN PBTRN.usuario_creacion IS
    'Usuario del sistema o canal que genero el movimiento en libreta';
COMMENT ON COLUMN PBTRN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion sobre el registro';
COMMENT ON COLUMN PBTRN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN PBTRN.observaciones IS
    'Notas adicionales sobre el movimiento de libreta';
COMMENT ON COLUMN PBTRN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN PBTRN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN PBTRN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN PBTRN (
    numero_cuenta            TEXT IS 'No. Cuenta',
    fecha                    TEXT IS 'Fecha',
    hora                     TEXT IS 'Hora',
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

CREATE INDEX IPBTRNPK ON PBTRN (numero_cuenta,fecha);
CREATE INDEX IPBTRNFEC ON PBTRN (fecha);
