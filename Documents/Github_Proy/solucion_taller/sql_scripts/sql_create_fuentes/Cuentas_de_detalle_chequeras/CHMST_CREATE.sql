-- ============================================================
-- Nombre de la Tabla  : CHMST
-- DESCRIPCION         : Maestro de Chequeras
-- Objetivo            : Controlar los talonarios de cheques asignados a
--                       cuentas corrientes, incluyendo su rango y estado.
-- Tipo de Tabla       : Maestra / Operativa
-- Origen de los Datos : Proceso de solicitud y asignacion de chequeras
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Control de emision, pago y devolucion de cheques
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CHMST (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CHMSTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN CHMSTSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN CHMSTMON,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN CHMSTCTA,
    cheque_inicial          VARCHAR(50)     NOT NULL    FOR COLUMN CHMSTCHI,
    cheque_final            VARCHAR(50)                 FOR COLUMN CHMSTCHF,
    cantidad_cheques        INT                         FOR COLUMN CHMSTQCH,
    cheques_utilizados      INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN CHMSTCHU,
    fecha_solicitud         DATE                        FOR COLUMN CHMSTFSO,
    fecha_entrega           DATE                        FOR COLUMN CHMSTFEN,
    estado_chequera         VARCHAR(20)                 FOR COLUMN CHMSTEST,
    fecha_apertura          DATE                        FOR COLUMN CHMSTFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CHMSTFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CHMSTSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CHMSTSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CHMSTLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CHMSTESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CHMSTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CHMSTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CHMSSTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CHMSTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CHMSTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHMSTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHMSTUAT,
    CONSTRAINT PK_CHMST PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_cuenta,
                                     cheque_inicial),
    CONSTRAINT FK_CHMST_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT CHMSTR;

RENAME TABLE HNEACOSTA1/CHMST
    TO CHMST FOR SYSTEM NAME CHMST;

COMMENT ON TABLE HNEACOSTA1/CHMST IS
    'Maestro de Chequeras de Cuentas Corrientes - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/CHMST
    IS 'Maestro Chequeras';

COMMENT ON COLUMN HNEACOSTA1/CHMST.codigo_banco IS
    'Codigo del banco al que pertenece la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.codigo_sucursal IS
    'Codigo de la sucursal que emitio o entrego la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta corriente de la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.numero_cuenta IS
    'Numero de cuenta corriente a la que fue asignada la chequera (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/CHMST.cheque_inicial IS
    'Numero del primer cheque del talonario asignado';
COMMENT ON COLUMN HNEACOSTA1/CHMST.cheque_final IS
    'Numero del ultimo cheque del talonario asignado';
COMMENT ON COLUMN HNEACOSTA1/CHMST.cantidad_cheques IS
    'Total de cheques que contiene el talonario';
COMMENT ON COLUMN HNEACOSTA1/CHMST.cheques_utilizados IS
    'Cantidad de cheques ya utilizados del talonario';
COMMENT ON COLUMN HNEACOSTA1/CHMST.fecha_solicitud IS
    'Fecha en que el cliente solicito la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.fecha_entrega IS
    'Fecha en que la chequera fue entregada al cliente';
COMMENT ON COLUMN HNEACOSTA1/CHMST.estado_chequera IS
    'Estado del talonario: ACTIVO, AGOTADO, BLOQUEADO, CANCELADO';
COMMENT ON COLUMN HNEACOSTA1/CHMST.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente asociada a la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.fecha_ultima_transaccion IS
    'Fecha del ultimo uso o modificacion sobre la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.saldo_actual IS
    'Saldo actual de la cuenta corriente al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/CHMST.saldo_disponible IS
    'Saldo disponible de la cuenta corriente al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/CHMST.limite_sobregiro IS
    'Limite de sobregiro de la cuenta corriente asociada';
COMMENT ON COLUMN HNEACOSTA1/CHMST.estado_cuenta IS
    'Estado operativo de la cuenta corriente asociada';
COMMENT ON COLUMN HNEACOSTA1/CHMST.usuario_creacion IS
    'Usuario del sistema que registro la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHMST.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CHMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CHMST.observaciones IS
    'Notas sobre la chequera, su emision o estado especial';
COMMENT ON COLUMN HNEACOSTA1/CHMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CHMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CHMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CHMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_cuenta            TEXT IS 'No. Cuenta',
    cheque_inicial           TEXT IS 'Cheque Inic',
    cheque_final             TEXT IS 'Cheque Final',
    cantidad_cheques         TEXT IS 'Cant Cheques',
    cheques_utilizados       TEXT IS 'Cheq Usados',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_entrega            TEXT IS 'Fec Entrega',
    estado_chequera          TEXT IS 'Estado Cheq',
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

CREATE INDEX HNEACOSTA1/ICHMSTCTA ON HNEACOSTA1/CHMST (numero_cuenta);
CREATE INDEX HNEACOSTA1/ICHMSTCAT ON HNEACOSTA1/CHMST (created_at);
