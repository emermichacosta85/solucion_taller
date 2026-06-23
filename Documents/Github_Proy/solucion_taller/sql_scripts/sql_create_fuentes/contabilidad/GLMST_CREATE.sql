-- ================================================================
-- Nombre de la Tabla  : GLMST
-- DESCRIPCION         : Maestro de Cuentas Contables
-- Objetivo            : Mantener el catalogo oficial del plan de cuentas
--                       contables del banco, definiendo la naturaleza,
--                       nivel jerarquico y saldo de cada cuenta, siendo
--                       la entidad padre de todos los movimientos y
--                       balances del modulo contable.
-- Tipo de Tabla       : Maestra / Catalogo
-- Origen de los Datos : Configuracion del plan de cuentas por el area
--                       de contabilidad y normativa regulatoria
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Registro de asientos, generacion de balances,
--                       estados financieros y reportes regulatorios
-- Restricciones       : PK compuesta por banco, moneda y cuenta_contable;
--                       UNIQUE sobre cuenta_contable para referencia de FK
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE GLMST (
    codigo_banco             FOR COLUMN GLMSTBNK VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN GLMSTMON VARCHAR(20)    NOT NULL,
    cuenta_contable          FOR COLUMN GLMSTCTC VARCHAR(24)    NOT NULL,
    descripcion_cuenta       FOR COLUMN GLMSTDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN GLMSTNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN GLMSTNIV VARCHAR(50),
    saldo_actual             FOR COLUMN GLMSTSAL DECIMAL(18,2)  NOT NULL DEFAULT 0,
    fecha_proceso_sistema    FOR COLUMN GLMSTFPS TIMESTAMP,
    observaciones            FOR COLUMN GLMSTOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN GLMSTUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN GLMSTUSA VARCHAR(30),
    version_registro         FOR COLUMN GLMSTVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN GLMSTERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN GLMSTCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN GLMSTUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_GLMST     PRIMARY KEY (codigo_banco, codigo_moneda,
                                         cuenta_contable)
    --CONSTRAINT UQ_GLMST_CTC UNIQUE      (cuenta_contable)
)
RCDFMT GLMSTR;

RENAME TABLE GLMST
    TO GLMST_TABLE FOR SYSTEM NAME GLMST;

COMMENT ON TABLE GLMST IS
    'Maestro de Cuentas Contables - Plan de Cuentas - Modulo 7 Contabilidad';

LABEL ON TABLE GLMST
    IS 'Maestro Cuentas Contab';

COMMENT ON COLUMN GLMST.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta en el plan de cuentas';
COMMENT ON COLUMN GLMST.codigo_moneda IS
    'Codigo ISO de la moneda a la que esta asociada la cuenta contable';
COMMENT ON COLUMN GLMST.cuenta_contable IS
    'Numero de cuenta en el plan de cuentas, unico en el sistema';
COMMENT ON COLUMN GLMST.descripcion_cuenta IS
    'Nombre descriptivo oficial de la cuenta segun el plan de cuentas';
COMMENT ON COLUMN GLMST.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN GLMST.nivel_cuenta IS
    'Nivel jerarquico de la cuenta dentro del plan de cuentas';
COMMENT ON COLUMN GLMST.saldo_actual IS
    'Saldo contable actual acumulado de la cuenta al cierre del ultimo dia';
COMMENT ON COLUMN GLMST.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de cierre o actualizacion de saldo';
COMMENT ON COLUMN GLMST.observaciones IS
    'Notas sobre la cuenta, sus restricciones o uso especifico';
COMMENT ON COLUMN GLMST.usuario_creacion IS
    'Usuario del sistema que creo la cuenta en el catalogo';
COMMENT ON COLUMN GLMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN GLMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN GLMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN GLMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN GLMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN GLMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
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

CREATE INDEX IGLMSTPK ON GLMST (codigo_banco, codigo_moneda);
CREATE INDEX IGLMSTCRAT ON GLMST (created_at);

