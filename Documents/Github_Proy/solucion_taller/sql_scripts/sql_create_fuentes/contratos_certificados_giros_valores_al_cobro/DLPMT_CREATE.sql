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

CREATE OR REPLACE TABLE HNEACOSTA1/DLPMT (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN DLPMTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN DLPMTSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN DLPMTMON,
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DLPMTNPR,
    fecha                   DATE            NOT NULL    FOR COLUMN DLPMTFEC,
    tipo_registro           VARCHAR(20)     NOT NULL    FOR COLUMN DLPMTTRG,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLPMTSEQ,
    numero_cuota            INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTNCQ,
    monto_cuota             DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTMCQ,
    monto_capital           DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTCAP,
    monto_interes           DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTINT,
    monto_pagado            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTMPG,
    fecha_desembolso        DATE                        FOR COLUMN DLPMTFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DLPMTFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLPMTDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DLPMTEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DLPMTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DLPMTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLPMTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DLPMTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DLPMTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLPMTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLPMTUAT,
    CONSTRAINT PK_DLPMT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_prestamo,
                                     fecha, tipo_registro, secuencia),
    CONSTRAINT FK_DLPMT_DEALS FOREIGN KEY (numero_prestamo)
        REFERENCES HNEACOSTA1/DEALS (numero_prestamo)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DLPMTR;

RENAME TABLE HNEACOSTA1/DLPMT
    TO DLPMT FOR SYSTEM NAME DLPMT;

COMMENT ON TABLE HNEACOSTA1/DLPMT IS
    'Plan de Pagos de Operaciones - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DLPMT
    IS 'Plan de Pagos';

COMMENT ON COLUMN HNEACOSTA1/DLPMT.codigo_banco IS
    'Codigo del banco al que pertenece la operacion del plan de pagos';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.codigo_sucursal IS
    'Codigo de la sucursal donde fue originada la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.codigo_moneda IS
    'Codigo ISO de la moneda en que se denomina cada cuota del plan';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.numero_prestamo IS
    'Numero funcional de la operacion a la que pertenece la cuota (FK DEALS)';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.fecha IS
    'Fecha de vencimiento programada de la cuota o evento de pago';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.tipo_registro IS
    'Tipo de registro del plan: CUOTA, CAPITAL, INTERES, SEGURO, COMISION';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.secuencia IS
    'Numero de orden del registro dentro de la misma fecha y tipo';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.numero_cuota IS
    'Numero correlativo de la cuota dentro del plan de pagos';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.monto_cuota IS
    'Monto total de la cuota (capital + intereses + seguros)';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.monto_capital IS
    'Porcion de capital contenida en la cuota';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.monto_interes IS
    'Porcion de intereses contenida en la cuota';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.monto_pagado IS
    'Monto efectivamente abonado a esta cuota a la fecha';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.fecha_desembolso IS
    'Fecha de desembolso o apertura de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.fecha_vencimiento IS
    'Fecha de vencimiento final de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.monto_original IS
    'Monto original de la operacion en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.saldo_actual IS
    'Saldo vigente de la operacion a la fecha del plan';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.tasa_interes IS
    'Tasa de interes anual aplicada en este tramo del plan';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.plazo_meses IS
    'Plazo total de la operacion en meses';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.dias_mora IS
    'Dias de atraso acumulados sobre esta cuota';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.estado_operacion IS
    'Estado de la cuota: PENDIENTE, PAGADA, VENCIDA, PARCIAL, CONDONADA';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.usuario_creacion IS
    'Usuario del sistema que genero el registro del plan';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.observaciones IS
    'Notas sobre la cuota, ajustes aplicados o acuerdos especiales';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DLPMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DLPMT (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_prestamo          TEXT IS 'No. Prestamo',
    fecha                    TEXT IS 'Fecha Cuota',
    tipo_registro            TEXT IS 'Tipo Reg',
    secuencia                TEXT IS 'Secuencia',
    numero_cuota             TEXT IS 'No. Cuota',
    monto_cuota              TEXT IS 'Monto Cuota',
    monto_capital            TEXT IS 'Capital',
    monto_interes            TEXT IS 'Interes',
    monto_pagado             TEXT IS 'Pagado',
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

CREATE INDEX HNEACOSTA1/IDLPMTNPR ON HNEACOSTA1/DLPMT (numero_prestamo);
CREATE INDEX HNEACOSTA1/IDLPMTFEC ON HNEACOSTA1/DLPMT (fecha);
CREATE INDEX HNEACOSTA1/IDLPMTCAT ON HNEACOSTA1/DLPMT (created_at);

-- =============================================================================
-- Fin de script: DLPMT_CREATE.sql
-- =============================================================================
