-- =============================================================================
-- Nombre de la Tabla  : CNTRLDLS
-- DESCRIPCION         : Tabla de Tasas para Control de Prestamos.
--                       Catalogo de tasas y parametros de control aplicables
--                       a los productos de credito por banco, tabla y producto.
-- Objetivo            : Centralizar las tasas activas, maximas y minimas de los
--                       productos de prestamo del banco, permitiendo controlar
--                       que las tasas aplicadas en cada operacion esten dentro
--                       de los rangos autorizados por la gerencia y regulacion.
-- Tipo de Tabla       : Catalogo / Control
-- Origen de los Datos : Configuracion de productos crediticios por la gerencia
-- Permanencia de Datos: Permanente (con historial por producto y tabla)
-- Uso de los datos    : Validacion de tasas en originacion, reporteria regulatoria,
--                       control de margenes y auditoria de condiciones de credito
-- Restricciones       : PK compuesta por banco, numero_tabla y tipo_producto.
--                       Tabla de control independiente sin FK en este modulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE CNTRLDLS (
    codigo_banco            FOR COLUMN CNTDLBNK VARCHAR(20)     NOT NULL,
    numero_tabla            FOR COLUMN CNTDLTBL VARCHAR(30)     NOT NULL,
    tipo_producto           FOR COLUMN CNTDLTPR VARCHAR(20)     NOT NULL,
    fecha_desembolso        FOR COLUMN CNTDLFDS DATE,
    fecha_vencimiento       FOR COLUMN CNTDLFVE DATE,
    monto_original          FOR COLUMN CNTDLMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN CNTDLSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN CNTDLTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN CNTDLPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN CNTDLDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN CNTDLEST VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN CNTDLUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN CNTDLUSA VARCHAR(30),
    version_registro        FOR COLUMN CNTDLVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN CNTDLOBS VARCHAR(120),
    estado_registro         FOR COLUMN CNTDLERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CNTDLCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN CNTDLUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLDLS PRIMARY KEY (codigo_banco, numero_tabla)
)
RCDFMT CNTDLSR;

RENAME TABLE CNTRLDLS
    TO CNTRLDLS_TABLE FOR SYSTEM NAME CNTRLDLS;

COMMENT ON TABLE CNTRLDLS IS
    'Tabla de Tasas para Control de Prestamos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE CNTRLDLS
    IS 'Control Tasas Prestamos';

COMMENT ON COLUMN CNTRLDLS.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de control de tasas';
COMMENT ON COLUMN CNTRLDLS.numero_tabla IS
    'Numero identificador de la tabla de tasas de prestamos';
COMMENT ON COLUMN CNTRLDLS.tipo_producto IS
    'Tipo de producto de credito al que aplica la tabla de control';
COMMENT ON COLUMN CNTRLDLS.fecha_desembolso IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.fecha_vencimiento IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.monto_original IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.saldo_actual IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.tasa_interes IS
    'Tasa de referencia operativa del catalogo de control';
COMMENT ON COLUMN CNTRLDLS.plazo_meses IS
    'Campo de referencia operativa heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.dias_mora IS
    'Campo de referencia heredado del patron de tabla';
COMMENT ON COLUMN CNTRLDLS.estado_operacion IS
    'Estado de la tabla de control: ACTIVA, VENCIDA, EN_REVISION';
COMMENT ON COLUMN CNTRLDLS.usuario_creacion IS
    'Usuario administrador que registro la tabla de control';
COMMENT ON COLUMN CNTRLDLS.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla';
COMMENT ON COLUMN CNTRLDLS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLDLS.observaciones IS
    'Notas sobre la aplicacion o excepciones de la tabla de control';
COMMENT ON COLUMN CNTRLDLS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLDLS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLDLS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLDLS (
    codigo_banco             TEXT IS 'Banco',
    numero_tabla             TEXT IS 'No. Tabla',
    tipo_producto            TEXT IS 'Tipo Prod',
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
CREATE INDEX ICNTDLTBL ON CNTRLDLS (codigo_banco, numero_tabla);
CREATE INDEX ICNTDLCAT ON CNTRLDLS (created_at);

-- =============================================================================
-- Fin de script: CNTRLDLS_CREATE.sql
-- =============================================================================
