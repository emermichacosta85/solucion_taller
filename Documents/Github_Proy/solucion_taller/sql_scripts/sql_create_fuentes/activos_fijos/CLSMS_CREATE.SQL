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

CREATE OR REPLACE TABLE HNEACOSTA1/CLSMS (
    codigo_clase             VARCHAR(20)    NOT NULL     FOR COLUMN CLSMSCOD,
    descripcion              VARCHAR(120)   NOT NULL     FOR COLUMN CLSMSDSC,
    tipo_activo              VARCHAR(20)                 FOR COLUMN CLSMSTAC,
    metodo_depreciacion      VARCHAR(20)    NOT NULL     FOR COLUMN CLSMSMDE,
    vida_util_meses          INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN CLSMSVU,
    porcentaje_depreciacion  DECIMAL(10,6)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CLSMSPDE,
    valor_residual_pct       DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CLSMSVRS,
    cuenta_activo            VARCHAR(24)                 FOR COLUMN CLSMSCA,
    cuenta_depreciacion      VARCHAR(24)                 FOR COLUMN CLSMSCD,
    cuenta_gasto_depreciacion VARCHAR(24)                FOR COLUMN CLSMSCGD,
    requiere_seguro          CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN CLSMSRSEG,
    fecha_adquisicion        DATE                        FOR COLUMN CLSMSFAD,
    valor_adquisicion        DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CLSMSVAD,
    depreciacion_acumulada   DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CLSMSDAC,
    estado_activo            VARCHAR(20)    NOT NULL     FOR COLUMN CLSMSEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CLSMSUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CLSMSUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CLSMSVR,
    observaciones            VARCHAR(120)                FOR COLUMN CLSMSOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CLSMSERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CLSMSCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CLSMSUAT,
    CONSTRAINT PK_CLSMS PRIMARY KEY (codigo_clase)
)
RCDFMT CLSMSR;

RENAME TABLE HNEACOSTA1/CLSMS
    TO CLSMS FOR SYSTEM NAME CLSMS;

COMMENT ON TABLE HNEACOSTA1/CLSMS IS
    'Catalogo de Clases de Amortizacion de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE HNEACOSTA1/CLSMS
    IS 'Clases Amortizacion AF';

COMMENT ON COLUMN HNEACOSTA1/CLSMS.codigo_clase IS
    'Codigo unico que identifica la clase de amortizacion de activo fijo';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.descripcion IS
    'Nombre o descripcion oficial de la clase de activo segun politica contable';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.tipo_activo IS
    'Tipo de activo que agrupa la clase: EDIFICIO, EQUIPO, VEHICULO, MOBILIARIO, SOFTWARE';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.metodo_depreciacion IS
    'Metodo de depreciacion aplicado: LINEA_RECTA, SALDO_DECRECIENTE, UNIDADES_PRODUCCION';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.vida_util_meses IS
    'Vida util estandar en meses para todos los activos de esta clase';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.porcentaje_depreciacion IS
    'Porcentaje anual de depreciacion aplicado bajo el metodo configurado';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.valor_residual_pct IS
    'Porcentaje del valor original que se conserva como valor residual al terminar la vida util';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.cuenta_activo IS
    'Numero de cuenta contable del plan de cuentas donde se registra el activo';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.cuenta_depreciacion IS
    'Numero de cuenta contable de depreciacion acumulada del activo';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.cuenta_gasto_depreciacion IS
    'Numero de cuenta contable del gasto por depreciacion del periodo';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.requiere_seguro IS
    'Indica si los activos de esta clase deben mantenerse asegurados: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo (fecha de alta de la clase)';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.valor_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.depreciacion_acumulada IS
    'Depreciacion acumulada total de todos los activos de esta clase en el banco';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.estado_activo IS
    'Estado de la clase: ACTIVA, INACTIVA, DEROGADA';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.usuario_creacion IS
    'Usuario del sistema que creo la clase de amortizacion';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.observaciones IS
    'Notas sobre la clase, su aplicacion o restricciones contables';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CLSMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CLSMS (
    codigo_clase             TEXT IS 'Cod Clase',
    descripcion              TEXT IS 'Descripcion',
    tipo_activo              TEXT IS 'Tipo Activo',
    metodo_depreciacion      TEXT IS 'Met Deprec',
    vida_util_meses          TEXT IS 'Vida Util',
    porcentaje_depreciacion  TEXT IS 'Porc Deprec',
    valor_residual_pct       TEXT IS 'Val Residual',
    cuenta_activo            TEXT IS 'Cta Activo',
    cuenta_depreciacion      TEXT IS 'Cta Deprec',
    cuenta_gasto_depreciacion TEXT IS 'Cta Gto Dep',
    requiere_seguro          TEXT IS 'Req Seguro',
    fecha_adquisicion        TEXT IS 'Fec Adquis',
    valor_adquisicion        TEXT IS 'Valor Adquis',
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

CREATE INDEX HNEACOSTA1/ICLSMSCAT ON HNEACOSTA1/CLSMS (created_at);
CREATE INDEX HNEACOSTA1/ICLSMSTAC ON HNEACOSTA1/CLSMS (tipo_activo);
CREATE INDEX HNEACOSTA1/ICLSMSEST ON HNEACOSTA1/CLSMS (estado_activo);