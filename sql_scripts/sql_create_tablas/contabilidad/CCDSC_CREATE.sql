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

CREATE OR REPLACE TABLE CCDSC (
    id                       FOR COLUMN CCDSCID BIGINT         NOT NULL,
    descripcion_cuenta       FOR COLUMN CCDSCDSC VARCHAR(120)   NOT NULL,
    naturaleza_cuenta        FOR COLUMN CCDSCNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN CCDSCNIV VARCHAR(50),
    saldo_actual             FOR COLUMN CCDSCSAL DECIMAL(18,2)  NOT NULL DEFAULT 0,
    fecha_proceso_sistema    FOR COLUMN CCDSCFPS TIMESTAMP,
    observaciones            FOR COLUMN CCDSCOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN CCDSCULC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CCDSCUSA VARCHAR(30),
    version_registro         FOR COLUMN CCDSCVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN CCDSCERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN CCDSCCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CCDSCUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP
)
RCDFMT CCDSCT;

RENAME TABLE CCDSC
    TO CCDSC_TABLE FOR SYSTEM NAME CCDSC;

COMMENT ON TABLE CCDSC IS
    'Maestro de Centros de Costos del Banco - Modulo 7 Contabilidad';

LABEL ON TABLE CCDSC
    IS 'Maestro Centros Costos';

COMMENT ON COLUMN CCDSC.id IS
    'Identificador tecnico unico autoincremental del centro de costo';
COMMENT ON COLUMN CCDSC.descripcion_cuenta IS
    'Nombre o descripcion oficial del centro de costo';
COMMENT ON COLUMN CCDSC.naturaleza_cuenta IS
    'Naturaleza predominante del centro: COSTOS, INGRESOS, MIXTO';
COMMENT ON COLUMN CCDSC.nivel_cuenta IS
    'Nivel de detalle contable asociado al centro de costo';
COMMENT ON COLUMN CCDSC.saldo_actual IS
    'Saldo neto acumulado del centro de costo en el periodo vigente';
COMMENT ON COLUMN CCDSC.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de actualizacion de saldo';
COMMENT ON COLUMN CCDSC.observaciones IS
    'Notas sobre el centro de costo, sus funciones o restricciones';
COMMENT ON COLUMN CCDSC.usuario_creacion IS
    'Usuario que creo el centro de costo en el sistema';
COMMENT ON COLUMN CCDSC.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN CCDSC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CCDSC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CCDSC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CCDSC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CCDSC (
    id                       TEXT IS 'ID Centro CC',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel Cta',
    saldo_actual             TEXT IS 'Saldo Actual',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX ICCDSCPK ON CCDSC (id);
CREATE INDEX ICCDSCREA ON CCDSC (created_at);

