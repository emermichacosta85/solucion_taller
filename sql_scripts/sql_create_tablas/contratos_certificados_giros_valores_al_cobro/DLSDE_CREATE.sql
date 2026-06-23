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

CREATE OR REPLACE TABLE DLSDE (
    numero_prestamo         FOR COLUMN DLSDENPR VARCHAR(30)     NOT NULL,
    fecha                   FOR COLUMN DLSDEFEC DATE            NOT NULL,
    tipo_registro           FOR COLUMN DLSDETRG VARCHAR(20)     NOT NULL,
    secuencia               FOR COLUMN DLSDESEQ INT             NOT NULL DEFAULT 1,
    codigo_deduccion        FOR COLUMN DLSDECDD VARCHAR(20)     NOT NULL,
    fecha_desembolso        FOR COLUMN DLSDEFDS DATE,
    fecha_vencimiento       FOR COLUMN DLSDEFVE DATE,
    monto_original          FOR COLUMN DLSDEMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DLSDESAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DLSDETSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DLSDEPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DLSDEDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DLSDEEOP VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DLSDEUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DLSDEUSA VARCHAR(30),
    version_registro        FOR COLUMN DLSDEVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DLSDEOBS VARCHAR(120),
    estado_registro         FOR COLUMN DLSDEERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DLSDECAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DLSDEUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DLSDE PRIMARY KEY (numero_prestamo, fecha)
    --CONSTRAINT FK_DLSDE_DEALS FOREIGN KEY (numero_prestamo)
    --    REFERENCES DEALS (numero_prestamo)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DLSDER;

RENAME TABLE DLSDE
    TO DLSDE_TABLE FOR SYSTEM NAME DLSDE;

COMMENT ON TABLE DLSDE IS
    'Detalle de Deducciones del Plan de Pagos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DLSDE
    IS 'Deducciones Plan Pagos';

COMMENT ON COLUMN DLSDE.numero_prestamo IS
    'Numero de la operacion a la que pertenece la deduccion (FK DEALS)';
COMMENT ON COLUMN DLSDE.fecha IS
    'Fecha de la cuota del plan de pagos a la que aplica la deduccion';
COMMENT ON COLUMN DLSDE.tipo_registro IS
    'Tipo de registro del plan al que pertenece la deduccion';
COMMENT ON COLUMN DLSDE.secuencia IS
    'Numero de secuencia de la deduccion dentro del mismo tipo y fecha';
COMMENT ON COLUMN DLSDE.codigo_deduccion IS
    'Codigo del concepto de deduccion: SEGURO_VIDA, COMISION, MORA, IVA';
COMMENT ON COLUMN DLSDE.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN DLSDE.fecha_vencimiento IS
    'Fecha de vencimiento de la cuota a la que pertenece la deduccion';
COMMENT ON COLUMN DLSDE.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN DLSDE.saldo_actual IS
    'Saldo vigente de la operacion al momento del registro de la deduccion';
COMMENT ON COLUMN DLSDE.tasa_interes IS
    'Tasa de interes aplicable a la operacion padre';
COMMENT ON COLUMN DLSDE.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN DLSDE.dias_mora IS
    'Dias de mora acumulados sobre la cuota a la que pertenece la deduccion';
COMMENT ON COLUMN DLSDE.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN DLSDE.usuario_creacion IS
    'Usuario que registro la deduccion en el plan de pagos';
COMMENT ON COLUMN DLSDE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN DLSDE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DLSDE.observaciones IS
    'Notas sobre la deduccion, exenciones o condiciones especiales';
COMMENT ON COLUMN DLSDE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DLSDE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DLSDE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DLSDE (
    numero_prestamo          TEXT IS 'No. Prestamo',
    fecha                    TEXT IS 'Fecha',
    tipo_registro            TEXT IS 'Tipo Reg',
    secuencia                TEXT IS 'Secuencia',
    codigo_deduccion         TEXT IS 'Cod Deducc',
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

CREATE INDEX IDLSDENPR ON DLSDE (numero_prestamo, fecha);
CREATE INDEX IDLSDEFEC ON DLSDE (fecha);

-- =============================================================================
-- Fin de script: DLSDE_CREATE.sql
-- =============================================================================
