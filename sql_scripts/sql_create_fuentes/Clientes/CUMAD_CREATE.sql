-- =============================================================================
-- Nombre de la Tabla:   CUMAD
-- DESCRIPCION:          Archivo de Direcciones de Correo y Beneficiarios de
--                       Operaciones y Clientes.
-- Objetivo:             Almacenar multiples direcciones y datos de beneficiarios
--                       asociados a un cliente u operacion.
-- Tipo de Tabla:        Detalle
-- Origen de los Datos:  Relacionado a clientes y operaciones en CUMST/ACMST
-- Permanencia de Datos: Permanente
-- Uso de los datos:     Notificaciones, pagos a beneficiarios, correspondencia
-- Restricciones:        FK a CUMST por id_cliente_operacion cuando tipo = cliente
-- -----------------------------------------------------------------------------
-- Hecho por:            Equipo Taller IBM i
-- Fecha:                2025-06-11
-- Proyecto:             Taller IBM i - Sistema Bancario IBS
-- =============================================================================
 
CREATE OR REPLACE TABLE CUMAD (
    id_cliente_operacion FOR COLUMN IDCLIOP VARCHAR(30)      NOT NULL,
    tipo_registro        FOR COLUMN TPREG   VARCHAR(20)      NOT NULL,
    secuencia            FOR COLUMN SECUENC INT              NOT NULL DEFAULT 1,
    tipo_persona         FOR COLUMN TPPERS VARCHAR(20)       NOT NULL DEFAULT '',
    tipo_identificacion  FOR COLUMN TPIDEN VARCHAR(20)       NOT NULL DEFAULT '',
    numero_identificacion FOR COLUMN NRIDEN VARCHAR(30)      NOT NULL DEFAULT '',
    nombres              FOR COLUMN NMBRES VARCHAR(80)       NOT NULL DEFAULT '',
    apellidos            FOR COLUMN APLLDO VARCHAR(80)       NOT NULL DEFAULT '',
    razon_social         FOR COLUMN RZSOCL VARCHAR(80)       NOT NULL DEFAULT '',
    fecha_nacimiento     FOR COLUMN FCNACM DATE              DEFAULT NULL,
    direccion            FOR COLUMN DIRECN VARCHAR(120)      NOT NULL DEFAULT '',
    email                FOR COLUMN EMADDR VARCHAR(80)       NOT NULL DEFAULT '',
    telefono             FOR COLUMN TELFNO VARCHAR(80)       NOT NULL DEFAULT '',
    pais_residencia      FOR COLUMN PAISRS VARCHAR(50)       NOT NULL DEFAULT '',
    usuario_creacion     FOR COLUMN USRCRE VARCHAR(30)       NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT VARCHAR(30)      NOT NULL DEFAULT '',
    version_registro     FOR COLUMN VRSNRG INT              NOT NULL DEFAULT 1,
    observaciones        FOR COLUMN OBSERVA VARCHAR(120)  NOT NULL DEFAULT '',
    estado_registro      FOR COLUMN ESTADRG CHAR(1)       NOT NULL DEFAULT 'A',
    created_at           FOR COLUMN CRTDAT  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           FOR COLUMN UPDDAT  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMAD_PK PRIMARY KEY (id_cliente_operacion, tipo_registro, secuencia)
)
RCDFMT CUMADR;
 
RENAME TABLE CUMAD TO CUMAD_TABLE FOR SYSTEM NAME CUMAD;
 
COMMENT ON TABLE CUMAD IS
    'Direcciones de Correo y Beneficiarios de Operaciones/Clientes - Modulo Clientes';
 
LABEL ON TABLE CUMAD IS
    'Direcciones y Beneficiarios';
 
COMMENT ON COLUMN CUMAD.id_cliente_operacion  IS 'Numero del cliente u operacion asociada';
COMMENT ON COLUMN CUMAD.tipo_registro          IS 'Tipo de registro: DIR=Direccion, BEN=Beneficiario';
COMMENT ON COLUMN CUMAD.secuencia              IS 'Numero de secuencia del registro';
COMMENT ON COLUMN CUMAD.tipo_persona           IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN CUMAD.tipo_identificacion    IS 'Tipo de documento de identificacion';
COMMENT ON COLUMN CUMAD.numero_identificacion  IS 'Numero de documento de identificacion';
COMMENT ON COLUMN CUMAD.nombres                IS 'Nombres del beneficiario persona natural';
COMMENT ON COLUMN CUMAD.apellidos              IS 'Apellidos del beneficiario persona natural';
COMMENT ON COLUMN CUMAD.razon_social           IS 'Razon social del beneficiario persona juridica';
COMMENT ON COLUMN CUMAD.fecha_nacimiento       IS 'Fecha de nacimiento del beneficiario';
COMMENT ON COLUMN CUMAD.direccion              IS 'Direccion postal o de notificacion';
COMMENT ON COLUMN CUMAD.email                  IS 'Correo electronico de contacto';
COMMENT ON COLUMN CUMAD.telefono               IS 'Telefono de contacto';
COMMENT ON COLUMN CUMAD.pais_residencia        IS 'Pais de residencia del beneficiario';
COMMENT ON COLUMN CUMAD.usuario_creacion       IS 'Usuario que creo el registro';
COMMENT ON COLUMN CUMAD.usuario_actualizacion  IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN CUMAD.version_registro       IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN CUMAD.observaciones          IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN CUMAD.estado_registro        IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CUMAD.created_at             IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN CUMAD.updated_at             IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN CUMAD (
    id_cliente_operacion  TEXT IS 'ID Cliente/Operacion',
    tipo_registro         TEXT IS 'Tipo Registro',
    secuencia             TEXT IS 'Secuencia',
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
 
LABEL ON COLUMN CUMAD (
    id_cliente_operacion  IS 'IDCLIOP',
    tipo_registro         IS 'TPREG',
    secuencia             IS 'SECUENC',
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
 
CREATE INDEX IDX_CUMAD_CRD ON CUMAD (created_at);
