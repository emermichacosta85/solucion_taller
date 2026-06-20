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
    codigo_banco             FOR COLUMN CNTLBNK    VARCHAR(20)    NOT NULL,
    lcrparm                  FOR COLUMN CNTLPRM    VARCHAR(20)    NOT NULL,
    fecha_emision            FOR COLUMN CNTLFEM    DATE,
    fecha_vencimiento        FOR COLUMN CNTLFVE    DATE,
    monto_original           FOR COLUMN CNTLMOR    DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN CNTLSAL    DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN CNTLBCR    VARCHAR(80),
    pais_destino             FOR COLUMN CNTLPDS    VARCHAR(80),
    estado_carta             FOR COLUMN CNTLEST    VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN CNTLUSC    VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTLUSA    VARCHAR(30),
    version_registro         FOR COLUMN CNTLVRS    INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN CNTLOBS    VARCHAR(120),
    estado_registro          FOR COLUMN CNTLERG    CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN CNTLCAT    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTLUAT    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
