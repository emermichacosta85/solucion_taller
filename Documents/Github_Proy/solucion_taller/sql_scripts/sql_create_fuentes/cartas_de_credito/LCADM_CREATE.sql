-- =============================================================================
-- Nombre de la Tabla  : LCADM
-- DESCRIPCION         : Enmiendas a Cartas de Credito. Registra cada modificacion
--                       aplicada a una carta de credito durante su vigencia.
-- Objetivo            : Controlar el historial de enmiendas de cada carta de credito,
--                       registrando cambios de monto, plazo, documentos
--                       y condiciones aprobados por las partes.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Solicitudes de enmienda procesadas por el area de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Trazabilidad de cambios, reporteria regulatoria y auditoria de operaciones
-- Restricciones       : FK hacia LCMST por numero_carta_credito.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCADM (
    numero_carta_credito    VARCHAR(30)     NOT NULL    FOR COLUMN LCADMNCC,
    numero_enmienda         VARCHAR(30)     NOT NULL    FOR COLUMN LCADMNEN,
    tipo_enmienda           VARCHAR(20)                 FOR COLUMN LCADMTEN,
    descripcion_enmienda    VARCHAR(120)                FOR COLUMN LCADMDES,
    monto_incremento        DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCADMMIN,
    nueva_fecha_vencimiento DATE                        FOR COLUMN LCADMNFV,
    estado_enmienda         VARCHAR(20)                 FOR COLUMN LCADMEST,
    fecha_notificacion      DATE                        FOR COLUMN LCADMFNO,
    fecha_emision           DATE                        FOR COLUMN LCADMFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCADMFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCADMMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCADMSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCADMBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCADMPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCADMEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCADMUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCADMUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCADMVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCADMOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCADMERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCADMCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCADMUAT,
    CONSTRAINT PK_LCADM PRIMARY KEY (numero_carta_credito, numero_enmienda),
    CONSTRAINT FK_LCADM_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT LCADMR;

RENAME TABLE HNEACOSTA1/LCADM
    TO LCADM FOR SYSTEM NAME LCADM;

COMMENT ON TABLE HNEACOSTA1/LCADM IS
    'Enmiendas a Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCADM
    IS 'Enmiendas Carta Cred';

COMMENT ON COLUMN HNEACOSTA1/LCADM.numero_carta_credito IS
    'Numero de la carta de credito a la que aplica la enmienda (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/LCADM.numero_enmienda IS
    'Numero correlativo de la enmienda dentro de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCADM.tipo_enmienda IS
    'Tipo de enmienda: MONTO, FECHA, DOCUMENTOS, CONDICIONES, BENEFICIARIO';
COMMENT ON COLUMN HNEACOSTA1/LCADM.descripcion_enmienda IS
    'Descripcion detallada de los cambios introducidos por la enmienda';
COMMENT ON COLUMN HNEACOSTA1/LCADM.monto_incremento IS
    'Incremento o decremento del monto aplicado por la enmienda';
COMMENT ON COLUMN HNEACOSTA1/LCADM.nueva_fecha_vencimiento IS
    'Nueva fecha de vencimiento de la carta si la enmienda modifica el plazo';
COMMENT ON COLUMN HNEACOSTA1/LCADM.estado_enmienda IS
    'Estado de la enmienda: SOLICITADA, APROBADA, RECHAZADA, APLICADA';
COMMENT ON COLUMN HNEACOSTA1/LCADM.fecha_notificacion IS
    'Fecha en que la enmienda fue notificada al banco corresponsal';
COMMENT ON COLUMN HNEACOSTA1/LCADM.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCADM.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCADM.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCADM.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCADM.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCADM.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCADM.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCADM.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCADM.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCADM.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCADM.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCADM.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCADM.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCADM.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCADM (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    numero_enmienda              TEXT IS 'No. Enmienda',
    tipo_enmienda                TEXT IS 'Tipo Enmienda',
    descripcion_enmienda         TEXT IS 'Desc Enmienda',
    monto_incremento             TEXT IS 'Mto Increment',
    nueva_fecha_vencimiento      TEXT IS 'Nueva Fec Vto',
    estado_enmienda              TEXT IS 'Estado Enmien',
    fecha_notificacion           TEXT IS 'Fec Notific',
    fecha_emision                TEXT IS 'Fec Emision',
    fecha_vencimiento            TEXT IS 'Fec Vencim',
    monto_original               TEXT IS 'Monto Orig',
    saldo_actual                 TEXT IS 'Saldo Actual',
    banco_corresponsal           TEXT IS 'Banco Corresp',
    pais_destino                 TEXT IS 'Pais Destino',
    estado_carta                 TEXT IS 'Estado Carta',
    usuario_creacion             TEXT IS 'Usr Creacion',
    usuario_actualizacion        TEXT IS 'Usr Actualiz',
    version_registro             TEXT IS 'Version Reg',
    observaciones                TEXT IS 'Observacion',
    estado_registro              TEXT IS 'Estado Reg',
    created_at                   TEXT IS 'Fec Creacion',
    updated_at                   TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ILCADMNCC ON HNEACOSTA1/LCADM (numero_carta_credito);
CREATE INDEX HNEACOSTA1/ILCADMCAT ON HNEACOSTA1/LCADM (created_at);

-- =============================================================================
-- Fin de script: LCADM_CREATE.sql
-- =============================================================================
