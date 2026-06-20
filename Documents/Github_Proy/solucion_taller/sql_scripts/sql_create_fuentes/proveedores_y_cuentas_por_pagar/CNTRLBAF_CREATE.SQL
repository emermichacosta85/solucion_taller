-- ================================================================
-- Nombre de la Tabla  : CNTRLBAF
-- DESCRIPCION         : Control de Cuentas por Pagar - Seccion Comisiones
-- Objetivo            : Almacenar los parametros de configuracion para
--                       el calculo y retencion de comisiones en el modulo
--                       de cuentas por pagar, incluyendo tasas, limites
--                       y cuentas contables por banco y moneda.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion inicial del modulo por el area
--                       de sistemas y contabilidad
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Calculo automatico de comisiones al procesar
--                       cuentas por pagar en el modulo
-- Restricciones       : PK compuesta por banco y moneda;
--                       tabla parametrica sin FK intramodulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE CNTRLBAF (
    codigo_banco             FOR COLUMN CNTBFBNK   VARCHAR(20)   NOT NULL,
    codigo_moneda            FOR COLUMN CNTBFMON   VARCHAR(20)   NOT NULL,
    numero_identificacion    FOR COLUMN CNTBFNID   VARCHAR(30),
    razon_social             FOR COLUMN CNTBFRS    VARCHAR(80),
    email                    FOR COLUMN CNTBFEM    VARCHAR(80),
    telefono                 FOR COLUMN CNTBFTLF   VARCHAR(80),
    monto_original           FOR COLUMN CNTBFMOR   DECIMAL(18,2),
    saldo_pendiente          FOR COLUMN CNTBFSPD   DECIMAL(18,2),
    fecha_emision            FOR COLUMN CNTBFFE    DATE,
    fecha_vencimiento        FOR COLUMN CNTBFFV    DATE,
    estado_cxp               FOR COLUMN CNTBFEST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN CNTBFUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTBFUSA   VARCHAR(30),
    version_registro         FOR COLUMN CNTBFVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN CNTBFOBS   VARCHAR(120),
    estado_registro          FOR COLUMN CNTBFERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN CNTBFCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTBFUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLBAF PRIMARY KEY (codigo_banco, codigo_moneda)
)
RCDFMT CNTBFR;

RENAME TABLE CNTRLBAF
    TO CNTRLBAF_TABLE FOR SYSTEM NAME CNTRLBAF;

COMMENT ON TABLE CNTRLBAF IS
    'Control CxP - Parametros de Comisiones por Banco y Moneda - Modulo 11';

LABEL ON TABLE CNTRLBAF
    IS 'Control CxP Comisiones';

COMMENT ON COLUMN CNTRLBAF.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de comisiones de CxP';
COMMENT ON COLUMN CNTRLBAF.codigo_moneda IS
    'Codigo ISO de la moneda a la que aplican estos parametros de comisiones';
COMMENT ON COLUMN CNTRLBAF.numero_identificacion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.razon_social IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.email IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.telefono IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.monto_original IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.saldo_pendiente IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLBAF.fecha_emision IS
    'Fecha de alta de la configuracion de comisiones en el sistema';
COMMENT ON COLUMN CNTRLBAF.fecha_vencimiento IS
    'Fecha de vigencia de los parametros de comision si aplica';
COMMENT ON COLUMN CNTRLBAF.estado_cxp IS
    'Estado de la configuracion: ACTIVA, INACTIVA, EN_REVISION';
COMMENT ON COLUMN CNTRLBAF.usuario_creacion IS
    'Usuario administrador que registro la configuracion';
COMMENT ON COLUMN CNTRLBAF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN CNTRLBAF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLBAF.observaciones IS
    'Notas sobre la configuracion de comisiones o condiciones especiales';
COMMENT ON COLUMN CNTRLBAF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLBAF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLBAF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLBAF (
    codigo_banco              IS 'Banco',
    codigo_moneda             IS 'Moneda',
    numero_identificacion     IS 'No. Identif',
    razon_social              IS 'Razon Social',
    email                     IS 'Email',
    telefono                  IS 'Telefono',
    monto_original            IS 'Monto Orig',
    saldo_pendiente           IS 'Saldo Pend',
    fecha_emision             IS 'Fec Emision',
    fecha_vencimiento         IS 'Fec Vencim',
    estado_cxp                IS 'Estado',
    usuario_creacion          IS 'Usr Creacion',
    usuario_actualizacion     IS 'Usr Actualiz',
    version_registro          IS 'Version Reg',
    observaciones             IS 'Observacion',
    estado_registro           IS 'Estado Reg',
    created_at                IS 'Fec Creacion',
    updated_at                IS 'Fec Actualiz'
);

-- ================================================================
-- Etiquetas de descripcion larga por columna (TEXT)
-- ================================================================
LABEL ON COLUMN CNTRLBAF (
    codigo_banco              TEXT IS 'Codigo del banco al que pertenece la',
    codigo_moneda             TEXT IS 'Codigo ISO de la moneda a la que aplican estos',
    numero_identificacion     TEXT IS 'Campo de referencia del patron de tabla del modulo',
    razon_social              TEXT IS 'Campo de referencia del patron de tabla del modulo',
    email                     TEXT IS 'Campo de referencia del patron de tabla del modulo',
    telefono                  TEXT IS 'Campo de referencia del patron de tabla del modulo',
    monto_original            TEXT IS 'Campo de referencia del patron de tabla del modulo',
    saldo_pendiente           TEXT IS 'Campo de referencia del patron de tabla del modulo',
    fecha_emision             TEXT IS 'Fecha de alta de la configuracion de comisiones',
    fecha_vencimiento         TEXT IS 'Fecha de vigencia de los parametros de comision',
    estado_cxp                TEXT IS 'Estado de la configuracion: ACTIVA, INACTIVA,',
    usuario_creacion          TEXT IS 'Usuario administrador que registro la',
    usuario_actualizacion     TEXT IS 'Usuario que realizo la ultima modificacion de la',
    version_registro          TEXT IS 'Version del registro para control de concurrencia',
    observaciones             TEXT IS 'Notas sobre la configuracion de comisiones o',
    estado_registro           TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at                TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at                TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX ICNTBFCAT ON CNTRLBAF (created_at);
CREATE INDEX ICNTBFCMO ON CNTRLBAF (codigo_banco, codigo_moneda);