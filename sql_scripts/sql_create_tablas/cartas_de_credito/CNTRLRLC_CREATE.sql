-- =============================================================================
-- Nombre de la Tabla  : CNTRLRLC
-- DESCRIPCION         : Tabla de Cargos por Servicios o Tarifas de Cartas de Credito.
--                       Parametriza las comisiones y cargos del modulo LC.
-- Objetivo            : Centralizar las tarifas, comisiones y cargos por servicios aplicables
--                       a las operaciones de cartas de credito por tipo
--                       de producto y banco, con sus metodos de calculo.
-- Tipo de Tabla       : Parametrica / Control
-- Origen de los Datos : Configuracion de tarifas por la gerencia del banco y comercio exterior
-- Permanencia de Datos: Permanente (con historial por vigencia)
-- Uso de los datos    : Calculo de comisiones al abrir, enmendar o negociar cartas de credito
-- Restricciones       : PK compuesta por codigo_banco, tipo_producto y numero_tabla.
--                       Tabla de tarifas independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE CNTRLRLC (
    codigo_banco             FOR COLUMN CNTRLBNK   VARCHAR(20)    NOT NULL,
    tipo_producto            FOR COLUMN CNTRLTPR   VARCHAR(20)    NOT NULL,
    numero_tabla             FOR COLUMN CNTRLTBL   VARCHAR(30)    NOT NULL,
    fecha_emision            FOR COLUMN CNTRLFEM   DATE,
    fecha_vencimiento        FOR COLUMN CNTRLFVE   DATE,
    monto_original           FOR COLUMN CNTRLMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN CNTRLSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN CNTRLBCR   VARCHAR(80),
    pais_destino             FOR COLUMN CNTRLPDS   VARCHAR(80),
    estado_carta             FOR COLUMN CNTRLEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN CNTRLUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN CNTRLUSA   VARCHAR(30),
    version_registro         FOR COLUMN CNTRLVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN CNTRLOBS   VARCHAR(120),
    estado_registro          FOR COLUMN CNTRLERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN CNTRLCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN CNTRLUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_CNTRLRLC PRIMARY KEY (codigo_banco, tipo_producto, numero_tabla)
)
RCDFMT CNTRLRLCR;

RENAME TABLE CNTRLRLC
    TO CNTRLRLC_TABLE FOR SYSTEM NAME CNTRLRLC;

COMMENT ON TABLE CNTRLRLC IS
    'Tarifas de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE CNTRLRLC
    IS 'Tarifas LC';

COMMENT ON COLUMN CNTRLRLC.codigo_banco IS
    'Codigo del banco al que pertenece la tabla de tarifas de cartas de credito';
COMMENT ON COLUMN CNTRLRLC.tipo_producto IS
    'Tipo de producto de carta de credito al que aplica la tarifa';
COMMENT ON COLUMN CNTRLRLC.numero_tabla IS
    'Numero identificador de la tabla de tarifas dentro del banco y producto';
COMMENT ON COLUMN CNTRLRLC.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN CNTRLRLC.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN CNTRLRLC.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN CNTRLRLC.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN CNTRLRLC.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN CNTRLRLC.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN CNTRLRLC.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN CNTRLRLC.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN CNTRLRLC.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN CNTRLRLC.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CNTRLRLC.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN CNTRLRLC.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CNTRLRLC.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CNTRLRLC.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CNTRLRLC (
    codigo_banco                 TEXT IS 'Banco',
    tipo_producto                TEXT IS 'Tipo Prod',
    numero_tabla                 TEXT IS 'No. Tabla',
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

CREATE INDEX ICNTRLCAT ON CNTRLRLC (created_at);
CREATE INDEX ICNTRLTPR ON CNTRLRLC (tipo_producto);

-- =============================================================================
-- Fin de script: CNTRLRLC_CREATE.sql
-- =============================================================================
