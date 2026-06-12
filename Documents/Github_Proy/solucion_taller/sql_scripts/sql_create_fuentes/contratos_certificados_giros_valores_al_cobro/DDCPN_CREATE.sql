-- =============================================================================
-- Nombre de la Tabla  : DDCPN
-- DESCRIPCION         : Transacciones Pendientes de Cobro.
--                       Registra las transacciones de cobro generadas por el
--                       sistema que estan pendientes de aplicacion en las
--                       cuentas del cliente.
-- Objetivo            : Controlar los cargos y abonos pendientes de aplicar
--                       sobre operaciones de credito, permitiendo el seguimiento
--                       del flujo de cobro y la conciliacion de pagos.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Proceso de cobro automatico y manual de cuotas
-- Permanencia de Datos: Operativa (se purga al aplicar las transacciones)
-- Uso de los datos    : Cola de cobro, conciliacion de pagos aplicados,
--                       reporteria de pendientes y control de flujo de caja
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DDCPN (
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DDCPNNPR,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DDCPNSEQ,
    tipo_cobro              VARCHAR(20)                 FOR COLUMN DDCPNTCO,
    monto_cobro             DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNMCO,
    fecha_cobro             DATE                        FOR COLUMN DDCPNFCO,
    estado_cobro            VARCHAR(20)                 FOR COLUMN DDCPNEST,
    referencia_cobro        VARCHAR(50)                 FOR COLUMN DDCPNRCB,
    fecha_desembolso        DATE                        FOR COLUMN DDCPNFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DDCPNFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DDCPNDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DDCPNEOP,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DDCPNUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DDCPNUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DDCPNVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DDCPNOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DDCPNERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DDCPNCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DDCPNUAT,
    CONSTRAINT PK_DDCPN PRIMARY KEY (numero_prestamo, secuencia),
    CONSTRAINT FK_DDCPN_DEALS FOREIGN KEY (numero_prestamo)
        REFERENCES HNEACOSTA1/DEALS (numero_prestamo)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DDCPNR;

RENAME TABLE HNEACOSTA1/DDCPN
    TO DDCPN FOR SYSTEM NAME DDCPN;

COMMENT ON TABLE HNEACOSTA1/DDCPN IS
    'Transacciones Pendientes de Cobro - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DDCPN
    IS 'Pendientes de Cobro';

COMMENT ON COLUMN HNEACOSTA1/DDCPN.numero_prestamo IS
    'Numero de la operacion sobre la que aplica el cobro pendiente (FK DEALS)';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.secuencia IS
    'Numero de orden para multiples cobros pendientes sobre la misma operacion';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.tipo_cobro IS
    'Clasificacion del cobro: CAPITAL, INTERES, MORA, SEGURO, COMISION';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.monto_cobro IS
    'Monto del cobro pendiente de aplicar en la moneda de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.fecha_cobro IS
    'Fecha programada para la aplicacion del cobro';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.estado_cobro IS
    'Estado del cobro: PENDIENTE, APLICADO, RECHAZADO, REVERSO';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.referencia_cobro IS
    'Referencia del documento o transaccion que origino el cobro pendiente';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.saldo_actual IS
    'Saldo vigente de la operacion al momento de registrar el cobro pendiente';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.tasa_interes IS
    'Tasa de interes aplicable a la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.dias_mora IS
    'Dias de mora de la operacion al momento del cobro';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.usuario_creacion IS
    'Usuario o proceso que genero el cobro pendiente';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.observaciones IS
    'Notas sobre el cobro pendiente, rechazos o acuerdos de pago';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DDCPN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DDCPN (
    numero_prestamo          TEXT IS 'No. Prestamo',
    secuencia                TEXT IS 'Secuencia',
    tipo_cobro               TEXT IS 'Tipo Cobro',
    monto_cobro              TEXT IS 'Monto Cobro',
    fecha_cobro              TEXT IS 'Fec Cobro',
    estado_cobro             TEXT IS 'Estado Cobro',
    referencia_cobro         TEXT IS 'Ref Cobro',
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

CREATE INDEX HNEACOSTA1/IDDCPNNPR ON HNEACOSTA1/DDCPN (numero_prestamo);
CREATE INDEX HNEACOSTA1/IDDCPNCAT ON HNEACOSTA1/DDCPN (created_at);

-- =============================================================================
-- Fin de script: DDCPN_CREATE.sql
-- =============================================================================
