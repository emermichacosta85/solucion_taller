-- ================================================================
-- Nombre de la Tabla  : SWITF
-- DESCRIPCION         : Historico de Pagos y Recibidos via Swift
-- Objetivo            : Almacenar el historial completo de mensajes
--                       SWIFT procesados por el banco (enviados y
--                       recibidos), incluyendo el contenido del mensaje,
--                       el estado de cada etapa del ciclo de vida y la
--                       trazabilidad completa desde el envio hasta la
--                       confirmacion de liquidacion por el corresponsal.
-- Tipo de Tabla       : Historica / Auditoria
-- Origen de los Datos : Procesamiento de mensajes SWIFT entrantes
--                       y salientes por el modulo de corresponsalia
-- Permanencia de Datos: Historica (retener segun normativa regulatoria)
-- Uso de los datos    : Trazabilidad de pagos internacionales,
--                       conciliacion con corresponsales y auditoria
-- Restricciones       : FK hacia POSWF por (banco, numero_referencia)
--                       para vincular con la orden que origino el mensaje
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 12 Pagos y Transferencias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/SWITF (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN SWITFBNK,
    numero_referencia        VARCHAR(30)    NOT NULL     FOR COLUMN SWITFREF,
    formato_swift            VARCHAR(50)    NOT NULL     FOR COLUMN SWITFFMT,
    secuencia                INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN SWITFSEQ,
    tipo_mensaje             VARCHAR(10)                 FOR COLUMN SWITFTMS,
    sentido                  CHAR(1)        NOT NULL     FOR COLUMN SWITFSEN,
    codigo_bic_origen        VARCHAR(20)                 FOR COLUMN SWITFBCO,
    codigo_bic_destino       VARCHAR(20)                 FOR COLUMN SWITFBCD,
    fecha_operacion          DATE           NOT NULL     FOR COLUMN SWITFFOP,
    fecha_valor              DATE                        FOR COLUMN SWITFFVA,
    fecha_confirmacion       DATE                        FOR COLUMN SWITFFCO,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN SWITFMNT,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN SWITFMON,
    beneficiario             VARCHAR(80)                 FOR COLUMN SWITFBEN,
    banco_destino            VARCHAR(80)                 FOR COLUMN SWITFBDE,
    numero_uetr              VARCHAR(50)                 FOR COLUMN SWITFUET,
    contenido_mensaje        VARCHAR(500)                FOR COLUMN SWITFCMS,
    codigo_error             VARCHAR(20)                 FOR COLUMN SWITFCER,
    descripcion_error        VARCHAR(120)                FOR COLUMN SWITFDER,
    canal_pago               VARCHAR(20)                 FOR COLUMN SWITFCPA,
    estado_pago              VARCHAR(20)    NOT NULL     FOR COLUMN SWITFEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN SWITFUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN SWITFUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN SWITFVRS,
    observaciones            VARCHAR(120)                FOR COLUMN SWITFOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN SWITFERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN SWITFCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN SWITFUAT,
    CONSTRAINT PK_SWITF PRIMARY KEY (codigo_banco, numero_referencia,
                                     formato_swift, secuencia),
    CONSTRAINT FK_SWITF_POSWF FOREIGN KEY (codigo_banco, numero_referencia)
        REFERENCES HNEACOSTA1/POSWF (codigo_banco, numero_referencia)
)
RCDFMT SWITFR;

RENAME TABLE HNEACOSTA1/SWITF
    TO SWITF FOR SYSTEM NAME SWITF;

COMMENT ON TABLE HNEACOSTA1/SWITF IS
    'Historico de Mensajes SWIFT Enviados y Recibidos - Modulo 12';

LABEL ON TABLE HNEACOSTA1/SWITF
    IS 'Historico SWIFT';

COMMENT ON COLUMN HNEACOSTA1/SWITF.codigo_banco IS
    'Codigo del banco que envio o recibio el mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.numero_referencia IS
    'Numero de referencia de la orden de pago SWIFT asociada (FK POSWF)';
COMMENT ON COLUMN HNEACOSTA1/SWITF.formato_swift IS
    'Formato o version del mensaje SWIFT procesado';
COMMENT ON COLUMN HNEACOSTA1/SWITF.secuencia IS
    'Numero de secuencia para multiples mensajes de la misma referencia';
