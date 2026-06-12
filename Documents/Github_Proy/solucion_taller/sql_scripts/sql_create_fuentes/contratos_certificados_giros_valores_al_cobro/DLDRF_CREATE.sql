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

CREATE OR REPLACE TABLE HNEACOSTA1/DLDRF (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN DLDRFBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN DLDRFSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN DLDRFMON,
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DLDRFNPR,
    identificacion          VARCHAR(50)     NOT NULL    FOR COLUMN DLDRFIDE,
    numero_documento        VARCHAR(30)     NOT NULL    FOR COLUMN DLDRFNDO,
    tipo_documento          VARCHAR(20)                 FOR COLUMN DLDRFTDO,
    nombre_girado           VARCHAR(80)                 FOR COLUMN DLDRFNGR,
    fecha_emision           DATE                        FOR COLUMN DLDRFFEM,
    fecha_vencimiento       DATE                        FOR COLUMN DLDRFFVE,
    monto_documento         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFMDO,
    estado_documento        VARCHAR(20)                 FOR COLUMN DLDRFEST,
    fecha_desembolso        DATE                        FOR COLUMN DLDRFFDS,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLDRFDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DLDRFEOP,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DLDRFUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DLDRFUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLDRFVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DLDRFOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DLDRFERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLDRFCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLDRFUAT,
    CONSTRAINT PK_DLDRF PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_prestamo,
                                     identificacion, numero_documento),
    CONSTRAINT FK_DLDRF_DEALS FOREIGN KEY (numero_prestamo)
        REFERENCES HNEACOSTA1/DEALS (numero_prestamo)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DLDRFR;

RENAME TABLE HNEACOSTA1/DLDRF
    TO DLDRF FOR SYSTEM NAME DLDRF;

COMMENT ON TABLE HNEACOSTA1/DLDRF IS
    'Detalle de Giros y Valores al Cobro - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DLDRF
    IS 'Detalle Giros Cobro';

COMMENT ON COLUMN HNEACOSTA1/DLDRF.codigo_banco IS
    'Codigo del banco que opera el giro o valor al cobro';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.codigo_sucursal IS
    'Codigo de la sucursal que registra el documento de cobro';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominado el documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.numero_prestamo IS
    'Numero de la operacion principal a la que pertenece el documento (FK DEALS)';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.identificacion IS
    'Identificacion del girador o deudor del documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.numero_documento IS
    'Numero unico del documento: giro, letra, pagare u otro titulo valor';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.tipo_documento IS
    'Tipo de titulo valor: GIRO, LETRA, PAGARE, FACTURA, CHEQUE';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.nombre_girado IS
    'Nombre completo del girado o deudor del documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.fecha_emision IS
    'Fecha de emision o creacion del documento comercial';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.fecha_vencimiento IS
    'Fecha de vencimiento para el cobro del documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.monto_documento IS
    'Valor monetario del documento en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.estado_documento IS
    'Estado del documento: PENDIENTE, COBRADO, PROTESTADO, DEVUELTO, VENCIDO';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.fecha_desembolso IS
    'Fecha de desembolso o liquidacion anticipada del documento si aplica';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.monto_original IS
    'Monto original de la operacion padre en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.saldo_actual IS
    'Saldo pendiente de cobro del documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.tasa_interes IS
    'Tasa de interes aplicable sobre el documento en mora';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.plazo_meses IS
    'Plazo del documento en meses desde emision a vencimiento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.dias_mora IS
    'Dias de atraso acumulados sobre el vencimiento del documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.estado_operacion IS
    'Estado de la operacion padre: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.usuario_creacion IS
    'Usuario del sistema que registro el documento';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.observaciones IS
    'Notas sobre el documento, gestiones de cobro o protestos';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DLDRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DLDRF (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_prestamo          TEXT IS 'No. Prestamo',
    identificacion           TEXT IS 'Identificacion',
    numero_documento         TEXT IS 'No. Documento',
    tipo_documento           TEXT IS 'Tipo Doc',
    nombre_girado            TEXT IS 'Nombre Girado',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_documento          TEXT IS 'Monto Doc',
    estado_documento         TEXT IS 'Estado Doc',
    fecha_desembolso         TEXT IS 'Fec Desemb',
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

CREATE INDEX HNEACOSTA1/IDLDRFNPR ON HNEACOSTA1/DLDRF (numero_prestamo);
CREATE INDEX HNEACOSTA1/IDLDRFCAT ON HNEACOSTA1/DLDRF (created_at);

-- =============================================================================
-- Fin de script: DLDRF_CREATE.sql
-- =============================================================================
