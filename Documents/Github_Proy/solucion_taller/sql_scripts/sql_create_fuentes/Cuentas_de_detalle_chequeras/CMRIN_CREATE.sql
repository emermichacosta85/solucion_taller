-- ============================================================
-- Nombre de la Tabla  : CMRIN
-- DESCRIPCION         : Detalle de Camara Entrante
-- Objetivo            : Registrar los cheques recibidos a traves del proceso
--                       de camara de compensacion para su acreditacion en
--                       las cuentas de los beneficiarios.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Proceso de camara de compensacion interbancaria
-- Permanencia de Datos: Historica (ciclo de compensacion)
-- Uso de los datos    : Acreditacion de cheques, control de camara y auditoria
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CMRIN (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CMRINBNK,
    sucursal_moneda         VARCHAR(50)     NOT NULL    FOR COLUMN CMRINSMO,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN CMRINCTA,
    monto                   DECIMAL(18,2)   NOT NULL    FOR COLUMN CMRINMNT,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CMRINSEQ,
    numero_cheque           VARCHAR(30)                 FOR COLUMN CMRINCHE,
    banco_origen            VARCHAR(50)                 FOR COLUMN CMRINBOR,
    fecha_compensacion      DATE                        FOR COLUMN CMRINFCO,
    estado_camara           VARCHAR(20)                 FOR COLUMN CMRINEST,
    codigo_moneda           VARCHAR(20)                 FOR COLUMN CMRINMON,
    fecha_apertura          DATE                        FOR COLUMN CMRINFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CMRINFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CMRINSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CMRINSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CMRINLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CMRINESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CMRINUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CMRINUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CMRINVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CMRINOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CMRINERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CMRINCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CMRINUAT,
    CONSTRAINT PK_CMRIN PRIMARY KEY (codigo_banco, sucursal_moneda,
                                     numero_cuenta, monto, secuencia),
    CONSTRAINT FK_CMRIN_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT CMRINR;

RENAME TABLE HNEACOSTA1/CMRIN
    TO CMRIN FOR SYSTEM NAME CMRIN;

COMMENT ON TABLE HNEACOSTA1/CMRIN IS
    'Detalle de Camara de Compensacion Entrante - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/CMRIN
    IS 'Camara Entrante';

COMMENT ON COLUMN HNEACOSTA1/CMRIN.codigo_banco IS
    'Codigo del banco receptor de los cheques en camara entrante';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.sucursal_moneda IS
    'Combinacion de sucursal y moneda que identifica la sesion de camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.numero_cuenta IS
    'Numero de cuenta a la que se acredita el cheque de camara (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.monto IS
    'Valor monetario del cheque recibido en camara de compensacion';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.secuencia IS
    'Numero de orden del cheque dentro de la sesion de camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.numero_cheque IS
    'Numero del cheque recibido en el proceso de camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.banco_origen IS
    'Nombre o codigo del banco de origen que envio el cheque a camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.fecha_compensacion IS
    'Fecha en que se procesa la compensacion y se acredita el monto';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.estado_camara IS
    'Estado del cheque en camara: PENDIENTE, ACREDITADO, DEVUELTO, RECHAZADO';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.codigo_moneda IS
    'Codigo ISO de la moneda del cheque recibido en camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.fecha_apertura IS
    'Fecha de apertura de la cuenta de acreditacion';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con este cheque de camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.saldo_actual IS
    'Saldo de la cuenta de destino al momento de la acreditacion';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.saldo_disponible IS
    'Saldo disponible de la cuenta despues de la acreditacion';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.limite_sobregiro IS
    'Limite de sobregiro de la cuenta de destino al momento del proceso';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.estado_cuenta IS
    'Estado operativo de la cuenta de destino al momento de la acreditacion';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.usuario_creacion IS
    'Usuario o proceso batch que registro el cheque de camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.observaciones IS
    'Notas sobre el procesamiento del cheque en camara';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CMRIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CMRIN (
    codigo_banco             TEXT IS 'Banco',
    sucursal_moneda          TEXT IS 'Suc Moneda',
    numero_cuenta            TEXT IS 'No. Cuenta',
    monto                    TEXT IS 'Monto',
    secuencia                TEXT IS 'Secuencia',
    numero_cheque            TEXT IS 'No. Cheque',
    banco_origen             TEXT IS 'Banco Origen',
    fecha_compensacion       TEXT IS 'Fec Compens',
    estado_camara            TEXT IS 'Estado Cam',
    codigo_moneda            TEXT IS 'Moneda',
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

CREATE INDEX HNEACOSTA1/ICMRINCTA ON HNEACOSTA1/CMRIN (numero_cuenta);
CREATE INDEX HNEACOSTA1/ICMRINFCO ON HNEACOSTA1/CMRIN (fecha_compensacion);
CREATE INDEX HNEACOSTA1/ICMRINCAT ON HNEACOSTA1/CMRIN (created_at);
