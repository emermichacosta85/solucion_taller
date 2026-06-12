-- =============================================================================
-- Nombre de la Tabla  : DLITP
-- DESCRIPCION         : Maestro de Deducciones de Prestamos.
--                       Catalogo que define las deducciones recurrentes
--                       configuradas para cada operacion de credito.
-- Objetivo            : Almacenar la configuracion de deducciones periodicas
--                       asociadas a una operacion, como seguros de vida,
--                       seguros de desempleo y otros cargos recurrentes.
-- Tipo de Tabla       : Maestra / Configuracion
-- Origen de los Datos : Configuracion al momento de originar la operacion
-- Permanencia de Datos: Permanente mientras la operacion este vigente
-- Uso de los datos    : Generacion automatica de deducciones en el plan de pagos,
--                       calculo de cuotas y reporteria de cartera
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DLITP (
    numero_prestamo         VARCHAR(30)     NOT NULL    FOR COLUMN DLITPNPR,
    codigo_deduccion        VARCHAR(20)     NOT NULL    FOR COLUMN DLITPCDD,
    descripcion_deduccion   VARCHAR(80)                 FOR COLUMN DLITPDSC,
    tipo_calculo            VARCHAR(20)                 FOR COLUMN DLITPTCL,
    monto_fijo              DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPMFI,
    porcentaje              DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPPCT,
    frecuencia              VARCHAR(20)                 FOR COLUMN DLITPFRE,
    vigente_desde           DATE                        FOR COLUMN DLITPVDE,
    vigente_hasta           DATE                        FOR COLUMN DLITPVHA,
    beneficiario            VARCHAR(80)                 FOR COLUMN DLITPBEN,
    fecha_desembolso        DATE                        FOR COLUMN DLITPFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DLITPFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLITPDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DLITPEOP,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DLITPUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DLITPUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLITPVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DLITPOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DLITPERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLITPCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLITPUAT,
    CONSTRAINT PK_DLITP PRIMARY KEY (numero_prestamo, codigo_deduccion),
    CONSTRAINT FK_DLITP_DEALS FOREIGN KEY (numero_prestamo)
        REFERENCES HNEACOSTA1/DEALS (numero_prestamo)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DLITPR;

RENAME TABLE HNEACOSTA1/DLITP
    TO DLITP FOR SYSTEM NAME DLITP;

COMMENT ON TABLE HNEACOSTA1/DLITP IS
    'Maestro de Deducciones de Prestamos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DLITP
    IS 'Deducciones Prestamos';

COMMENT ON COLUMN HNEACOSTA1/DLITP.numero_prestamo IS
    'Numero de la operacion a la que esta configurada la deduccion (FK DEALS)';
COMMENT ON COLUMN HNEACOSTA1/DLITP.codigo_deduccion IS
    'Codigo del concepto de deduccion: SEGURO_VIDA, SEGURO_DESEMPLEO, OTROS';
COMMENT ON COLUMN HNEACOSTA1/DLITP.descripcion_deduccion IS
    'Descripcion completa del concepto de deduccion configurado';
COMMENT ON COLUMN HNEACOSTA1/DLITP.tipo_calculo IS
    'Metodo de calculo: FIJO, PORCENTAJE, COMBINADO';
COMMENT ON COLUMN HNEACOSTA1/DLITP.monto_fijo IS
    'Monto fijo de la deduccion en la moneda de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.porcentaje IS
    'Porcentaje sobre el saldo para calcular la deduccion variable';
COMMENT ON COLUMN HNEACOSTA1/DLITP.frecuencia IS
    'Frecuencia de cobro: MENSUAL, TRIMESTRAL, SEMESTRAL, ANUAL';
COMMENT ON COLUMN HNEACOSTA1/DLITP.vigente_desde IS
    'Fecha desde la que esta activa la configuracion de la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.vigente_hasta IS
    'Fecha hasta la que aplica la deduccion, nula si es por toda la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.beneficiario IS
    'Nombre de la entidad o persona que recibe el pago de la deduccion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLITP.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLITP.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLITP.saldo_actual IS
    'Saldo vigente de la operacion al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/DLITP.tasa_interes IS
    'Tasa de interes de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLITP.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN HNEACOSTA1/DLITP.dias_mora IS
    'Dias de mora de la operacion padre';
COMMENT ON COLUMN HNEACOSTA1/DLITP.estado_operacion IS
    'Estado de la operacion: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN HNEACOSTA1/DLITP.usuario_creacion IS
    'Usuario que configuro la deduccion en la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN HNEACOSTA1/DLITP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DLITP.observaciones IS
    'Notas sobre la deduccion, condiciones especiales o exenciones';
COMMENT ON COLUMN HNEACOSTA1/DLITP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DLITP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DLITP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DLITP (
    numero_prestamo          TEXT IS 'No. Prestamo',
    codigo_deduccion         TEXT IS 'Cod Deducc',
    descripcion_deduccion    TEXT IS 'Desc Deducc',
    tipo_calculo             TEXT IS 'Tipo Calc',
    monto_fijo               TEXT IS 'Monto Fijo',
    porcentaje               TEXT IS 'Porcentaje',
    frecuencia               TEXT IS 'Frecuencia',
    vigente_desde            TEXT IS 'Vig Desde',
    vigente_hasta            TEXT IS 'Vig Hasta',
    beneficiario             TEXT IS 'Beneficiario',
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

CREATE INDEX HNEACOSTA1/IDLITPNPR ON HNEACOSTA1/DLITP (numero_prestamo);
CREATE INDEX HNEACOSTA1/IDLITPCAT ON HNEACOSTA1/DLITP (created_at);

-- =============================================================================
-- Fin de script: DLITP_CREATE.sql
-- =============================================================================
