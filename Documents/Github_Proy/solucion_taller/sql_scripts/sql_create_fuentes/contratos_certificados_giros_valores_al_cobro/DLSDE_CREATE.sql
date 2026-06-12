-- =============================================================================
-- Nombre de la Tabla  : DLSDE
-- DESCRIPCION         : Detalle de Deducciones del Plan de Pagos.
--                       Registra cada deduccion aplicada en las cuotas del plan
--                       de pagos de una operacion (seguros, comisiones, etc.).
-- Objetivo            : Controlar los cargos adicionales incluidos en el plan
--                       de pagos, permitiendo calcular el costo total de cada
--                       cuota y reportar deducciones por tipo.
-- Tipo de Tabla       : Detalle / Transaccional
-- Origen de los Datos : Generacion automatica al crear el plan de pagos en DLPMT
-- Permanencia de Datos: Historica (permanente mientras la deduccion este activa)
-- Uso de los datos    : Calculo de cuotas, liquidacion de seguros y comisiones,
--                       reporteria de cartera y auditoria de cobros
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DLSDE (
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DLSDENPR,
    fecha                   DATE            NOT NULL    FOR COLUMN DLSDEFEC,
    tipo_registro           VARCHAR(20)     NOT NULL    FOR COLUMN DLSDETRG,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLSDESEQ,
    codigo_deduccion        VARCHAR(20)     NOT NULL    FOR COLUMN DLSDECDD,
    descripcion_deduccion   VARCHAR(80)                 FOR COLUMN DLSDEDSC,
    monto_deduccion         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDEMDD,
    porcentaje_deduccion    DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDEPDD,
    estado_deduccion        VARCHAR(20)                 FOR COLUMN DLSDEEST,
    fecha_desembolso        DATE                        FOR COLUMN DLSDEFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DLSDEFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDEMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDESAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDETSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDEPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLSDEDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DLSDEEOP,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DLSDEUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DLSDEUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLSDEVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DLSDEOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DLSDEERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLSDECAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLSDEUAT,
    CONSTRAINT PK_DLSDE PRIMARY KEY (numero_prestamo, fecha,
                                     tipo_registro, secuencia, codigo_deduccion),
    CONSTRAINT FK_DLSDE_DEALS FOREIGN KEY (numero_prestamo)
        REFERENCES HNEACOSTA1/DEALS (numero_prestamo)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DLSDER;

RENAME TABLE HNEACOSTA1/DLSDE
    TO DLSDE FOR SYSTEM NAME DLSDE;

COMMENT ON TABLE HNEACOSTA1/DLSDE IS
    'Detalle de Deducciones del Plan de Pagos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DLSDE
    IS 'Deducciones Plan Pagos';

COMMENT ON COLUMN HNEACOSTA1/DLSDE.numero_prestamo IS
    'Numero de la operacion a la que pertenece la deduccion (FK DEALS)';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.fecha IS
    'Fecha de la cuota del plan de pagos a la que aplica la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.tipo_registro IS
    'Tipo de registro del plan al que pertenece la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.secuencia IS
    'Numero de secuencia de la deduccion dentro del mismo tipo y fecha';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.codigo_deduccion IS
    'Codigo del concepto de deduccion: SEGURO_VIDA, COMISION, MORA, IVA';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.descripcion_deduccion IS
    'Descripcion legible del concepto de deduccion aplicado';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.monto_deduccion IS
    'Monto fijo de la deduccion en la moneda de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.porcentaje_deduccion IS
    'Porcentaje base utilizado para calcular el monto de la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.estado_deduccion IS
    'Estado de la deduccion: PENDIENTE, COBRADA, CONDONADA, AJUSTADA';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.fecha_vencimiento IS
    'Fecha de vencimiento de la cuota a la que pertenece la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.saldo_actual IS
    'Saldo vigente de la operacion al momento del registro de la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.tasa_interes IS
    'Tasa de interes aplicable a la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.dias_mora IS
    'Dias de mora acumulados sobre la cuota a la que pertenece la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.usuario_creacion IS
    'Usuario que registro la deduccion en el plan de pagos';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.observaciones IS
    'Notas sobre la deduccion, exenciones o condiciones especiales';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DLSDE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DLSDE (
    numero_prestamo          TEXT IS 'No. Prestamo',
    fecha                    TEXT IS 'Fecha',
    tipo_registro            TEXT IS 'Tipo Reg',
    secuencia                TEXT IS 'Secuencia',
    codigo_deduccion         TEXT IS 'Cod Deducc',
    descripcion_deduccion    TEXT IS 'Desc Deducc',
    monto_deduccion          TEXT IS 'Monto Ded',
    porcentaje_deduccion     TEXT IS 'Porc Ded',
    estado_deduccion         TEXT IS 'Estado Ded',
    fecha_desembolso         TEXT IS 'Fec Desemb',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_actual             TEXT IS 'Saldo Actual',
    tasa_interes             TEXT IS 'Tasa',
    plazo_meses              TEXT IS 'Plazo Meses',
    dias_mora                TEXT IS 'Dias Mora',
    estado_operacion         TEXT IS 'Estado Oper',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IDLSDENPR ON HNEACOSTA1/DLSDE (numero_prestamo);
CREATE INDEX HNEACOSTA1/IDLSDEFEC ON HNEACOSTA1/DLSDE (fecha);
CREATE INDEX HNEACOSTA1/IDLSDECAT ON HNEACOSTA1/DLSDE (created_at);

-- =============================================================================
-- Fin de script: DLSDE_CREATE.sql
-- =============================================================================
