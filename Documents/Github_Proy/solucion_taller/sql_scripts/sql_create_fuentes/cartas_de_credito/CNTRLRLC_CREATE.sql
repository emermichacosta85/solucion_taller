-- =============================================================================
-- Nombre de la Tabla  : CNTRLRLC
-- DESCRIPCION         : Tabla de Cargos por Servicios o Tarifas de Cartas de Credito.
--                       Parametriza las comisiones y cargos del modulo LC.
-- Objetivo            : Centralizar las tarifas, comisiones y cargos por servicios aplicables
--                       a las operaciones de cartas de credito por tipo
--                       de producto y banco, con sus metodos de calculo.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion de tarifas por la gerencia del banco y comercio exterior
-- Permanencia de Datos: Permanente (con historial por vigencia)
-- Uso de los datos    : Calculo de comisiones al abrir, enmendar o negociar cartas de credito
-- Restricciones       : PK compuesta por codigo_banco, tipo_producto y numero_tabla.
--                       Tabla de tarifas independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLRLC (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CNTRLBNK,
    tipo_producto           VARCHAR(20)     NOT NULL    FOR COLUMN CNTRLTPR,
    numero_tabla            VARCHAR(30)     NOT NULL    FOR COLUMN CNTRLTBL,
    descripcion_cargo       VARCHAR(120)                FOR COLUMN CNTRLDSC,
    tipo_calculo            VARCHAR(20)                 FOR COLUMN CNTRLTCL,
    tasa_porcentaje         DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLTAS,
    monto_fijo              DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLMFI,
    monto_minimo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLMMN,
    monto_maximo            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLMMX,
    moneda_cargo            VARCHAR(20)                 FOR COLUMN CNTRLMCD,
    vigente_desde           DATE                        FOR COLUMN CNTRLVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTRLVHA,
    frecuencia_cobro        VARCHAR(20)                 FOR COLUMN CNTRLFCO,
    fecha_emision           DATE                        FOR COLUMN CNTRLFEM,
    fecha_vencimiento       DATE                        FOR COLUMN CNTRLFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN CNTRLSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN CNTRLBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN CNTRLPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN CNTRLEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTRLUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTRLUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTRLVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTRLOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTRLERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRLCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRLUAT,
    CONSTRAINT PK_CNTRLRLC PRIMARY KEY (codigo_banco, tipo_producto, numero_tabla)
)
RCDFMT CNTRLRLCR;

RENAME TABLE HNEACOSTA1/CNTRLRLC
    TO CNTRLRLC FOR SYSTEM NAME CNTRLRLC;

COMMENT ON TABLE HNEACOSTA1/CNTRLRLC IS
    'Tarifas de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/CNTRLRLC
    IS 'Tarifas LC';

COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tarifas de cartas de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.tipo_producto IS
    'Tipo de producto de carta de credito al que aplica la tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.numero_tabla IS
    'Numero identificador de la tabla de tarifas dentro del banco y producto';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.descripcion_cargo IS
    'Descripcion del cargo o servicio al que aplica esta tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.tipo_calculo IS
    'Metodo de calculo: PORCENTAJE, FIJO, COMBINADO, MINIMO_MAXIMO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.tasa_porcentaje IS
    'Porcentaje aplicable sobre el monto de la operacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.monto_fijo IS
    'Monto fijo del cargo en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.monto_minimo IS
    'Monto minimo del cargo independientemente del calculo porcentual';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.monto_maximo IS
    'Monto maximo del cargo independientemente del calculo porcentual';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.moneda_cargo IS
    'Codigo ISO de la moneda en que se expresa el cargo fijo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.vigente_desde IS
    'Fecha desde la que esta tabla de tarifas esta vigente';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.vigente_hasta IS
    'Fecha hasta la que es valida la tarifa, nula si es indefinida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.frecuencia_cobro IS
    'Periodicidad del cobro: APERTURA, VENCIMIENTO, MENSUAL, POR_EVENTO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRLC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLRLC (
    codigo_banco                 TEXT IS 'Banco',
    tipo_producto                TEXT IS 'Tipo Prod',
    numero_tabla                 TEXT IS 'No. Tabla',
    descripcion_cargo            TEXT IS 'Desc Cargo',
    tipo_calculo                 TEXT IS 'Tipo Calc',
    tasa_porcentaje              TEXT IS 'Tasa Porc',
    monto_fijo                   TEXT IS 'Monto Fijo',
    monto_minimo                 TEXT IS 'Monto Min',
    monto_maximo                 TEXT IS 'Monto Max',
    moneda_cargo                 TEXT IS 'Moneda',
    vigente_desde                TEXT IS 'Vig Desde',
    vigente_hasta                TEXT IS 'Vig Hasta',
    frecuencia_cobro             TEXT IS 'Freq Cobro',
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

CREATE INDEX HNEACOSTA1/ICNTRLCAT ON HNEACOSTA1/CNTRLRLC (created_at);
CREATE INDEX HNEACOSTA1/ICNTRLTPR ON HNEACOSTA1/CNTRLRLC (tipo_producto);

-- =============================================================================
-- Fin de script: CNTRLRLC_CREATE.sql
-- =============================================================================
