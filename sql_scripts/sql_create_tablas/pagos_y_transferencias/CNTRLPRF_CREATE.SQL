-- ================================================================
-- Nombre de la Tabla  : CNTRLPRF
-- DESCRIPCION         : Archivo de Control de Pagos y Recibos
-- Objetivo            : Almacenar los parametros de configuracion del
--                       modulo de pagos y transferencias por banco,
--                       conforme a la estructura definida en
--                       estructura_bd.md (Modulo 12).
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion del modulo por sistemas y
--                       el area de operaciones internacionales
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Referencia en los procesos del modulo para
--                       validaciones y parametros globales
-- Restricciones       : PK compuesta (codigo_banco, parametro,
--                       codigo_tabla). Tabla raiz parametrica del modulo.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE CNTRLPRF (
    codigo_banco             FOR COLUMN CNTPRBNK   VARCHAR(20)    NOT NULL,
    parametro                FOR COLUMN CNTPRPAR   VARCHAR(20)    NOT NULL,
    codigo_tabla             FOR COLUMN CNTPRTBL   VARCHAR(20)    NOT NULL,
    fecha_operacion          FOR COLUMN CNTPRFOP   DATE,
    monto                    FOR COLUMN CNTPRMNT   DECIMAL(18,2)  NOT NULL
                                                   WITH DEFAULT 0,
    beneficiario             FOR COLUMN CNTPRBEN   VARCHAR(80),
    banco_destino            FOR COLUMN CNTPRBDE   VARCHAR(80),
    canal_pago               FOR COLUMN CNTPRCPA   VARCHAR(20),
    estado_pago              FOR COLUMN CNTPREST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN CNTPRUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTPRUSA   VARCHAR(30),
    version_registro         FOR COLUMN CNTPRVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN CNTPROBS   VARCHAR(120),
    estado_registro          FOR COLUMN CNTPRERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN CNTPRCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTPRUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLPRF PRIMARY KEY (codigo_banco, parametro,
                                        codigo_tabla)
)
RCDFMT CNTPRFR;

RENAME TABLE CNTRLPRF
    TO CNTRLPRF_TABLE FOR SYSTEM NAME CNTRLPRF;

COMMENT ON TABLE CNTRLPRF IS
    'Parametros de Control de Pagos y Transferencias - Modulo 12';

LABEL ON TABLE CNTRLPRF
    IS 'Control Pagos Transf';

COMMENT ON COLUMN CNTRLPRF.codigo_banco IS
    'Codigo del banco al que pertenece la configuracion de pagos';
COMMENT ON COLUMN CNTRLPRF.parametro IS
    'Nombre o codigo del parametro de control (ej: SWIFT_BIC, LIMITE_DIARIO)';
COMMENT ON COLUMN CNTRLPRF.codigo_tabla IS
    'Tabla o seccion a la que pertenece el parametro para organizacion';
COMMENT ON COLUMN CNTRLPRF.fecha_operacion IS
    'Fecha de operacion o vigencia asociada al parametro de control';
COMMENT ON COLUMN CNTRLPRF.monto IS
    'Monto de referencia o limite asociado al parametro de control';
COMMENT ON COLUMN CNTRLPRF.beneficiario IS
    'Beneficiario de referencia asociado al parametro cuando aplica';
COMMENT ON COLUMN CNTRLPRF.banco_destino IS
    'Banco destino de referencia asociado al parametro cuando aplica';
COMMENT ON COLUMN CNTRLPRF.canal_pago IS
    'Canal de pago al que aplica este parametro de control';
COMMENT ON COLUMN CNTRLPRF.estado_pago IS
    'Estado del parametro: ACTIVO, INACTIVO, EN_REVISION, DEROGADO';
COMMENT ON COLUMN CNTRLPRF.usuario_creacion IS
    'Usuario administrador que registro el parametro';
COMMENT ON COLUMN CNTRLPRF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del parametro';
COMMENT ON COLUMN CNTRLPRF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLPRF.observaciones IS
    'Notas sobre el parametro, su uso o restricciones de aplicacion';
COMMENT ON COLUMN CNTRLPRF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLPRF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLPRF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLPRF (
    codigo_banco             IS 'Banco',
    parametro                IS 'Parametro',
    codigo_tabla             IS 'Cod Tabla',
    fecha_operacion          IS 'Fec Oper',
    monto                    IS 'Monto',
    beneficiario             IS 'Beneficiario',
    banco_destino            IS 'Banco Dest',
    canal_pago               IS 'Canal Pago',
    estado_pago              IS 'Estado',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN CNTRLPRF (
    codigo_banco             TEXT IS 'Banco propietario de la configuracion',
    parametro                TEXT IS 'Codigo del parametro de control',
    codigo_tabla             TEXT IS 'Tabla o seccion del parametro',
    fecha_operacion          TEXT IS 'Fecha de operacion o vigencia',
    monto                    TEXT IS 'Monto de referencia o limite',
    beneficiario             TEXT IS 'Beneficiario de referencia del parametro',
    banco_destino            TEXT IS 'Banco destino de referencia',
    canal_pago               TEXT IS 'Canal de pago al que aplica el parametro',
    estado_pago              TEXT IS 'Estado del parametro de control',
    usuario_creacion         TEXT IS 'Usuario que registro el parametro',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas sobre el uso del parametro',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX ICNTPRCAT ON CNTRLPRF (created_at);
