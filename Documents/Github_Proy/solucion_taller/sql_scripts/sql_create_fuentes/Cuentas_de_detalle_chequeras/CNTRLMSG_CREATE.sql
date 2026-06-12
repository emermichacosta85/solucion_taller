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

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLMSG (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CNTRMBNK,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTRMSEQ,
    idioma                  VARCHAR(20)     NOT NULL
                                            DEFAULT 'ES' FOR COLUMN CNTRMIDM,
    tipo_mensaje            VARCHAR(20)                 FOR COLUMN CNTRMTMS,
    texto_mensaje           VARCHAR(500)                FOR COLUMN CNTRMTXT,
    vigente_desde           DATE                        FOR COLUMN CNTRMVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTRMVHA,
    aplica_tipo_producto    VARCHAR(20)                 FOR COLUMN CNTRMTPR,
    fecha_apertura          DATE                        FOR COLUMN CNTRMFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CNTRMFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CNTRMSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CNTRMSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CNTRMLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CNTRMESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTRMUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTRMUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTRMVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTRMOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTRMERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRMCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRMUAT,
    CONSTRAINT PK_CNTRLMSG PRIMARY KEY (codigo_banco, secuencia, idioma)
)
RCDFMT CNTRLMSR;

RENAME TABLE HNEACOSTA1/CNTRLMSG
    TO CNTRLMSG FOR SYSTEM NAME CNTRMSG;

COMMENT ON TABLE HNEACOSTA1/CNTRLMSG IS
    'Mensajes para Impresion en Estados de Cuenta - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/CNTRLMSG
    IS 'Mensajes Estado Cuenta';

COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de mensajes';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.secuencia IS
    'Numero de orden del mensaje para impresion en el estado de cuenta';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.idioma IS
    'Codigo del idioma del mensaje: ES=Espanol, EN=Ingles';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.tipo_mensaje IS
    'Clasificacion del mensaje: INFORMATIVO, PROMOCIONAL, LEGAL, ALERTA';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.texto_mensaje IS
    'Contenido completo del mensaje a imprimir en el estado de cuenta';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.vigente_desde IS
    'Fecha desde la que el mensaje es valido para impresion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.vigente_hasta IS
    'Fecha hasta la que el mensaje debe imprimirse en estados de cuenta';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.aplica_tipo_producto IS
    'Tipo de producto al que aplica el mensaje, nulo si es universal';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.fecha_apertura IS
    'Fecha de alta del mensaje en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion del mensaje';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.estado_cuenta IS
    'Estado del mensaje de estado de cuenta: ACTIVO, VENCIDO, SUSPENDIDO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.usuario_creacion IS
    'Usuario administrador que ingreso el mensaje al sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del mensaje';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.observaciones IS
    'Notas sobre el contexto o uso del mensaje en estados de cuenta';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLMSG.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLMSG (
    codigo_banco             TEXT IS 'Banco',
    secuencia                TEXT IS 'Secuencia',
    idioma                   TEXT IS 'Idioma',
    tipo_mensaje             TEXT IS 'Tipo Mensaje',
    texto_mensaje            TEXT IS 'Texto Msg',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
    aplica_tipo_producto     TEXT IS 'Tipo Prod',
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

CREATE INDEX HNEACOSTA1/ICNTRMCAT ON HNEACOSTA1/CNTRLMSG (created_at);
