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

CREATE OR REPLACE TABLE CHMST (
    codigo_banco            FOR COLUMN CHMSTBNK VARCHAR(20)  NOT NULL    ,
    codigo_sucursal         FOR COLUMN CHMSTSUC VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN CHMSTMON VARCHAR(20)     NOT NULL    ,
    numero_cuenta           FOR COLUMN CHMSTCTA VARCHAR(24)     NOT NULL    ,
    cheque_inicial          FOR COLUMN CHMSTCHI VARCHAR(50)     NOT NULL    ,
    cheque_final            FOR COLUMN CHMSTCHF VARCHAR(50)     NOT NULL  ,
    cantidad_cheques        FOR COLUMN CHMSTQCH INT  NOT NULL DEFAULT 0   , 
    cheques_utilizados      FOR COLUMN CHMSTCHU INT  NOT NULL DEFAULT 0   ,
    fecha_solicitud         FOR COLUMN CHMSTFSO DATE                        ,
    fecha_entrega           FOR COLUMN CHMSTFEN DATE                        ,
    estado_chequera         FOR COLUMN CHMSTEST VARCHAR(20)                 ,
    fecha_apertura           FOR COLUMN CHMSTFAP DATE                       ,
    fecha_ultima_transaccion FOR COLUMN CHMSTFUT DATE                       ,
    saldo_actual            FOR COLUMN CHMSTSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN CHMSTSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN CHMSTLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN CHMSTESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN CHMSTUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN CHMSTUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN CHMSSTVRS INT   NOT NULL DEFAULT 1   ,
    observaciones           FOR COLUMN CHMSTOBS VARCHAR(120) NOT NULL                ,
    estado_registro         FOR COLUMN CHMSTERG CHAR(1) NOT NULL DEFAULT 'A' ,
    created_at              FOR COLUMN CHMSTCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CHMSTUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CHMST PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_cuenta,
                                     cheque_inicial)
    --CONSTRAINT FK_CHMST_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT CHMSTR;

RENAME TABLE CHMST
    TO CHMST_TABLE FOR SYSTEM NAME CHMST;

COMMENT ON TABLE CHMST IS
    'Maestro de Chequeras de Cuentas Corrientes - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE CHMST
    IS 'Maestro Chequeras';

COMMENT ON COLUMN CHMST.codigo_banco IS
    'Codigo del banco al que pertenece la chequera';
COMMENT ON COLUMN CHMST.codigo_sucursal IS
    'Codigo de la sucursal que emitio o entrego la chequera';
COMMENT ON COLUMN CHMST.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta corriente de la chequera';
COMMENT ON COLUMN CHMST.numero_cuenta IS
    'Numero de cuenta corriente a la que fue asignada la chequera (FK ACMST)';
COMMENT ON COLUMN CHMST.cheque_inicial IS
    'Numero del primer cheque del talonario asignado';
COMMENT ON COLUMN CHMST.cheque_final IS
    'Numero del ultimo cheque del talonario asignado';
COMMENT ON COLUMN CHMST.cantidad_cheques IS
    'Total de cheques que contiene el talonario';
COMMENT ON COLUMN CHMST.cheques_utilizados IS
    'Cantidad de cheques ya utilizados del talonario';
COMMENT ON COLUMN CHMST.fecha_solicitud IS
    'Fecha en que el cliente solicito la chequera';
COMMENT ON COLUMN CHMST.fecha_entrega IS
    'Fecha en que la chequera fue entregada al cliente';
COMMENT ON COLUMN CHMST.estado_chequera IS
    'Estado del talonario: ACTIVO, AGOTADO, BLOQUEADO, CANCELADO';
COMMENT ON COLUMN CHMST.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente asociada a la chequera';
COMMENT ON COLUMN CHMST.fecha_ultima_transaccion IS
    'Fecha del ultimo uso o modificacion sobre la chequera';
COMMENT ON COLUMN CHMST.saldo_actual IS
    'Saldo actual de la cuenta corriente al momento del registro';
COMMENT ON COLUMN CHMST.saldo_disponible IS
    'Saldo disponible de la cuenta corriente al momento del registro';
COMMENT ON COLUMN CHMST.limite_sobregiro IS
    'Limite de sobregiro de la cuenta corriente asociada';
COMMENT ON COLUMN CHMST.estado_cuenta IS
    'Estado operativo de la cuenta corriente asociada';
COMMENT ON COLUMN CHMST.usuario_creacion IS
    'Usuario del sistema que registro la chequera';
COMMENT ON COLUMN CHMST.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN CHMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CHMST.observaciones IS
    'Notas sobre la chequera, su emision o estado especial';
COMMENT ON COLUMN CHMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CHMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CHMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CHMST (
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

CREATE INDEX ICHMSTCTA ON CHMST (numero_cuenta);
CREATE INDEX ICHMSTCAT ON CHMST (created_at);
