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

CREATE OR REPLACE TABLE CMRIN (
    codigo_banco            FOR COLUMN CMRINBNK VARCHAR(20)     NOT NULL    ,
    sucursal_moneda         FOR COLUMN CMRINSMO VARCHAR(50)     NOT NULL    ,
    numero_cuenta           FOR COLUMN CMRINCTA VARCHAR(24)     NOT NULL    ,
    monto                   FOR COLUMN CMRINMNT DECIMAL(18,2)   NOT NULL    ,
    secuencia               FOR COLUMN CMRINSEQ INT             NOT NULL
                                            DEFAULT 1   ,
    numero_cheque           FOR COLUMN CMRINCHE VARCHAR(30) NOT NULL                 ,
    banco_origen            FOR COLUMN CMRINBOR VARCHAR(50) NOT NULL                ,
    fecha_compensacion      FOR COLUMN CMRINFCO DATE                        ,
    estado_camara           FOR COLUMN CMRINEST VARCHAR(20) NOT NULL                ,
    codigo_moneda           FOR COLUMN CMRINMON VARCHAR(20) NOT NULL                ,
    fecha_apertura          FOR COLUMN CMRINFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CMRINFUT DATE                       ,
    saldo_actual            FOR COLUMN CMRINSAL DECIMAL(18,2) NOT NULL              ,
    saldo_disponible        FOR COLUMN CMRINSDP DECIMAL(18,2) NOT NULL              ,
    limite_sobregiro        FOR COLUMN CMRINLSO DECIMAL(18,2) NOT NULL              ,
    estado_cuenta           FOR COLUMN CMRINESC VARCHAR(20) NOT NULL                ,
    usuario_creacion        FOR COLUMN CMRINUSC VARCHAR(30) NOT NULL                ,
    usuario_actualizacion   FOR COLUMN CMRINUSA VARCHAR(30) NOT NULL                ,
    version_registro        FOR COLUMN CMRINVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CMRINOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN CMRINERG CHAR(1)         NOT NULL,
    created_at              FOR COLUMN CMRINCAT TIMESTAMP default CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CMRINUAT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CMRIN PRIMARY KEY (codigo_banco, sucursal_moneda,
                                     numero_cuenta, monto, secuencia)
    --CONSTRAINT FK_CMRIN_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT CMRINR;

RENAME TABLE CMRIN
    TO CMRIN_TABLE FOR SYSTEM NAME CMRIN;

COMMENT ON TABLE CMRIN IS
    'Detalle de Camara de Compensacion Entrante - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE CMRIN
    IS 'Camara Entrante';

COMMENT ON COLUMN CMRIN.codigo_banco IS
    'Codigo del banco receptor de los cheques en camara entrante';
COMMENT ON COLUMN CMRIN.sucursal_moneda IS
    'Combinacion de sucursal y moneda que identifica la sesion de camara';
COMMENT ON COLUMN CMRIN.numero_cuenta IS
    'Numero de cuenta a la que se acredita el cheque de camara (FK ACMST)';
COMMENT ON COLUMN CMRIN.monto IS
    'Valor monetario del cheque recibido en camara de compensacion';
COMMENT ON COLUMN CMRIN.secuencia IS
    'Numero de orden del cheque dentro de la sesion de camara';
COMMENT ON COLUMN CMRIN.numero_cheque IS
    'Numero del cheque recibido en el proceso de camara';
COMMENT ON COLUMN CMRIN.banco_origen IS
    'Nombre o codigo del banco de origen que envio el cheque a camara';
COMMENT ON COLUMN CMRIN.fecha_compensacion IS
    'Fecha en que se procesa la compensacion y se acredita el monto';
COMMENT ON COLUMN CMRIN.estado_camara IS
    'Estado del cheque en camara: PENDIENTE, ACREDITADO, DEVUELTO, RECHAZADO';
COMMENT ON COLUMN CMRIN.codigo_moneda IS
    'Codigo ISO de la moneda del cheque recibido en camara';
COMMENT ON COLUMN CMRIN.fecha_apertura IS
    'Fecha de apertura de la cuenta de acreditacion';
COMMENT ON COLUMN CMRIN.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento relacionado con este cheque de camara';
COMMENT ON COLUMN CMRIN.saldo_actual IS
    'Saldo de la cuenta de destino al momento de la acreditacion';
COMMENT ON COLUMN CMRIN.saldo_disponible IS
    'Saldo disponible de la cuenta despues de la acreditacion';
COMMENT ON COLUMN CMRIN.limite_sobregiro IS
    'Limite de sobregiro de la cuenta de destino al momento del proceso';
COMMENT ON COLUMN CMRIN.estado_cuenta IS
    'Estado operativo de la cuenta de destino al momento de la acreditacion';
COMMENT ON COLUMN CMRIN.usuario_creacion IS
    'Usuario o proceso batch que registro el cheque de camara';
COMMENT ON COLUMN CMRIN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN CMRIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CMRIN.observaciones IS
    'Notas sobre el procesamiento del cheque en camara';
COMMENT ON COLUMN CMRIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CMRIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CMRIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CMRIN (
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

CREATE INDEX ICMRINCTA ON CMRIN (numero_cuenta);
CREATE INDEX ICMRINFCO ON CMRIN (fecha_compensacion);
CREATE INDEX ICMRINCAT ON CMRIN (created_at);
