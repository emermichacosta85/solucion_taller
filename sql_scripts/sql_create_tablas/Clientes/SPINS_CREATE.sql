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
 
CREATE OR REPLACE TABLE SPINS (
    tipo_informacion     FOR COLUMN TPINFO VARCHAR(50)       NOT NULL,
    cuenta_o_cliente     FOR COLUMN CTACLI VARCHAR(50)       NOT NULL,
    secuencia            FOR COLUMN SECUENC INT  NOT NULL DEFAULT 1,
    tipo_persona         FOR COLUMN TPPERS    VARCHAR(20)    NOT NULL DEFAULT '',
    tipo_identificacion  FOR COLUMN TPIDEN    VARCHAR(20)    NOT NULL DEFAULT '',
    numero_identificacion FOR COLUMN NRIDEN    VARCHAR(30)   NOT NULL DEFAULT '',
    nombres              FOR COLUMN NMBRES    VARCHAR(80)       NOT NULL DEFAULT '',
    apellidos            FOR COLUMN APLLDO    VARCHAR(80)       NOT NULL DEFAULT '',
    razon_social         FOR COLUMN RZSOCL    VARCHAR(80)    NOT NULL DEFAULT '',
    fecha_nacimiento     FOR COLUMN FCNACM    DATE         DEFAULT NULL,
    direccion            FOR COLUMN DIRECN    VARCHAR(120)   NOT NULL DEFAULT '',
    email                FOR COLUMN EMADDR    VARCHAR(80)    NOT NULL DEFAULT '',
    telefono             FOR COLUMN TELFNO    VARCHAR(80)    NOT NULL DEFAULT '',
    pais_residencia      FOR COLUMN PAISRS    VARCHAR(50)    NOT NULL DEFAULT '',
    usuario_creacion     FOR COLUMN USRCRE    VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT  VARCHAR(30)  NOT NULL DEFAULT '',
    version_registro     FOR COLUMN VRSNRG    INT            NOT NULL DEFAULT 1,
    observaciones        FOR COLUMN OBSERVA   VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro      FOR COLUMN ESTADRG CHAR(1)          NOT NULL DEFAULT 'A',
    created_at           FOR COLUMN CRTDAT  TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           FOR COLUMN UPDDAT    TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT SPINS_PK PRIMARY KEY (tipo_informacion, cuenta_o_cliente, secuencia)
)
RCDFMT SPINSR;
 
RENAME TABLE SPINS TO SPINS_TABLE FOR SYSTEM NAME SPINS;
 
COMMENT ON TABLE SPINS IS
    'Instrucciones Especiales para cuentas y clientes - Modulo Clientes';
 
LABEL ON TABLE SPINS IS
    'Instrucciones Especiales';
 
COMMENT ON COLUMN SPINS.tipo_informacion      IS 'Tipo de instruccion especial a aplicar';
COMMENT ON COLUMN SPINS.cuenta_o_cliente      IS 'Numero de cuenta o cliente al que aplica la instruccion';
COMMENT ON COLUMN SPINS.secuencia             IS 'Numero de secuencia de la instruccion';
COMMENT ON COLUMN SPINS.tipo_persona          IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN SPINS.tipo_identificacion   IS 'Tipo de identificacion relacionada';
COMMENT ON COLUMN SPINS.numero_identificacion IS 'Numero de identificacion relacionado';
COMMENT ON COLUMN SPINS.nombres               IS 'Nombres del cliente relacionado';
COMMENT ON COLUMN SPINS.apellidos             IS 'Apellidos del cliente relacionado';
COMMENT ON COLUMN SPINS.razon_social          IS 'Razon social de la empresa relacionada';
COMMENT ON COLUMN SPINS.fecha_nacimiento      IS 'Fecha de nacimiento de referencia';
COMMENT ON COLUMN SPINS.direccion             IS 'Direccion de referencia';
COMMENT ON COLUMN SPINS.email                 IS 'Correo electronico de referencia';
COMMENT ON COLUMN SPINS.telefono              IS 'Telefono de referencia';
COMMENT ON COLUMN SPINS.pais_residencia       IS 'Pais de referencia';
COMMENT ON COLUMN SPINS.usuario_creacion      IS 'Usuario que creo el registro';
COMMENT ON COLUMN SPINS.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN SPINS.version_registro      IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN SPINS.observaciones         IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN SPINS.estado_registro       IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN SPINS.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN SPINS.updated_at            IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN SPINS (
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
 
LABEL ON COLUMN SPINS (
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
 
CREATE INDEX IDX_SPINS_CRD ON SPINS (created_at);
 
-- FIN MODULO 02 CLIENTES
