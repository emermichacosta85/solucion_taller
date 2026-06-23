-- ================================================================
-- Nombre de la Tabla  : DCMST
-- DESCRIPCION         : Maestro de Cobranzas Documentarias
-- Objetivo            : Centralizar la informacion de las cobranzas
--                       documentarias gestionadas por el banco,
--                       registrando montos, vencimientos y estado de
--                       gestion hasta su liquidacion, conforme a la
--                       estructura definida en estructura_bd.md (Modulo 6).
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Recepcion de documentos de cobranza de bancos
--                       corresponsales o clientes exportadores
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Gestion de cobro, seguimiento de vencimientos
--                       y conciliacion de operaciones de cobranza
-- Restricciones       : PK tecnica simple (id BIGINT). Sin FK intramodulo
--                       segun estructura_bd.md (DCMST no declara FK).
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE DCMST (
    id                       FOR COLUMN DCMSTID    BIGINT         NOT NULL,
    fecha_recepcion          FOR COLUMN DCMSTFRP   DATE,
    fecha_vencimiento        FOR COLUMN DCMSTFVE   DATE,
    monto_original           FOR COLUMN DCMSTMOR   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    saldo_pendiente          FOR COLUMN DCMSTSPD   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    tipo_documento           FOR COLUMN DCMSTTDO   VARCHAR(20),
    estado_operacion         FOR COLUMN DCMSTESO   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN DCMSTUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN DCMSTUSA   VARCHAR(30),
    version_registro         FOR COLUMN DCMSTVRS   INT            NOT NULL
                                                   DEFAULT 1,
    observaciones            FOR COLUMN DCMSTOBS   VARCHAR(120),
    estado_registro          FOR COLUMN DCMSTERG   CHAR(1)        NOT NULL
                                                   DEFAULT 'A',
    created_at               FOR COLUMN DCMSTCAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN DCMSTUAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DCMST PRIMARY KEY (id)
)
RCDFMT DCMSTR;

RENAME TABLE DCMST
    TO DCMST_TABLE FOR SYSTEM NAME DCMST;

COMMENT ON TABLE DCMST IS
    'Maestro de Cobranzas Documentarias - Modulo 6 Cobranzas';

LABEL ON TABLE DCMST
    IS 'Maestro Cobranzas Doc';

COMMENT ON COLUMN DCMST.id IS
    'Identificador tecnico unico de la cobranza documentaria';
COMMENT ON COLUMN DCMST.fecha_recepcion IS
    'Fecha en que el banco recibio los documentos de la cobranza';
COMMENT ON COLUMN DCMST.fecha_vencimiento IS
    'Fecha limite para que el girado acepte o pague la cobranza';
COMMENT ON COLUMN DCMST.monto_original IS
    'Monto total de la cobranza segun los documentos recibidos';
COMMENT ON COLUMN DCMST.saldo_pendiente IS
    'Saldo aun no cobrado de la cobranza documentaria';
COMMENT ON COLUMN DCMST.tipo_documento IS
    'Tipo de documento principal: LETRA, PAGARE, FACTURA, GIRO, OTRO';
COMMENT ON COLUMN DCMST.estado_operacion IS
    'Estado de la cobranza: PENDIENTE, ACEPTADA, PAGADA, PROTESTADA, DEVUELTA';
COMMENT ON COLUMN DCMST.usuario_creacion IS
    'Usuario del sistema que registro la cobranza';
COMMENT ON COLUMN DCMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN DCMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DCMST.observaciones IS
    'Notas operativas o condiciones especiales de la cobranza';
COMMENT ON COLUMN DCMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DCMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DCMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DCMST (
    id                       IS 'ID Cobranza',
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

LABEL ON COLUMN DCMST (
    id                       TEXT IS 'Identificador tecnico unico de la cobranza',
    fecha_recepcion          TEXT IS 'Fecha de recepcion de los documentos',
    fecha_vencimiento        TEXT IS 'Fecha de vencimiento de la cobranza',
    monto_original           TEXT IS 'Monto total original de la cobranza',
    saldo_pendiente          TEXT IS 'Saldo pendiente de cobro',
    tipo_documento           TEXT IS 'Tipo de documento principal de la cobranza',
    estado_operacion         TEXT IS 'Estado operativo de la cobranza',
    usuario_creacion         TEXT IS 'Usuario que registro la cobranza',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas operativas de la cobranza',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IDCMSTCAT ON DCMST (created_at);
