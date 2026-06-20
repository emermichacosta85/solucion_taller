-- =============================================================================
-- Nombre de la Tabla:   CUMSD
-- DESCRIPCION:          Archivo de indice de busqueda de Clientes por cadena
--                       de caracteres (string).
-- Objetivo:             Facilitar la busqueda rapida de clientes mediante
--                       algoritmos de coincidencia por nombre o identificacion.
-- Tipo de Tabla:        Indice / Auxiliar
-- Origen de los Datos:  Derivado de CUMST al crear/modificar clientes
-- Permanencia de Datos: Permanente, se sincroniza con CUMST
-- Uso de los datos:     Busqueda de clientes en pantallas y consultas
-- Restricciones:        FK a CUMST por id_cliente
-- -----------------------------------------------------------------------------
-- Hecho por:            Equipo Taller IBM i
-- Fecha:                2025-06-11
-- Proyecto:             Taller IBM i - Sistema Bancario IBS
-- =============================================================================
 
CREATE OR REPLACE TABLE CUMSD (
    id_cliente           FOR COLUMN IDCLI VARCHAR(30)        NOT NULL,
    tipo_persona         FOR COLUMN TPPERS    VARCHAR(20)    NOT NULL DEFAULT '',
    tipo_identificacion  FOR COLUMN TPIDEN    VARCHAR(20)    NOT NULL DEFAULT '',
    numero_identificacion FOR COLUMN NRIDEN    VARCHAR(30)   NOT NULL DEFAULT '',
    nombres              FOR COLUMN NMBRES    VARCHAR(80)       NOT NULL DEFAULT '',
    apellidos            FOR COLUMN APLLDO    VARCHAR(80)       NOT NULL DEFAULT '',
    razon_social         FOR COLUMN RZSOCL VARCHAR(80)      NOT NULL DEFAULT '',
    fecha_nacimiento     FOR COLUMN FCNACM DATE                       DEFAULT NULL,
    direccion            FOR COLUMN DIRECN    VARCHAR(120)  NOT NULL DEFAULT '',
    email                FOR COLUMN EMADDR    VARCHAR(80)   NOT NULL DEFAULT '',
    telefono             FOR COLUMN TELFNO    VARCHAR(80)   NOT NULL DEFAULT '',
    pais_residencia      FOR COLUMN PAISRS    VARCHAR(50)   NOT NULL DEFAULT '',
    usuario_creacion     FOR COLUMN USRCRE    VARCHAR(30)   NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT VARCHAR(30)      NOT NULL DEFAULT '',
    version_registro     FOR COLUMN VRSNRG INT               NOT NULL DEFAULT 1,
    observaciones        FOR COLUMN OBSERVA   VARCHAR(120)     NOT NULL DEFAULT '',
    estado_registro      FOR COLUMN ESTADRG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at           FOR COLUMN CRTDAT    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           FOR COLUMN UPDDAT    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT CUMSD_PK PRIMARY KEY (id_cliente)
    --CONSTRAINT CUMSD_FK_CUMST FOREIGN KEY (id_cliente)
    --    REFERENCES CUMST (id_cliente)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT CUMSDR;
 
RENAME TABLE CUMSD TO CUMSD_TABLE FOR SYSTEM NAME CUMSD;
 
COMMENT ON TABLE CUMSD IS
    'Indice de busqueda de clientes por cadena de caracteres - Modulo Clientes';
 
LABEL ON TABLE CUMSD IS
    'Indice Busqueda Clientes';
 
COMMENT ON COLUMN CUMSD.id_cliente            IS 'Identificador unico del cliente (FK a CUMST)';
COMMENT ON COLUMN CUMSD.tipo_persona          IS 'Tipo de persona: Natural o Juridica';
COMMENT ON COLUMN CUMSD.tipo_identificacion   IS 'Tipo de documento de identificacion';
COMMENT ON COLUMN CUMSD.numero_identificacion IS 'Numero de documento de identificacion';
COMMENT ON COLUMN CUMSD.nombres               IS 'Nombres indexados para busqueda';
COMMENT ON COLUMN CUMSD.apellidos             IS 'Apellidos indexados para busqueda';
COMMENT ON COLUMN CUMSD.razon_social          IS 'Razon social indexada para busqueda';
COMMENT ON COLUMN CUMSD.fecha_nacimiento      IS 'Fecha de nacimiento del cliente';
COMMENT ON COLUMN CUMSD.direccion             IS 'Direccion del cliente';
COMMENT ON COLUMN CUMSD.email                 IS 'Correo electronico del cliente';
COMMENT ON COLUMN CUMSD.telefono              IS 'Telefono del cliente';
COMMENT ON COLUMN CUMSD.pais_residencia       IS 'Pais de residencia del cliente';
COMMENT ON COLUMN CUMSD.usuario_creacion      IS 'Usuario que creo el registro';
COMMENT ON COLUMN CUMSD.usuario_actualizacion IS 'Usuario que realizo la ultima actualizacion';
COMMENT ON COLUMN CUMSD.version_registro      IS 'Version del registro para control de concurrencia';
COMMENT ON COLUMN CUMSD.observaciones         IS 'Observaciones o notas adicionales';
COMMENT ON COLUMN CUMSD.estado_registro       IS 'Estado del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CUMSD.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN CUMSD.updated_at            IS 'Fecha y hora de la ultima actualizacion';
 
LABEL ON COLUMN CUMSD (
    id_cliente            TEXT IS 'ID Cliente',
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
 
LABEL ON COLUMN CUMSD (
    id_cliente            IS 'IDCLI',
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
 
CREATE INDEX IDX_CUMSD_CRD ON CUMSD (created_at);
