-- =============================================================================
-- Nombre de la Tabla  : DLPMT
-- DESCRIPCION         : Plan de Pagos de Prestamos y Contratos.
--                       Registra cada cuota o evento de pago programado
--                       dentro del ciclo de vida de una operacion.
-- Objetivo            : Controlar el calendario de pagos de cada operacion,
--                       permitiendo calcular montos vencidos, proyectar flujos
--                       y registrar el estado de cada cuota.
-- Tipo de Tabla       : Transaccional / Detalle
-- Origen de los Datos : Generacion automatica al originar una operacion en DEALS
-- Permanencia de Datos: Historica (permanente mientras la operacion este vigente)
-- Uso de los datos    : Cobro de cuotas, calculo de mora, reporteria de cartera
--                       y cuadratura contable de obligaciones
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE DLPMT (
    codigo_banco            FOR COLUMN DLPMTBNK VARCHAR(20)     NOT NULL,
    codigo_sucursal         FOR COLUMN DLPMTSUC VARCHAR(20)     NOT NULL,
    codigo_moneda           FOR COLUMN DLPMTMON VARCHAR(20)     NOT NULL,
    numero_prestamo         FOR COLUMN DLPMTNPR VARCHAR(30)     NOT NULL,
    fecha                   FOR COLUMN DLPMTFEC DATE            NOT NULL,
    tipo_registro           FOR COLUMN DLPMTTRG VARCHAR(20)     NOT NULL,
    fecha_desembolso        FOR COLUMN DLPMTFDS DATE,
    fecha_vencimiento       FOR COLUMN DLPMTFVE DATE,
    monto_original          FOR COLUMN DLPMTMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DLPMTSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DLPMTTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DLPMTPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DLPMTDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DLPMTEST VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DLPMTUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DLPMTUSA VARCHAR(30),
    version_registro        FOR COLUMN DLPMTVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DLPMTOBS VARCHAR(120),
    estado_registro         FOR COLUMN DLPMTERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DLPMTCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DLPMTUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DLPMT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_prestamo,
                                     fecha, tipo_registro)
    --CONSTRAINT FK_DLPMT_DEALS FOREIGN KEY (numero_prestamo)
    --    REFERENCES DEALS (numero_prestamo)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DLPMTR;

RENAME TABLE DLPMT
    TO DLPMT_TABLE FOR SYSTEM NAME DLPMT;

COMMENT ON TABLE DLPMT IS
    'Plan de Pagos de Operaciones - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DLPMT
    IS 'Plan de Pagos';

COMMENT ON COLUMN DLPMT.codigo_banco IS
    'Codigo del banco al que pertenece la operacion del plan de pagos';
COMMENT ON COLUMN DLPMT.codigo_sucursal IS
    'Codigo de la sucursal donde fue originada la operacion';
COMMENT ON COLUMN DLPMT.codigo_moneda IS
    'Codigo ISO de la moneda en que se denomina cada cuota del plan';
COMMENT ON COLUMN DLPMT.numero_prestamo IS
    'Numero funcional de la operacion a la que pertenece la cuota (FK DEALS)';
COMMENT ON COLUMN DLPMT.fecha IS
    'Fecha de vencimiento programada de la cuota o evento de pago';
COMMENT ON COLUMN DLPMT.tipo_registro IS
    'Tipo de registro del plan: CUOTA, CAPITAL, INTERES, SEGURO, COMISION';
COMMENT ON COLUMN DLPMT.fecha_desembolso IS
    'Fecha de desembolso o apertura de la operacion padre';
COMMENT ON COLUMN DLPMT.fecha_vencimiento IS
    'Fecha de vencimiento final de la operacion padre';
COMMENT ON COLUMN DLPMT.monto_original IS
    'Monto original de la operacion en la moneda pactada';
COMMENT ON COLUMN DLPMT.saldo_actual IS
    'Saldo vigente de la operacion a la fecha del plan';
COMMENT ON COLUMN DLPMT.tasa_interes IS
    'Tasa de interes anual aplicada en este tramo del plan';
COMMENT ON COLUMN DLPMT.plazo_meses IS
    'Plazo total de la operacion en meses';
COMMENT ON COLUMN DLPMT.dias_mora IS
    'Dias de atraso acumulados sobre esta cuota';
COMMENT ON COLUMN DLPMT.estado_operacion IS
    'Estado de la cuota: PENDIENTE, PAGADA, VENCIDA, PARCIAL, CONDONADA';
COMMENT ON COLUMN DLPMT.usuario_creacion IS
    'Usuario del sistema que genero el registro del plan';
COMMENT ON COLUMN DLPMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN DLPMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DLPMT.observaciones IS
    'Notas sobre la cuota, ajustes aplicados o acuerdos especiales';
COMMENT ON COLUMN DLPMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DLPMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DLPMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DLPMT (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_prestamo          TEXT IS 'No. Prestamo',
    fecha                    TEXT IS 'Fecha Cuota',
    tipo_registro            TEXT IS 'Tipo Reg',
    fecha_desembolso         TEXT IS 'Fec Desemb',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_actual             TEXT IS 'Saldo Actual',
    tasa_interes             TEXT IS 'Tasa',
    plazo_meses              TEXT IS 'Plazo Meses',
    dias_mora                TEXT IS 'Dias Mora',
    estado_operacion         TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IDLPMTPK ON DLPMT (CODIGO_BANCO, CODIGO_SUCURSAL);
CREATE INDEX IDLPMTFEC ON DLPMT (fecha);

-- =============================================================================
-- Fin de script: DLPMT_CREATE.sql
-- =============================================================================
