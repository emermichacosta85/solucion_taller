-- ==============================================================================
-- Nombre de la Tabla  : TRDSC
-- DESCRIPCION         : Descripciones Adicionales a las Transacciones. Almacena
--                       texto descriptivo extendido y clasificaciones adicionales
--                       para las transacciones del historico (TRANS), permitiendo
--                       detallar el concepto, subtipo y observaciones de cada
--                       movimiento sin ampliar la estructura de TRANS.
-- Objetivo            : Enriquecer el registro de transacciones con descripciones
--                       adicionales, subtipos y observaciones auditables, sin
--                       modificar la estructura de la tabla TRANS.
-- Tipo de Tabla       : Detalle de Transacciones
-- Origen de los Datos : Ingreso por proceso batch o usuario al crear/actualizar
--                       transacciones en TRANS
-- Permanencia de Datos: Permanente con historico indefinido
-- Uso de los datos    : Modulo Archivos Comunes - descripciones de transacciones
--                       para conciliacion, notificaciones y auditoria;
--                       tabla hija de TRANS via numero_registro_relativo
-- Restricciones       : PK compuesta (numero_registro_relativo, secuencia);
--                       FK a TRANS (numero_registro_relativo);
--                       estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Archivos Comunes
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE TRDSC (
    numero_registro_relativo FOR COLUMN NUMREG  VARCHAR(30)    NOT NULL,
    secuencia               FOR COLUMN SECUENC  INTEGER        NOT NULL,
    tipo_descripcion        FOR COLUMN TIPDSC   VARCHAR(20)    NOT NULL DEFAULT '',
    texto_descripcion       FOR COLUMN TXTDSC   VARCHAR(200)   NOT NULL DEFAULT '',
    codigo_idioma           FOR COLUMN CODIDM   VARCHAR(5)     NOT NULL DEFAULT 'ES',
    formato_salida          FOR COLUMN FMTSAL   VARCHAR(20)    NOT NULL DEFAULT '',
    obligatorio             FOR COLUMN OBLIG    CHAR(1)        NOT NULL DEFAULT 'N',
    usuario_creacion        FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion   FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro        FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro         FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_TRDSC     PRIMARY KEY (numero_registro_relativo, secuencia)
    --CONSTRAINT FK_TRDSC_TRANS FOREIGN KEY (numero_registro_relativo)
    --    REFERENCES TRANS (numero_registro_relativo)
)
RCDFMT TRDSCR;

RENAME TABLE TRDSC
    TO TRDSC_TABLE FOR SYSTEM NAME TRDSC;

COMMENT ON TABLE TRDSC IS
    'Descripciones Adicionales a Transacciones - Modulo 01 Archivos Comunes Taller IBM i';

LABEL ON TABLE TRDSC IS
    'Descripciones de Transacciones';

COMMENT ON COLUMN TRDSC.numero_registro_relativo IS 'Numero de registro relativo de TRANS al que aplica la descripcion; FK a TRANS; parte de la PK';
COMMENT ON COLUMN TRDSC.secuencia               IS 'Numero de secuencia de la descripcion dentro de la transaccion; parte de la PK';
COMMENT ON COLUMN TRDSC.tipo_descripcion        IS 'Clasificacion de la descripcion: DETALLE_ORIGEN, AJUSTE_REQUERIDO, TRANSITO, etc.';
COMMENT ON COLUMN TRDSC.texto_descripcion       IS 'Texto libre con la descripcion adicional de la transaccion';
COMMENT ON COLUMN TRDSC.codigo_idioma           IS 'Idioma del texto de descripcion: ES=Espanol, EN=Ingles';
COMMENT ON COLUMN TRDSC.formato_salida          IS 'Formato de uso de la descripcion: JSON, IMPRESO, PANTALLA, etc.';
COMMENT ON COLUMN TRDSC.obligatorio             IS 'Indica si la descripcion es obligatoria en la salida: S=Si, N=No';
COMMENT ON COLUMN TRDSC.usuario_creacion        IS 'Usuario o proceso que creo el registro de descripcion adicional';
COMMENT ON COLUMN TRDSC.usuario_actualizacion   IS 'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN TRDSC.version_registro        IS 'Contador de versiones para control de concurrencia optimista';
COMMENT ON COLUMN TRDSC.observaciones           IS 'Notas adicionales sobre la descripcion registrada';
COMMENT ON COLUMN TRDSC.estado_registro         IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN TRDSC.created_at              IS 'Fecha y hora exacta de creacion del registro';
COMMENT ON COLUMN TRDSC.updated_at              IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN TRDSC (
    numero_registro_relativo TEXT IS 'Num Registro Relativo',
    secuencia               TEXT IS 'Secuencia',
    tipo_descripcion        TEXT IS 'Tipo Descripcion',
    texto_descripcion       TEXT IS 'Texto Descripcion',
    codigo_idioma           TEXT IS 'Codigo Idioma',
    formato_salida          TEXT IS 'Formato Salida',
    obligatorio             TEXT IS 'Obligatorio S/N',
    usuario_creacion        TEXT IS 'Usuario Creacion',
    usuario_actualizacion   TEXT IS 'Usuario Actualizacion',
    version_registro        TEXT IS 'Version Registro',
    observaciones           TEXT IS 'Observaciones',
    estado_registro         TEXT IS 'Estado Registro',
    created_at              TEXT IS 'Fecha Creacion',
    updated_at              TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX IDX_TRDSC_TD ON TRDSC (tipo_descripcion);
CREATE INDEX IDX_TRDSC_C  ON TRDSC (created_at);
