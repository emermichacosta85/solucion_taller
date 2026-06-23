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

CREATE OR REPLACE TABLE LCCOV (
    numero_carta_credito     FOR COLUMN LCCOVNCC   VARCHAR(30)    NOT NULL,
    secuencia                FOR COLUMN LCCOVSEQ   INT            NOT NULL,
    fecha_emision            FOR COLUMN LCCOVFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCCOVFVE   DATE,
    monto_original           FOR COLUMN LCCOVMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCCOVSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCCOVBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCCOVPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCCOVEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCCOVUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCCOVUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCCOVVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCCOVOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCCOVERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCCOVCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCCOVUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCCOV PRIMARY KEY (numero_carta_credito, secuencia)
)
RCDFMT LCCOVR;

RENAME TABLE LCCOV
    TO LCCOV_TABLE FOR SYSTEM NAME LCCOV;

COMMENT ON TABLE LCCOV IS
    'Negociaciones de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCCOV
    IS 'Negociaciones LC';

COMMENT ON COLUMN LCCOV.numero_carta_credito IS
    'Numero de la carta de credito que se negocia (FK LCMST)';
COMMENT ON COLUMN LCCOV.secuencia IS
    'Numero de secuencia de la negociacion dentro de la carta';
COMMENT ON COLUMN LCCOV.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCCOV.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCCOV.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCCOV.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCCOV.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCCOV.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCCOV.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCCOV.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCCOV.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCCOV.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCCOV.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCCOV.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCCOV.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCCOV.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCCOV (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    secuencia                    TEXT IS 'Secuencia',
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

CREATE INDEX ILCCOVNCC ON LCCOV (numero_carta_credito);

CREATE INDEX ILCCOVCAT ON LCCOV (created_at);

-- =============================================================================
-- Fin de script: LCCOV_CREATE.sql
-- =============================================================================
