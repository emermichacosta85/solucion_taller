-- ================================================================
-- Nombre de la Tabla  : APPRV
-- DESCRIPCION         : Cobranzas Pendientes de Aprobacion
-- Objetivo            : Registrar las cobranzas o transacciones de cartas
--                       de credito que requieren aprobacion interna antes
--                       de ser procesadas, conforme a la estructura
--                       definida en estructura_bd.md (Modulo 6).
-- Tipo de Tabla       : Transaccional / Control de Flujo
-- Origen de los Datos : Proceso de recepcion y validacion de cobranzas
-- Permanencia de Datos: Transitoria hasta aprobacion; luego historica
-- Uso de los datos    : Control de autorizaciones y auditoria de aprobaciones
-- Restricciones       : PK compuesta (numero_carta_credito, tipo_registro).
--                       FK numero_carta_credito hacia LCMST
--                       (segun ERD: LCMST ||--o{ APPRV).
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE APPRV (
    numero_carta_credito     FOR COLUMN APPRVNCC   VARCHAR(30)    NOT NULL,
    tipo_registro            FOR COLUMN APPRVTRG   VARCHAR(20)    NOT NULL,
    fecha_recepcion          FOR COLUMN APPRVFRP   DATE,
    fecha_vencimiento        FOR COLUMN APPRVFVE   DATE,
    monto_original           FOR COLUMN APPRVMOR   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    saldo_pendiente          FOR COLUMN APPRVSPD   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    tipo_documento           FOR COLUMN APPRVTDO   VARCHAR(20),
    estado_operacion         FOR COLUMN APPRVESO   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN APPRVUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN APPRVUSA   VARCHAR(30),
    version_registro         FOR COLUMN APPRVVRS   INT            NOT NULL
                                                   DEFAULT 1,
    observaciones            FOR COLUMN APPRVOBS   VARCHAR(120),
    estado_registro          FOR COLUMN APPRVERG   CHAR(1)        NOT NULL
                                                   DEFAULT 'A',
    created_at               FOR COLUMN APPRVCAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN APPRVUAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_APPRV PRIMARY KEY (numero_carta_credito, tipo_registro)
    --CONSTRAINT FK_APPRV_LCMST FOREIGN KEY (numero_carta_credito)
    --    REFERENCES LCMST (numero_carta_credito)
)
RCDFMT APPRVR;

RENAME TABLE APPRV
    TO APPRV_TABLE FOR SYSTEM NAME APPRV;

COMMENT ON TABLE APPRV IS
    'Cobranzas Pendientes de Aprobacion - Modulo 6 Cobranzas';

LABEL ON TABLE APPRV
    IS 'Pend Aprobacion Cobran';

COMMENT ON COLUMN APPRV.numero_carta_credito IS
    'Numero de carta de credito o cobranza asociada que requiere aprobacion (FK LCMST)';
COMMENT ON COLUMN APPRV.tipo_registro IS
    'Tipo de registro de aprobacion: PAGO, NEGOCIACION, ENMIENDA, DEVOLUCION';
COMMENT ON COLUMN APPRV.fecha_recepcion IS
    'Fecha de recepcion del documento original de cobranza';
COMMENT ON COLUMN APPRV.fecha_vencimiento IS
    'Fecha limite de la carta de credito o cobranza asociada';
COMMENT ON COLUMN APPRV.monto_original IS
    'Monto total original de la carta de credito o cobranza vinculada';
COMMENT ON COLUMN APPRV.saldo_pendiente IS
    'Saldo pendiente de la operacion al momento del registro';
COMMENT ON COLUMN APPRV.tipo_documento IS
    'Tipo de documento presentado que origina la solicitud de aprobacion';
COMMENT ON COLUMN APPRV.estado_operacion IS
    'Estado del proceso de aprobacion: PENDIENTE, APROBADO, RECHAZADO, ANULADO';
COMMENT ON COLUMN APPRV.usuario_creacion IS
    'Usuario que registro la solicitud de aprobacion';
COMMENT ON COLUMN APPRV.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN APPRV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN APPRV.observaciones IS
    'Notas adicionales sobre la solicitud de aprobacion o sus condiciones';
COMMENT ON COLUMN APPRV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN APPRV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN APPRV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN APPRV (
    numero_carta_credito     IS 'No. Carta Cred',
    tipo_registro            IS 'Tipo Reg',
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

LABEL ON COLUMN APPRV (
    numero_carta_credito     TEXT IS 'Numero de carta de credito asociada (FK LCMST)',
    tipo_registro            TEXT IS 'Tipo de registro de aprobacion',
    fecha_recepcion          TEXT IS 'Fecha de recepcion del documento',
    fecha_vencimiento        TEXT IS 'Fecha de vencimiento de la operacion',
    monto_original           TEXT IS 'Monto total original de la operacion',
    saldo_pendiente          TEXT IS 'Saldo pendiente al momento del registro',
    tipo_documento           TEXT IS 'Tipo de documento que origina la aprobacion',
    estado_operacion         TEXT IS 'Estado del proceso de aprobacion',
    usuario_creacion         TEXT IS 'Usuario que registro la solicitud',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas sobre la solicitud de aprobacion',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX IAPPRVCAT ON APPRV (created_at);
