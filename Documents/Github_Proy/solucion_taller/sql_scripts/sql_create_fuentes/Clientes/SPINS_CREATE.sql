-- =============================================================================
-- Nombre de la Tabla:   SPINS
-- DESCRIPCION:          Archivo de Instrucciones Especiales asociadas a clientes
--                       o cuentas (Usos).
-- Objetivo:             Almacenar instrucciones particulares que deben aplicarse
--                       al operar determinadas cuentas o clientes.
-- Tipo de Tabla:        Detalle / Instrucciones
-- Origen de los Datos:  Parametrizado por operadores o gerentes de cuenta
-- Permanencia de Datos: Permanente
-- Uso de los datos:     Aplicacion de instrucciones en transacciones y consultas
-- Restricciones:        cuenta_o_cliente referencia a CUMST o ACMST segun tipo
-- -----------------------------------------------------------------------------
-- Hecho por:            Equipo Taller IBM i
-- Fecha:                2025-06-11
-- Proyecto:             Taller IBM i - Sistema Bancario IBS
-- =============================================================================
 
CREATE OR REPLACE TABLE HNEACOSTA1/SPINS (
    tipo_informacion     VARCHAR(50)   FOR COLUMN TPINFO    NOT NULL,
    cuenta_o_cliente     VARCHAR(50)   FOR COLUMN CTACLI    NOT NULL,
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
    CONSTRAINT SPINS_PK PRIMARY KEY (tipo_informacion, cuenta_o_cliente, secuencia)
)
RCDFMT SPINSR;
 
RENAME TABLE HNEACOSTA1/SPINS TO SPINS FOR SYSTEM NAME SPINS;
 
COMMENT ON TABLE HNEACOSTA1/SPINS IS
    'Instrucciones Especiales para cuentas y clientes - Modulo Clientes';
 
LABEL ON TABLE HNEACOSTA1/SPINS IS
    'Instrucciones Especiales';
 
COMMENT ON COLUMN HNEACOSTA1/SPINS.tipo_informacion      IS 'Tipo de instruccion especial a aplicar';
COMMENT ON COLUMN HNEACOSTA1/SPINS.cuenta_o_cliente      IS 'Numero de cuenta o cliente al que aplica la instruccion';
COMMENT ON COLUMN HNEACOSTA1/SPINS.secuencia             IS 'Numero de secuencia de la instruccion';
COMMENT ON COLUMN HNEACOSTA1/SPINS.tipo_persona          IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN HNEACOSTA1/SPINS.tipo_identificacion   IS 'Tipo de identificacion relacionada';
COMMENT ON COLUMN HNEACOSTA1/SPINS.numero_identificacion IS 'Numero de identificacion relacionado';
COMMENT ON COLUMN HNEACOSTA1/SPINS.nombres               IS 'Nombres del cliente relacionado';
COMMENT ON COLUMN HNEACOSTA1/SPINS.apellidos             IS 'Apellidos del cliente relacionado';
COMMENT ON COLUMN HNEACOSTA1/SPINS.razon_social          IS 'Razon social de la empresa relacionada';
COMMENT ON COLUMN HNEACOSTA1/SPINS.fecha_nacimiento      IS 'Fecha de nacimiento de referencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.direccion             IS 'Direccion de referencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.email                 IS 'Correo electronico de referencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.telefono              IS 'Telefono de referencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.pais_residencia       IS 'Pais de referencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.usuario_creacion      IS 'Usuario que creo el registro';
COMMENT ON COLUMN HNEACOSTA1/SPINS.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN HNEACOSTA1/SPINS.version_registro      IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN HNEACOSTA1/SPINS.observaciones         IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN HNEACOSTA1/SPINS.estado_registro       IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/SPINS.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/SPINS.updated_at            IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN HNEACOSTA1/SPINS (
    tipo_informacion      TEXT IS 'Tipo Informacion',
    cuenta_o_cliente      TEXT IS 'Cuenta o Cliente',
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
 
LABEL ON COLUMN HNEACOSTA1/SPINS (
    tipo_informacion      IS 'TPINFO',
    cuenta_o_cliente      IS 'CTACLI',
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
 
CREATE INDEX HNEACOSTA1/IDX_SPINS_CRD ON HNEACOSTA1/SPINS (created_at);
 
-- FIN MODULO 02 CLIENTES
