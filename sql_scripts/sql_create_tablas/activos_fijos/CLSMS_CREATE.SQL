-- ================================================================
-- Nombre de la Tabla  : CLSMS
-- DESCRIPCION         : Maestro de Clases de Amortizaciones de Activos Fijos
-- Objetivo            : Catalogar las clases o categorias de activos fijos
--                       del banco definiendo para cada una el metodo de
--                       depreciacion o amortizacion, la vida util estandar
--                       y los parametros de calculo que aplican a todos
--                       los activos clasificados bajo esa categoria.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion por el area de contabilidad segun
--                       politica de activos fijos y normativa contable
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Asignacion de clase al registrar activos en FIXMS,
--                       calculo automatico de depreciacion en cierre de mes
-- Restricciones       : PK por codigo_clase; tabla raiz del modulo,
--                       crearse antes que FIXMS
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 10 Activos Fijos
-- ================================================================

CREATE OR REPLACE TABLE CLSMS (
    codigo_clase             FOR COLUMN CLSMSCOD VARCHAR(20)    NOT NULL     ,
    descripcion              FOR COLUMN CLSMSDSC VARCHAR(120)   NOT NULL     ,
    fecha_adquisicion        FOR COLUMN CLSMSFAD DATE                       ,
    valor_adquisicion        FOR COLUMN CLSMSVAD DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    vida_util_meses          FOR COLUMN CLSMSVU INT            NOT NULL
                                            DEFAULT 0    ,                                        
    depreciacion_acumulada   FOR COLUMN CLSMSDAC DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    estado_activo            FOR COLUMN CLSMSEST VARCHAR(20)    NOT NULL     ,
    usuario_creacion         FOR COLUMN CLSMSUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN CLSMSUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN CLSMSVR INT            NOT NULL
                                            DEFAULT 1    ,
    observaciones            FOR COLUMN CLSMSOBS VARCHAR(120) NOT NULL,
    estado_registro          FOR COLUMN CLSMSERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN CLSMSCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    updated_at               FOR COLUMN CLSMSUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    CONSTRAINT PK_CLSMS PRIMARY KEY (codigo_clase)
)
RCDFMT CLSMSR;

RENAME TABLE CLSMS
    TO CLSMS_TABLE FOR SYSTEM NAME CLSMS;

COMMENT ON TABLE CLSMS IS
    'Catalogo de Clases de Amortizacion de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE CLSMS
    IS 'Clases Amortizacion AF';

COMMENT ON COLUMN CLSMS.codigo_clase IS
    'Codigo unico que identifica la clase de amortizacion de activo fijo';
COMMENT ON COLUMN CLSMS.descripcion IS
    'Nombre o descripcion oficial de la clase de activo segun politica contable';
COMMENT ON COLUMN CLSMS.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo (fecha de alta de la clase)';
COMMENT ON COLUMN CLSMS.valor_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN CLSMS.vida_util_meses IS
    'Vida util estandar en meses para todos los activos de esta clase';
COMMENT ON COLUMN CLSMS.depreciacion_acumulada IS
    'Depreciacion acumulada total de todos los activos de esta clase en el banco';
COMMENT ON COLUMN CLSMS.estado_activo IS
    'Estado de la clase: ACTIVA, INACTIVA, DEROGADA';
COMMENT ON COLUMN CLSMS.usuario_creacion IS
    'Usuario del sistema que creo la clase de amortizacion';
COMMENT ON COLUMN CLSMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN CLSMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CLSMS.observaciones IS
    'Notas sobre la clase, su aplicacion o restricciones contables';
COMMENT ON COLUMN CLSMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CLSMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CLSMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CLSMS (
    codigo_clase             TEXT IS 'Cod Clase',
    descripcion              TEXT IS 'Descripcion',
    fecha_adquisicion        TEXT IS 'Fec Adquis',
    valor_adquisicion        TEXT IS 'Valor Adquis',
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

CREATE INDEX ICLSMSCCL ON CLSMS (codigo_clase);
CREATE INDEX ICLSMSACT ON CLSMS (created_at);