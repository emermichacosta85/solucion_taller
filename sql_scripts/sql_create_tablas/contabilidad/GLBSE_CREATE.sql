-- ================================================================
-- Nombre de la Tabla  : GLBSE
-- DESCRIPCION         : Balances Generales Consolidados
-- Objetivo            : Almacenar los balances generales consolidados
--                       del banco como un todo, agregando los saldos
--                       de todas las sucursales y monedas en un reporte
--                       unico para la alta gerencia y entes reguladores.
-- Tipo de Tabla       : Historica / Reportes Gerenciales
-- Origen de los Datos : Proceso de consolidacion de GLBLN al cierre
-- Permanencia de Datos: Historica
-- Uso de los datos    : Reportes gerenciales, estados financieros
--                       consolidados y entrega a reguladores
-- Restricciones       : PK tecnica (id); tabla derivada sin FK directa
--                       a GLMST para mantener independencia del consolidado
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE GLBSE (
    id                       FOR COLUMN GLBSEID BIGINT         NOT NULL,
    descripcion_cuenta       FOR COLUMN GLBSEDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN GLBSENCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN GLBSENIV VARCHAR(50),
    saldo_actual             FOR COLUMN GLBSESAL DECIMAL(18,2)  NOT NULL DEFAULT 0,
    fecha_proceso_sistema    FOR COLUMN GLBSEFPS TIMESTAMP,
    observaciones            FOR COLUMN GLBSEOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN GLBSEUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN GLBSEUSA VARCHAR(30),
    version_registro         FOR COLUMN GLBSEVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN GLBSEERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN GLBSECAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN GLBSEUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_GLBSE PRIMARY KEY (id)
)
RCDFMT GLBSER;

RENAME TABLE GLBSE
    TO GLBSE_TABLE FOR SYSTEM NAME GLBSE;

COMMENT ON TABLE GLBSE IS
    'Balances Generales Consolidados del Banco - Modulo 7 Contabilidad';

LABEL ON TABLE GLBSE
    IS 'Balances Consolidados';

COMMENT ON COLUMN GLBSE.id IS
    'Identificador tecnico unico autoincremental del registro consolidado';
COMMENT ON COLUMN GLBSE.descripcion_cuenta IS
    'Descripcion de la cuenta al momento del proceso de consolidacion';
COMMENT ON COLUMN GLBSE.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta consolidada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN GLBSE.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN GLBSE.saldo_actual IS
    'Saldo consolidado de la cuenta al cierre de la fecha de consolidacion';
COMMENT ON COLUMN GLBSE.fecha_proceso_sistema IS
    'Marca de tiempo del proceso de consolidacion que genero el registro';
COMMENT ON COLUMN GLBSE.observaciones IS
    'Notas sobre ajustes de consolidacion o condiciones especiales del saldo';
COMMENT ON COLUMN GLBSE.usuario_creacion IS
    'Usuario o proceso que genero el registro de balance consolidado';
COMMENT ON COLUMN GLBSE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN GLBSE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN GLBSE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN GLBSE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN GLBSE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN GLBSE (
    id                       TEXT IS 'ID Consolid',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
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

CREATE INDEX IGLBSEPK ON GLBSE (id);
CREATE INDEX IGLBSECAT ON GLBSE (created_at);
