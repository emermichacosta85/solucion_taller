-- ================================================================
-- Nombre de la Tabla  : GLBLN
-- DESCRIPCION         : Balances Generales por Sucursal
-- Objetivo            : Registrar los saldos diarios del balance general
--                       desglosados por banco, sucursal, moneda y cuenta
--                       contable, permitiendo la consolidacion por entidad
--                       y la generacion de reportes de balance regulatorios.
-- Tipo de Tabla       : Historica / Reportes
-- Origen de los Datos : Proceso de cierre diario contable
-- Permanencia de Datos: Historica (un registro por cuenta por dia)
-- Uso de los datos    : Generacion de balances, reportes regulatorios
--                       y conciliacion intersucursal
-- Restricciones       : FK hacia GLMST por cuenta_contable
--                       (segun ERD: GLMST ||--o{ GLBLN)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE GLBLN (
    codigo_banco             FOR COLUMN GLBLNBNK VARCHAR(20)    NOT NULL,
    codigo_sucursal          FOR COLUMN GLBLNSUC VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN GLBLNMON VARCHAR(20)    NOT NULL,
    cuenta_contable          FOR COLUMN GLBLNCTC VARCHAR(24)    NOT NULL,
    descripcion_cuenta       FOR COLUMN GLBLNDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN GLBLNNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN GLBLNNIV VARCHAR(50),
    saldo_actual             FOR COLUMN GLBLNSAL DECIMAL(18,2)  NOT NULL DEFAULT 0,
    fecha_proceso_sistema    FOR COLUMN GLBLNFPS TIMESTAMP,
    observaciones            FOR COLUMN GLBLNOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN GLBLNUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN GLBLNUSA VARCHAR(30),
    version_registro         FOR COLUMN GLBLNVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN GLBLNERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN GLBLNCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN GLBLNUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_GLBLN PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable)
    --CONSTRAINT FK_GLBLN_GLMST FOREIGN KEY (cuenta_contable)
    --    REFERENCES GLMST (cuenta_contable)
)
RCDFMT GLBLNR;

RENAME TABLE GLBLN
    TO GLBLN_TABLE FOR SYSTEM NAME GLBLN;

COMMENT ON TABLE GLBLN IS
    'Balances Generales por Sucursal y Fecha - Modulo 7 Contabilidad';

LABEL ON TABLE GLBLN
    IS 'Balances Generales';

COMMENT ON COLUMN GLBLN.codigo_banco IS
    'Codigo del banco al que corresponde el saldo de balance';
COMMENT ON COLUMN GLBLN.codigo_sucursal IS
    'Codigo de la sucursal cuyo saldo se registra en el balance';
COMMENT ON COLUMN GLBLN.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el saldo de balance';
COMMENT ON COLUMN GLBLN.cuenta_contable IS
    'Numero de cuenta contable cuyo saldo se registra (FK GLMST)';
COMMENT ON COLUMN GLBLN.descripcion_cuenta IS
    'Descripcion de la cuenta contable (referencia informativa del cierre)';
COMMENT ON COLUMN GLBLN.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN GLBLN.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas al cierre';
COMMENT ON COLUMN GLBLN.saldo_actual IS
    'Saldo final de la cuenta al cierre del dia de proceso';
COMMENT ON COLUMN GLBLN.fecha_proceso_sistema IS
    'Marca de tiempo del proceso de cierre que genero este registro de balance';
COMMENT ON COLUMN GLBLN.observaciones IS
    'Notas sobre ajustes, reclasificaciones o condiciones del saldo';
COMMENT ON COLUMN GLBLN.usuario_creacion IS
    'Usuario o proceso de cierre que genero el registro de balance';
COMMENT ON COLUMN GLBLN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN GLBLN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN GLBLN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN GLBLN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN GLBLN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN GLBLN (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
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

CREATE INDEX IGLBLNPK ON GLBLN (codigo_banco, codigo_sucursal);
CREATE INDEX IGLBLNCAT ON GLBLN (created_at);
