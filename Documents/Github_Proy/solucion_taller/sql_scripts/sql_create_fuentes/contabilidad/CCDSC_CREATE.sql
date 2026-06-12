-- ================================================================
-- Nombre de la Tabla  : CCDSC
-- DESCRIPCION         : Maestro de Centros de Costos
-- Objetivo            : Catalogar los centros de costo del banco para
--                       la distribucion y control de gastos e ingresos,
--                       permitiendo el analisis de rentabilidad por
--                       unidad de negocio, sucursal o departamento.
-- Tipo de Tabla       : Maestra / Catalogo
-- Origen de los Datos : Configuracion del area de contabilidad
--                       y control de gestion
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Imputacion de asientos por centro de costo,
--                       reportes de rentabilidad y control presupuestario
-- Restricciones       : PK tecnica (id); UNIQUE sobre (codigo_centro,
--                       codigo_banco) para referencia desde BUMST
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CCDSC (
    id                       BIGINT         NOT NULL     FOR COLUMN CCDSCID,
    codigo_centro            VARCHAR(50)    NOT NULL     FOR COLUMN CCDSCCOD,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN CCDSCBNK,
    descripcion_cuenta       VARCHAR(120)   NOT NULL     FOR COLUMN CCDSCDSC,
    tipo_centro              VARCHAR(20)                 FOR COLUMN CCDSCTCO,
    responsable              VARCHAR(80)                 FOR COLUMN CCDSCRES,
    centro_padre             VARCHAR(50)                 FOR COLUMN CCDSCCPA,
    nivel_jerarquico         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CCDSCNJR,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN CCDSCNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN CCDSCNIV,
    saldo_actual             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN CCDSCSAL,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN CCDSCFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN CCDSCULC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN CCDSCUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN CCDSCVRS,
    observaciones            VARCHAR(120)                FOR COLUMN CCDSCOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN CCDSCERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CCDSCCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN CCDSCUAT,
    CONSTRAINT PK_CCDSC     PRIMARY KEY (id),
    CONSTRAINT UQ_CCDSC_COD UNIQUE      (codigo_centro, codigo_banco)
)
RCDFMT CCDSCT;

RENAME TABLE HNEACOSTA1/CCDSC
    TO CCDSC FOR SYSTEM NAME CCDSC;

COMMENT ON TABLE HNEACOSTA1/CCDSC IS
    'Maestro de Centros de Costos del Banco - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/CCDSC
    IS 'Maestro Centros Costos';

COMMENT ON COLUMN HNEACOSTA1/CCDSC.id IS
    'Identificador tecnico unico autoincremental del centro de costo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.codigo_centro IS
    'Codigo unico del centro de costo dentro del banco';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.codigo_banco IS
    'Codigo del banco al que pertenece el centro de costo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.descripcion_cuenta IS
    'Nombre o descripcion oficial del centro de costo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.tipo_centro IS
    'Tipo del centro de costo: NEGOCIO, SOPORTE, SERVICIO, SUCURSAL';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.responsable IS
    'Nombre del funcionario responsable del centro de costo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.centro_padre IS
    'Codigo del centro de costo padre en la jerarquia organizacional';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.nivel_jerarquico IS
    'Nivel del centro en la jerarquia: 1=Corporativo, 2=Division, 3=Departamento';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.naturaleza_cuenta IS
    'Naturaleza predominante del centro: COSTOS, INGRESOS, MIXTO';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.nivel_cuenta IS
    'Nivel de detalle contable asociado al centro de costo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.saldo_actual IS
    'Saldo neto acumulado del centro de costo en el periodo vigente';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de actualizacion de saldo';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.usuario_creacion IS
    'Usuario que creo el centro de costo en el sistema';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.observaciones IS
    'Notas sobre el centro de costo, sus funciones o restricciones';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CCDSC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CCDSC (
    id                       TEXT IS 'ID Centro CC',
    codigo_centro            TEXT IS 'Cod Centro',
    codigo_banco             TEXT IS 'Banco',
    descripcion_cuenta       TEXT IS 'Descripcion',
    tipo_centro              TEXT IS 'Tipo Centro',
    responsable              TEXT IS 'Responsable',
    centro_padre             TEXT IS 'Centro Padre',
    nivel_jerarquico         TEXT IS 'Nivel Jerarc',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel Cta',
    saldo_actual             TEXT IS 'Saldo Actual',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ICCDSCCAT ON HNEACOSTA1/CCDSC (created_at);
CREATE INDEX HNEACOSTA1/ICCDSCBNK ON HNEACOSTA1/CCDSC (codigo_banco);
CREATE INDEX HNEACOSTA1/ICCDSCNIV ON HNEACOSTA1/CCDSC (nivel_jerarquico);
