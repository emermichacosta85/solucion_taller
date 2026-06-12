-- =============================================================================
-- Nombre de la Tabla  : USERS
-- DESCRIPCIÓN         : Archivo de Autorizaciones por Menús. Define los
--                       permisos de acceso que tiene cada usuario del sistema
--                       sobre cada opción de menú, incluyendo el nivel de
--                       autorización y las operaciones permitidas.
-- Objetivo            : Controlar y auditar los privilegios de acceso de los
--                       usuarios del sistema bancario sobre los menús y
--                       opciones funcionales, aplicando seguridad por rol
--                       y nivel de autorización.
-- Tipo de Tabla       : Maestra de Seguridad
-- Origen de los Datos : Administración de seguridad del sistema; alta y
--                       modificación de perfiles de usuario por el área de
--                       Seguridad Informática.
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Validación de acceso en tiempo de ejecución de cada
--                       programa; auditoría de permisos; generación de reportes
--                       de seguridad por usuario y módulo.
-- Restricciones       : No se permite crear PF ni LF. Solo SQL DDL.
--                       Sin FK externas: tabla independiente según diagrama ER.
-- -----------------------------------------------------------------------------
-- Hecho por           : Taller IBM i - Equipo de Base de Datos
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Módulo 15 Seguridad
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/USERS (
    -- -------------------------------------------------------------------------
    -- Clave primaria compuesta
    -- -------------------------------------------------------------------------
    codigo_usuario  VARCHAR(20)  NOT NULL FOR COLUMN CODUSR ,
    menu            VARCHAR(20)  NOT NULL FOR COLUMN MNUNOM ,
    opcion          VARCHAR(20)  NOT NULL FOR COLUMN OPCION ,

    -- -------------------------------------------------------------------------
    -- Atributos funcionales de autorización
    -- -------------------------------------------------------------------------
    rol                    VARCHAR(20)  NOT NULL FOR COLUMN ROLNOM
                           DEFAULT 'CONSULTA' ,
    nivel_autorizacion     INT          NOT NULL FOR COLUMN NIVAUZ
                           DEFAULT 0 ,
    permite_consulta       SMALLINT     NOT NULL FOR COLUMN PMTCON
                           DEFAULT 0 ,
    permite_creacion       SMALLINT     NOT NULL FOR COLUMN PMTCRE
                           DEFAULT 0 ,
    permite_actualizacion  SMALLINT     NOT NULL FOR COLUMN PMTACT
                           DEFAULT 0 ,
    permite_aprobacion     SMALLINT     NOT NULL FOR COLUMN PMTAPR
                           DEFAULT 0 ,
    observaciones          VARCHAR(120)          FOR COLUMN OBSERV  ,

    -- -------------------------------------------------------------------------
    -- Campos de auditoría y control
    -- -------------------------------------------------------------------------
    usuario_creacion       VARCHAR(30)  NOT NULL FOR COLUMN USRCRE ,
    usuario_actualizacion  VARCHAR(30)           FOR COLUMN USRACT  ,
    version_registro       INT          NOT NULL FOR COLUMN VERNUM
                           DEFAULT 1 ,
    estado_registro        CHAR(1)      NOT NULL FOR COLUMN ESTREG
                           DEFAULT 'A' ,
    created_at             TIMESTAMP    NOT NULL FOR COLUMN CRTDAT
                           DEFAULT CURRENT_TIMESTAMP ,
    updated_at             TIMESTAMP             FOR COLUMN UPDDAT ,

    -- -------------------------------------------------------------------------
    -- Restricciones de tabla
    -- -------------------------------------------------------------------------
    CONSTRAINT USERS_PK PRIMARY KEY (codigo_usuario, menu, opcion) ,

    CONSTRAINT USERS_CHK_CONSULTA
        CHECK (permite_consulta IN (0, 1)) ,
    CONSTRAINT USERS_CHK_CREACION
        CHECK (permite_creacion IN (0, 1)) ,
    CONSTRAINT USERS_CHK_ACTUALIZACION
        CHECK (permite_actualizacion IN (0, 1)) ,
    CONSTRAINT USERS_CHK_APROBACION
        CHECK (permite_aprobacion IN (0, 1)) ,
    CONSTRAINT USERS_CHK_ESTADO
        CHECK (estado_registro IN ('A', 'I'))
)
RCDFMT USERSFMT;

-- =============================================================================
-- Renombramiento a nombre corto de sistema (IBM i)
-- =============================================================================
RENAME TABLE HNEACOSTA1/USERS
    TO USERS FOR SYSTEM NAME USERS;

-- =============================================================================
-- Comentarios y etiquetas de tabla
-- =============================================================================
COMMENT ON TABLE HNEACOSTA1/USERS IS
    'Archivo de Autorizaciones por Menus - Control de acceso de usuarios a opciones del sistema';

LABEL ON TABLE HNEACOSTA1/USERS IS
    'Autorizaciones por Menus';

