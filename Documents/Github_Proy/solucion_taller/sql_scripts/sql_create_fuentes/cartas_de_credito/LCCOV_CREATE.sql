-- =============================================================================
-- Nombre de la Tabla  : LCCOV
-- DESCRIPCION         : Negociaciones de Cartas de Credito. Registra cada evento
--                       de negociacion o pago realizado sobre la carta.
-- Objetivo            : Almacenar el historial de negociaciones y utilizaciones de cada carta
--                       de credito, permitiendo calcular el saldo disponible
--                       y controlar los pagos realizados al beneficiario.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Proceso de negociacion y utilizacion de cartas de credito
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Calculo de saldos, control de utilizaciones y reporteria de operaciones
-- Restricciones       : FK hacia LCMST por numero_carta_credito.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCCOV (
    numero_carta_credito    VARCHAR(30)     NOT NULL    FOR COLUMN LCCOVNCC,
    secuencia               INT             NOT NULL    FOR COLUMN LCCOVSEQ,
    tipo_negociacion        VARCHAR(20)                 FOR COLUMN LCCOVTNG,
    monto_negociado         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCCOVMNG,
    fecha_negociacion       DATE                        FOR COLUMN LCCOVFNG,
    fecha_valor             DATE                        FOR COLUMN LCCOVFVL,
    banco_negociador        VARCHAR(80)                 FOR COLUMN LCCOVBNG,
    referencia_negociacion  VARCHAR(50)                 FOR COLUMN LCCOVREF,
    estado_negociacion      VARCHAR(20)                 FOR COLUMN LCCOVEST,
    fecha_emision           DATE                        FOR COLUMN LCCOVFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCCOVFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCCOVMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCCOVSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCCOVBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCCOVPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCCOVEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCCOVUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCCOVUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCCOVVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCCOVOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCCOVERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCCOVCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCCOVUAT,
    CONSTRAINT PK_LCCOV PRIMARY KEY (numero_carta_credito, secuencia),
    CONSTRAINT FK_LCCOV_LCMST FOREIGN KEY (numero_carta_credito)
        REFERENCES HNEACOSTA1/LCMST (numero_carta_credito)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT LCCOVR;

RENAME TABLE HNEACOSTA1/LCCOV
    TO LCCOV FOR SYSTEM NAME LCCOV;

COMMENT ON TABLE HNEACOSTA1/LCCOV IS
    'Negociaciones de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCCOV
    IS 'Negociaciones LC';

COMMENT ON COLUMN HNEACOSTA1/LCCOV.numero_carta_credito IS
    'Numero de la carta de credito que se negocia (FK LCMST)';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.secuencia IS
    'Numero de secuencia de la negociacion dentro de la carta';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.tipo_negociacion IS
    'Tipo de negociacion: PAGO_VISTA, ACEPTACION, DIFERIDO, NEGOCIACION';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.monto_negociado IS
    'Monto efectivamente negociado en esta operacion';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.fecha_negociacion IS
    'Fecha en que se realizo la negociacion de la carta';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.fecha_valor IS
    'Fecha valor para la acreditacion de fondos al beneficiario';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.banco_negociador IS
    'Nombre del banco que realiza la negociacion de la carta';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.referencia_negociacion IS
    'Referencia interna del banco negociador para la operacion';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.estado_negociacion IS
    'Estado de la negociacion: PENDIENTE, PROCESADA, PAGADA, RECHAZADA';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCCOV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCCOV (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    secuencia                    TEXT IS 'Secuencia',
    tipo_negociacion             TEXT IS 'Tipo Negoc',
    monto_negociado              TEXT IS 'Mto Negociado',
    fecha_negociacion            TEXT IS 'Fec Negoc',
    fecha_valor                  TEXT IS 'Fec Valor',
    banco_negociador             TEXT IS 'Banco Negoc',
    referencia_negociacion       TEXT IS 'Ref Negoc',
    estado_negociacion           TEXT IS 'Estado Negoc',
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

CREATE INDEX HNEACOSTA1/ILCCOVNCC ON HNEACOSTA1/LCCOV (numero_carta_credito);
CREATE INDEX HNEACOSTA1/ILCCOVFNG ON HNEACOSTA1/LCCOV (fecha_negociacion);
CREATE INDEX HNEACOSTA1/ILCCOVCAT ON HNEACOSTA1/LCCOV (created_at);

-- =============================================================================
-- Fin de script: LCCOV_CREATE.sql
-- =============================================================================
