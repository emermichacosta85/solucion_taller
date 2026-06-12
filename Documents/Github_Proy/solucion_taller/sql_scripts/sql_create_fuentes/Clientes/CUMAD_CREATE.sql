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
 
CREATE OR REPLACE TABLE HNEACOSTA1/CUMAD (
    id_cliente_operacion VARCHAR(30)   FOR COLUMN IDCLIOP   NOT NULL,
    tipo_registro        VARCHAR(20)   FOR COLUMN TPREG     NOT NULL,
    secuencia            INT           FOR COLUMN SECUENC   NOT NULL DEFAULT 1,
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
    CONSTRAINT CUMAD_PK PRIMARY KEY (id_cliente_operacion, tipo_registro, secuencia)
)
RCDFMT CUMADR;
 
RENAME TABLE HNEACOSTA1/CUMAD TO CUMAD FOR SYSTEM NAME CUMAD;
 
COMMENT ON TABLE HNEACOSTA1/CUMAD IS
    'Direcciones de Correo y Beneficiarios de Operaciones/Clientes - Modulo Clientes';
 
LABEL ON TABLE HNEACOSTA1/CUMAD IS
    'Direcciones y Beneficiarios';
 
COMMENT ON COLUMN HNEACOSTA1/CUMAD.id_cliente_operacion  IS 'Numero del cliente u operacion asociada';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.tipo_registro          IS 'Tipo de registro: DIR=Direccion, BEN=Beneficiario';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.secuencia              IS 'Numero de secuencia del registro';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.tipo_persona           IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.tipo_identificacion    IS 'Tipo de documento de identificacion';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.numero_identificacion  IS 'Numero de documento de identificacion';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.nombres                IS 'Nombres del beneficiario persona natural';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.apellidos              IS 'Apellidos del beneficiario persona natural';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.razon_social           IS 'Razon social del beneficiario persona juridica';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.fecha_nacimiento       IS 'Fecha de nacimiento del beneficiario';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.direccion              IS 'Direccion postal o de notificacion';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.email                  IS 'Correo electronico de contacto';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.telefono               IS 'Telefono de contacto';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.pais_residencia        IS 'Pais de residencia del beneficiario';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.usuario_creacion       IS 'Usuario que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.usuario_actualizacion  IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.version_registro       IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.observaciones          IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.estado_registro        IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.created_at             IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CUMAD.updated_at             IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN HNEACOSTA1/CUMAD (
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
 
LABEL ON COLUMN HNEACOSTA1/CUMAD (
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
 
CREATE INDEX HNEACOSTA1/IDX_CUMAD_CRD ON HNEACOSTA1/CUMAD (created_at);
