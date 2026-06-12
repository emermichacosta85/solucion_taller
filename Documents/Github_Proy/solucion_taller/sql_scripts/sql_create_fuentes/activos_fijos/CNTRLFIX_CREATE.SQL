-- ================================================================
-- Nombre de la Tabla  : CNTRLFIX
-- DESCRIPCION         : Archivo de Control de Activos Fijos
-- Objetivo            : Almacenar los parametros generales que rigen el
--                       modulo de activos fijos para cada banco, incluyendo
--                       numeracion automatica, porcentajes de depreciacion
--                       globales, politicas de revaluacion y cuentas
--                       contables por defecto para el procesamiento
--                       automatico del cierre mensual de activos.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion inicial del modulo de activos fijos
--                       por el area de sistemas y contabilidad
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia en todos los procesos del modulo de
--                       activos fijos para aplicar parametros globales
-- Restricciones       : PK por codigo_banco; un registro de control
--                       por banco; tabla de configuracion global del modulo
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 10 Activos Fijos
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CNTRLFIX (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CNTRFBNK,
    descripcion              VARCHAR(120)                FOR COLUMN CNTRFDSC,
    ultimo_numero_activo     VARCHAR(30)                 FOR COLUMN CNTRFUNA,
    prefijo_numero_activo    VARCHAR(10)                 FOR COLUMN CNTRFPNA,
    cuenta_activos_defecto   VARCHAR(24)                 FOR COLUMN CNTRFCAD,
    cuenta_deprec_defecto    VARCHAR(24)                 FOR COLUMN CNTRFCDD,
    cuenta_gto_dep_defecto   VARCHAR(24)                 FOR COLUMN CNTRFCGD,
    porcentaje_revaluacion   DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRFPRV,
    mes_cierre_activos       INT            NOT NULL
                                            DEFAULT 12   FOR COLUMN CNTRFMCA,
    dia_proceso_depreciacion INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNTRFDPD,
    metodo_defecto           VARCHAR(20)                 FOR COLUMN CNTRFMDE,
    codigo_moneda_base       VARCHAR(20)                 FOR COLUMN CNTRFMON,
    permite_depreciacion_neg CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN CNTRFPDN,
    requiere_aprobacion      CHAR(1)        NOT NULL
                                            DEFAULT 'S'  FOR COLUMN CNTRFRAP,
    fecha_adquisicion        DATE                        FOR COLUMN CNTRFFAD,
    valor_adquisicion        DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRFVAD,
    vida_util_meses          INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRFVU,
    depreciacion_acumulada   DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CNTRFDAC,
    estado_activo            VARCHAR(20)    NOT NULL     FOR COLUMN CNTRFEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CNTRFUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CNTRFUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CNTRFVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CNTRFOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CNTRFERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTRFCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CNTRFUAT,
    CONSTRAINT PK_CNTRLFIX PRIMARY KEY (codigo_banco)
)
RCDFMT CNTRLFR;

RENAME TABLE HNEACOSTA1/CNTRLFIX
    TO CNTRLFIX FOR SYSTEM NAME CNTRLFIX;

COMMENT ON TABLE HNEACOSTA1/CNTRLFIX IS
    'Parametros Generales de Control de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE HNEACOSTA1/CNTRLFIX
    IS 'Control Activos Fijos';

COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de activos fijos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.descripcion IS
    'Descripcion o nombre identificativo del conjunto de parametros configurados';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.ultimo_numero_activo IS
    'Ultimo numero de activo asignado para continuar la numeracion consecutiva';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.prefijo_numero_activo IS
    'Prefijo que se antepone al numero de activo en la numeracion automatica';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.cuenta_activos_defecto IS
    'Cuenta contable por defecto para el registro de activos sin clase asignada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.cuenta_deprec_defecto IS
    'Cuenta contable por defecto para la depreciacion acumulada';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.cuenta_gto_dep_defecto IS
    'Cuenta contable por defecto para el registro del gasto por depreciacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.porcentaje_revaluacion IS
    'Porcentaje de revaluacion anual aplicable cuando la politica lo permite';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.mes_cierre_activos IS
    'Mes del anio fiscal en que se realiza el cierre anual de activos fijos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.dia_proceso_depreciacion IS
    'Dia del mes en que se ejecuta automaticamente el proceso de depreciacion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.metodo_defecto IS
    'Metodo de depreciacion aplicado por defecto si la clase no especifica uno';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.codigo_moneda_base IS
    'Moneda base del banco para la valoracion y reporte de activos fijos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.permite_depreciacion_neg IS
    'Indica si el sistema permite registrar depreciacion negativa: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.requiere_aprobacion IS
    'Indica si los altas, bajas y traslados de activos requieren aprobacion: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.valor_adquisicion IS
    'Valor total de todos los activos registrados en el banco';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.vida_util_meses IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.depreciacion_acumulada IS
    'Depreciacion acumulada total de todos los activos del banco';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.estado_activo IS
    'Estado de la configuracion del modulo: ACTIVO, INACTIVO, EN_MANTENIMIENTO';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.usuario_creacion IS
    'Usuario del sistema que registro la configuracion del modulo';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.observaciones IS
    'Notas sobre la configuracion del modulo o cambios en parametros globales';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CNTRLFIX.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CNTRLFIX (
    codigo_banco             TEXT IS 'Banco',
    descripcion              TEXT IS 'Descripcion',
    ultimo_numero_activo     TEXT IS 'Ult No Activo',
    prefijo_numero_activo    TEXT IS 'Prefijo',
    cuenta_activos_defecto   TEXT IS 'Cta Activos',
    cuenta_deprec_defecto    TEXT IS 'Cta Deprec',
    cuenta_gto_dep_defecto   TEXT IS 'Cta Gto Dep',
    porcentaje_revaluacion   TEXT IS 'Porc Revalua',
    mes_cierre_activos       TEXT IS 'Mes Cierre',
    dia_proceso_depreciacion TEXT IS 'Dia Deprec',
    metodo_defecto           TEXT IS 'Met Defecto',
    codigo_moneda_base       TEXT IS 'Moneda Base',
    permite_depreciacion_neg TEXT IS 'Deprec Neg',
    requiere_aprobacion      TEXT IS 'Req Aprobac',
    fecha_adquisicion        TEXT IS 'Fec Adquis',
    valor_adquisicion        TEXT IS 'Valor Total',
    vida_util_meses          TEXT IS 'Vida Util',
    depreciacion_acumulada   TEXT IS 'Deprec Acum',
    estado_activo            TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICNTRFCAT ON HNEACOSTA1/CNTRLFIX (created_at);
