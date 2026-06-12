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

CREATE OR REPLACE TABLE HNEACOSTA1/DEALS (
    id                      BIGINT          NOT NULL    FOR COLUMN DEALSID,
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DEALSNPR,
    id_cliente              VARCHAR(30)     NOT NULL    FOR COLUMN DEALSCLI,
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN DEALSBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN DEALSSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN DEALSMON,
    tipo_operacion          VARCHAR(20)     NOT NULL    FOR COLUMN DEALSTOP,
    tipo_producto           VARCHAR(20)     NOT NULL    FOR COLUMN DEALSTPR,
    fecha_desembolso        DATE                        FOR COLUMN DEALSFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DEALSFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DEALSMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DEALSSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DEALSTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DEALSPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DEALSMOR2,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DEALSEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DEALSUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DEALSUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DEALSVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DEALSOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DEALSERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DEALSCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DEALSUAT,
    CONSTRAINT PK_DEALS PRIMARY KEY (id),
    CONSTRAINT UQ_DEALS_NPR UNIQUE (numero_prestamo)
)
RCDFMT DEALSR;

RENAME TABLE HNEACOSTA1/DEALS
    TO DEALS FOR SYSTEM NAME DEALS;

COMMENT ON TABLE HNEACOSTA1/DEALS IS
    'Maestro de Prestamos, Certificados, Giros, Valores al Cobro e Inversiones - Modulo 4';

LABEL ON TABLE HNEACOSTA1/DEALS
    IS 'Maestro Contratos';

COMMENT ON COLUMN HNEACOSTA1/DEALS.id IS
    'Identificador tecnico unico autoincremental de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.numero_prestamo IS
    'Numero funcional unico de la operacion, referenciado por tablas hijas del modulo';
COMMENT ON COLUMN HNEACOSTA1/DEALS.id_cliente IS
    'Identificador del cliente titular de la operacion (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/DEALS.codigo_banco IS
    'Codigo del banco al que pertenece la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.codigo_sucursal IS
    'Codigo de la sucursal donde fue originada la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.tipo_operacion IS
    'Clasificacion de la operacion: PRESTAMO, CERTIFICADO, GIRO, INVERSION, COBRO';
COMMENT ON COLUMN HNEACOSTA1/DEALS.tipo_producto IS
    'Codigo del producto bancario especifico de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.fecha_desembolso IS
    'Fecha en que se realizo el desembolso o apertura de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.fecha_vencimiento IS
    'Fecha en que vence o expira la operacion segun contrato';
COMMENT ON COLUMN HNEACOSTA1/DEALS.monto_original IS
    'Monto original de la operacion en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/DEALS.saldo_actual IS
    'Saldo vigente de la operacion despues de aplicar pagos y ajustes';
COMMENT ON COLUMN HNEACOSTA1/DEALS.tasa_interes IS
    'Tasa de interes anual pactada para la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.plazo_meses IS
    'Plazo total de la operacion expresado en meses';
COMMENT ON COLUMN HNEACOSTA1/DEALS.dias_mora IS
    'Numero de dias de atraso acumulados en la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.estado_operacion IS
    'Estado actual de la operacion: VIGENTE, CANCELADA, VENCIDA, MORA, CASTIGADA';
COMMENT ON COLUMN HNEACOSTA1/DEALS.usuario_creacion IS
    'Usuario del sistema que registro la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DEALS.observaciones IS
    'Notas o anotaciones operativas sobre la operacion';
COMMENT ON COLUMN HNEACOSTA1/DEALS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DEALS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DEALS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DEALS (
    id                       TEXT IS 'ID Operacion',
    numero_prestamo          TEXT IS 'No. Prestamo',
    id_cliente               TEXT IS 'ID Cliente',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    tipo_operacion           TEXT IS 'Tipo Operac',
    tipo_producto            TEXT IS 'Tipo Prod',
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

CREATE INDEX HNEACOSTA1/IDEALSID  ON HNEACOSTA1/DEALS (id);
CREATE INDEX HNEACOSTA1/IDEALSCAT ON HNEACOSTA1/DEALS (created_at);
CREATE INDEX HNEACOSTA1/IDEALSCLI ON HNEACOSTA1/DEALS (id_cliente);

-- =============================================================================
-- Fin de script: DEALS_CREATE.sql
-- =============================================================================
