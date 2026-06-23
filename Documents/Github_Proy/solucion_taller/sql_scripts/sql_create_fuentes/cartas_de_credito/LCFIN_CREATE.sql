-- =============================================================================
-- Nombre de la Tabla  : LCFIN
-- DESCRIPCION         : Indice de Formatos de Cartas de Credito. Catalogo de plantillas
--                       y textos estandar utilizados en la documentacion.
-- Objetivo            : Centralizar el indice de formatos y plantillas de texto aplicables
--                       a los distintos documentos de cartas de credito,
--                       organizados por nivel, codigo y secuencia.
-- Tipo de Tabla       : Catalogo / Parametrica
-- Origen de los Datos : Configuracion de formatos por el area de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Generacion automatica de textos en documentos de cartas de credito
-- Restricciones       : PK compuesta por nivel, codigo_documento y secuencia_de_texto.
--                       Tabla de catalogo independiente sin FK intramodulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE LCFIN (
    nivel                    FOR COLUMN LCFINNIV   INT            NOT NULL,
    codigo_documento         FOR COLUMN LCFINCDO   VARCHAR(20)    NOT NULL,
    secuencia_de_texto       FOR COLUMN LCFINSEQ   VARCHAR(50)    NOT NULL,
    fecha_emision            FOR COLUMN LCFINFEM   DATE,
    fecha_vencimiento        FOR COLUMN LCFINFVE   DATE,
    monto_original           FOR COLUMN LCFINMOR   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    saldo_actual             FOR COLUMN LCFINSAL   DECIMAL(18,2)  NOT NULL DEFAULT 0,
    banco_corresponsal       FOR COLUMN LCFINBCR   VARCHAR(80),
    pais_destino             FOR COLUMN LCFINPDS   VARCHAR(80),
    estado_carta             FOR COLUMN LCFINEST   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCFINUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCFINUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCFINVRS   INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN LCFINOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCFINERG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN LCFINCAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCFINUAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCFIN PRIMARY KEY (nivel, codigo_documento, secuencia_de_texto)
)
RCDFMT LCFINR;

RENAME TABLE LCFIN
    TO LCFIN_TABLE FOR SYSTEM NAME LCFIN;

COMMENT ON TABLE LCFIN IS
    'Indice de Formatos de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE LCFIN
    IS 'Indice Formatos LC';

COMMENT ON COLUMN LCFIN.nivel IS
    'Nivel jerarquico del formato dentro del indice de cartas de credito';
COMMENT ON COLUMN LCFIN.codigo_documento IS
    'Codigo del documento al que pertenece este formato segun catalogo';
COMMENT ON COLUMN LCFIN.secuencia_de_texto IS
    'Identificador de secuencia del texto dentro del nivel y documento';
COMMENT ON COLUMN LCFIN.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN LCFIN.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN LCFIN.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN LCFIN.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN LCFIN.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN LCFIN.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN LCFIN.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LCFIN.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN LCFIN.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN LCFIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCFIN.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN LCFIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCFIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCFIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCFIN (
    nivel                        TEXT IS 'Nivel',
    codigo_documento             TEXT IS 'Cod Doc',
    secuencia_de_texto           TEXT IS 'Secuencia',
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

CREATE INDEX ILCFINCAT ON LCFIN (created_at);
CREATE INDEX ILCFINCDO ON LCFIN (codigo_documento);

-- =============================================================================
-- Fin de script: LCFIN_CREATE.sql
-- =============================================================================
