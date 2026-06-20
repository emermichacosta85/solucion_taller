-- =============================================================================
-- Nombre de la Tabla  : LCMST
-- DESCRIPCION         : Maestro de Cartas de Credito. Registra la informacion principal de cada
--                       carta de credito documentaria emitida o recibida.
-- Objetivo            : Almacenar el encabezado unico de cada carta de credito, sirviendo como
--                       tabla padre de documentos, enmiendas, negociaciones
--                       y documentos recibidos del modulo.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Apertura y emision de cartas de credito por operadores de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Consulta de operaciones, calculo de saldos, reporteria regulatoria
--                       y base para submodulos de documentos y negociaciones
-- Restricciones       : id es PK tecnica autoincremental; numero_carta_credito es clave funcional
--                       unica referenciada por tablas hijas del modulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE LCMST (
    id                       FOR COLUMN LCMSTID    BIGINT         NOT NULL,
    fecha_emision            FOR COLUMN LCMSTFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCMSTFVE   DATE,
    monto_original           FOR COLUMN LCMSTMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCMSTSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCMSTBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCMSTPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCMSTEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCMSTUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCMSTUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCMSTVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCMSTOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCMSTERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCMSTCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCMSTUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCMST     PRIMARY KEY (id)
)
RCDFMT LCMSTR;

RENAME TABLE LCMST
    TO LCMST_TABLE FOR SYSTEM NAME LCMST;

COMMENT ON TABLE LCMST IS
    'Maestro de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCMST
    IS 'Maestro Cartas Cred';

COMMENT ON COLUMN LCMST.id IS
    'Identificador tecnico unico autoincremental de la carta de credito';
COMMENT ON COLUMN LCMST.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCMST.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCMST.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCMST.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCMST.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCMST.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCMST.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCMST.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCMST.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCMST (
    id                           TEXT IS 'ID Carta',
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

CREATE INDEX ILCMSTCAT ON LCMST (created_at);

CREATE INDEX ILCMSTFVE ON LCMST (fecha_vencimiento);

-- =============================================================================
-- Fin de script: LCMST_CREATE.sql
-- =============================================================================
