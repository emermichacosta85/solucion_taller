-- =============================================================================
-- Nombre de la Tabla  : USERS
-- DESCRIPCION         : Archivo de Autorizaciones por Menus. Define los
--                       permisos de acceso que tiene cada usuario del sistema
--                       sobre cada opcion de menu, incluyendo el nivel de
--                       autorizacion y las operaciones permitidas.
-- Objetivo            : Controlar y auditar los privilegios de acceso de los
--                       usuarios del sistema bancario sobre los menus y
--                       opciones funcionales, aplicando seguridad por rol
--                       y nivel de autorizacion.
-- Tipo de Tabla       : Maestra de Seguridad
-- Origen de los Datos : Administracion de seguridad del sistema; alta y
--                       modificacion de perfiles de usuario por el area de
--                       Seguridad Informatica.
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Validacion de acceso en tiempo de ejecucion de cada
--                       programa; auditoria de permisos; generacion de reportes
--                       de seguridad por usuario y modulo.
-- Restricciones       : No se permite crear PF ni LF. Solo SQL DDL.
--                       Sin FK externas: tabla independiente segun diagrama ER.
-- -----------------------------------------------------------------------------
-- Hecho por           : Taller IBM i - Equipo de Base de Datos
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 15 Seguridad
-- =============================================================================

CREATE OR REPLACE TABLE USERS (
    -- -------------------------------------------------------------------------
    -- Clave primaria compuesta
    -- -------------------------------------------------------------------------
    codigo_usuario          FOR COLUMN CODUSR   VARCHAR(20)   NOT NULL,
    menu                    FOR COLUMN MNUNOM   VARCHAR(20)   NOT NULL,
    opcion                  FOR COLUMN OPCION   VARCHAR(20)   NOT NULL,

    -- -------------------------------------------------------------------------
    -- Atributos funcionales de autorizacion
    -- -------------------------------------------------------------------------
    rol                     FOR COLUMN ROLNOM   VARCHAR(20)   NOT NULL DEFAULT 'CONSULTA',
    nivel_autorizacion      FOR COLUMN NIVAUZ   INT           NOT NULL DEFAULT 0,
    permite_consulta        FOR COLUMN PMTCON   SMALLINT      NOT NULL DEFAULT 0,
    permite_creacion        FOR COLUMN PMTCRE   SMALLINT      NOT NULL DEFAULT 0,
    permite_actualizacion   FOR COLUMN PMTACT   SMALLINT      NOT NULL DEFAULT 0,
    permite_aprobacion      FOR COLUMN PMTAPR   SMALLINT      NOT NULL DEFAULT 0,
    observaciones           FOR COLUMN OBSERV   VARCHAR(120),

    -- -------------------------------------------------------------------------
    -- Campos de auditoria y control
    -- -------------------------------------------------------------------------
    usuario_creacion        FOR COLUMN USRCRE   VARCHAR(30)   NOT NULL,
    usuario_actualizacion   FOR COLUMN USRACT   VARCHAR(30),
    version_registro        FOR COLUMN VERNUM   INT           NOT NULL DEFAULT 1,
    estado_registro         FOR COLUMN ESTREG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CRTDAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN UPDDAT   TIMESTAMP,

    -- -------------------------------------------------------------------------
    -- Restricciones de tabla
    -- -------------------------------------------------------------------------
    CONSTRAINT USERS_PK PRIMARY KEY (codigo_usuario, menu, opcion),

    CONSTRAINT USERS_CHK_CONSULTA
        CHECK (permite_consulta IN (0, 1)),
    CONSTRAINT USERS_CHK_CREACION
        CHECK (permite_creacion IN (0, 1)),
    CONSTRAINT USERS_CHK_ACTUALIZACION
        CHECK (permite_actualizacion IN (0, 1)),
    CONSTRAINT USERS_CHK_APROBACION
        CHECK (permite_aprobacion IN (0, 1)),
    CONSTRAINT USERS_CHK_ESTADO
        CHECK (estado_registro IN ('A', 'I'))
)
RCDFMT USERSFMT;

-- =============================================================================
-- Renombramiento a nombre corto de sistema (IBM i)
-- =============================================================================
RENAME TABLE USERS
    TO USERS_table FOR SYSTEM NAME USERS;

-- =============================================================================
-- Comentarios y etiquetas de tabla
-- =============================================================================
COMMENT ON TABLE USERS IS
    'Archivo de Autorizaciones por Menus - Control de acceso de usuarios a opciones del sistema';

LABEL ON TABLE USERS IS
    'Autorizaciones por Menus';

