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

CREATE OR REPLACE TABLE HNEACOSTA1/GLMST (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN GLMSTBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN GLMSTMON,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN GLMSTCTC,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN GLMSTDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN GLMSTNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN GLMSTNIV,
    tipo_cuenta              VARCHAR(20)                 FOR COLUMN GLMSTTCT,
    grupo_cuenta             VARCHAR(20)                 FOR COLUMN GLMSTGRP,
    cuenta_padre             VARCHAR(24)                 FOR COLUMN GLMSTCTP,
    permite_movimiento       CHAR(1)        NOT NULL
                                            DEFAULT 'S'  FOR COLUMN GLMSTPMV,
    requiere_centro_costo    CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN GLMSTRCC,
    saldo_actual             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLMSTSAL,
    saldo_debitos            DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLMSTSDG,
    saldo_creditos           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLMSTSCR,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN GLMSTFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN GLMSTUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN GLMSTUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN GLMSTVRS,
    observaciones            VARCHAR(120)                FOR COLUMN GLMSTOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN GLMSTERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLMSTCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLMSTUAT,
    CONSTRAINT PK_GLMST     PRIMARY KEY (codigo_banco, codigo_moneda,
                                         cuenta_contable),
    CONSTRAINT UQ_GLMST_CTC UNIQUE      (cuenta_contable)
)
RCDFMT GLMSTR;

RENAME TABLE HNEACOSTA1/GLMST
    TO GLMST FOR SYSTEM NAME GLMST;

COMMENT ON TABLE HNEACOSTA1/GLMST IS
    'Maestro de Cuentas Contables - Plan de Cuentas - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/GLMST
    IS 'Maestro Cuentas Contab';

COMMENT ON COLUMN HNEACOSTA1/GLMST.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/GLMST.codigo_moneda IS
    'Codigo ISO de la moneda a la que esta asociada la cuenta contable';
COMMENT ON COLUMN HNEACOSTA1/GLMST.cuenta_contable IS
    'Numero de cuenta en el plan de cuentas, unico en el sistema';
COMMENT ON COLUMN HNEACOSTA1/GLMST.descripcion_cuenta IS
    'Nombre descriptivo oficial de la cuenta segun el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/GLMST.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/GLMST.nivel_cuenta IS
    'Nivel jerarquico de la cuenta dentro del plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/GLMST.tipo_cuenta IS
    'Tipo de cuenta: ACTIVO, PASIVO, PATRIMONIO, INGRESO, GASTO, ORDEN';
COMMENT ON COLUMN HNEACOSTA1/GLMST.grupo_cuenta IS
    'Grupo o categoria de la cuenta para agrupacion en estados financieros';
COMMENT ON COLUMN HNEACOSTA1/GLMST.cuenta_padre IS
    'Cuenta contable padre para estructurar la jerarquia del plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/GLMST.permite_movimiento IS
    'Indica si la cuenta acepta asientos directos: S=Si (detalle), N=No (grupo)';
COMMENT ON COLUMN HNEACOSTA1/GLMST.requiere_centro_costo IS
    'Indica si los movimientos en esta cuenta deben asociarse a un centro de costo';
COMMENT ON COLUMN HNEACOSTA1/GLMST.saldo_actual IS
    'Saldo contable actual acumulado de la cuenta al cierre del ultimo dia';
COMMENT ON COLUMN HNEACOSTA1/GLMST.saldo_debitos IS
    'Total acumulado de debitos registrados en la cuenta en el periodo';
COMMENT ON COLUMN HNEACOSTA1/GLMST.saldo_creditos IS
    'Total acumulado de creditos registrados en la cuenta en el periodo';
COMMENT ON COLUMN HNEACOSTA1/GLMST.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de cierre o actualizacion de saldo';
COMMENT ON COLUMN HNEACOSTA1/GLMST.usuario_creacion IS
    'Usuario del sistema que creo la cuenta en el catalogo';
COMMENT ON COLUMN HNEACOSTA1/GLMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/GLMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/GLMST.observaciones IS
    'Notas sobre la cuenta, sus restricciones o uso especifico';
COMMENT ON COLUMN HNEACOSTA1/GLMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/GLMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/GLMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/GLMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    tipo_cuenta              TEXT IS 'Tipo Cuenta',
    grupo_cuenta             TEXT IS 'Grupo',
    cuenta_padre             TEXT IS 'Cta Padre',
    permite_movimiento       TEXT IS 'Perm Movim',
    requiere_centro_costo    TEXT IS 'Req CC',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_debitos            TEXT IS 'Saldo Debit',
    saldo_creditos           TEXT IS 'Saldo Cred',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IGLMSTCAT ON HNEACOSTA1/GLMST (created_at);
CREATE INDEX HNEACOSTA1/IGLMSTGRP ON HNEACOSTA1/GLMST (grupo_cuenta);
CREATE INDEX HNEACOSTA1/IGLMSTTCT ON HNEACOSTA1/GLMST (tipo_cuenta);
