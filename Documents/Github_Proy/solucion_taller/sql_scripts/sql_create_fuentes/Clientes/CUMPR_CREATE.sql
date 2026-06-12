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
 
CREATE OR REPLACE TABLE HNEACOSTA1/CUMPR (
    palabra              VARCHAR(50)   FOR COLUMN PALABR    NOT NULL,
    tipo_persona         VARCHAR(20)   FOR COLUMN TPPERS    NOT NULL DEFAULT '',
    tipo_identificacion  VARCHAR(20)   FOR COLUMN TPIDEN    NOT NULL DEFAULT '',
    numero_identificacion VARCHAR(30)  FOR COLUMN NRIDEN    NOT NULL DEFAULT '',
    nombres              VARCHAR(80)   FOR COLUMN NMBRES    NOT NULL DEFAULT '',
    apellidos            VARCHAR(80)   FOR COLUMN APLLDO    NOT NULL DEFAULT '',
    razon_social         VARCHAR(80)   FOR COLUMN RZSOCL    NOT NULL DEFAULT '',
    fecha_nacimiento     DATE          FOR COLUMN FCNACM             DEFAULT NULL,
    direccion            VARCHAR(120)  FOR COLUMN DIRECN    NOT NULL DEFAULT '',
    email                VARCHAR(80)   FOR COLUMN EMADDR    NOT NULL DEFAULT '',
    telefono             VARCHAR(80)   FOR COLUMN TELFNO    NOT NULL DEFAULT '',
    pais_residencia      VARCHAR(50)   FOR COLUMN PAISRS    NOT NULL DEFAULT '',
    usuario_creacion     VARCHAR(30)   FOR COLUMN USRCRE    NOT NULL DEFAULT '',
    usuario_actualizacion VARCHAR(30)  FOR COLUMN USRACT    NOT NULL DEFAULT '',
    version_registro     INT           FOR COLUMN VRSNRG    NOT NULL DEFAULT 1,
    observaciones        VARCHAR(120)  FOR COLUMN OBSERVA   NOT NULL DEFAULT '',
    estado_registro      CHAR(1)       FOR COLUMN ESTADRG   NOT NULL DEFAULT 'A',
    created_at           TIMESTAMP     FOR COLUMN CRTDAT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           TIMESTAMP     FOR COLUMN UPDDAT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMPR_PK PRIMARY KEY (palabra)
)
RCDFMT CUMPRR;
 
RENAME TABLE HNEACOSTA1/CUMPR TO CUMPR FOR SYSTEM NAME CUMPR;
 
COMMENT ON TABLE HNEACOSTA1/CUMPR IS
    'Palabras Reservadas excluidas en busqueda de clientes - Modulo Clientes';
 
LABEL ON TABLE HNEACOSTA1/CUMPR IS
    'Palabras Reservadas Busqueda';
 
COMMENT ON COLUMN HNEACOSTA1/CUMPR.palabra               IS 'Palabra reservada a excluir de la busqueda';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.tipo_persona          IS 'Tipo de persona asociada a la palabra';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.tipo_identificacion   IS 'Tipo de identificacion relacionada';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.numero_identificacion IS 'Numero de identificacion relacionado';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.nombres               IS 'Nombres de referencia asociados';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.apellidos             IS 'Apellidos de referencia asociados';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.razon_social          IS 'Razon social de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.fecha_nacimiento      IS 'Fecha de nacimiento de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.direccion             IS 'Direccion de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.email                 IS 'Correo electronico de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.telefono              IS 'Telefono de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.pais_residencia       IS 'Pais de referencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.usuario_creacion      IS 'Usuario que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.version_registro      IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.observaciones         IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.estado_registro       IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CUMPR.updated_at            IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN HNEACOSTA1/CUMPR (
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
 
LABEL ON COLUMN HNEACOSTA1/CUMPR (
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
 
CREATE INDEX HNEACOSTA1/IDX_CUMPR_CRD ON HNEACOSTA1/CUMPR (created_at);
