-- ================================================================
-- Nombre de la Tabla  : CNTRLPRF
-- DESCRIPCION         : Archivo de Control de Pagos y Recibos
-- Objetivo            : Almacenar los parametros de configuracion del
--                       modulo de pagos y transferencias, definiendo
--                       por banco las cuentas contables, limites de
--                       monto, canales habilitados y politicas que
--                       rigen el procesamiento de ordenes de pago,
--                       transferencias SWIFT y mensajes telex.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion del modulo por sistemas y
--                       el area de operaciones internacionales
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia en todos los procesos del modulo
--                       para validaciones y parametros globales
-- Restricciones       : PK compuesta por banco, parametro y codigo_tabla;
--                       tabla raiz parametrica del modulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLPRF (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CNPRFBNK,
    parametro                VARCHAR(20)    NOT NULL     FOR COLUMN CNPRFPAR,
    codigo_tabla             VARCHAR(20)    NOT NULL     FOR COLUMN CNPRFTBL,
    descripcion              VARCHAR(120)                FOR COLUMN CNPRFDSC,
    valor_texto              VARCHAR(120)                FOR COLUMN CNPRFVTX,
    valor_numerico           DECIMAL(18,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNPRFVNM,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN CNPRFMON,
    cuenta_contable_debito   VARCHAR(24)                 FOR COLUMN CNPRFCDB,
    cuenta_contable_credito  VARCHAR(24)                 FOR COLUMN CNPRFCCR,
    monto_limite_diario      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNPRFMLD,
    monto_limite_transaccion DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNPRFMLT,
    requiere_autorizacion    CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN CNPRFRAT,
    canal_habilitado         CHAR(1)        NOT NULL
                                            DEFAULT 'S'  FOR COLUMN CNPRFCHA,
    fecha_operacion          DATE                        FOR COLUMN CNPRFFOP,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNPRFMNT,
    beneficiario             VARCHAR(80)                 FOR COLUMN CNPRFBEN,
    banco_destino            VARCHAR(80)                 FOR COLUMN CNPRFBDE,
    canal_pago               VARCHAR(20)                 FOR COLUMN CNPRFCPA,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN CNPRFEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CNPRFUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CNPRFUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNPRFVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CNPRFOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CNPRFERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNPRFCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNPRFUAT,
    CONSTRAINT PK_CNTRLPRF PRIMARY KEY (codigo_banco, parametro,
                                        codigo_tabla)
)
RCDFMT CNTPRFR;

RENAME TABLE HNEACOSTA1/CNTRLPRF
    TO CNTRLPRF FOR SYSTEM NAME CNTRLPRF;

COMMENT ON TABLE HNEACOSTA1/CNTRLPRF IS
    'Parametros de Control de Pagos y Transferencias - Modulo 12';

LABEL ON TABLE HNEACOSTA1/CNTRLPRF
    IS 'Control Pagos Transf';

COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de pagos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.parametro IS
    'Nombre o codigo del parametro de control (ej: SWIFT_BIC, LIMITE_DIARIO)';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.codigo_tabla IS
    'Tabla o seccion a la que pertenece el parametro para organizacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.descripcion IS
    'Descripcion funcional del parametro y su efecto en el modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.valor_texto IS
    'Valor del parametro cuando es de tipo texto (codigos, nombres, flags)';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.valor_numerico IS
    'Valor del parametro cuando es de tipo numerico (montos, tasas, dias)';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.codigo_moneda IS
    'Moneda a la que aplica el parametro cuando es especifico por moneda';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.cuenta_contable_debito IS
    'Cuenta contable debitada en la operacion asociada a este parametro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.cuenta_contable_credito IS
    'Cuenta contable acreditada en la operacion asociada a este parametro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.monto_limite_diario IS
    'Limite maximo acumulado diario para el tipo de operacion del parametro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.monto_limite_transaccion IS
    'Limite maximo por transaccion individual para este tipo de operacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.requiere_autorizacion IS
    'Indica si las transacciones de este tipo requieren aprobacion: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.canal_habilitado IS
    'Indica si el canal o tipo de operacion esta habilitado: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.fecha_operacion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.monto IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.beneficiario IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.banco_destino IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.canal_pago IS
    'Canal de pago al que aplica este parametro de control';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.estado_pago IS
    'Estado del parametro: ACTIVO, INACTIVO, EN_REVISION, DEROGADO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.usuario_creacion IS
    'Usuario administrador que registro el parametro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del parametro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.observaciones IS
    'Notas sobre el parametro, su uso o restricciones de aplicacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLPRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLPRF (
    codigo_banco             TEXT IS 'Banco',
    parametro                TEXT IS 'Parametro',
    codigo_tabla             TEXT IS 'Cod Tabla',
    descripcion              TEXT IS 'Descripcion',
    valor_texto              TEXT IS 'Valor Texto',
    valor_numerico           TEXT IS 'Valor Num',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable_debito   TEXT IS 'Cta Debito',
    cuenta_contable_credito  TEXT IS 'Cta Credito',
    monto_limite_diario      TEXT IS 'Lim Diario',
    monto_limite_transaccion TEXT IS 'Lim Transac',
    requiere_autorizacion    TEXT IS 'Req Autoriz',
    canal_habilitado         TEXT IS 'Habilitado',
    fecha_operacion          TEXT IS 'Fec Oper',
    monto                    TEXT IS 'Monto',
    beneficiario             TEXT IS 'Beneficiario',
    banco_destino            TEXT IS 'Banco Dest',
    canal_pago               TEXT IS 'Canal Pago',
    estado_pago              TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNPRFCAT ON HNEACOSTA1/CNTRLPRF (created_at);
CREATE INDEX HNEACOSTA1/ICNPRFMON ON HNEACOSTA1/CNTRLPRF (codigo_moneda);

