-- =============================================================================
-- Nombre de la Tabla:   CUMST
-- DESCRIPCION:          Archivo Maestro de Clientes del sistema bancario IBS.
-- Objetivo:             Almacenar la informacion principal de cada cliente del banco,
--                       incluyendo identificacion, datos personales y estado.
-- Tipo de Tabla:        Maestra
-- Origen de los Datos:  Registro de clientes por operadores bancarios
-- Permanencia de Datos: Permanente
-- Uso de los datos:     Consulta y mantenimiento de clientes en todos los modulos
-- Restricciones:        id_cliente es clave unica e irrepetible
-- -----------------------------------------------------------------------------
-- Hecho por:            Equipo Taller IBM i
-- Fecha:                2025-06-11
-- Proyecto:             Taller IBM i - Sistema Bancario IBS
-- =============================================================================
 
CREATE OR REPLACE TABLE HNEACOSTA1/CUMST (
    id_cliente          VARCHAR(30)    FOR COLUMN IDCLI     NOT NULL,
    tipo_persona        VARCHAR(20)    FOR COLUMN TPPERS    NOT NULL DEFAULT '',
    tipo_identificacion VARCHAR(20)    FOR COLUMN TPIDEN    NOT NULL DEFAULT '',
    numero_identificacion VARCHAR(30)  FOR COLUMN NRIDEN    NOT NULL DEFAULT '',
    nombres             VARCHAR(80)    FOR COLUMN NMBRES    NOT NULL DEFAULT '',
    apellidos           VARCHAR(80)    FOR COLUMN APLLDO    NOT NULL DEFAULT '',
    razon_social        VARCHAR(80)    FOR COLUMN RZSOCL    NOT NULL DEFAULT '',
    fecha_nacimiento    DATE           FOR COLUMN FCNACM             DEFAULT NULL,
    direccion           VARCHAR(120)   FOR COLUMN DIRECN    NOT NULL DEFAULT '',
    email               VARCHAR(80)    FOR COLUMN EMADDR    NOT NULL DEFAULT '',
    telefono            VARCHAR(80)    FOR COLUMN TELFNO    NOT NULL DEFAULT '',
    pais_residencia     VARCHAR(50)    FOR COLUMN PAISRS    NOT NULL DEFAULT '',
    usuario_creacion    VARCHAR(30)    FOR COLUMN USRCRE    NOT NULL DEFAULT '',
    usuario_actualizacion VARCHAR(30)  FOR COLUMN USRACT    NOT NULL DEFAULT '',
    version_registro    INT            FOR COLUMN VRSNRG    NOT NULL DEFAULT 1,
    observaciones       VARCHAR(120)   FOR COLUMN OBSERVA   NOT NULL DEFAULT '',
    estado_registro     CHAR(1)        FOR COLUMN ESTADRG   NOT NULL DEFAULT 'A',
    created_at          TIMESTAMP      FOR COLUMN CRTDAT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP      FOR COLUMN UPDDAT    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMST_PK PRIMARY KEY (id_cliente)
)
RCDFMT CUMSTR;
 
RENAME TABLE HNEACOSTA1/CUMST TO CUMST FOR SYSTEM NAME CUMST;
 
COMMENT ON TABLE HNEACOSTA1/CUMST IS
    'Archivo Maestro de Clientes - Modulo Clientes IBS';
 
LABEL ON TABLE HNEACOSTA1/CUMST IS
    'Maestro de Clientes';
 
COMMENT ON COLUMN HNEACOSTA1/CUMST.id_cliente          IS 'Identificador unico del cliente en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CUMST.tipo_persona         IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN HNEACOSTA1/CUMST.tipo_identificacion  IS 'Tipo de documento de identificacion del cliente';
COMMENT ON COLUMN HNEACOSTA1/CUMST.numero_identificacion IS 'Numero del documento de identificacion';
COMMENT ON COLUMN HNEACOSTA1/CUMST.nombres              IS 'Nombres del cliente persona natural';
COMMENT ON COLUMN HNEACOSTA1/CUMST.apellidos            IS 'Apellidos del cliente persona natural';
COMMENT ON COLUMN HNEACOSTA1/CUMST.razon_social         IS 'Razon social del cliente persona juridica';
COMMENT ON COLUMN HNEACOSTA1/CUMST.fecha_nacimiento     IS 'Fecha de nacimiento o constitucion';
COMMENT ON COLUMN HNEACOSTA1/CUMST.direccion            IS 'Direccion de residencia o domicilio fiscal';
COMMENT ON COLUMN HNEACOSTA1/CUMST.email                IS 'Correo electronico de contacto';
COMMENT ON COLUMN HNEACOSTA1/CUMST.telefono             IS 'Numero de telefono de contacto';
COMMENT ON COLUMN HNEACOSTA1/CUMST.pais_residencia      IS 'Codigo del pais de residencia del cliente';
COMMENT ON COLUMN HNEACOSTA1/CUMST.usuario_creacion     IS 'Usuario que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/CUMST.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN HNEACOSTA1/CUMST.version_registro     IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN HNEACOSTA1/CUMST.observaciones        IS 'Observaciones o notas adicionales del registro';
COMMENT ON COLUMN HNEACOSTA1/CUMST.estado_registro      IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CUMST.created_at           IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CUMST.updated_at           IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN HNEACOSTA1/CUMST (
    id_cliente           TEXT IS 'ID Cliente',
    tipo_persona         TEXT IS 'Tipo Persona',
    tipo_identificacion  TEXT IS 'Tipo Ident.',
    numero_identificacion TEXT IS 'Num. Identificacion',
    nombres              TEXT IS 'Nombres',
    apellidos            TEXT IS 'Apellidos',
    razon_social         TEXT IS 'Razon Social',
    fecha_nacimiento     TEXT IS 'Fecha Nacimiento',
    direccion            TEXT IS 'Direccion',
    email                TEXT IS 'Email',
    telefono             TEXT IS 'Telefono',
    pais_residencia      TEXT IS 'Pais Residencia',
    usuario_creacion     TEXT IS 'Usuario Creacion',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro     TEXT IS 'Version Registro',
    observaciones        TEXT IS 'Observaciones',
    estado_registro      TEXT IS 'Estado Registro',
    created_at           TEXT IS 'Fecha Creacion',
    updated_at           TEXT IS 'Fecha Actualizacion'
);
 
LABEL ON COLUMN HNEACOSTA1/CUMST (
    id_cliente           IS 'IDCLI',
    tipo_persona         IS 'TPPERS',
    tipo_identificacion  IS 'TPIDEN',
    numero_identificacion IS 'NRIDEN',
    nombres              IS 'NMBRES',
    apellidos            IS 'APLLDO',
    razon_social         IS 'RZSOCL',
    fecha_nacimiento     IS 'FCNACM',
    direccion            IS 'DIRECN',
    email                IS 'EMADDR',
    telefono             IS 'TELFNO',
    pais_residencia      IS 'PAISRS',
    usuario_creacion     IS 'USRCRE',
    usuario_actualizacion IS 'USRACT',
    version_registro     IS 'VRSNRG',
    observaciones        IS 'OBSERVA',
    estado_registro      IS 'ESTADRG',
    created_at           IS 'CRTDAT',
    updated_at           IS 'UPDDAT'
);
 
CREATE INDEX HNEACOSTA1/IDX_CUMST_CRD ON HNEACOSTA1/CUMST (created_at);
