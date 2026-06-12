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

CREATE OR REPLACE TABLE HNEACOSTA1/LOCMS (
    numero_localizacion      VARCHAR(30)    NOT NULL     FOR COLUMN LOCMSNLC,
    descripcion              VARCHAR(120)   NOT NULL     FOR COLUMN LOCMSDSC,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN LOCMSBNK,
    codigo_sucursal          VARCHAR(20)                 FOR COLUMN LOCMSSUC,
    tipo_ubicacion           VARCHAR(20)                 FOR COLUMN LOCMSTUB,
    direccion                VARCHAR(120)                FOR COLUMN LOCMSDIR,
    ciudad                   VARCHAR(50)                 FOR COLUMN LOCMSCIU,
    departamento             VARCHAR(50)                 FOR COLUMN LOCMSDPT,
    pais                     VARCHAR(50)                 FOR COLUMN LOCMSPAS,
    responsable              VARCHAR(80)                 FOR COLUMN LOCMSRES,
    telefono_contacto        VARCHAR(30)                 FOR COLUMN LOCMSTLF,
    capacidad_activos        INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN LOCMSCAP,
    activos_asignados        INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN LOCMSASIG,
    fecha_adquisicion        DATE                        FOR COLUMN LOCMSFAD,
    valor_adquisicion        DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LOCMSVAD,
    vida_util_meses          INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN LOCMSVU,
    depreciacion_acumulada   DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LOCMSDAC,
    estado_activo            VARCHAR(20)    NOT NULL     FOR COLUMN LOCMSEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN LOCMSUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN LOCMSUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN LOCMSVR,
    observaciones            VARCHAR(120)                FOR COLUMN LOCMSOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN LOCMSERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LOCMSCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LOCMSUAT,
    CONSTRAINT PK_LOCMS PRIMARY KEY (numero_localizacion)
)
RCDFMT LOCMSR;

RENAME TABLE HNEACOSTA1/LOCMS
    TO LOCMS FOR SYSTEM NAME LOCMS;

COMMENT ON TABLE HNEACOSTA1/LOCMS IS
    'Maestro de Localizaciones de Activos Fijos - Modulo 10 Activos Fijos';

LABEL ON TABLE HNEACOSTA1/LOCMS
    IS 'Localizaciones Activos';

COMMENT ON COLUMN HNEACOSTA1/LOCMS.numero_localizacion IS
    'Codigo unico que identifica la localizacion o ubicacion fisica';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.descripcion IS
    'Nombre descriptivo de la localizacion (ej: Oficina Central Piso 3)';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.codigo_banco IS
    'Codigo del banco propietario de la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.codigo_sucursal IS
    'Codigo de la sucursal a la que pertenece la localizacion cuando aplica';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.tipo_ubicacion IS
    'Tipo de ubicacion: OFICINA, SUCURSAL, BODEGA, PLANTA, EXTERIOR, OTRO';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.direccion IS
    'Direccion fisica completa de la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.ciudad IS
    'Ciudad donde se encuentra la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.departamento IS
    'Departamento o estado donde se encuentra la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.pais IS
    'Pais donde se encuentra la localizacion del activo';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.responsable IS
    'Nombre del funcionario responsable del control de activos en esta ubicacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.telefono_contacto IS
    'Numero de telefono de contacto de la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.capacidad_activos IS
    'Numero maximo de activos que pueden ser asignados a esta localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.activos_asignados IS
    'Numero de activos actualmente registrados en esta localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.fecha_adquisicion IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.valor_adquisicion IS
    'Valor total de todos los activos asignados a esta localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.vida_util_meses IS
    'Campo de referencia del patron de tabla del modulo';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.depreciacion_acumulada IS
    'Depreciacion acumulada total de los activos asignados a esta localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.estado_activo IS
    'Estado de la localizacion: ACTIVA, INACTIVA, CERRADA, EN_REMODELACION';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.usuario_creacion IS
    'Usuario del sistema que registro la localizacion';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.observaciones IS
    'Notas sobre la localizacion, accesos restringidos o condiciones especiales';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LOCMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LOCMS (
    numero_localizacion      TEXT IS 'No. Localiz',
    descripcion              TEXT IS 'Descripcion',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    tipo_ubicacion           TEXT IS 'Tipo Ubic',
    direccion                TEXT IS 'Direccion',
    ciudad                   TEXT IS 'Ciudad',
    departamento             TEXT IS 'Departamento',
    pais                     TEXT IS 'Pais',
    responsable              TEXT IS 'Responsable',
    telefono_contacto        TEXT IS 'Telefono',
    capacidad_activos        TEXT IS 'Capacidad',
    activos_asignados        TEXT IS 'Asignados',
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

CREATE INDEX HNEACOSTA1/ILOCMSCAT ON HNEACOSTA1/LOCMS (created_at);
CREATE INDEX HNEACOSTA1/ILOCMSBNK ON HNEACOSTA1/LOCMS (codigo_banco);
CREATE INDEX HNEACOSTA1/ILOCMSEST ON HNEACOSTA1/LOCMS (estado_activo);