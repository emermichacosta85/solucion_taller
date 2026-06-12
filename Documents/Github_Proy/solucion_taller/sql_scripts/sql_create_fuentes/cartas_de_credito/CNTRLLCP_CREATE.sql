-- =============================================================================
-- Nombre de la Tabla  : CNTRLLCP
-- DESCRIPCION         : Archivo de Control de Cartas de Credito. Parametros operativos
--                       del modulo de cartas de credito por banco.
-- Objetivo            : Centralizar los parametros de configuracion y control del modulo
--                       de cartas de credito por banco, incluyendo
--                       limites, tasas, indicadores y valores de referencia.
-- Tipo de Tabla       : Control / Parametrica
-- Origen de los Datos : Configuracion de parametros por el area de sistemas y comercio exterior
-- Permanencia de Datos: Permanente (actualizable por banco y parametro)
-- Uso de los datos    : Consulta de parametros al procesar operaciones de cartas de credito
-- Restricciones       : PK compuesta por codigo_banco y lcrparm.
--                       Tabla de control independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLLCP (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CNTLBNK,
    lcrparm                 VARCHAR(20)     NOT NULL    FOR COLUMN CNTLPRM,
    descripcion             VARCHAR(120)                FOR COLUMN CNTLDSC,
    valor_texto             VARCHAR(80)                 FOR COLUMN CNTLVTX,
    valor_numerico          DECIMAL(18,4)               FOR COLUMN CNTLVNU,
    valor_fecha             DATE                        FOR COLUMN CNTLVFE,
    tipo_parametro          VARCHAR(20)                 FOR COLUMN CNTLTPR,
    vigente_desde           DATE                        FOR COLUMN CNTLVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTLVHA,
    fecha_emision           DATE                        FOR COLUMN CNTLFEM,
    fecha_vencimiento       DATE                        FOR COLUMN CNTLFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTLMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTLSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN CNTLBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN CNTLPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN CNTLEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTLUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTLUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTLVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTLOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTLERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTLCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTLUAT,
    CONSTRAINT PK_CNTRLLCP PRIMARY KEY (codigo_banco, lcrparm)
)
RCDFMT CNTLLCPR;

RENAME TABLE HNEACOSTA1/CNTRLLCP
    TO CNTRLLCP FOR SYSTEM NAME CNTRLLCP;

COMMENT ON TABLE HNEACOSTA1/CNTRLLCP IS
    'Archivo de Control de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/CNTRLLCP
    IS 'Control LC';

COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de parametros LC';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.lcrparm IS
    'Codigo del parametro de control de cartas de credito segun catalogo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.descripcion IS
    'Descripcion del parametro y su efecto en el proceso de cartas de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.valor_texto IS
    'Valor textual del parametro cuando aplica tipo caracter';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.valor_numerico IS
    'Valor numerico del parametro cuando aplica tipo numerico';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.valor_fecha IS
    'Valor fecha del parametro cuando aplica tipo fecha';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.tipo_parametro IS
    'Tipo de dato del parametro: TEXTO, NUMERICO, FECHA, INDICADOR';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.vigente_desde IS
    'Fecha desde la que este valor del parametro esta vigente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.vigente_hasta IS
    'Fecha hasta la que este valor del parametro tiene vigencia';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLLCP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLLCP (
    codigo_banco                 TEXT IS 'Banco',
    lcrparm                      TEXT IS 'Cod Parametro',
    descripcion                  TEXT IS 'Descripcion',
    valor_texto                  TEXT IS 'Valor Texto',
    valor_numerico               TEXT IS 'Valor Numerico',
    valor_fecha                  TEXT IS 'Valor Fecha',
    tipo_parametro               TEXT IS 'Tipo Param',
    vigente_desde                TEXT IS 'Vig Desde',
    vigente_hasta                TEXT IS 'Vig Hasta',
    fecha_emision                TEXT IS 'Fec Emision',
    fecha_vencimiento            TEXT IS 'Fec Vencim',
    monto_original               TEXT IS 'Monto Orig',
    saldo_actual                 TEXT IS 'Saldo Actual',
    banco_corresponsal           TEXT IS 'Banco Corresp',
    pais_destino                 TEXT IS 'Pais Destino',
    estado_carta                 TEXT IS 'Estado Carta',
    usuario_creacion             TEXT IS 'Usr Creacion',
    usuario_actualizacion        TEXT IS 'Usr Actualiz',
    version_registro             TEXT IS 'Version Reg',
    observaciones                TEXT IS 'Observacion',
    estado_registro              TEXT IS 'Estado Reg',
    created_at                   TEXT IS 'Fec Creacion',
    updated_at                   TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTLLCAT ON HNEACOSTA1/CNTRLLCP (created_at);

-- =============================================================================
-- Fin de script: CNTRLLCP_CREATE.sql
-- =============================================================================
