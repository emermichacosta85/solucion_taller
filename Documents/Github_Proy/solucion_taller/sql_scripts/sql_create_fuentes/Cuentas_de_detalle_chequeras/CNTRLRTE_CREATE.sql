-- ============================================================
-- Nombre de la Tabla  : CNTRLRTE
-- DESCRIPCION         : Tabla de Tasas y Cargos por Servicio en Cuentas de Detalle
-- Objetivo            : Definir las tarifas, tasas de interes y cargos
--                       por servicios aplicables a cada tipo de producto
--                       de cuentas de detalle.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion de tarifas por la gerencia del banco
-- Permanencia de Datos: Permanente (con historial por vigencia)
-- Uso de los datos    : Calculo de cargos, intereses y comisiones en cuentas
-- Restricciones       : PK compuesta por banco, tipo de producto y codigo de tabla
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLRTE (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CNTRBNK,
    tipo_producto           VARCHAR(20)     NOT NULL    FOR COLUMN CNTRTPR,
    codigo_tabla            VARCHAR(20)     NOT NULL    FOR COLUMN CNTRTBL,
    descripcion_cargo       VARCHAR(120)                FOR COLUMN CNTRDSC,
    tipo_calculo            VARCHAR(20)                 FOR COLUMN CNTRTCL,
    tasa_porcentaje         DECIMAL(10,6)               FOR COLUMN CNTRTPR2,
    monto_fijo              DECIMAL(18,2)               FOR COLUMN CNTRMFI,
    moneda_cargo            VARCHAR(20)                 FOR COLUMN CNTRMCD,
    vigente_desde           DATE                        FOR COLUMN CNTRVDE,
    vigente_hasta           DATE                        FOR COLUMN CNTRVHA,
    frecuencia_cobro        VARCHAR(20)                 FOR COLUMN CNTRFCO,
    fecha_apertura          DATE                        FOR COLUMN CNTRFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CNTRFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CNTRSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CNTRSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CNTRLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CNTRESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CNTRUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CNTRUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CNTRVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CNTROBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CNTRERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CNTRUAT,
    CONSTRAINT PK_CNTRLRTE PRIMARY KEY (codigo_banco, tipo_producto,
                                        codigo_tabla)
)
RCDFMT CNTRLRTR;

RENAME TABLE HNEACOSTA1/CNTRLRTE
    TO CNTRLRTE FOR SYSTEM NAME CNTRRTE;

COMMENT ON TABLE HNEACOSTA1/CNTRLRTE IS
    'Tasas y Cargos por Servicio en Cuentas de Detalle - Modulo 3';

LABEL ON TABLE HNEACOSTA1/CNTRLRTE
    IS 'Tasas Cargos Cuentas';

COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tasas y cargos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.tipo_producto IS
    'Tipo de producto bancario al que aplica la tasa o cargo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.codigo_tabla IS
    'Codigo interno que identifica la tabla de tasas dentro del tipo de producto';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.descripcion_cargo IS
    'Descripcion del cargo o servicio al que aplica la tasa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.tipo_calculo IS
    'Metodo de calculo: PORCENTAJE, FIJO, COMBINADO, ESCALADO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.tasa_porcentaje IS
    'Tasa porcentual anual o periodica segun tipo de calculo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.monto_fijo IS
    'Monto fijo del cargo en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.moneda_cargo IS
    'Codigo ISO de la moneda en que se expresa el cargo fijo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.vigente_desde IS
    'Fecha desde la que rige la tarifa o tasa definida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.vigente_hasta IS
    'Fecha hasta la que es valida la tarifa, nula si es indefinida';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.frecuencia_cobro IS
    'Periodicidad del cobro: DIARIO, MENSUAL, TRIMESTRAL, ANUAL, POR_EVENTO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.fecha_apertura IS
    'Fecha de alta de la tabla de tasas en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion de la tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.estado_cuenta IS
    'Estado de la tabla de tasas: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.usuario_creacion IS
    'Usuario administrador que registro la tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla de tasas';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.observaciones IS
    'Notas sobre la aplicacion o condiciones especiales de la tarifa';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLRTE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLRTE (
    codigo_banco             TEXT IS 'Banco',
    tipo_producto            TEXT IS 'Tipo Producto',
    codigo_tabla             TEXT IS 'Cod Tabla',
    descripcion_cargo        TEXT IS 'Desc Cargo',
    tipo_calculo             TEXT IS 'Tipo Calc',
    tasa_porcentaje          TEXT IS 'Tasa Porc',
    monto_fijo               TEXT IS 'Monto Fijo',
    moneda_cargo             TEXT IS 'Moneda Cargo',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
    frecuencia_cobro         TEXT IS 'Freq Cobro',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Tabla',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTRCAT ON HNEACOSTA1/CNTRLRTE (created_at);
