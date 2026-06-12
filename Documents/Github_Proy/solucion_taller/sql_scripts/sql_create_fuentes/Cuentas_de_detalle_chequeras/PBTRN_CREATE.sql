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

CREATE OR REPLACE TABLE HNEACOSTA1/PBTRN (
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN PBTRNRTA,
    fecha                   DATE            NOT NULL    FOR COLUMN PBTRNFEC,
    hora                    TIME            NOT NULL    FOR COLUMN PBTRNHRA,
    codigo_transaccion      VARCHAR(20)                 FOR COLUMN PBTRNCTX,
    descripcion_transaccion VARCHAR(80)                 FOR COLUMN PBTRNDES,
    monto                   DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN PBTRNMNT,
    debito_credito          CHAR(1)                     FOR COLUMN PBTRNDC,
    saldo_libreta           DECIMAL(18,2)               FOR COLUMN PBTRNSLB,
    numero_pagina           INT                         FOR COLUMN PBTRNPAG,
    numero_linea            INT                         FOR COLUMN PBTRNLIN,
    fecha_apertura          DATE                        FOR COLUMN PBTRNFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN PBTRNFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN PBTRNSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN PBTRNSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN PBTRNLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN PBTRNESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN PBTRNUS,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN PBTRNUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN PBTRNVRS,
    observaciones           VARCHAR(120)                FOR COLUMN PBTRNOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN PBTRNERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN PBTRNCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN PBTRNUAT,
    CONSTRAINT PK_PBTRN PRIMARY KEY (numero_cuenta, fecha, hora),
    CONSTRAINT FK_PBTRN_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT PBTRNR;

RENAME TABLE HNEACOSTA1/PBTRN
    TO PBTRN FOR SYSTEM NAME PBTRN;

COMMENT ON TABLE HNEACOSTA1/PBTRN IS
    'Transacciones de Libretas de Ahorro - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/PBTRN
    IS 'Transac Libretas Ahorro';

COMMENT ON COLUMN HNEACOSTA1/PBTRN.numero_cuenta IS
    'Numero de cuenta de ahorro a la que corresponde la transaccion (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.fecha IS
    'Fecha de la transaccion procesada en la libreta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.hora IS
    'Hora exacta del procesamiento de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.codigo_transaccion IS
    'Codigo del tipo de transaccion segun catalogo TDRCR';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.descripcion_transaccion IS
    'Descripcion legible de la transaccion para impresion en libreta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.monto IS
    'Valor monetario de la transaccion en la moneda de la cuenta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.debito_credito IS
    'Indicador de naturaleza: D=Debito (retiro), C=Credito (deposito)';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.saldo_libreta IS
    'Saldo de la cuenta impreso en la libreta al momento de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.numero_pagina IS
    'Numero de pagina de la libreta fisica donde se imprimio la linea';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.numero_linea IS
    'Numero de linea dentro de la pagina de la libreta donde aparece el movimiento';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.fecha_apertura IS
    'Fecha de apertura de la cuenta de ahorro asociada';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.saldo_actual IS
    'Saldo contable actual de la cuenta en el momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.saldo_disponible IS
    'Saldo disponible para retiro en el momento de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.limite_sobregiro IS
    'Limite de sobregiro de la cuenta vigente al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.estado_cuenta IS
    'Estado operativo de la cuenta al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.usuario_creacion IS
    'Usuario del sistema o canal que genero el movimiento en libreta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion sobre el registro';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.observaciones IS
    'Notas adicionales sobre el movimiento de libreta';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/PBTRN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/PBTRN (
    numero_cuenta            TEXT IS 'No. Cuenta',
    fecha                    TEXT IS 'Fecha',
    hora                     TEXT IS 'Hora',
    codigo_transaccion       TEXT IS 'Cod Transacc',
    descripcion_transaccion  TEXT IS 'Descripcion',
    monto                    TEXT IS 'Monto',
    debito_credito           TEXT IS 'D/C',
    saldo_libreta            TEXT IS 'Saldo Libret',
    numero_pagina            TEXT IS 'No. Pagina',
    numero_linea             TEXT IS 'No. Linea',
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

CREATE INDEX HNEACOSTA1/IPBTRNFEC ON HNEACOSTA1/PBTRN (fecha);
CREATE INDEX HNEACOSTA1/IPBTRNCAT ON HNEACOSTA1/PBTRN (created_at);
