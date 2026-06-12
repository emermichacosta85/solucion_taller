-- =============================================================================
-- Nombre de la Tabla  : LCSTA
-- DESCRIPCION         : Estadistica de Aperturas, Enmiendas y Pagos en Cartas de Credito.
--                       Concentra indicadores agregados por periodo.
-- Objetivo            : Almacenar estadisticas consolidadas de las operaciones de cartas de
--                       credito por periodo, banco, tipo y moneda para
--                       reporteria gerencial y cumplimiento regulatorio.
-- Tipo de Tabla       : Estadistica / Resumen
-- Origen de los Datos : Proceso batch de cierre estadistico periodico
-- Permanencia de Datos: Historica (retener por ciclos regulatorios)
-- Uso de los datos    : Reporteria gerencial, estadistica regulatoria y analisis de tendencias
-- Restricciones       : PK tecnica (id). UNIQUE por periodo, banco, tipo y moneda.
--                       Tabla estadistica independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCSTA (
    id                      BIGINT          NOT NULL    FOR COLUMN LCSTAID,
    periodo                 VARCHAR(10)     NOT NULL    FOR COLUMN LCSTAPER,
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN LCSTABNK,
    tipo_estadistica        VARCHAR(20)     NOT NULL    FOR COLUMN LCSTATES,
    tipo_carta              VARCHAR(20)                 FOR COLUMN LCSTATCO,
    codigo_moneda           VARCHAR(20)                 FOR COLUMN LCSTAMON,
    cantidad_operaciones    INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN LCSTAQOP,
    monto_total             DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCSTAMTO,
    pais_destino_principal  VARCHAR(80)                 FOR COLUMN LCSTAPDS,
    fecha_emision           DATE                        FOR COLUMN LCSTAFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCSTAFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCSTAMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCSTASAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCSTABCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCSTAPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCSTAEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCSTAUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCSTAUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCSTAVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCSTAOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCSTAERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCSTACAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCSTAUAT,
    CONSTRAINT PK_LCSTA PRIMARY KEY (id),
    CONSTRAINT UQ_LCSTA_PRD UNIQUE (periodo, codigo_banco, tipo_estadistica, tipo_carta, codigo_moneda)
)
RCDFMT LCSTAR;

RENAME TABLE HNEACOSTA1/LCSTA
    TO LCSTA FOR SYSTEM NAME LCSTA;

COMMENT ON TABLE HNEACOSTA1/LCSTA IS
    'Estadistica de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCSTA
    IS 'Estadistica LC';

COMMENT ON COLUMN HNEACOSTA1/LCSTA.id IS
    'Identificador tecnico unico autoincremental del registro estadistico';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.periodo IS
    'Periodo de la estadistica en formato AAAAMM';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.codigo_banco IS
    'Codigo del banco al que corresponde la estadistica';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.tipo_estadistica IS
    'Tipo de evento estadistico: APERTURA, ENMIENDA, PAGO, VENCIMIENTO, CANCELACION';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.tipo_carta IS
    'Tipo de carta de credito: IMPORTACION, EXPORTACION, STAND_BY, GARANTIA';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.codigo_moneda IS
    'Codigo ISO de la moneda de las operaciones contabilizadas';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.cantidad_operaciones IS
    'Numero total de operaciones del tipo en el periodo';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.monto_total IS
    'Monto agregado de todas las operaciones del tipo en el periodo';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.pais_destino_principal IS
    'Pais de mayor volumen de operaciones en el periodo estadistico';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCSTA.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCSTA (
    id                           TEXT IS 'ID Estadistica',
    periodo                      TEXT IS 'Periodo',
    codigo_banco                 TEXT IS 'Banco',
    tipo_estadistica             TEXT IS 'Tipo Estadist',
    tipo_carta                   TEXT IS 'Tipo Carta',
    codigo_moneda                TEXT IS 'Moneda',
    cantidad_operaciones         TEXT IS 'Cant Oper',
    monto_total                  TEXT IS 'Monto Total',
    pais_destino_principal       TEXT IS 'Pais Principal',
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

CREATE INDEX HNEACOSTA1/ILCSTAPER ON HNEACOSTA1/LCSTA (periodo);
CREATE INDEX HNEACOSTA1/ILCSTACAT ON HNEACOSTA1/LCSTA (created_at);

-- =============================================================================
-- Fin de script: LCSTA_CREATE.sql
-- =============================================================================
