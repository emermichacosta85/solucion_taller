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

CREATE OR REPLACE TABLE HNEACOSTA1/GLBLN (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN GLBLNBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN GLBLNSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN GLBLNMON,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN GLBLNCTC,
    fecha_balance            DATE           NOT NULL     FOR COLUMN GLBLNFBA,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN GLBLNDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN GLBLNNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN GLBLNNIV,
    saldo_inicial            DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNSINI,
    total_debitos            DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNTDB,
    total_creditos           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNTCR,
    saldo_actual             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNSAL,
    saldo_mes_anterior       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNSMA,
    saldo_anio_anterior      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBLNSAA,
    centro_costo             VARCHAR(50)                 FOR COLUMN GLBLNCC,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN GLBLNFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN GLBLNUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN GLBLNUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN GLBLNVRS,
    observaciones            VARCHAR(120)                FOR COLUMN GLBLNOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN GLBLNERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLBLNCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLBLNUAT,
    CONSTRAINT PK_GLBLN PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     fecha_balance),
    CONSTRAINT FK_GLBLN_GLMST FOREIGN KEY (cuenta_contable)
        REFERENCES HNEACOSTA1/GLMST (cuenta_contable)
)
RCDFMT GLBLNR;

RENAME TABLE HNEACOSTA1/GLBLN
    TO GLBLN FOR SYSTEM NAME GLBLN;

COMMENT ON TABLE HNEACOSTA1/GLBLN IS
    'Balances Generales por Sucursal y Fecha - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/GLBLN
    IS 'Balances Generales';

COMMENT ON COLUMN HNEACOSTA1/GLBLN.codigo_banco IS
    'Codigo del banco al que corresponde el saldo de balance';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.codigo_sucursal IS
    'Codigo de la sucursal cuyo saldo se registra en el balance';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el saldo de balance';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.cuenta_contable IS
    'Numero de cuenta contable cuyo saldo se registra (FK GLMST)';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.fecha_balance IS
    'Fecha del cierre contable a la que corresponde el saldo registrado';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.descripcion_cuenta IS
    'Descripcion de la cuenta contable (referencia informativa del cierre)';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas al cierre';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.saldo_inicial IS
    'Saldo de la cuenta al inicio del dia antes de los movimientos del dia';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.total_debitos IS
    'Sumatoria de todos los debitos registrados en la cuenta durante el dia';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.total_creditos IS
    'Sumatoria de todos los creditos registrados en la cuenta durante el dia';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.saldo_actual IS
    'Saldo final de la cuenta al cierre del dia de proceso';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.saldo_mes_anterior IS
    'Saldo de la cuenta al cierre del mes anterior para comparativos';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.saldo_anio_anterior IS
    'Saldo de la cuenta al cierre del mismo periodo del anio anterior';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.centro_costo IS
    'Centro de costo al que se imputa el saldo cuando la cuenta lo requiere';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.fecha_proceso_sistema IS
    'Marca de tiempo del proceso de cierre que genero este registro de balance';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.usuario_creacion IS
    'Usuario o proceso de cierre que genero el registro de balance';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.observaciones IS
    'Notas sobre ajustes, reclasificaciones o condiciones del saldo';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/GLBLN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/GLBLN (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    fecha_balance            TEXT IS 'Fec Balance',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_inicial            TEXT IS 'Saldo Inic',
    total_debitos            TEXT IS 'Tot Debitos',
    total_creditos           TEXT IS 'Tot Creditos',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_mes_anterior       TEXT IS 'Sdo Mes Ant',
    saldo_anio_anterior      TEXT IS 'Sdo Anio Ant',
    centro_costo             TEXT IS 'Centro Costo',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IGLBLNCTC ON HNEACOSTA1/GLBLN (cuenta_contable);
CREATE INDEX HNEACOSTA1/IGLBLNFBA ON HNEACOSTA1/GLBLN (fecha_balance);
CREATE INDEX HNEACOSTA1/IGLBLNCAT ON HNEACOSTA1/GLBLN (created_at);
