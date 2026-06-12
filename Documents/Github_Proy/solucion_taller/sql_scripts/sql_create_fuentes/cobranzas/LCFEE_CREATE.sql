-- ================================================================
-- Nombre de la Tabla  : LCFEE
-- DESCRIPCION         : Control de Cobro de Comisiones de Cobranzas
-- Objetivo            : Registrar y controlar las comisiones generadas
--                       por la gestion de cartas de credito y cobranzas
--                       documentarias, asegurando el cobro correcto de
--                       cada concepto comisionable segun las tarifas vigentes.
-- Tipo de Tabla       : Transaccional / Control
-- Origen de los Datos : Proceso de calculo de comisiones al abrir o gestionar
--                       cartas de credito y cobranzas
-- Permanencia de Datos: Historica
-- Uso de los datos    : Cobro de comisiones, conciliacion de ingresos y auditoria
-- Restricciones       : FK hacia LCMST por numero_carta_credito
--                       (segun ERD: LCMST ||--o{ LCFEE)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCFEE (
    numero_carta_credito     VARCHAR(30)    NOT NULL     FOR COLUMN LCFEENCC,
    codigo_de_comision       VARCHAR(20)    NOT NULL     FOR COLUMN LCFEECCO,
    secuencia                INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN LCFEESEQ,
    descripcion_comision     VARCHAR(80)                 FOR COLUMN LCFEEDSC,
    tipo_comision            VARCHAR(20)                 FOR COLUMN LCFEETCO,
    base_calculo             VARCHAR(20)                 FOR COLUMN LCFEEBCL,
    porcentaje_comision      DECIMAL(10,6)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LCFEEPCM,
    monto_comision           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LCFEEMCM,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN LCFEEMON,
    monto_cobrado            DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LCFEEMCO,
    saldo_comision           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LCFEESCM,
    fecha_generacion         DATE                        FOR COLUMN LCFEEFGE,
    fecha_cobro              DATE                        FOR COLUMN LCFEEFCO,
    fecha_recepcion          DATE                        FOR COLUMN LCFEEFRP,
    fecha_vencimiento        DATE                        FOR COLUMN LCFEEFVE,
    monto_original           DECIMAL(18,2)               FOR COLUMN LCFEEMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN LCFEESPD,
    tipo_documento           VARCHAR(20)                 FOR COLUMN LCFEETDO,
    estado_operacion         VARCHAR(20)    NOT NULL     FOR COLUMN LCFEEESO,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN LCFEEUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN LCFEEUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN LCFEEVRS,
    observaciones            VARCHAR(120)                FOR COLUMN LCFEEOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN LCFEEERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LCFEECAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LCFEEUAT,
    CONSTRAINT PK_LCFEE PRIMARY KEY (numero_carta_credito,
                                     codigo_de_comision, secuencia),
    CONSTRAINT FK_LCFEE_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
)
RCDFMT LCFEER;

RENAME TABLE HNEACOSTA1/LCFEE
    TO LCFEE FOR SYSTEM NAME LCFEE;

COMMENT ON TABLE HNEACOSTA1/LCFEE IS
    'Control de Cobro de Comisiones de Cartas de Credito y Cobranzas - Modulo 6';

LABEL ON TABLE HNEACOSTA1/LCFEE
    IS 'Control Comisiones LC';

COMMENT ON COLUMN HNEACOSTA1/LCFEE.numero_carta_credito IS
    'Numero de la carta de credito a la que corresponde la comision (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.codigo_de_comision IS
    'Codigo del tipo de comision segun el catalogo de cargos vigente';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.secuencia IS
    'Numero de secuencia para multiples cobros del mismo tipo de comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.descripcion_comision IS
    'Descripcion legible del concepto de comision para estados de cuenta';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.tipo_comision IS
    'Clasificacion: APERTURA, UTILIZACION, ENMIENDA, NEGOCIACION, ACEPTACION';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.base_calculo IS
    'Base sobre la que se calcula la comision: MONTO_TOTAL, MONTO_UTILIZADO, FIJO';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.porcentaje_comision IS
    'Porcentaje aplicado sobre la base de calculo para determinar la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.monto_comision IS
    'Monto total calculado de la comision en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.codigo_moneda IS
    'Codigo ISO de la moneda en que se calcula y cobra la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.monto_cobrado IS
    'Monto de la comision ya cobrado o debidamente liquidado';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.saldo_comision IS
    'Saldo de la comision aun pendiente de cobro (calculado menos cobrado)';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.fecha_generacion IS
    'Fecha en que se genero el calculo de la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.fecha_cobro IS
    'Fecha en que fue efectivamente cobrada la comision al cliente';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.fecha_recepcion IS
    'Fecha de recepcion de la carta de credito o cobranza que origina la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.fecha_vencimiento IS
    'Fecha de vencimiento de la carta de credito asociada';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.monto_original IS
    'Monto total original de la carta de credito que genera la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.saldo_pendiente IS
    'Saldo no utilizado de la carta de credito al momento del calculo';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.tipo_documento IS
    'Tipo de documento que origina el cobro de la comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.estado_operacion IS
    'Estado de la comision: PENDIENTE, COBRADA, EXONERADA, ANULADA';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.usuario_creacion IS
    'Usuario o proceso que genero el registro de comision';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.observaciones IS
    'Notas sobre la comision, exoneraciones o condiciones especiales de cobro';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCFEE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCFEE (
    numero_carta_credito     TEXT IS 'No. Carta Cred',
    codigo_de_comision       TEXT IS 'Cod Comision',
    secuencia                TEXT IS 'Secuencia',
    descripcion_comision     TEXT IS 'Desc Comision',
    tipo_comision            TEXT IS 'Tipo Comis',
    base_calculo             TEXT IS 'Base Calc',
    porcentaje_comision      TEXT IS 'Porc Comis',
    monto_comision           TEXT IS 'Mto Comision',
    codigo_moneda            TEXT IS 'Moneda',
    monto_cobrado            TEXT IS 'Mto Cobrado',
    saldo_comision           TEXT IS 'Saldo Comis',
    fecha_generacion         TEXT IS 'Fec Generac',
    fecha_cobro              TEXT IS 'Fec Cobro',
    fecha_recepcion          TEXT IS 'Fec Recep',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    tipo_documento           TEXT IS 'Tipo Doc',
    estado_operacion         TEXT IS 'Estado Oper',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ILCFEENCC ON HNEACOSTA1/LCFEE (numero_carta_credito);
CREATE INDEX HNEACOSTA1/ILCFEEFGE ON HNEACOSTA1/LCFEE (fecha_generacion);
CREATE INDEX HNEACOSTA1/ILCFEECAT ON HNEACOSTA1/LCFEE (created_at);
CREATE INDEX HNEACOSTA1/ILCFEEESO ON HNEACOSTA1/LCFEE (estado_operacion);
