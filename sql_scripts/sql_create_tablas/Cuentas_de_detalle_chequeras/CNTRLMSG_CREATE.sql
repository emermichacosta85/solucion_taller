-- ============================================================
-- Nombre de la Tabla  : CNTRLMSG
-- DESCRIPCION         : Mensajes a ser impresos en estados de cuenta
-- Objetivo            : Almacenar los mensajes institucionales o promocionales
--                       que el banco desea imprimir en los estados de cuenta
--                       de sus clientes.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion administrativa del banco
-- Permanencia de Datos: Permanente (actualizable por ciclo de estado de cuenta)
-- Uso de los datos    : Generacion de estados de cuenta con mensajes vigentes
-- Restricciones       : PK por codigo de banco
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE CNTRLMSG (
    codigo_banco            FOR COLUMN CNTRMBNK VARCHAR(20)     NOT NULL    ,
    fecha_apertura          FOR COLUMN CNTRMFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CNTRMFUT DATE                       ,
    saldo_actual            FOR COLUMN CNTRMSAC DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN CNTRMSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN CNTRMLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN CNTRMESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN CNTRMUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN CNTRMUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN CNTRMVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CNTRMOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN CNTRMERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN CNTRMCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CNTRMUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLMSG PRIMARY KEY (codigo_banco, secuencia, idioma)
)
RCDFMT CNTRLMSR;

RENAME TABLE CNTRLMSG
    TO CNTRLMSG_TABLE FOR SYSTEM NAME CNTRLMSG;

COMMENT ON TABLE CNTRLMSG IS
    'Mensajes para Impresion en Estados de Cuenta - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE CNTRLMSG
    IS 'Mensajes Estado Cuenta';

COMMENT ON COLUMN CNTRLMSG.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de mensajes';
COMMENT ON COLUMN CNTRLMSG.fecha_apertura IS
    'Fecha de alta del mensaje en el sistema';
COMMENT ON COLUMN CNTRLMSG.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion del mensaje';
COMMENT ON COLUMN CNTRLMSG.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLMSG.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLMSG.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLMSG.estado_cuenta IS
    'Estado del mensaje de estado de cuenta: ACTIVO, VENCIDO, SUSPENDIDO';
COMMENT ON COLUMN CNTRLMSG.usuario_creacion IS
    'Usuario administrador que ingreso el mensaje al sistema';
COMMENT ON COLUMN CNTRLMSG.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del mensaje';
COMMENT ON COLUMN CNTRLMSG.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLMSG.observaciones IS
    'Notas sobre el contexto o uso del mensaje en estados de cuenta';
COMMENT ON COLUMN CNTRLMSG.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLMSG.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLMSG.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLMSG (
    codigo_banco             TEXT IS 'Banco',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Msg',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX ICNTRMCAT ON CNTRLMSG (created_at);
