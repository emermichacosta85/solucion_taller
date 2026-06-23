-- =============================================================================
-- Nombre de la Tabla  : DLITP
-- DESCRIPCION         : Maestro de Deducciones de Prestamos.
--                       Catalogo que define las deducciones recurrentes
--                       configuradas para cada operacion de credito.
-- Objetivo            : Almacenar la configuracion de deducciones periodicas
--                       asociadas a una operacion, como seguros de vida,
--                       seguros de desempleo y otros cargos recurrentes.
-- Tipo de Tabla       : Maestra / Configuracion
-- Origen de los Datos : Configuracion al momento de originar la operacion
-- Permanencia de Datos: Permanente mientras la operacion este vigente
-- Uso de los datos    : Generacion automatica de deducciones en el plan de pagos,
--                       calculo de cuotas y reporteria de cartera
-- Restricciones       : FK hacia DEALS por numero_prestamo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE DLITP (
    numero_prestamo         FOR COLUMN DLITPNPR VARCHAR(30)     NOT NULL,
    codigo_deduccion        FOR COLUMN DLITPCDD VARCHAR(20)     NOT NULL,
    fecha_desembolso        FOR COLUMN DLITPFDS DATE,
    fecha_vencimiento       FOR COLUMN DLITPFVE DATE,
    monto_original          FOR COLUMN DLITPMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DLITPSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DLITPTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DLITPPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DLITPDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DLITPEOP VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DLITPUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DLITPUSA VARCHAR(30),
    version_registro        FOR COLUMN DLITPVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DLITPOBS VARCHAR(120),
    estado_registro         FOR COLUMN DLITPERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DLITPCAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DLITPUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DLITP PRIMARY KEY (numero_prestamo, codigo_deduccion)
    --CONSTRAINT FK_DLITP_DEALS FOREIGN KEY (numero_prestamo)
    --    REFERENCES DEALS (numero_prestamo)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DLITPR;

RENAME TABLE DLITP
    TO DLITP_TABLE FOR SYSTEM NAME DLITP;

COMMENT ON TABLE DLITP IS
    'Maestro de Deducciones de Prestamos - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DLITP
    IS 'Deducciones Prestamos';

COMMENT ON COLUMN DLITP.numero_prestamo IS
    'Numero de la operacion a la que esta configurada la deduccion (FK DEALS)';
COMMENT ON COLUMN DLITP.codigo_deduccion IS
    'Codigo del concepto de deduccion: SEGURO_VIDA, SEGURO_DESEMPLEO, OTROS';
COMMENT ON COLUMN DLITP.fecha_desembolso IS
    'Fecha de desembolso de la operacion padre';
COMMENT ON COLUMN DLITP.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion padre';
COMMENT ON COLUMN DLITP.monto_original IS
    'Monto original de la operacion padre';
COMMENT ON COLUMN DLITP.saldo_actual IS
    'Saldo vigente de la operacion al momento del registro';
COMMENT ON COLUMN DLITP.tasa_interes IS
    'Tasa de interes de la operacion padre';
COMMENT ON COLUMN DLITP.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN DLITP.dias_mora IS
    'Dias de mora de la operacion padre';
COMMENT ON COLUMN DLITP.estado_operacion IS
    'Estado de la operacion: VIGENTE, CANCELADA, VENCIDA, MORA';
COMMENT ON COLUMN DLITP.usuario_creacion IS
    'Usuario que configuro la deduccion en la operacion';
COMMENT ON COLUMN DLITP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la configuracion';
COMMENT ON COLUMN DLITP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DLITP.observaciones IS
    'Notas sobre la deduccion, condiciones especiales o exenciones';
COMMENT ON COLUMN DLITP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DLITP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DLITP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DLITP (
    numero_prestamo          TEXT IS 'No. Prestamo',
    codigo_deduccion         TEXT IS 'Cod Deducc',
    fecha_desembolso         TEXT IS 'Fec Desemb',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_actual             TEXT IS 'Saldo Actual',
    tasa_interes             TEXT IS 'Tasa',
    plazo_meses              TEXT IS 'Plazo Meses',
    dias_mora                TEXT IS 'Dias Mora',
    estado_operacion         TEXT IS 'Estado Oper',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IDLITPNPR ON DLITP (numero_prestamo, codigo_deduccion);
CREATE INDEX IDLITPCAT ON DLITP (created_at);

-- =============================================================================
-- Fin de script: DLITP_CREATE.sql
-- =============================================================================
