-- ==============================================================================
-- Nombre de la Tabla  : CNOFC
-- DESCRIPCION         : Archivo de Referencias del Sistema o de Datos Comunes.
--                       Contiene los registros de detalle de cada tabla de
--                       codigos del sistema, referenciados por el maestro
--                       CNOFT a traves de codigo_tabla.
-- Objetivo            : Almacenar los valores individuales de cada tabla de
--                       codigos del sistema, permitiendo la parametrizacion
--                       centralizada de dominios, listas de valores y
--                       referencias cruzadas del sistema IBS.
-- Tipo de Tabla       : Detalle de Catalogo
-- Origen de los Datos : Parametrizacion inicial y mantenimiento por
--                       administrador del sistema
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Modulo Archivos Comunes - detalle de catalogos del
--                       sistema; tabla hija de CNOFT via codigo_tabla
-- Restricciones       : PK compuesta (codigo_tabla, codigo_registro);
--                       FK a CNOFT (codigo_tabla);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE CNOFC (
    codigo_tabla          FOR COLUMN CODTBL   VARCHAR(20)    NOT NULL,
    codigo_registro       FOR COLUMN CODREG   VARCHAR(20)    NOT NULL,
    descripcion           FOR COLUMN DESCRIP  VARCHAR(120)   NOT NULL DEFAULT '',
    valor_texto           FOR COLUMN VALTXT   VARCHAR(50)    NOT NULL DEFAULT '',
    valor_numerico        FOR COLUMN VALNUM   DECIMAL(18, 2),
    vigencia_desde        FOR COLUMN VIGDES   DATE,
    vigencia_hasta        FOR COLUMN VIGHST   DATE,
    orden_visualizacion   FOR COLUMN ORDVIS   INTEGER        NOT NULL DEFAULT 0,
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNOFC   PRIMARY KEY (codigo_tabla, codigo_registro),
    CONSTRAINT FK_CNOFC_CNOFT FOREIGN KEY (codigo_tabla)
        REFERENCES CNOFT (codigo_tabla)
)
RCDFMT CNOFCR;

RENAME TABLE CNOFC
    TO CNOFC_TABLE FOR SYSTEM NAME CNOFC;

COMMENT ON TABLE CNOFC IS
    'Referencias del Sistema - Detalle de Datos Comunes - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE CNOFC IS
    'Referencias Sistema Comunes';

COMMENT ON COLUMN CNOFC.codigo_tabla          IS 'Codigo de la tabla de datos comunes a la que pertenece el registro; FK a CNOFT; parte de la PK';
COMMENT ON COLUMN CNOFC.codigo_registro       IS 'Codigo unico del registro dentro de la tabla de datos comunes; parte de la PK';
COMMENT ON COLUMN CNOFC.descripcion           IS 'Descripcion funcional del valor o referencia del sistema';
COMMENT ON COLUMN CNOFC.valor_texto           IS 'Valor de texto asociado al registro de referencia';
COMMENT ON COLUMN CNOFC.valor_numerico        IS 'Valor numerico asociado al registro de referencia si aplica';
COMMENT ON COLUMN CNOFC.vigencia_desde        IS 'Fecha desde la cual el registro de referencia es vigente';
COMMENT ON COLUMN CNOFC.vigencia_hasta        IS 'Fecha hasta la cual el registro de referencia es vigente';
COMMENT ON COLUMN CNOFC.orden_visualizacion   IS 'Numero de orden para presentacion en pantallas y listas de valores';
COMMENT ON COLUMN CNOFC.usuario_creacion      IS 'Usuario del sistema que creo el registro de referencia';
COMMENT ON COLUMN CNOFC.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN CNOFC.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN CNOFC.observaciones         IS 'Notas adicionales sobre el registro de referencia';
COMMENT ON COLUMN CNOFC.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN CNOFC.created_at            IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN CNOFC.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN CNOFC (
    codigo_tabla          TEXT IS 'Codigo de Tabla',
    codigo_registro       TEXT IS 'Codigo de Registro',
    descripcion           TEXT IS 'Descripcion',
    valor_texto           TEXT IS 'Valor Texto',
    valor_numerico        TEXT IS 'Valor Numerico',
    vigencia_desde        TEXT IS 'Vigencia Desde',
    vigencia_hasta        TEXT IS 'Vigencia Hasta',
    orden_visualizacion   TEXT IS 'Orden Visualizacion',
    usuario_creacion      TEXT IS 'Usuario Creacion',
    usuario_actualizacion TEXT IS 'Usuario Actualizacion',
    version_registro      TEXT IS 'Version Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_CNOFC_C ON CNOFC (created_at);
