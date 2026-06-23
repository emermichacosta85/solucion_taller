-- ================================================================
-- Nombre de la Tabla  : LOCMS
-- DESCRIPCION         : Maestro de Localizaciones de Activos Fijos
-- Objetivo            : Catalogar las ubicaciones fisicas donde se
--                       encuentran los activos fijos del banco (oficinas,
--                       sucursales, bodegas, plantas), permitiendo el
--                       control de la ubicacion de cada activo y la
--                       generacion de inventarios por localizacion.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion por el area de activos fijos
--                       y control de bienes patrimoniales
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Asignacion de ubicacion a activos en FIXMS,
--                       inventarios fisicos y reportes de control
-- Restricciones       : PK por numero_localizacion; tabla raiz del
--                       modulo, debe crearse antes que FIXMS
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 10 Activos Fijos
-- ================================================================

CREATE OR REPLACE TABLE LOCMS (
    numero_localizacion      FOR COLUMN LOCMSNLC VARCHAR(30)    NOT NULL     ,
    descripcion              FOR COLUMN LOCMSDSC VARCHAR(120)   NOT NULL     ,
    fecha_adquisicion        FOR COLUMN LOCMSFAD DATE           NOT NULL     ,
    valor_adquisicion        FOR COLUMN LOCMSVAD DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    vida_util_meses          FOR COLUMN LOCMSVU INT            NOT NULL
                                            DEFAULT 0    ,
    depreciacion_acumulada   FOR COLUMN LOCMSDAC DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    estado_activo            FOR COLUMN LOCMSEST VARCHAR(20)    NOT NULL     ,
    usuario_creacion         FOR COLUMN LOCMSUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN LOCMSUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN LOCMSVR INT            NOT NULL
                                            DEFAULT 1    ,
    observaciones            FOR COLUMN LOCOBSER VARCHAR(120) NOT NULL,
    estado_registro          FOR COLUMN LOCESTRE VARCHAR(1) NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LOCMSCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LOCMSUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
                                                        
    CONSTRAINT PK_LOCMS PRIMARY KEY (numero_localizacion)
)
RCDFMT LOCMSR;

RENAME TABLE LOCMS
    TO LOCMS_TABLE FOR SYSTEM NAME LOCMS;

COMMENT ON TABLE LOCMS IS
    'Maestro de Localizaciones de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE LOCMS
    IS 'Localizaciones Activos';

COMMENT ON COLUMN LOCMS.numero_localizacion IS
    'Codigo unico que identifica la localizacion o ubicacion fisica';
COMMENT ON COLUMN LOCMS.descripcion IS
    'Nombre descriptivo de la localizacion (ej: Oficina Central Piso 3)';
COMMENT ON COLUMN LOCMS.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN LOCMS.valor_adquisicion IS
    'Valor total de todos los activos asignados a esta localizacion';
COMMENT ON COLUMN LOCMS.vida_util_meses IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN LOCMS.depreciacion_acumulada IS
    'Depreciacion acumulada total de los activos asignados a esta localizacion';
COMMENT ON COLUMN LOCMS.estado_activo IS
    'Estado de la localizacion: ACTIVA, INACTIVA, CERRADA, EN_REMODELACION';
COMMENT ON COLUMN LOCMS.usuario_creacion IS
    'Usuario del sistema que registro la localizacion';
COMMENT ON COLUMN LOCMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN LOCMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LOCMS.observaciones IS
    'Notas sobre la localizacion, accesos restringidos o condiciones especiales';
COMMENT ON COLUMN LOCMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LOCMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LOCMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LOCMS (
    numero_localizacion      TEXT IS 'No. Localiz',
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

CREATE INDEX ILOCMSNLO ON LOCMS (numero_localizacion);
CREATE INDEX ILOCMSCAT ON LOCMS (created_at);
