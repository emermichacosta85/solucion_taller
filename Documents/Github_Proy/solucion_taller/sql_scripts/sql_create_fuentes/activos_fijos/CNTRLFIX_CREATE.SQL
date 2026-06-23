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

CREATE OR REPLACE TABLE CNTRLFIX (
    codigo_banco             FOR COLUMN CNTRFBNK VARCHAR(20)    NOT NULL     ,
    descripcion              FOR COLUMN CNTRFDSC VARCHAR(120)   NOT NULL     ,
    fecha_adquisicion        FOR COLUMN CNTRFFAD DATE                       ,
    valor_adquisicion        FOR COLUMN CNTRFVAD DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    vida_util_meses          FOR COLUMN CNTRFVU INT            NOT NULL
                                            DEFAULT 0    ,                                        
    depreciacion_acumulada   FOR COLUMN CNTRFDAC DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    estado_activo            FOR COLUMN CNTRFEST VARCHAR(20)    NOT NULL     ,
    usuario_creacion         FOR COLUMN CNTRFUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN CNTRFUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN CNTRFVRS INT            NOT NULL
                                            DEFAULT 1    ,
    observaciones            FOR COLUMN CNTRFOBS VARCHAR(120) NOT NULL,
    estado_registro          FOR COLUMN CNTRFERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN CNTRFCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTRFUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLFIX PRIMARY KEY (codigo_banco)
)
RCDFMT CNTRLFR;

RENAME TABLE CNTRLFIX
    TO CNTRLFIX_TABLE FOR SYSTEM NAME CNTRLFIX;

COMMENT ON TABLE CNTRLFIX IS
    'Parametros Generales de Control de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE CNTRLFIX
    IS 'Control Activos Fijos';

COMMENT ON COLUMN CNTRLFIX.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de activos fijos';
COMMENT ON COLUMN CNTRLFIX.descripcion IS
    'Descripcion o nombre identificativo del conjunto de parametros configurados';
COMMENT ON COLUMN CNTRLFIX.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLFIX.valor_adquisicion IS
    'Valor total de todos los activos registrados en el banco';
COMMENT ON COLUMN CNTRLFIX.vida_util_meses IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CNTRLFIX.depreciacion_acumulada IS
    'Depreciacion acumulada total de todos los activos del banco';
COMMENT ON COLUMN CNTRLFIX.estado_activo IS
    'Estado de la configuracion del modulo: ACTIVO, INACTIVO, EN_MANTENIMIENTO';
COMMENT ON COLUMN CNTRLFIX.usuario_creacion IS
    'Usuario del sistema que registro la configuracion del modulo';
COMMENT ON COLUMN CNTRLFIX.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN CNTRLFIX.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLFIX.observaciones IS
    'Notas sobre la configuracion del modulo o cambios en parametros globales';
COMMENT ON COLUMN CNTRLFIX.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLFIX.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLFIX.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLFIX (
    codigo_banco             TEXT IS 'Banco',
    descripcion              TEXT IS 'Descripcion',
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

CREATE INDEX ICNTRFCAT ON CNTRLFIX (created_at);
CREATE INDEX ICNTRFCBA ON CNTRLFIX (codigo_banco);
