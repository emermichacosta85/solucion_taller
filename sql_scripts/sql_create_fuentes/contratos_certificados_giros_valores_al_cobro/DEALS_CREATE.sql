-- =============================================================================
-- Nombre de la Tabla  : DEALS
-- DESCRIPCION         : Maestro de Prestamos, Certificados, Giros, Valores al
--                       Cobro e Inversiones. Concentra la informacion principal
--                       de todas las operaciones de credito y captacion del banco.
-- Objetivo            : Almacenar el encabezado unico de cada operacion activa
--                       o pasiva del banco, sirviendo como tabla padre de los
--                       modulos de plan de pagos, giros, deducciones y cobros.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Originacion de creditos, apertura de certificados,
--                       emision de giros y registro de inversiones
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Consulta de operaciones, calculo de saldos, reporteria
--                       regulatoria y base para modulos de cobro y conciliacion
-- Restricciones       : id es PK tecnica autoincremental; numero_prestamo es
--                       clave funcional unica referenciada por tablas hijas.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE DEALS (
    id                      FOR COLUMN DEALSID  BIGINT          NOT NULL,
    fecha_desembolso        FOR COLUMN DEALSFDS DATE,
    fecha_vencimiento       FOR COLUMN DEALSFVE DATE,
    monto_original          FOR COLUMN DEALSMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DEALSSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DEALSTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DEALSPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DEALSMOR2 INT            NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DEALSEST VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DEALSUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DEALSUSA VARCHAR(30),
    version_registro        FOR COLUMN DEALSVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DEALSOBS VARCHAR(120),
    estado_registro         FOR COLUMN DEALSERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DEALSCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DEALSUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DEALS PRIMARY KEY (id)
    --CONSTRAINT UQ_DEALS_NPR UNIQUE (id)
)
RCDFMT DEALSR;

RENAME TABLE DEALS
    TO DEALS_TABLE FOR SYSTEM NAME DEALS;

COMMENT ON TABLE DEALS IS
    'Maestro de Prestamos, Certificados, Giros, Valores al Cobro e Inversiones - Modulo 4';

LABEL ON TABLE DEALS
    IS 'Maestro Contratos';

COMMENT ON COLUMN DEALS.id IS
    'Identificador tecnico unico autoincremental de la operacion';
COMMENT ON COLUMN DEALS.fecha_desembolso IS
    'Fecha en que se realizo el desembolso o apertura de la operacion';
COMMENT ON COLUMN DEALS.fecha_vencimiento IS
    'Fecha en que vence o expira la operacion segun contrato';
COMMENT ON COLUMN DEALS.monto_original IS
    'Monto original de la operacion en la moneda pactada';
COMMENT ON COLUMN DEALS.saldo_actual IS
    'Saldo vigente de la operacion despues de aplicar pagos y ajustes';
COMMENT ON COLUMN DEALS.tasa_interes IS
    'Tasa de interes anual pactada para la operacion';
COMMENT ON COLUMN DEALS.plazo_meses IS
    'Plazo total de la operacion expresado en meses';
COMMENT ON COLUMN DEALS.dias_mora IS
    'Numero de dias de atraso acumulados en la operacion';
COMMENT ON COLUMN DEALS.estado_operacion IS
    'Estado actual de la operacion: VIGENTE, CANCELADA, VENCIDA, MORA, CASTIGADA';
COMMENT ON COLUMN DEALS.usuario_creacion IS
    'Usuario del sistema que registro la operacion';
COMMENT ON COLUMN DEALS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN DEALS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DEALS.observaciones IS
    'Notas o anotaciones operativas sobre la operacion';
COMMENT ON COLUMN DEALS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DEALS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DEALS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DEALS (
    id                       TEXT IS 'ID Operacion',
    fecha_desembolso         TEXT IS 'Fec Desemb',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_actual             TEXT IS 'Saldo Actual',
    tasa_interes             TEXT IS 'Tasa Interes',
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

CREATE INDEX IDEALSID  ON DEALS (id);
CREATE INDEX IDEALSCAT ON DEALS (created_at);

-- =============================================================================
-- Fin de script: DEALS_CREATE.sql
-- =============================================================================