-- =============================================================================
-- Comentarios tecnicos por columna
-- =============================================================================
COMMENT ON COLUMN USERS.codigo_usuario        IS 'Codigo unico del usuario del sistema (PK parte 1)';
COMMENT ON COLUMN USERS.menu                  IS 'Identificador del menu sobre el cual se define la autorizacion (PK parte 2)';
COMMENT ON COLUMN USERS.opcion                IS 'Identificador de la opcion dentro del menu (PK parte 3)';
COMMENT ON COLUMN USERS.rol                   IS 'Rol asignado al usuario para esta combinacion de menu y opcion';
COMMENT ON COLUMN USERS.nivel_autorizacion    IS 'Nivel numerico de autorizacion del usuario: a mayor numero mayor privilegio';
COMMENT ON COLUMN USERS.permite_consulta      IS 'Indicador de permiso de consulta sobre la opcion: 1=Si 0=No';
COMMENT ON COLUMN USERS.permite_creacion      IS 'Indicador de permiso de creacion de registros: 1=Si 0=No';
COMMENT ON COLUMN USERS.permite_actualizacion IS 'Indicador de permiso de actualizacion de registros: 1=Si 0=No';
COMMENT ON COLUMN USERS.permite_aprobacion    IS 'Indicador de permiso para aprobar operaciones: 1=Si 0=No';
COMMENT ON COLUMN USERS.observaciones         IS 'Observaciones o notas adicionales sobre la autorizacion';
COMMENT ON COLUMN USERS.usuario_creacion      IS 'Codigo del usuario que creo el registro de autorizacion';
COMMENT ON COLUMN USERS.usuario_actualizacion IS 'Codigo del usuario que realizo la ultima modificacion';
COMMENT ON COLUMN USERS.version_registro      IS 'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN USERS.estado_registro       IS 'Estado del registro: A=Activo I=Inactivo';
COMMENT ON COLUMN USERS.created_at            IS 'Timestamp de creacion del registro de autorizacion';
COMMENT ON COLUMN USERS.updated_at            IS 'Timestamp de la ultima modificacion del registro';

-- =============================================================================
-- Etiquetas cortas por columna (heading en pantalla/reporte)
-- =============================================================================
LABEL ON COLUMN USERS (
    codigo_usuario         IS 'Cod Usuario'  ,
    menu                   IS 'Menu'         ,
    opcion                 IS 'Opcion'       ,
    rol                    IS 'Rol'          ,
    nivel_autorizacion     IS 'Nivel Autriz' ,
    permite_consulta       IS 'Consulta'     ,
    permite_creacion       IS 'Creacion'     ,
    permite_actualizacion  IS 'Actualizacion',
    permite_aprobacion     IS 'Aprobacion'   ,
    observaciones          IS 'Observ'       ,
    usuario_creacion       IS 'Usr Crea'     ,
    usuario_actualizacion  IS 'Usr Act'      ,
    version_registro       IS 'Version'      ,
    estado_registro        IS 'Estado'       ,
    created_at             IS 'Creado'       ,
    updated_at             IS 'Actualizado'
);

-- =============================================================================
-- Etiquetas de descripcion larga por columna
-- =============================================================================
LABEL ON COLUMN USERS
    (codigo_usuario        TEXT IS 'Codigo unico del usuario del sistema');
LABEL ON COLUMN USERS
    (menu                  TEXT IS 'Identificador del menu sobre el que aplica la autorizacion');
LABEL ON COLUMN USERS
    (opcion                TEXT IS 'Identificador de la opcion dentro del menu');
LABEL ON COLUMN USERS
    (rol                   TEXT IS 'Rol asignado al usuario para esta opcion de menu');
LABEL ON COLUMN USERS
    (nivel_autorizacion    TEXT IS 'Nivel numerico de autorizacion: mayor numero mayor privilegio');
LABEL ON COLUMN USERS
    (permite_consulta      TEXT IS 'Permiso de consulta sobre la opcion del menu (1=Si 0=No)');
LABEL ON COLUMN USERS
    (permite_creacion      TEXT IS 'Permiso para crear registros en la opcion (1=Si 0=No)');
LABEL ON COLUMN USERS
    (permite_actualizacion TEXT IS 'Permiso para modificar registros en la opcion (1=Si 0=No)');
LABEL ON COLUMN USERS
    (permite_aprobacion    TEXT IS 'Permiso para aprobar operaciones en la opcion (1=Si 0=No)');
LABEL ON COLUMN USERS
    (observaciones         TEXT IS 'Observaciones o notas adicionales sobre la autorizacion');
LABEL ON COLUMN USERS
    (usuario_creacion      TEXT IS 'Usuario que creo el registro de autorizacion');
LABEL ON COLUMN USERS
    (usuario_actualizacion TEXT IS 'Usuario que realizo la ultima modificacion del registro');
LABEL ON COLUMN USERS
    (version_registro      TEXT IS 'Version del registro para control de concurrencia optimista');
LABEL ON COLUMN USERS
    (estado_registro       TEXT IS 'Estado del registro de autorizacion: A=Activo I=Inactivo');
LABEL ON COLUMN USERS
    (created_at            TEXT IS 'Marca de tiempo de creacion del registro');
LABEL ON COLUMN USERS
    (updated_at            TEXT IS 'Marca de tiempo de la ultima modificacion del registro');

-- =============================================================================
-- Indices de soporte
-- =============================================================================
-- Indice por usuario para consulta rapida de todos sus accesos
CREATE INDEX IDX_USERS_USR ON USERS (codigo_usuario, estado_registro);

-- Indice por menu para reportes de autorizaciones por modulo
CREATE INDEX IDX_USERS_MNU ON USERS (menu, opcion);

-- Indice por fecha de creacion para auditorias cronologicas
CREATE INDEX IDX_USERS_CRT ON USERS (created_at);

-- =============================================================================
-- Fin de script: USERS
-- =============================================================================
