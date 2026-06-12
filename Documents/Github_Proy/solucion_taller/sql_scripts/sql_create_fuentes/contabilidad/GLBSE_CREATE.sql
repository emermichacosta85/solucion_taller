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

CREATE OR REPLACE TABLE HNEACOSTA1/GLBSE (
    id                       BIGINT         NOT NULL     FOR COLUMN GLBSEID,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN GLBSEBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN GLBSEMON,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN GLBSECTC,
    fecha_consolidacion      DATE           NOT NULL     FOR COLUMN GLBSEFCO,
    tipo_consolidacion       VARCHAR(20)                 FOR COLUMN GLBSETCO,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN GLBSEDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN GLBSENCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN GLBSENIV,
    saldo_actual             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBSESAL,
    saldo_mes_anterior       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBSESMA,
    saldo_anio_anterior      DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLBSESAA,
    numero_sucursales        INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN GLBSENSUC,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN GLBSEFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN GLBSEUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN GLBSEUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN GLBSEVRS,
    observaciones            VARCHAR(120)                FOR COLUMN GLBSEOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN GLBSEERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLBSECAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLBSEUAT,
    CONSTRAINT PK_GLBSE PRIMARY KEY (id)
)
RCDFMT GLBSER;

RENAME TABLE HNEACOSTA1/GLBSE
    TO GLBSE FOR SYSTEM NAME GLBSE;

COMMENT ON TABLE HNEACOSTA1/GLBSE IS
    'Balances Generales Consolidados del Banco - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/GLBSE
    IS 'Balances Consolidados';

COMMENT ON COLUMN HNEACOSTA1/GLBSE.id IS
    'Identificador tecnico unico autoincremental del registro consolidado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.codigo_banco IS
    'Codigo del banco al que corresponde el balance consolidado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.codigo_moneda IS
    'Codigo ISO de la moneda en que se expresa el saldo consolidado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.cuenta_contable IS
    'Numero de cuenta contable cuyo saldo se consolida';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.fecha_consolidacion IS
    'Fecha del cierre al que corresponde el saldo consolidado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.tipo_consolidacion IS
    'Alcance de la consolidacion: DIARIO, MENSUAL, TRIMESTRAL, ANUAL';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.descripcion_cuenta IS
    'Descripcion de la cuenta al momento del proceso de consolidacion';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.naturaleza_cuenta IS
    'Naturaleza contable de la cuenta consolidada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.saldo_actual IS
    'Saldo consolidado de la cuenta al cierre de la fecha de consolidacion';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.saldo_mes_anterior IS
    'Saldo consolidado de la cuenta al cierre del mes anterior';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.saldo_anio_anterior IS
    'Saldo consolidado de la cuenta al mismo periodo del anio anterior';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.numero_sucursales IS
    'Numero de sucursales incluidas en la consolidacion de este saldo';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.fecha_proceso_sistema IS
    'Marca de tiempo del proceso de consolidacion que genero el registro';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.usuario_creacion IS
    'Usuario o proceso que genero el registro de balance consolidado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.observaciones IS
    'Notas sobre ajustes de consolidacion o condiciones especiales del saldo';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/GLBSE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/GLBSE (
    id                       TEXT IS 'ID Consolid',
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    fecha_consolidacion      TEXT IS 'Fec Consolid',
    tipo_consolidacion       TEXT IS 'Tipo Consol',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_mes_anterior       TEXT IS 'Sdo Mes Ant',
    saldo_anio_anterior      TEXT IS 'Sdo Anio Ant',
    numero_sucursales        TEXT IS 'Num Sucursal',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IGLBSEFCO ON HNEACOSTA1/GLBSE (fecha_consolidacion);
CREATE INDEX HNEACOSTA1/IGLBSECTC ON HNEACOSTA1/GLBSE (cuenta_contable);
CREATE INDEX HNEACOSTA1/IGLBSECAT ON HNEACOSTA1/GLBSE (created_at);
