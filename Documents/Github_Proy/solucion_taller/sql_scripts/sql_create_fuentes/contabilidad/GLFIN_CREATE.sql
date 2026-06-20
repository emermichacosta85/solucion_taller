-- ================================================================
-- Nombre de la Tabla  : GLFIN
-- DESCRIPCION         : Estados Financieros por Niveles
-- Objetivo            : Almacenar los estados financieros estructurados
--                       por niveles jerarquicos del plan de cuentas,
--                       listos para presentacion gerencial y regulatoria,
--                       incluyendo variaciones absolutas y porcentuales.
-- Tipo de Tabla       : Historica / Reportes Financieros
-- Origen de los Datos : Proceso de generacion desde GLBSE y GLBLN
-- Permanencia de Datos: Historica por periodo
-- Uso de los datos    : Presentacion a junta directiva, reguladores y auditores
-- Restricciones       : PK tecnica (id); tabla de reporte derivada
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE GLFIN (
    id                       FOR COLUMN GLFINID BIGINT         NOT NULL,
    descripcion_cuenta       FOR COLUMN GLFINDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN GLFINNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN GLFINNCV VARCHAR(50),
    saldo_actual             FOR COLUMN GLFINSAL DECIMAL(18,2)  NOT NULL DEFAULT 0,
    fecha_proceso_sistema    FOR COLUMN GLFINFPS TIMESTAMP,
    observaciones            FOR COLUMN GLFINOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN GLFINUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN GLFINUSA VARCHAR(30),
    version_registro         FOR COLUMN GLFINVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN GLFINERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN GLFINCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN GLFINUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_GLFIN PRIMARY KEY (id)
)
RCDFMT GLFINR;

RENAME TABLE GLFIN
    TO GLFIN_TABLE FOR SYSTEM NAME GLFIN;

COMMENT ON TABLE GLFIN IS
    'Estados Financieros por Niveles - Modulo 7 Contabilidad';

LABEL ON TABLE GLFIN
    IS 'Estados Financieros';

COMMENT ON COLUMN GLFIN.id IS
    'Identificador tecnico unico autoincremental del registro de estado financiero';
COMMENT ON COLUMN GLFIN.descripcion_cuenta IS
    'Descripcion de la linea o rubro del estado financiero';
COMMENT ON COLUMN GLFIN.naturaleza_cuenta IS
    'Naturaleza contable de la linea: DEUDORA o ACREEDORA';
COMMENT ON COLUMN GLFIN.nivel_cuenta IS
    'Nivel del plan de cuentas al que corresponde esta linea del estado';
COMMENT ON COLUMN GLFIN.saldo_actual IS
    'Saldo de la linea al cierre del periodo del estado financiero';
COMMENT ON COLUMN GLFIN.fecha_proceso_sistema IS
    'Marca de tiempo del proceso que genero el estado financiero';
COMMENT ON COLUMN GLFIN.observaciones IS
    'Notas sobre ajustes, reexpresiones o condiciones especiales del estado';
COMMENT ON COLUMN GLFIN.usuario_creacion IS
    'Usuario o proceso que genero el registro del estado financiero';
COMMENT ON COLUMN GLFIN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN GLFIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN GLFIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN GLFIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN GLFIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN GLFIN (
    id                       TEXT IS 'ID Estado Fin',
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

CREATE INDEX IGLFINPK ON GLFIN (id);
CREATE INDEX IGLFINCAT ON GLFIN (created_at);
