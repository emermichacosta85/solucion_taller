-- ================================================================
-- Nombre de la Tabla  : CNTRLRCO
-- DESCRIPCION         : Tabla de Cargos por Servicios o Tarifas de Cobranzas
-- Objetivo            : Parametrizar las tarifas y cargos aplicables a las
--                       operaciones de cobranza documentaria por banco y
--                       tipo de producto, conforme a la estructura definida
--                       en estructura_bd.md (Modulo 6).
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion de tarifas por la gerencia bancaria
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia para el calculo de comisiones en cobranzas
-- Restricciones       : PK compuesta (codigo_banco, tipo_producto,
--                       numero_tabla). Tabla parametrica sin FK intramodulo.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE CNTRLRCO (
    codigo_banco             FOR COLUMN CNTRCBNK   VARCHAR(20)    NOT NULL,
    tipo_producto            FOR COLUMN CNTRCTPR   VARCHAR(20)    NOT NULL,
    numero_tabla             FOR COLUMN CNTRCTBL   VARCHAR(30)    NOT NULL,
    fecha_recepcion          FOR COLUMN CNTRCFRP   DATE,
    fecha_vencimiento        FOR COLUMN CNTRCFVE   DATE,
    monto_original           FOR COLUMN CNTRCMOR   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    saldo_pendiente          FOR COLUMN CNTRCSPD   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    tipo_documento           FOR COLUMN CNTRCTDO   VARCHAR(20),
    estado_operacion         FOR COLUMN CNTRCESO   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN CNTRCUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTRCUSA   VARCHAR(30),
    version_registro         FOR COLUMN CNTRCVRS   INT            NOT NULL
                                                   DEFAULT 1,
    observaciones            FOR COLUMN CNTRCOBS   VARCHAR(120),
    estado_registro          FOR COLUMN CNTRCERG   CHAR(1)        NOT NULL
                                                   DEFAULT 'A',
    created_at               FOR COLUMN CNTRCCAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTRCUAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLRCO PRIMARY KEY (codigo_banco, tipo_producto,
                                        numero_tabla)
)
RCDFMT CNTRLROR;

RENAME TABLE CNTRLRCO
    TO CNTRLRCO_TABLE FOR SYSTEM NAME CNTRRCO;

COMMENT ON TABLE CNTRLRCO IS
    'Tarifas y Cargos por Servicio de Cobranzas Documentarias - Modulo 6';

LABEL ON TABLE CNTRLRCO
    IS 'Tarifas Cobranzas';

COMMENT ON COLUMN CNTRLRCO.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tarifas de cobranza';
COMMENT ON COLUMN CNTRLRCO.tipo_producto IS
    'Tipo de producto de cobranza al que aplica esta tarifa';
COMMENT ON COLUMN CNTRLRCO.numero_tabla IS
    'Codigo que identifica la tabla de tarifas dentro del tipo de producto';
COMMENT ON COLUMN CNTRLRCO.fecha_recepcion IS
    'Fecha de recepcion u operacion de referencia de la tarifa';
COMMENT ON COLUMN CNTRLRCO.fecha_vencimiento IS
    'Fecha de vencimiento u operacion de referencia de la tarifa';
COMMENT ON COLUMN CNTRLRCO.monto_original IS
    'Monto original de referencia asociado a la tarifa';
COMMENT ON COLUMN CNTRLRCO.saldo_pendiente IS
    'Saldo pendiente de referencia asociado a la tarifa';
COMMENT ON COLUMN CNTRLRCO.tipo_documento IS
    'Tipo de documento al que aplica esta tabla de tarifas';
COMMENT ON COLUMN CNTRLRCO.estado_operacion IS
    'Estado de la tabla de tarifas: ACTIVA, VENCIDA, DEROGADA, EN_REVISION';
COMMENT ON COLUMN CNTRLRCO.usuario_creacion IS
    'Usuario administrador que registro la tabla de tarifas';
COMMENT ON COLUMN CNTRLRCO.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la tabla de tarifas';
COMMENT ON COLUMN CNTRLRCO.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLRCO.observaciones IS
    'Notas sobre condiciones especiales, excepciones o restricciones de la tarifa';
COMMENT ON COLUMN CNTRLRCO.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLRCO.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLRCO.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLRCO (
    codigo_banco             IS 'Banco',
    tipo_producto            IS 'Tipo Product',
    numero_tabla             IS 'No. Tabla',
    fecha_recepcion          IS 'Fec Recep',
    fecha_vencimiento        IS 'Fec Vencim',
    monto_original           IS 'Monto Orig',
    saldo_pendiente          IS 'Saldo Pend',
    tipo_documento           IS 'Tipo Doc',
    estado_operacion         IS 'Estado Oper',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN CNTRLRCO (
    codigo_banco             TEXT IS 'Codigo del banco propietario de la tarifa',
    tipo_producto            TEXT IS 'Tipo de producto de cobranza',
    numero_tabla             TEXT IS 'Codigo de la tabla de tarifas',
    fecha_recepcion          TEXT IS 'Fecha de recepcion de referencia',
    fecha_vencimiento        TEXT IS 'Fecha de vencimiento de referencia',
    monto_original           TEXT IS 'Monto original de referencia',
    saldo_pendiente          TEXT IS 'Saldo pendiente de referencia',
    tipo_documento           TEXT IS 'Tipo de documento al que aplica la tarifa',
    estado_operacion         TEXT IS 'Estado de la tabla de tarifas',
    usuario_creacion         TEXT IS 'Usuario que registro la tabla de tarifas',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas sobre condiciones de la tarifa',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX ICNTRCCAT ON CNTRLRCO (created_at);
