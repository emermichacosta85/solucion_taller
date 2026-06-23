-- ================================================================
-- Nombre de la Tabla  : CNTRLBAP
-- DESCRIPCION         : Control de Cuentas por Pagar - Otros Parametros
-- Objetivo            : Almacenar los parametros generales adicionales
--                       de configuracion del modulo de cuentas por pagar
--                       por banco y moneda, complementando los parametros
--                       de comisiones de CNTRLBAF con otros aspectos
--                       operativos como numeracion, plazos y politicas.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion del modulo por sistemas y contabilidad
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia en procesos del modulo CxP para
--                       aplicar parametros generales del banco
-- Restricciones       : PK compuesta por banco y moneda;
--                       tabla parametrica sin FK intramodulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE CNTRLBAP (
    codigo_banco             FOR COLUMN CNTBPBNK   VARCHAR(20)   NOT NULL,
    codigo_moneda            FOR COLUMN CNTBPMON   VARCHAR(20)   NOT NULL,
    numero_identificacion    FOR COLUMN CNTBPNID   VARCHAR(30),
    razon_social             FOR COLUMN CNTBPRS    VARCHAR(80),
    email                    FOR COLUMN CNTBPEM    VARCHAR(80),
    telefono                 FOR COLUMN CNTBPTLF   VARCHAR(80),
    monto_original           FOR COLUMN CNTBPMOR   DECIMAL(18,2),
    saldo_pendiente          FOR COLUMN CNTBPSPD   DECIMAL(18,2),
    fecha_emision            FOR COLUMN CNTBPFE    DATE,
    fecha_vencimiento        FOR COLUMN CNTBPFV    DATE,
    estado_cxp               FOR COLUMN CNTBPEST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN CNTBPUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTBPUSA   VARCHAR(30),
    version_registro         FOR COLUMN CNTBPVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN CNTBPOBS   VARCHAR(120),
    estado_registro          FOR COLUMN CNTBPERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN CNTBPCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTBPUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLBAP PRIMARY KEY (codigo_banco, codigo_moneda)
)
RCDFMT CNTBPR;

RENAME TABLE CNTRLBAP
    TO CNTRLBAP_TABLE FOR SYSTEM NAME CNTRLBAP;

COMMENT ON TABLE CNTRLBAP IS
    'Control CxP - Otros Parametros por Banco y Moneda - Modulo 11';

LABEL ON TABLE CNTRLBAP
    IS 'Control CxP Parametros';

COMMENT ON COLUMN CNTRLBAP.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion general de CxP';
COMMENT ON COLUMN CNTRLBAP.codigo_moneda IS
    'Codigo ISO de la moneda a la que aplican estos parametros generales';
COMMENT ON COLUMN CNTRLBAP.numero_identificacion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.razon_social IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.email IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.telefono IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.monto_original IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.saldo_pendiente IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAP.fecha_emision IS
    'Fecha de alta de la configuracion de parametros en el sistema';
COMMENT ON COLUMN CNTRLBAP.fecha_vencimiento IS
    'Fecha de vigencia de la configuracion si aplica revision periodica';
COMMENT ON COLUMN CNTRLBAP.estado_cxp IS
    'Estado de la configuracion: ACTIVA, INACTIVA, EN_REVISION';
COMMENT ON COLUMN CNTRLBAP.usuario_creacion IS
    'Usuario administrador que registro la configuracion';
COMMENT ON COLUMN CNTRLBAP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de los parametros';
COMMENT ON COLUMN CNTRLBAP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLBAP.observaciones IS
    'Notas sobre la configuracion o cambios en los parametros del modulo';
COMMENT ON COLUMN CNTRLBAP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLBAP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLBAP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLBAP (
    codigo_banco             IS 'Banco',
    codigo_moneda            IS 'Moneda',
    numero_identificacion    IS 'No. Identif',
    razon_social             IS 'Razon Social',
    email                    IS 'Email',
    telefono                 IS 'Telefono',
    monto_original           IS 'Monto Orig',
    saldo_pendiente          IS 'Saldo Pend',
    fecha_emision            IS 'Fec Emision',
    fecha_vencimiento        IS 'Fec Vencim',
    estado_cxp               IS 'Estado',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

-- ================================================================
-- Etiquetas de descripcion larga por columna (TEXT)
-- ================================================================
LABEL ON COLUMN CNTRLBAP (
    codigo_banco             TEXT IS 'Codigo del banco al que pertenece la',
    codigo_moneda            TEXT IS 'Codigo ISO de la moneda a la que aplican estos',
    numero_identificacion    TEXT IS 'Campo de referencia del patron de tabla del modulo',
    razon_social             TEXT IS 'Campo de referencia del patron de tabla del modulo',
    email                    TEXT IS 'Campo de referencia del patron de tabla del modulo',
    telefono                 TEXT IS 'Campo de referencia del patron de tabla del modulo',
    monto_original           TEXT IS 'Campo de referencia del patron de tabla del modulo',
    saldo_pendiente          TEXT IS 'Campo de referencia del patron de tabla del modulo',
    fecha_emision            TEXT IS 'Fecha de alta de la configuracion de parametros',
    fecha_vencimiento        TEXT IS 'Fecha de vigencia de la configuracion si aplica',
    estado_cxp               TEXT IS 'Estado de la configuracion: ACTIVA, INACTIVA,',
    usuario_creacion         TEXT IS 'Usuario administrador que registro la',
    usuario_actualizacion    TEXT IS 'Usuario que realizo la ultima modificacion de los',
    version_registro         TEXT IS 'Version del registro para control de concurrencia',
    observaciones            TEXT IS 'Notas sobre la configuracion o cambios en los',
    estado_registro          TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at               TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at               TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX ICNTBPCAT ON CNTRLBAP (created_at);
CREATE INDEX ICNTBPCMO ON CNTRLBAP (codigo_banco, codigo_moneda);
