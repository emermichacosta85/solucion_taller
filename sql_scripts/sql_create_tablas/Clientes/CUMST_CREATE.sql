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
 
CREATE OR REPLACE TABLE CUMST (
    id_cliente          FOR COLUMN IDCLI VARCHAR(30)         NOT NULL,
    tipo_persona        FOR COLUMN TPPERS    VARCHAR(20)    NOT NULL DEFAULT '',
    tipo_identificacion FOR COLUMN TPIDEN    VARCHAR(20)    NOT NULL DEFAULT '',
    numero_identificacion FOR COLUMN NRIDEN    VARCHAR(30)   NOT NULL DEFAULT '',
    nombres             FOR COLUMN NMBRES    VARCHAR(80)       NOT NULL DEFAULT '',
    apellidos           FOR COLUMN APLLDO    VARCHAR(80)       NOT NULL DEFAULT '',
    razon_social        FOR COLUMN RZSOCL    VARCHAR(80)    NOT NULL DEFAULT '',
    fecha_nacimiento    FOR COLUMN FCNACM    DATE           DEFAULT NULL,
    direccion           FOR COLUMN DIRECN    VARCHAR(120)   NOT NULL DEFAULT '',
    email               FOR COLUMN EMADDR    VARCHAR(80)    NOT NULL DEFAULT '',
    telefono            FOR COLUMN TELFNO    VARCHAR(80)    NOT NULL DEFAULT '',
    pais_residencia     FOR COLUMN PAISRS    VARCHAR(50)    NOT NULL DEFAULT '',
    usuario_creacion    FOR COLUMN USRCRE    VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT  VARCHAR(30)  NOT NULL DEFAULT '',
    version_registro    FOR COLUMN VRSNRG    INT            NOT NULL DEFAULT 1,
    observaciones       FOR COLUMN OBSERVA   VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro     FOR COLUMN ESTADRG CHAR(1)           NOT NULL DEFAULT 'A',
    created_at          FOR COLUMN CRTDAT    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          FOR COLUMN UPDDAT    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMST_PK PRIMARY KEY (id_cliente)
)
RCDFMT CUMSTR;
 
RENAME TABLE CUMST TO CUMST_TABLE FOR SYSTEM NAME CUMST;
 
COMMENT ON TABLE CUMST IS
    'Archivo Maestro de Clientes - Modulo Clientes IBS';
 
LABEL ON TABLE CUMST IS
    'Maestro de Clientes';
 
COMMENT ON COLUMN CUMST.id_cliente          IS 'Identificador unico del cliente en el sistema';
COMMENT ON COLUMN CUMST.tipo_persona         IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN CUMST.tipo_identificacion  IS 'Tipo de documento de identificacion del cliente';
COMMENT ON COLUMN CUMST.numero_identificacion IS 'Numero del documento de identificacion';
COMMENT ON COLUMN CUMST.nombres              IS 'Nombres del cliente persona natural';
COMMENT ON COLUMN CUMST.apellidos            IS 'Apellidos del cliente persona natural';
COMMENT ON COLUMN CUMST.razon_social         IS 'Razon social del cliente persona juridica';
COMMENT ON COLUMN CUMST.fecha_nacimiento     IS 'Fecha de nacimiento o constitucion';
COMMENT ON COLUMN CUMST.direccion            IS 'Direccion de residencia o domicilio fiscal';
COMMENT ON COLUMN CUMST.email                IS 'Correo electronico de contacto';
COMMENT ON COLUMN CUMST.telefono             IS 'Numero de telefono de contacto';
COMMENT ON COLUMN CUMST.pais_residencia      IS 'Codigo del pais de residencia del cliente';
COMMENT ON COLUMN CUMST.usuario_creacion     IS 'Usuario que creo el registro';
COMMENT ON COLUMN CUMST.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN CUMST.version_registro     IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN CUMST.observaciones        IS 'Observaciones o notas adicionales del registro';
COMMENT ON COLUMN CUMST.estado_registro      IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CUMST.created_at           IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN CUMST.updated_at           IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN CUMST (
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
 
LABEL ON COLUMN CUMST (
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
 
CREATE INDEX IDX_CUMST_CRD ON CUMST (created_at);
