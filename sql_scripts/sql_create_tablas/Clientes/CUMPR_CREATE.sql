-- =============================================================================
-- Nombre de la Tabla:   CUMPR
-- DESCRIPCION:          Archivo Maestro de Palabras Reservadas que se omiten
--                       en la busqueda de clientes por cadena de caracteres.
-- Objetivo:             Excluir palabras genericas (SA, DE, EL, etc.) de los
--                       algoritmos de busqueda de clientes por nombre.
-- Tipo de Tabla:        Catalogo
-- Origen de los Datos:  Configuracion del sistema por administradores
-- Permanencia de Datos: Permanente
-- Uso de los datos:     Motor de busqueda de clientes por string
-- Restricciones:        Clave unica por palabra
-- -----------------------------------------------------------------------------
-- Hecho por:            Equipo Taller IBM i
-- Fecha:                2025-06-11
-- Proyecto:             Taller IBM i - Sistema Bancario IBS
-- =============================================================================
 
CREATE OR REPLACE TABLE CUMPR (
    palabra              FOR COLUMN PALABR VARCHAR(50)       NOT NULL,
    tipo_persona         FOR COLUMN TPPERS    VARCHAR(20)       NOT NULL DEFAULT '',
    tipo_identificacion  FOR COLUMN TPIDEN    VARCHAR(20)       NOT NULL DEFAULT '',
    numero_identificacion FOR COLUMN NRIDEN    VARCHAR(30)      NOT NULL DEFAULT '',
    nombres              FOR COLUMN NMBRES    VARCHAR(80)       NOT NULL DEFAULT '',
    apellidos            FOR COLUMN APLLDO    VARCHAR(80)       NOT NULL DEFAULT '',
    razon_social         FOR COLUMN RZSOCL    VARCHAR(80)       NOT NULL DEFAULT '',
    fecha_nacimiento     FOR COLUMN FCNACM    DATE              DEFAULT NULL,
    direccion            FOR COLUMN DIRECN    VARCHAR(120)      NOT NULL DEFAULT '',
    email                FOR COLUMN EMADDR    VARCHAR(80)       NOT NULL DEFAULT '',
    telefono             FOR COLUMN TELFNO    VARCHAR(80)       NOT NULL DEFAULT '',
    pais_residencia      FOR COLUMN PAISRS    VARCHAR(50)       NOT NULL DEFAULT '',
    usuario_creacion     FOR COLUMN USRCRE    VARCHAR(30)       NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT    VARCHAR(30)      NOT NULL DEFAULT '',
    version_registro     FOR COLUMN VRSNRG    INT              NOT NULL DEFAULT 1,
    observaciones        FOR COLUMN OBSERVA   VARCHAR(120)  NOT NULL DEFAULT '',
    estado_registro      FOR COLUMN ESTADRG CHAR(1)          NOT NULL DEFAULT 'A',
    created_at           FOR COLUMN CRTDAT TIMESTAMP         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           FOR COLUMN UPDDAT    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMPR_PK PRIMARY KEY (palabra)
)
RCDFMT CUMPRR;
 
RENAME TABLE CUMPR TO CUMPR_TABLE FOR SYSTEM NAME CUMPR;
 
COMMENT ON TABLE CUMPR IS
    'Palabras Reservadas excluidas en busqueda de clientes - Modulo Clientes';
 
LABEL ON TABLE CUMPR IS
    'Palabras Reservadas Busqueda';
 
COMMENT ON COLUMN CUMPR.palabra               IS 'Palabra reservada a excluir de la busqueda';
COMMENT ON COLUMN CUMPR.tipo_persona          IS 'Tipo de persona asociada a la palabra';
COMMENT ON COLUMN CUMPR.tipo_identificacion   IS 'Tipo de identificacion relacionada';
COMMENT ON COLUMN CUMPR.numero_identificacion IS 'Numero de identificacion relacionado';
COMMENT ON COLUMN CUMPR.nombres               IS 'Nombres de referencia asociados';
COMMENT ON COLUMN CUMPR.apellidos             IS 'Apellidos de referencia asociados';
COMMENT ON COLUMN CUMPR.razon_social          IS 'Razon social de referencia';
COMMENT ON COLUMN CUMPR.fecha_nacimiento      IS 'Fecha de nacimiento de referencia';
COMMENT ON COLUMN CUMPR.direccion             IS 'Direccion de referencia';
COMMENT ON COLUMN CUMPR.email                 IS 'Correo electronico de referencia';
COMMENT ON COLUMN CUMPR.telefono              IS 'Telefono de referencia';
COMMENT ON COLUMN CUMPR.pais_residencia       IS 'Pais de referencia';
COMMENT ON COLUMN CUMPR.usuario_creacion      IS 'Usuario que creo el registro';
COMMENT ON COLUMN CUMPR.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN CUMPR.version_registro      IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN CUMPR.observaciones         IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN CUMPR.estado_registro       IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CUMPR.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN CUMPR.updated_at            IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN CUMPR (
    palabra               TEXT IS 'Palabra Reservada',
    tipo_persona          TEXT IS 'Tipo Persona',
    tipo_identificacion   TEXT IS 'Tipo Identificacion',
    numero_identificacion TEXT IS 'Num. Identificacion',
    nombres               TEXT IS 'Nombres',
    apellidos             TEXT IS 'Apellidos',
    razon_social          TEXT IS 'Razon Social',
    fecha_nacimiento      TEXT IS 'Fecha Nacimiento',
    direccion             TEXT IS 'Direccion',
    email                 TEXT IS 'Email',
    telefono              TEXT IS 'Telefono',
    pais_residencia       TEXT IS 'Pais Residencia',
    usuario_creacion      TEXT IS 'Usuario Creacion',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro      TEXT IS 'Version Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);
 
LABEL ON COLUMN CUMPR (
    palabra               IS 'PALABR',
    tipo_persona          IS 'TPPERS',
    tipo_identificacion   IS 'TPIDEN',
    numero_identificacion IS 'NRIDEN',
    nombres               IS 'NMBRES',
    apellidos             IS 'APLLDO',
    razon_social          IS 'RZSOCL',
    fecha_nacimiento      IS 'FCNACM',
    direccion             IS 'DIRECN',
    email                 IS 'EMADDR',
    telefono              IS 'TELFNO',
    pais_residencia       IS 'PAISRS',
    usuario_creacion      IS 'USRCRE',
    usuario_actualizacion IS 'USRACT',
    version_registro      IS 'VRSNRG',
    observaciones         IS 'OBSERVA',
    estado_registro       IS 'ESTADRG',
    created_at            IS 'CRTDAT',
    updated_at            IS 'UPDDAT'
);
 
CREATE INDEX IDX_CUMPR_CRD ON CUMPR (created_at);
