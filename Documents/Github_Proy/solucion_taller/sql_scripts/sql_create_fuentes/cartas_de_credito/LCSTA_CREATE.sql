-- =============================================================================
-- Nombre de la Tabla  : LCSTA
-- DESCRIPCION         : Estadistica de Aperturas, Enmiendas y Pagos en Cartas de Credito.
--                       Concentra indicadores agregados por periodo.
-- Objetivo            : Almacenar estadisticas consolidadas de las operaciones de cartas de
--                       credito por periodo, banco, tipo y moneda para
--                       reporteria gerencial y cumplimiento regulatorio.
-- Tipo de Tabla       : Estadistica / Resumen
-- Origen de los Datos : Proceso batch de cierre estadistico periodico
-- Permanencia de Datos: Historica (retener por ciclos regulatorios)
-- Uso de los datos    : Reporteria gerencial, estadistica regulatoria y analisis de tendencias
-- Restricciones       : PK tecnica (id). UNIQUE por periodo, banco, tipo y moneda.
--                       Tabla estadistica independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE LCSTA (
    id                       FOR COLUMN LCSTAID    BIGINT         NOT NULL,
    fecha_emision            FOR COLUMN LCSTAFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCSTAFVE   DATE,
    monto_original           FOR COLUMN LCSTAMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCSTASAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCSTABCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCSTAPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCSTAEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCSTAUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCSTAUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCSTAVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCSTAOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCSTAERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCSTACAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCSTAUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCSTA PRIMARY KEY (id)
)
RCDFMT LCSTAR;

RENAME TABLE LCSTA
    TO LCSTA_TABLE FOR SYSTEM NAME LCSTA;

COMMENT ON TABLE LCSTA IS
    'Estadistica de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCSTA
    IS 'Estadistica LC';

COMMENT ON COLUMN LCSTA.id IS
    'Identificador tecnico unico autoincremental del registro estadistico';
COMMENT ON COLUMN LCSTA.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCSTA.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCSTA.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCSTA.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCSTA.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCSTA.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCSTA.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCSTA.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCSTA.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCSTA.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCSTA.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCSTA.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCSTA.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCSTA.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCSTA (
    id                           TEXT IS 'ID Estadistica',
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

CREATE INDEX ILCSTACAT ON LCSTA (created_at);

-- =============================================================================
-- Fin de script: LCSTA_CREATE.sql
-- =============================================================================
