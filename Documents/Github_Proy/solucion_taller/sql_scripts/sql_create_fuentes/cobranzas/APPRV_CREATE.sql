-- ================================================================
-- Nombre de la Tabla  : APPRV
-- DESCRIPCION         : Cobranzas Pendientes de Aprobacion
-- Objetivo            : Registrar las cobranzas documentarias o transacciones
--                       de cartas de credito que requieren aprobacion
--                       interna antes de ser procesadas, permitiendo el
--                       flujo de autorizacion por niveles.
-- Tipo de Tabla       : Transaccional / Control de Flujo
-- Origen de los Datos : Proceso de recepcion y validacion de cobranzas
-- Permanencia de Datos: Transitoria hasta aprobacion; luego historica
-- Uso de los datos    : Control de autorizaciones, auditoria de aprobaciones
-- Restricciones       : FK hacia LCMST por numero_carta_credito
--                       (segun ERD: LCMST ||--o{ APPRV)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/APPRV (
    numero_carta_credito     VARCHAR(30)    NOT NULL     FOR COLUMN APPRVNCC,
    tipo_registro            VARCHAR(20)    NOT NULL     FOR COLUMN APPRVTRG,
    secuencia                INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN APPRVSEQ,
    tipo_aprobacion          VARCHAR(20)                 FOR COLUMN APPRVTAP,
    monto_a_aprobar          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN APPRVMAA,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN APPRVMON,
    nivel_aprobacion         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN APPRVNAP,
    usuario_aprobador        VARCHAR(30)                 FOR COLUMN APPRVUAP,
    fecha_solicitud          DATE                        FOR COLUMN APPRVFSO,
    fecha_aprobacion         DATE                        FOR COLUMN APPRVFAP,
    fecha_recepcion          DATE                        FOR COLUMN APPRVFRP,
    fecha_vencimiento        DATE                        FOR COLUMN APPRVFVE,
    monto_original           DECIMAL(18,2)               FOR COLUMN APPRVMOR,
    saldo_pendiente          DECIMAL(18,2)               FOR COLUMN APPRVSPD,
    tipo_documento           VARCHAR(20)                 FOR COLUMN APPRVTDO,
    estado_operacion         VARCHAR(20)    NOT NULL     FOR COLUMN APPRVESO,
    comentario_aprobacion    VARCHAR(120)                FOR COLUMN APPRVCOM,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN APPRVUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN APPRVUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN APPRVVRS,
    observaciones            VARCHAR(120)                FOR COLUMN APPRVOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN APPRVERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN APPRVCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN APPRVUAT,
    CONSTRAINT PK_APPRV PRIMARY KEY (numero_carta_credito,
                                     tipo_registro, secuencia),
    CONSTRAINT FK_APPRV_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
)
RCDFMT APPRVR;

RENAME TABLE HNEACOSTA1/APPRV
    TO APPRV FOR SYSTEM NAME APPRV;

COMMENT ON TABLE HNEACOSTA1/APPRV IS
    'Cobranzas Pendientes de Aprobacion - Modulo 6 Cobranzas';

LABEL ON TABLE HNEACOSTA1/APPRV
    IS 'Pend Aprobacion Cobran';

COMMENT ON COLUMN HNEACOSTA1/APPRV.numero_carta_credito IS
    'Numero de carta de credito o cobranza asociada que requiere aprobacion (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/APPRV.tipo_registro IS
    'Tipo de registro de aprobacion: PAGO, NEGOCIACION, ENMIENDA, DEVOLUCION';
COMMENT ON COLUMN HNEACOSTA1/APPRV.secuencia IS
    'Numero de secuencia para multiples pendientes sobre el mismo documento';
COMMENT ON COLUMN HNEACOSTA1/APPRV.tipo_aprobacion IS
    'Tipo de proceso que requiere aprobacion: OPERATIVO, FINANCIERO, LEGAL';
COMMENT ON COLUMN HNEACOSTA1/APPRV.monto_a_aprobar IS
    'Monto de la transaccion que se somete al proceso de aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.codigo_moneda IS
    'Codigo ISO de la moneda del monto sometido a aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.nivel_aprobacion IS
    'Nivel jerarquico requerido para la aprobacion segun monto y tipo';
COMMENT ON COLUMN HNEACOSTA1/APPRV.usuario_aprobador IS
    'Usuario que realizo o tiene asignada la aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.fecha_solicitud IS
    'Fecha en que se genero la solicitud de aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.fecha_aprobacion IS
    'Fecha en que fue otorgada o denegada la aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.fecha_recepcion IS
    'Fecha de recepcion del documento original de cobranza';
COMMENT ON COLUMN HNEACOSTA1/APPRV.fecha_vencimiento IS
    'Fecha limite de la carta de credito o cobranza asociada';
COMMENT ON COLUMN HNEACOSTA1/APPRV.monto_original IS
    'Monto total original de la carta de credito o cobranza vinculada';
COMMENT ON COLUMN HNEACOSTA1/APPRV.saldo_pendiente IS
    'Saldo pendiente de la carta de credito o cobranza al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/APPRV.tipo_documento IS
    'Tipo de documento presentado que origina la solicitud de aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.estado_operacion IS
    'Estado del proceso de aprobacion: PENDIENTE, APROBADO, RECHAZADO, ANULADO';
COMMENT ON COLUMN HNEACOSTA1/APPRV.comentario_aprobacion IS
    'Comentario o justificacion del aprobador al otorgar o denegar la aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.usuario_creacion IS
    'Usuario que registro la solicitud de aprobacion';
COMMENT ON COLUMN HNEACOSTA1/APPRV.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/APPRV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/APPRV.observaciones IS
    'Notas adicionales sobre la solicitud de aprobacion o sus condiciones';
COMMENT ON COLUMN HNEACOSTA1/APPRV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/APPRV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/APPRV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/APPRV (
    numero_carta_credito     TEXT IS 'No. Carta Cred',
    tipo_registro            TEXT IS 'Tipo Reg',
    secuencia                TEXT IS 'Secuencia',
    tipo_aprobacion          TEXT IS 'Tipo Aprob',
    monto_a_aprobar          TEXT IS 'Mto Aprobar',
    codigo_moneda            TEXT IS 'Moneda',
    nivel_aprobacion         TEXT IS 'Nivel Aprob',
    usuario_aprobador        TEXT IS 'Aprobador',
    fecha_solicitud          TEXT IS 'Fec Solicitud',
    fecha_aprobacion         TEXT IS 'Fec Aprobac',
    fecha_recepcion          TEXT IS 'Fec Recep',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    tipo_documento           TEXT IS 'Tipo Doc',
    estado_operacion         TEXT IS 'Estado Oper',
    comentario_aprobacion    TEXT IS 'Comentario',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IAPPRVNCC ON HNEACOSTA1/APPRV (numero_carta_credito);
CREATE INDEX HNEACOSTA1/IAPPRVCAT ON HNEACOSTA1/APPRV (created_at);
CREATE INDEX HNEACOSTA1/IAPPRVESO ON HNEACOSTA1/APPRV (estado_operacion);
CREATE INDEX HNEACOSTA1/IAPPRVFSO ON HNEACOSTA1/APPRV (fecha_solicitud);
