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

CREATE OR REPLACE TABLE LCADM (
    numero_carta_credito     FOR COLUMN LCADMNCC   VARCHAR(30)    NOT NULL,
    numero_enmienda          FOR COLUMN LCADMNEN   VARCHAR(30)    NOT NULL,
    fecha_emision            FOR COLUMN LCADMFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCADMFVE   DATE,
    monto_original           FOR COLUMN LCADMMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCADMSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCADMBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCADMPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCADMEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCADMUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCADMUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCADMVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCADMOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCADMERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCADMCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCADMUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCADM PRIMARY KEY (numero_carta_credito, numero_enmienda)
)
RCDFMT LCADMR;

RENAME TABLE LCADM
    TO LCADM_TABLE FOR SYSTEM NAME LCADM;

COMMENT ON TABLE LCADM IS
    'Enmiendas a Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCADM
    IS 'Enmiendas Carta Cred';

COMMENT ON COLUMN LCADM.numero_carta_credito IS
    'Numero de la carta de credito a la que aplica la enmienda (FK LCMST)';
COMMENT ON COLUMN LCADM.numero_enmienda IS
    'Numero correlativo de la enmienda dentro de la carta de credito';
COMMENT ON COLUMN LCADM.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCADM.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCADM.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCADM.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCADM.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCADM.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCADM.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCADM.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCADM.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCADM.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCADM.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCADM.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCADM.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCADM.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCADM (
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    numero_enmienda              TEXT IS 'No. Enmienda',
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

CREATE INDEX ILCADMNCC ON LCADM (numero_carta_credito);
CREATE INDEX ILCADMCAT ON LCADM (created_at);

-- =============================================================================
-- Fin de script: LCADM_CREATE.sql
-- =============================================================================
