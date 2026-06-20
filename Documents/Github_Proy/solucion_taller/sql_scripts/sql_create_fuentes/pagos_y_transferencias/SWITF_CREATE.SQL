-- ================================================================
-- Nombre de la Tabla  : SWITF
-- DESCRIPCION         : Historico de Pagos y Recibidos via Swift
-- Objetivo            : Almacenar el historial de mensajes SWIFT
--                       procesados por el banco (enviados y recibidos),
--                       con trazabilidad del ciclo de vida, conforme a la
--                       estructura definida en estructura_bd.md (Modulo 12).
-- Tipo de Tabla       : Historica / Auditoria
-- Origen de los Datos : Procesamiento de mensajes SWIFT entrantes
--                       y salientes por el modulo de corresponsalia
-- Permanencia de Datos: Historica (retener segun normativa regulatoria)
-- Uso de los datos    : Trazabilidad de pagos internacionales,
--                       conciliacion con corresponsales y auditoria
-- Restricciones       : PK compuesta (codigo_banco, numero_referencia,
--                       formato_swift). Sin FK segun estructura_bd.md.
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE SWITF (
    codigo_banco             FOR COLUMN SWITFBNK   VARCHAR(20)    NOT NULL,
    numero_referencia        FOR COLUMN SWITFREF   VARCHAR(30)    NOT NULL,
    formato_swift            FOR COLUMN SWITFFMT   VARCHAR(50)    NOT NULL,
    fecha_operacion          FOR COLUMN SWITFFOP   DATE           NOT NULL,
    monto                    FOR COLUMN SWITFMNT   DECIMAL(18,2)  NOT NULL
                                                   WITH DEFAULT 0,
    beneficiario             FOR COLUMN SWITFBEN   VARCHAR(80),
    banco_destino            FOR COLUMN SWITFBDE   VARCHAR(80),
    canal_pago               FOR COLUMN SWITFCPA   VARCHAR(20),
    estado_pago              FOR COLUMN SWITFEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN SWITFUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN SWITFUSA   VARCHAR(30),
    version_registro         FOR COLUMN SWITFVRS   INT            NOT NULL
                                                   WITH DEFAULT 1,
    observaciones            FOR COLUMN SWITFOBS   VARCHAR(120),
    estado_registro          FOR COLUMN SWITFERG   CHAR(1)        NOT NULL
                                                   WITH DEFAULT 'A',
    created_at               FOR COLUMN SWITFCAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN SWITFUAT   TIMESTAMP      NOT NULL
                                                   WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_SWITF PRIMARY KEY (codigo_banco, numero_referencia,
                                     formato_swift)
)
RCDFMT SWITFR;

RENAME TABLE SWITF
    TO SWITF_TABLE FOR SYSTEM NAME SWITF;

COMMENT ON TABLE SWITF IS
    'Historico de Mensajes SWIFT Enviados y Recibidos - Modulo 12';

LABEL ON TABLE SWITF
    IS 'Historico SWIFT';

COMMENT ON COLUMN SWITF.codigo_banco IS
    'Codigo del banco que envio o recibio el mensaje SWIFT';
COMMENT ON COLUMN SWITF.numero_referencia IS
    'Numero de referencia de la orden de pago SWIFT asociada';
COMMENT ON COLUMN SWITF.formato_swift IS
    'Formato o version del mensaje SWIFT procesado';
COMMENT ON COLUMN SWITF.fecha_operacion IS
    'Fecha de envio o recepcion del mensaje SWIFT';
COMMENT ON COLUMN SWITF.monto IS
    'Monto de la transferencia incluido en el mensaje SWIFT';
COMMENT ON COLUMN SWITF.beneficiario IS
    'Nombre del beneficiario final de la transferencia SWIFT';
COMMENT ON COLUMN SWITF.banco_destino IS
    'Nombre del banco corresponsal destino de la transferencia';
COMMENT ON COLUMN SWITF.canal_pago IS
    'Canal de la red SWIFT utilizado: FIN, GPI, SEPA, TARGET2';
COMMENT ON COLUMN SWITF.estado_pago IS
    'Estado del mensaje SWIFT: ENVIADO, RECIBIDO, CONFIRMADO, RECHAZADO, DEVUELTO';
COMMENT ON COLUMN SWITF.usuario_creacion IS
    'Usuario o proceso que registro el mensaje SWIFT en el historico';
COMMENT ON COLUMN SWITF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN SWITF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN SWITF.observaciones IS
    'Notas sobre el mensaje, incidencias de procesamiento o seguimiento';
COMMENT ON COLUMN SWITF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN SWITF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN SWITF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN SWITF (
    codigo_banco             IS 'Banco',
    numero_referencia        IS 'No. Referenc',
    formato_swift            IS 'Formato',
    fecha_operacion          IS 'Fec Oper',
    monto                    IS 'Monto',
    beneficiario             IS 'Beneficiario',
    banco_destino            IS 'Banco Dest',
    canal_pago               IS 'Canal',
    estado_pago              IS 'Estado',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN SWITF (
    codigo_banco             TEXT IS 'Banco que envio o recibio el mensaje',
    numero_referencia        TEXT IS 'Referencia de la orden SWIFT asociada',
    formato_swift            TEXT IS 'Formato o version del mensaje SWIFT',
    fecha_operacion          TEXT IS 'Fecha de envio o recepcion del mensaje',
    monto                    TEXT IS 'Monto incluido en el mensaje SWIFT',
    beneficiario             TEXT IS 'Beneficiario final de la transferencia',
    banco_destino            TEXT IS 'Banco corresponsal destino',
    canal_pago               TEXT IS 'Canal de la red SWIFT utilizado',
    estado_pago              TEXT IS 'Estado del mensaje SWIFT',
    usuario_creacion         TEXT IS 'Usuario o proceso que registro el mensaje',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas o incidencias de procesamiento',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX ISWITFCAT ON SWITF (created_at);