COMMENT ON COLUMN HNEACOSTA1/SWITF.tipo_mensaje IS
    'Tipo de mensaje SWIFT: MT103, MT202, MT199, MT900, MT910, MT940';
COMMENT ON COLUMN HNEACOSTA1/SWITF.sentido IS
    'Direccion del mensaje: E=Enviado (saliente), R=Recibido (entrante)';
COMMENT ON COLUMN HNEACOSTA1/SWITF.codigo_bic_origen IS
    'Codigo BIC del banco que origina o envia el mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.codigo_bic_destino IS
    'Codigo BIC del banco receptor del mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.fecha_operacion IS
    'Fecha de envio o recepcion del mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.fecha_valor IS
    'Fecha de valor incluida en el mensaje SWIFT para la liquidacion';
COMMENT ON COLUMN HNEACOSTA1/SWITF.fecha_confirmacion IS
    'Fecha en que el banco corresponsal confirmo la recepcion o liquidacion';
COMMENT ON COLUMN HNEACOSTA1/SWITF.monto IS
    'Monto de la transferencia incluido en el mensaje SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.codigo_moneda IS
    'Codigo ISO de la moneda del monto de la transferencia SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.beneficiario IS
    'Nombre del beneficiario final de la transferencia SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.banco_destino IS
    'Nombre del banco corresponsal destino de la transferencia';
COMMENT ON COLUMN HNEACOSTA1/SWITF.numero_uetr IS
    'Unique End-to-end Transaction Reference asignado por la red SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.contenido_mensaje IS
    'Extracto o resumen del contenido del mensaje SWIFT para trazabilidad';
COMMENT ON COLUMN HNEACOSTA1/SWITF.codigo_error IS
    'Codigo de error SWIFT en caso de rechazo o devolucion del mensaje';
COMMENT ON COLUMN HNEACOSTA1/SWITF.descripcion_error IS
    'Descripcion del error o motivo de rechazo reportado por la red SWIFT';
COMMENT ON COLUMN HNEACOSTA1/SWITF.canal_pago IS
    'Canal de la red SWIFT utilizado: FIN, GPI, SEPA, TARGET2';
COMMENT ON COLUMN HNEACOSTA1/SWITF.estado_pago IS
    'Estado del mensaje SWIFT: ENVIADO, RECIBIDO, CONFIRMADO, RECHAZADO, DEVUELTO';
COMMENT ON COLUMN HNEACOSTA1/SWITF.usuario_creacion IS
    'Usuario o proceso que registro el mensaje SWIFT en el historico';
COMMENT ON COLUMN HNEACOSTA1/SWITF.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/SWITF.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/SWITF.observaciones IS
    'Notas sobre el mensaje, incidencias de procesamiento o seguimiento';
COMMENT ON COLUMN HNEACOSTA1/SWITF.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/SWITF.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/SWITF.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/SWITF (
    codigo_banco             TEXT IS 'Banco',
    numero_referencia        TEXT IS 'No. Referenc',
    formato_swift            TEXT IS 'Formato',
    secuencia                TEXT IS 'Secuencia',
    tipo_mensaje             TEXT IS 'Tipo Msg',
    sentido                  TEXT IS 'E/R',
    codigo_bic_origen        TEXT IS 'BIC Origen',
    codigo_bic_destino       TEXT IS 'BIC Destino',
    fecha_operacion          TEXT IS 'Fec Oper',
    fecha_valor              TEXT IS 'Fec Valor',
    fecha_confirmacion       TEXT IS 'Fec Confirm',
    monto                    TEXT IS 'Monto',
    codigo_moneda            TEXT IS 'Moneda',
    beneficiario             TEXT IS 'Beneficiario',
    banco_destino            TEXT IS 'Banco Dest',
    numero_uetr              TEXT IS 'UETR',
    contenido_mensaje        TEXT IS 'Contenido',
    codigo_error             TEXT IS 'Cod Error',
    descripcion_error        TEXT IS 'Desc Error',
    canal_pago               TEXT IS 'Canal',
    estado_pago              TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ISWITFEST ON HNEACOSTA1/SWITF (estado_pago);
CREATE INDEX HNEACOSTA1/ISWITFFOP ON HNEACOSTA1/SWITF (fecha_operacion);
CREATE INDEX HNEACOSTA1/ISWITFCAT ON HNEACOSTA1/SWITF (created_at);
CREATE INDEX HNEACOSTA1/ISWITFUET ON HNEACOSTA1/SWITF (numero_uetr);

