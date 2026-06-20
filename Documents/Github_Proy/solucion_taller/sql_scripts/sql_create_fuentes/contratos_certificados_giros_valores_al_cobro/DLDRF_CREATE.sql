-- =============================================================================
-- Nombre de la Tabla  : DLDRF
-- DESCRIPCION         : Detalle de Giros y Valores al Cobro.
--                       Registra cada documento individual (giro, letra, pagare)
--                       asociado a una operacion de cobro documentario.
-- Objetivo            : Almacenar los documentos comerciales subyacentes de las
--                       operaciones de giros y valores al cobro, permitiendo
--                       rastrear el estado de cobro de cada documento.
-- Tipo de Tabla       : Detalle / Transaccional
-- Origen de los Datos : Proceso de registro de giros y valores al cobro
-- Permanencia de Datos: Historica (permanente mientras el documento este activo)
-- Uso de los datos    : Seguimiento de cobro, notificacion a beneficiarios,
--                       reporteria de vencimientos y auditoria documentaria
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE DLDRF (
    codigo_banco            FOR COLUMN DLDRFBNK VARCHAR(20)     NOT NULL,
    codigo_sucursal         FOR COLUMN DLDRFSUC VARCHAR(20)     NOT NULL,
    codigo_moneda           FOR COLUMN DLDRFMON VARCHAR(20)     NOT NULL,
    numero_prestamo         FOR COLUMN DLDRFNPR VARCHAR(30)     NOT NULL,
    identificacion          FOR COLUMN DLDRFIDE VARCHAR(50)     NOT NULL,
    numero_documento        FOR COLUMN DLDRFNDO VARCHAR(30)     NOT NULL,
    fecha_desembolso        FOR COLUMN DLDRFFDS DATE,
    fecha_vencimiento       FOR COLUMN DLDRFFVE DATE,
    monto_original          FOR COLUMN DLDRFMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DLDRFSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DLDRFTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DLDRFPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DLDRFDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DLDRFEOP VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DLDRFUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DLDRFUSA VARCHAR(30),
    version_registro        FOR COLUMN DLDRFVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DLDRFOBS VARCHAR(120),
    estado_registro         FOR COLUMN DLDRFERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DLDRFCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DLDRFUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DLDRF PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_prestamo,
                                     identificacion, numero_documento)
    --CONSTRAINT FK_DLDRF_DEALS FOREIGN KEY (numero_prestamo)
    --    REFERENCES DEALS (numero_prestamo)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DLDRFR;

RENAME TABLE DLDRF
    TO DLDRF_TABLE FOR SYSTEM NAME DLDRF;

COMMENT ON TABLE DLDRF IS
    'Detalle de Giros y Valores al Cobro - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DLDRF
    IS 'Detalle Giros Cobro';

COMMENT ON COLUMN DLDRF.codigo_banco IS
    'Codigo del banco que opera el giro o valor al cobro';
COMMENT ON COLUMN DLDRF.codigo_sucursal IS
    'Codigo de la sucursal que registra el documento de cobro';
COMMENT ON COLUMN DLDRF.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominado el documento';
COMMENT ON COLUMN DLDRF.numero_prestamo IS
    'Numero de la operacion principal a la que pertenece el documento (FK DEALS)';
COMMENT ON COLUMN DLDRF.identificacion IS
    'Identificacion del girador o deudor del documento';
COMMENT ON COLUMN DLDRF.numero_documento IS
    'Numero unico del documento: giro, letra, pagare u otro titulo valor';
COMMENT ON COLUMN DLDRF.fecha_desembolso IS
    'Fecha de desembolso o liquidacion anticipada del documento si aplica';
COMMENT ON COLUMN DLDRF.fecha_vencimiento IS
    'Fecha de vencimiento para el cobro del documento';
COMMENT ON COLUMN DLDRF.monto_original IS
    'Monto original de la operacion padre en la moneda pactada';
COMMENT ON COLUMN DLDRF.saldo_actual IS
    'Saldo pendiente de cobro del documento';
COMMENT ON COLUMN DLDRF.tasa_interes IS
    'Tasa de interes aplicable sobre el documento en mora';
COMMENT ON COLUMN DLDRF.plazo_meses IS
    'Plazo del documento en meses desde emision a vencimiento';
COMMENT ON COLUMN DLDRF.dias_mora IS
    'Dias de atraso acumulados sobre el vencimiento del documento';
COMMENT ON COLUMN DLDRF.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN DLDRF.usuario_creacion IS
    'Usuario del sistema que registro el documento';
COMMENT ON COLUMN DLDRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN DLDRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DLDRF.observaciones IS
    'Notas sobre el documento, gestiones de cobro o protestos';
COMMENT ON COLUMN DLDRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DLDRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DLDRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DLDRF (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_prestamo          TEXT IS 'No. Prestamo',
    identificacion           TEXT IS 'Identificacion',
    numero_documento         TEXT IS 'No. Documento',
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

CREATE INDEX IDLDRFPF ON DLDRF (codigo_banco, codigo_sucursal);
CREATE INDEX IDLDRFCAT ON DLDRF (created_at);

-- =============================================================================
-- Fin de script: DLDRF_CREATE.sql
-- =============================================================================