-- =============================================================================
-- Comentarios técnicos por columna
-- =============================================================================
COMMENT ON COLUMN HNEACOSTA1/USERS.codigo_usuario        IS 'Codigo unico del usuario del sistema (PK parte 1)';
COMMENT ON COLUMN HNEACOSTA1/USERS.menu                  IS 'Identificador del menu sobre el cual se define la autorizacion (PK parte 2)';
COMMENT ON COLUMN HNEACOSTA1/USERS.opcion                IS 'Identificador de la opcion dentro del menu (PK parte 3)';
COMMENT ON COLUMN HNEACOSTA1/USERS.rol                   IS 'Rol asignado al usuario para esta combinacion de menu y opcion';
COMMENT ON COLUMN HNEACOSTA1/USERS.nivel_autorizacion    IS 'Nivel numerico de autorizacion del usuario: a mayor numero mayor privilegio';
COMMENT ON COLUMN HNEACOSTA1/USERS.permite_consulta      IS 'Indicador de permiso de consulta sobre la opcion: 1=Si 0=No';
COMMENT ON COLUMN HNEACOSTA1/USERS.permite_creacion      IS 'Indicador de permiso de creacion de registros: 1=Si 0=No';
COMMENT ON COLUMN HNEACOSTA1/USERS.permite_actualizacion IS 'Indicador de permiso de actualizacion de registros: 1=Si 0=No';
COMMENT ON COLUMN HNEACOSTA1/USERS.permite_aprobacion    IS 'Indicador de permiso para aprobar operaciones: 1=Si 0=No';
COMMENT ON COLUMN HNEACOSTA1/USERS.observaciones         IS 'Observaciones o notas adicionales sobre la autorizacion';
COMMENT ON COLUMN HNEACOSTA1/USERS.usuario_creacion      IS 'Codigo del usuario que creo el registro de autorizacion';
COMMENT ON COLUMN HNEACOSTA1/USERS.usuario_actualizacion IS 'Codigo del usuario que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/USERS.version_registro      IS 'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/USERS.estado_registro       IS 'Estado del registro: A=Activo I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/USERS.created_at            IS 'Timestamp de creacion del registro de autorizacion';
COMMENT ON COLUMN HNEACOSTA1/USERS.updated_at            IS 'Timestamp de la ultima modificacion del registro';

-- =============================================================================
-- Etiquetas cortas por columna (header en pantalla/reporte)
-- =============================================================================
LABEL ON COLUMN HNEACOSTA1/USERS (
    codigo_usuario         TEXT IS 'Cod Usuario'  ,
    menu                   TEXT IS 'Menu'         ,
    opcion                 TEXT IS 'Opcion'       ,
    rol                    TEXT IS 'Rol'          ,
    nivel_autorizacion     TEXT IS 'Nivel Autriz' ,
    permite_consulta       TEXT IS 'Consulta'     ,
    permite_creacion       TEXT IS 'Creacion'     ,
    permite_actualizacion  TEXT IS 'Actualizacion',
    permite_aprobacion     TEXT IS 'Aprobacion'   ,
    observaciones          TEXT IS 'Observ'       ,
    usuario_creacion       TEXT IS 'Usr Crea'     ,
    usuario_actualizacion  TEXT IS 'Usr Act'      ,
    version_registro       TEXT IS 'Version'      ,
    estado_registro        TEXT IS 'Estado'       ,
    created_at             TEXT IS 'Creado'       ,
    updated_at             TEXT IS 'Actualizado'
);

-- =============================================================================
-- Etiquetas de descripcion larga por columna
-- =============================================================================
LABEL ON COLUMN HNEACOSTA1/USERS
    (codigo_usuario        TEXT IS 'Codigo unico del usuario del sistema') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (menu                  TEXT IS 'Identificador del menu sobre el que aplica la autorizacion') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (opcion                TEXT IS 'Identificador de la opcion dentro del menu') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (rol                   TEXT IS 'Rol asignado al usuario para esta opcion de menu') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (nivel_autorizacion    TEXT IS 'Nivel numerico de autorizacion: mayor numero mayor privilegio') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (permite_consulta      TEXT IS 'Permiso de consulta sobre la opcion del menu (1=Si 0=No)') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (permite_creacion      TEXT IS 'Permiso para crear registros en la opcion (1=Si 0=No)') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (permite_actualizacion TEXT IS 'Permiso para modificar registros en la opcion (1=Si 0=No)') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (permite_aprobacion    TEXT IS 'Permiso para aprobar operaciones en la opcion (1=Si 0=No)') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (observaciones         TEXT IS 'Observaciones o notas adicionales sobre la autorizacion') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (usuario_creacion      TEXT IS 'Usuario que creo el registro de autorizacion') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (usuario_actualizacion TEXT IS 'Usuario que realizo la ultima modificacion del registro') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (version_registro      TEXT IS 'Version del registro para control de concurrencia optimista') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (estado_registro       TEXT IS 'Estado del registro de autorizacion: A=Activo I=Inactivo') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (created_at            TEXT IS 'Marca de tiempo de creacion del registro') ;
LABEL ON COLUMN HNEACOSTA1/USERS
    (updated_at            TEXT IS 'Marca de tiempo de la ultima modificacion del registro') ;

-- =============================================================================
-- Indices de soporte
-- =============================================================================
-- Indice por usuario para consulta rapida de todos sus accesos
CREATE INDEX HNEACOSTA1/IDX_USERS_USR ON HNEACOSTA1/USERS (codigo_usuario, estado_registro);

-- Indice por menu para reportes de autorizaciones por modulo
CREATE INDEX HNEACOSTA1/IDX_USERS_MNU ON HNEACOSTA1/USERS (menu, opcion);

-- Indice por fecha de creacion para auditorias cronologicas
CREATE INDEX HNEACOSTA1/IDX_USERS_CRT ON TALLERLIB/USERS (created_at);

-- =============================================================================
-- Fin de script: USERS
-- =============================================================================