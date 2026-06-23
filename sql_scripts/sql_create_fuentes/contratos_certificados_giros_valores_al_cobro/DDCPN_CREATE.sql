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

CREATE OR REPLACE TABLE DDCPN (
    numero_prestamo         FOR COLUMN DDCPNNPR VARCHAR(30)     NOT NULL,
    fecha_desembolso        FOR COLUMN DDCPNFDS DATE,
    fecha_vencimiento       FOR COLUMN DDCPNFVE DATE,
    monto_original          FOR COLUMN DDCPNMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DDCPNSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DDCPNTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DDCPNPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DDCPNDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DDCPNEOP VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DDCPNUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DDCPNUSA VARCHAR(30),
    version_registro        FOR COLUMN DDCPNVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DDCPNOBS VARCHAR(120),
    estado_registro         FOR COLUMN DDCPNERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DDCPNCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DDCPNUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DDCPN PRIMARY KEY (numero_prestamo)
    --CONSTRAINT FK_DDCPN_DEALS FOREIGN KEY (numero_prestamo)
    --    REFERENCES DEALS (numero_prestamo)
    --   ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DDCPNR;

RENAME TABLE DDCPN
    TO DDCPN_TABLE FOR SYSTEM NAME DDCPN;

COMMENT ON TABLE DDCPN IS
    'Transacciones Pendientes de Cobro - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DDCPN
    IS 'Pendientes de Cobro';

COMMENT ON COLUMN DDCPN.numero_prestamo IS
    'Numero de la operacion sobre la que aplica el cobro pendiente (FK DEALS)';
COMMENT ON COLUMN DDCPN.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN DDCPN.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion padre';
COMMENT ON COLUMN DDCPN.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN DDCPN.saldo_actual IS
    'Saldo vigente de la operacion al momento de registrar el cobro pendiente';
COMMENT ON COLUMN DDCPN.tasa_interes IS
    'Tasa de interes aplicable a la operacion padre';
COMMENT ON COLUMN DDCPN.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN DDCPN.dias_mora IS
    'Dias de mora de la operacion al momento del cobro';
COMMENT ON COLUMN DDCPN.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN DDCPN.usuario_creacion IS
    'Usuario o proceso que genero el cobro pendiente';
COMMENT ON COLUMN DDCPN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN DDCPN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DDCPN.observaciones IS
    'Notas sobre el cobro pendiente, rechazos o acuerdos de pago';
COMMENT ON COLUMN DDCPN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DDCPN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DDCPN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DDCPN (
    numero_prestamo          TEXT IS 'No. Prestamo',
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

CREATE INDEX IDDCPNNPR ON DDCPN (numero_prestamo);
CREATE INDEX IDDCPNCAT ON DDCPN (created_at);

-- =============================================================================
-- Fin de script: DDCPN_CREATE.sql
-- =============================================================================
