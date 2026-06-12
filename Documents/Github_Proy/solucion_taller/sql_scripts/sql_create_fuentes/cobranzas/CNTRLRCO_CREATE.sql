-- ================================================================
-- Nombre de la Tabla  : CNTRLRCO
-- DESCRIPCION         : Tabla de Cargos por Servicios o Tarifas de Cobranzas
-- Objetivo            : Parametrizar las tarifas, cargos y comisiones
--                       aplicables a los diferentes tipos de operaciones
--                       de cobranza documentaria por banco y tipo de producto,
--                       sirviendo como referencia para el calculo en LCFEE.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion de tarifas por la gerencia bancaria
-- Permanencia de Datos: Permanente (con historial por vigencia)
-- Uso de los datos    : Calculo de comisiones en procesos de cobranza
-- Restricciones       : PK compuesta por banco, tipo_producto y numero_tabla;
--                       tabla parametrica sin FK intramodulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLRCO (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CNTRCBNK,
    tipo_producto            VARCHAR(20)    NOT NULL     FOR COLUMN CNTRCTPR,
    numero_tabla             VARCHAR(30)    NOT NULL     FOR COLUMN CNTRCTBL,
    descripcion_cargo        VARCHAR(120)                FOR COLUMN CNTRCDSC,
    codigo_comision          VARCHAR(20)                 FOR COLUMN CNTRCCCO,
    tipo_calculo             VARCHAR(20)                 FOR COLUMN CNTRCALC,
    porcentaje               DECIMAL(10,6)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRCPRC,
    monto_fijo               DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRCMFI,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN CNTRCMON,
    monto_minimo             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRCMMI,
    monto_maximo             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRCMMA,
    vigente_desde            DATE                        FOR COLUMN CNTRCVDE,
    vigente_hasta            DATE                        FOR COLUMN CNTRCVHA,
    frecuencia_cobro         VARCHAR(20)                 FOR COLUMN CNTRCFCO,
    aplica_iva               CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN CNTRCIVA,
    fecha_recepcion          DATE                        FOR COLUMN CNTRCFRP,
    fecha_vencimiento        DATE                        FOR COLUMN CNTRCFVE,
    monto_original           DECIMAL(18,2)               FOR COLUMN CNTRCMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN CNTRCSPD,
    tipo_documento           VARCHAR(20)                 FOR COLUMN CNTRCTDO,
    estado_operacion         VARCHAR(20)    NOT NULL     FOR COLUMN CNTRCESO,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CNTRCULC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CNTRCUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNTRCVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CNTRCOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CNTRCERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTRCCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTRCUAT,
    CONSTRAINT PK_CNTRLRCO PRIMARY KEY (codigo_banco, tipo_producto,
                                        numero_tabla)
)
RCDFMT CNTRLROR;

RENAME TABLE HNEACOSTA1/CNTRLRCO
    TO CNTRLRCO FOR SYSTEM NAME CNTRRCO;

COMMENT ON TABLE HNEACOSTA1/CNTRLRCO IS
    'Tarifas y Cargos por Servicio de Cobranzas Documentarias - Modulo 6';

LABEL ON TABLE HNEACOSTA1/CNTRLRCO
    IS 'Tarifas Cobranzas';

COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tarifas de cobranza';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.tipo_producto IS
    'Tipo de producto de cobranza al que aplica esta tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.numero_tabla IS
    'Codigo que identifica la tabla de tarifas dentro del tipo de producto';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.descripcion_cargo IS
    'Descripcion del cargo o servicio al que corresponde la tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.codigo_comision IS
    'Codigo de la comision en el catalogo de servicios del banco';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.tipo_calculo IS
    'Metodo de calculo de la tarifa: PORCENTAJE, FIJO, COMBINADO, ESCALADO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.porcentaje IS
    'Porcentaje aplicado sobre el monto de la operacion para calcular el cargo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.monto_fijo IS
    'Monto fijo del cargo cuando el tipo de calculo es FIJO o tiene minimo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.codigo_moneda IS
    'Codigo ISO de la moneda en que se expresa el cargo fijo o minimo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.monto_minimo IS
    'Monto minimo de cargo aplicable incluso si el porcentaje resulta menor';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.monto_maximo IS
    'Monto maximo de cargo aplicable incluso si el porcentaje resulta mayor';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.vigente_desde IS
    'Fecha desde la que esta tabla de tarifas tiene vigencia';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.vigente_hasta IS
    'Fecha hasta la que esta tabla de tarifas tiene vigencia, nula si indefinida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.frecuencia_cobro IS
    'Periodicidad del cobro: POR_EVENTO, MENSUAL, TRIMESTRAL, ANUAL';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.aplica_iva IS
    'Indica si sobre esta comision aplica IVA u otro impuesto: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.fecha_recepcion IS
    'Campo de referencia operativa heredado del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.fecha_vencimiento IS
    'Campo de referencia operativa heredado del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.monto_original IS
    'Campo de referencia operativa heredado del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.saldo_pendiente IS
    'Campo de referencia operativa heredado del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.tipo_documento IS
    'Tipo de documento al que aplica esta tabla de tarifas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.estado_operacion IS
    'Estado de la tabla de tarifas: ACTIVA, VENCIDA, DEROGADA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.usuario_creacion IS
    'Usuario administrador que registro la tabla de tarifas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla de tarifas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.observaciones IS
    'Notas sobre condiciones especiales, excepciones o restricciones de la tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRCO.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLRCO (
    codigo_banco             TEXT IS 'Banco',
    tipo_producto            TEXT IS 'Tipo Product',
    numero_tabla             TEXT IS 'No. Tabla',
    descripcion_cargo        TEXT IS 'Desc Cargo',
    codigo_comision          TEXT IS 'Cod Comision',
    tipo_calculo             TEXT IS 'Tipo Calc',
    porcentaje               TEXT IS 'Porcentaje',
    monto_fijo               TEXT IS 'Monto Fijo',
    codigo_moneda            TEXT IS 'Moneda',
    monto_minimo             TEXT IS 'Monto Min',
    monto_maximo             TEXT IS 'Monto Max',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
    frecuencia_cobro         TEXT IS 'Freq Cobro',
    aplica_iva               TEXT IS 'Aplica IVA',
    fecha_recepcion          TEXT IS 'Fec Recep',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    tipo_documento           TEXT IS 'Tipo Doc',
    estado_operacion         TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTRCCAT ON HNEACOSTA1/CNTRLRCO (created_at);
CREATE INDEX HNEACOSTA1/ICNTRCMON ON HNEACOSTA1/CNTRLRCO (codigo_moneda);
CREATE INDEX HNEACOSTA1/ICNTRCVDE ON HNEACOSTA1/CNTRLRCO (vigente_desde);
