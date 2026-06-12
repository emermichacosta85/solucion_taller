-- ==============================================================================
-- Nombre de la Tabla  : DIMST
-- DESCRIPCION         : Maestro de Inventario de Documentos. Registra los
--                       documentos fisicos o digitales recopilados por tipo
--                       de cuenta u operacion, vinculados al catalogo de
--                       tipos de documentos (DITBL). Controla la recepcion,
--                       vencimiento y obligatoriedad de cada documento en
--                       el expediente del cliente u operacion.
-- Objetivo            : Mantener el inventario actualizado de documentos
--                       recibidos y pendientes por tipo de cuenta, permitiendo
--                       el seguimiento del cumplimiento documental requerido
--                       para cada operacion o producto bancario.
-- Tipo de Tabla       : Maestra Transaccional
-- Origen de los Datos : Ingreso por oficial de negocios o gestor documental
--                       al recepcionar documentos de clientes u operaciones
-- Permanencia de Datos: Permanente con historico; actualizacion por recepcion
--                       o vencimiento de documentos
-- Uso de los datos    : Modulo de Manejo de Documentos - control de expedientes,
--                       alertas de documentos vencidos o faltantes,
--                       auditoria documental
-- Restricciones       : PK compuesta (tipo_cuenta, numero_tabla, secuencia);
--                       FK a DITBL.numero_tabla (numero_tabla);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Manejo de Documentos
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DIMST (
    tipo_cuenta           FOR COLUMN TIPCTA   VARCHAR(20)    NOT NULL,
    numero_tabla          FOR COLUMN NUMTBL   VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
    tipo_documento        FOR COLUMN TIPDOC   VARCHAR(20)    NOT NULL DEFAULT '',
    descripcion_documento FOR COLUMN DESCDOC  VARCHAR(120)   NOT NULL DEFAULT '',
    obligatorio           FOR COLUMN OBLIG    CHAR(1)        NOT NULL DEFAULT 'N',
    fecha_recepcion       FOR COLUMN FECREC   DATE,
    fecha_vencimiento     FOR COLUMN FECVENC  DATE,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DIMST   PRIMARY KEY (tipo_cuenta, numero_tabla, secuencia),
    CONSTRAINT FK_DIMST_DITBL FOREIGN KEY (numero_tabla)
        REFERENCES HNEACOSTA1/DITBL (numero_tabla)
)
RCDFMT DIMSTR;

RENAME TABLE HNEACOSTA1/DIMST
    TO DIMST FOR SYSTEM NAME DIMST;

COMMENT ON TABLE HNEACOSTA1/DIMST IS
    'Maestro de Inventario de Documentos - Modulo 14 Manejo de Documentos Taller IBM i';

LABEL ON TABLE HNEACOSTA1/DIMST IS
    'Inventario de Documentos';

COMMENT ON COLUMN HNEACOSTA1/DIMST.tipo_cuenta           IS 'Tipo de cuenta u operacion a la que pertenece el documento inventariado; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/DIMST.numero_tabla          IS 'Numero de tabla de tipos de documentos; FK a DITBL.numero_tabla; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/DIMST.secuencia             IS 'Numero de secuencia del documento dentro del inventario por tipo de cuenta; parte de la PK';
COMMENT ON COLUMN HNEACOSTA1/DIMST.tipo_documento        IS 'Codigo del tipo de documento recibido segun catalogo (IDENTIDAD, CONTRATO, etc.)';
COMMENT ON COLUMN HNEACOSTA1/DIMST.descripcion_documento IS 'Descripcion del documento especifico recibido para el expediente';
COMMENT ON COLUMN HNEACOSTA1/DIMST.obligatorio           IS 'Indica si el documento es obligatorio para esta operacion: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/DIMST.fecha_recepcion       IS 'Fecha en que se recibio fisicamente el documento del cliente';
COMMENT ON COLUMN HNEACOSTA1/DIMST.fecha_vencimiento     IS 'Fecha de vencimiento o expiracion del documento recibido';
COMMENT ON COLUMN HNEACOSTA1/DIMST.observaciones         IS 'Notas del gestor documental sobre el estado o condicion del documento';
COMMENT ON COLUMN HNEACOSTA1/DIMST.usuario_creacion      IS 'Usuario del sistema que registro el documento en el inventario';
COMMENT ON COLUMN HNEACOSTA1/DIMST.usuario_actualizacion IS 'Usuario del sistema que realizo la ultima modificacion al registro';
COMMENT ON COLUMN HNEACOSTA1/DIMST.version_registro      IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DIMST.estado_registro       IS 'Estado logico del documento en el inventario: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/DIMST.created_at            IS 'Fecha y hora exacta de creacion del registro en la base de datos';
COMMENT ON COLUMN HNEACOSTA1/DIMST.updated_at            IS 'Fecha y hora de la ultima actualizacion registrada en la base de datos';

LABEL ON COLUMN HNEACOSTA1/DIMST (
    tipo_cuenta           TEXT IS 'Tipo de Cuenta',
    numero_tabla          TEXT IS 'Numero de Tabla',
    secuencia             TEXT IS 'Secuencia',
    tipo_documento        TEXT IS 'Tipo de Documento',
    descripcion_documento TEXT IS 'Descripcion Documento',
    obligatorio           TEXT IS 'Obligatorio S/N',
    fecha_recepcion       TEXT IS 'Fecha de Recepcion',
    fecha_vencimiento     TEXT IS 'Fecha de Vencimiento',
    observaciones         TEXT IS 'Observaciones',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_DIMST_C  ON HNEACOSTA1/DIMST (created_at);
CREATE INDEX HNEACOSTA1/IDX_DIMST_TC ON HNEACOSTA1/DIMST (tipo_cuenta);
