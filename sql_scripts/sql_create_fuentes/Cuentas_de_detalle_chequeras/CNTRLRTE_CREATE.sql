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

CREATE OR REPLACE TABLE CNTRLRTE (
    codigo_banco            FOR COLUMN CNTRBNK VARCHAR(20)     NOT NULL    ,
    tipo_producto           FOR COLUMN CNTRTPR VARCHAR(20)     NOT NULL    ,
    codigo_tabla            FOR COLUMN CNTRTBL VARCHAR(20)     NOT NULL    ,
    descripcion_cargo       FOR COLUMN CNTRDSC VARCHAR(120)                ,
    tipo_calculo            FOR COLUMN CNTRTCL VARCHAR(20)                 ,
    tasa_porcentaje         FOR COLUMN CNTRTPR2 DECIMAL(10,6)               ,
    monto_fijo              FOR COLUMN CNTRMFI DECIMAL(18,2)               ,
    moneda_cargo            FOR COLUMN CNTRMCD VARCHAR(20)                 ,
    vigente_desde           FOR COLUMN CNTRVDE DATE                        ,
    vigente_hasta           FOR COLUMN CNTRVHA DATE                        ,
    frecuencia_cobro        FOR COLUMN CNTRFCO VARCHAR(20)                 ,
    fecha_apertura          FOR COLUMN CNTRFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CNTRFUT DATE                       ,
    saldo_actual            FOR COLUMN CNTRSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN CNTRSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN CNTRLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN CNTRESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN CNTRUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN CNTRUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN CNTRVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CNTROBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN CNTRERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at               FOR COLUMN CNTRCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                       ,
    updated_at              FOR COLUMN CNTRUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
    --CONSTRAINT PK_CNTRLRTE PRIMARY KEY (codigo_banco, tipo_producto,
    --                                    codigo_tabla)
)
RCDFMT CNTRLRTR;

RENAME TABLE CNTRLRTE
    TO CNTRLRTE_TABLE FOR SYSTEM NAME CNTRLRTE;

COMMENT ON TABLE CNTRLRTE IS
    'Tasas y Cargos por Servicio en Cuentas de Detalle - Modulo 3';

LABEL ON TABLE CNTRLRTE
    IS 'Tasas Cargos Cuentas';

COMMENT ON COLUMN CNTRLRTE.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tasas y cargos';
COMMENT ON COLUMN CNTRLRTE.tipo_producto IS
    'Tipo de producto bancario al que aplica la tasa o cargo';
COMMENT ON COLUMN CNTRLRTE.codigo_tabla IS
    'Codigo interno que identifica la tabla de tasas dentro del tipo de producto';
COMMENT ON COLUMN CNTRLRTE.descripcion_cargo IS
    'Descripcion del cargo o servicio al que aplica la tasa';
COMMENT ON COLUMN CNTRLRTE.tipo_calculo IS
    'Metodo de calculo: PORCENTAJE, FIJO, COMBINADO, ESCALADO';
COMMENT ON COLUMN CNTRLRTE.tasa_porcentaje IS
    'Tasa porcentual anual o periodica segun tipo de calculo';
COMMENT ON COLUMN CNTRLRTE.monto_fijo IS
    'Monto fijo del cargo en la moneda indicada';
COMMENT ON COLUMN CNTRLRTE.moneda_cargo IS
    'Codigo ISO de la moneda en que se expresa el cargo fijo';
COMMENT ON COLUMN CNTRLRTE.vigente_desde IS
    'Fecha desde la que rige la tarifa o tasa definida';
COMMENT ON COLUMN CNTRLRTE.vigente_hasta IS
    'Fecha hasta la que es valida la tarifa, nula si es indefinida';
COMMENT ON COLUMN CNTRLRTE.frecuencia_cobro IS
    'Periodicidad del cobro: DIARIO, MENSUAL, TRIMESTRAL, ANUAL, POR_EVENTO';
COMMENT ON COLUMN CNTRLRTE.fecha_apertura IS
    'Fecha de alta de la tabla de tasas en el sistema';
COMMENT ON COLUMN CNTRLRTE.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion de la tabla de tasas';
COMMENT ON COLUMN CNTRLRTE.saldo_actual IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLRTE.saldo_disponible IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLRTE.limite_sobregiro IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLRTE.estado_cuenta IS
    'Estado de la tabla de tasas: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN CNTRLRTE.usuario_creacion IS
    'Usuario administrador que registro la tabla de tasas';
COMMENT ON COLUMN CNTRLRTE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla de tasas';
COMMENT ON COLUMN CNTRLRTE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLRTE.observaciones IS
    'Notas sobre la aplicacion o condiciones especiales de la tarifa';
COMMENT ON COLUMN CNTRLRTE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLRTE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLRTE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLRTE (
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

CREATE INDEX ICNTRCAT ON CNTRLRTE (created_at);
