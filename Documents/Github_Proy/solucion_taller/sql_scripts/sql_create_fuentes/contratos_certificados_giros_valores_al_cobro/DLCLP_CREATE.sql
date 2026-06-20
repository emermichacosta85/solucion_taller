-- =============================================================================
-- Nombre de la Tabla  : DLCLP
-- DESCRIPCION         : Calificacion y Prevision de Cartera.
--                       Registra la calificacion de riesgo asignada a cada
--                       operacion de credito segun normativa regulatoria.
-- Objetivo            : Almacenar la clasificacion de riesgo crediticio por
--                       cliente y operacion, incluyendo porcentaje de prevision
--                       y estado segun las categorias de la superintendencia.
-- Tipo de Tabla       : Operativa / Regulatoria
-- Origen de los Datos : Proceso de calificacion periodica de cartera y
--                       evaluacion de riesgo por el area de creditos
-- Permanencia de Datos: Historica (retener por ciclos regulatorios)
-- Uso de los datos    : Calculo de provisiones, reporteria regulatoria,
--                       clasificacion de cartera y estados financieros
-- Restricciones       : FK hacia CUMST por id_cliente.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 4 Contratos/Certificados/Giros
-- =============================================================================

CREATE OR REPLACE TABLE DLCLP (
    id_cliente              FOR COLUMN DLCLPCLI VARCHAR(30)     NOT NULL,
    numero_cuenta           FOR COLUMN DLCLPCTA VARCHAR(24)     NOT NULL,
    referencia              FOR COLUMN DLCLPREF VARCHAR(50)     NOT NULL,
    fecha_desembolso        FOR COLUMN DLCLPFDS DATE,
    fecha_vencimiento       FOR COLUMN DLCLPFVE DATE,
    monto_original          FOR COLUMN DLCLPMOR DECIMAL(18,2)   NOT NULL DEFAULT 0,
    saldo_actual            FOR COLUMN DLCLPSAL DECIMAL(18,2)   NOT NULL DEFAULT 0,
    tasa_interes            FOR COLUMN DLCLPTSA DECIMAL(18,4)   NOT NULL DEFAULT 0,
    plazo_meses             FOR COLUMN DLCLPPLA INT             NOT NULL DEFAULT 0,
    dias_mora               FOR COLUMN DLCLPDMR INT             NOT NULL DEFAULT 0,
    estado_operacion        FOR COLUMN DLCLPEOP VARCHAR(20)     NOT NULL,
    usuario_creacion        FOR COLUMN DLCLPUSC VARCHAR(30),
    usuario_actualizacion   FOR COLUMN DLCLPUSA VARCHAR(30),
    version_registro        FOR COLUMN DLCLPVRS INT             NOT NULL DEFAULT 1,
    observaciones           FOR COLUMN DLCLPOBS VARCHAR(120),
    estado_registro         FOR COLUMN DLCLPERG CHAR(1)         NOT NULL DEFAULT 'A',
    created_at              FOR COLUMN DLCLPCAT2 TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN DLCLPUAT TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DLCLP PRIMARY KEY (id_cliente, numero_cuenta)
    --CONSTRAINT FK_DLCLP_CUMST FOREIGN KEY (id_cliente)
    --    REFERENCES CUMST (id_cliente)
    --    ON DELETE RESTRICT
    --    ON UPDATE RESTRICT
)
RCDFMT DLCLPR;

RENAME TABLE DLCLP
    TO DLCLP_TABLE FOR SYSTEM NAME DLCLP;

COMMENT ON TABLE DLCLP IS
    'Calificacion y Prevision de Cartera - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE DLCLP
    IS 'Calificacion Cartera';

COMMENT ON COLUMN DLCLP.id_cliente IS
    'Identificador del cliente titular de la operacion calificada (FK CUMST)';
COMMENT ON COLUMN DLCLP.numero_cuenta IS
    'Numero de cuenta o identificador de la operacion calificada';
COMMENT ON COLUMN DLCLP.referencia IS
    'Referencia interna o externa de la operacion en el proceso de calificacion';
COMMENT ON COLUMN DLCLP.fecha_desembolso IS
    'Fecha de desembolso de la operacion calificada';
COMMENT ON COLUMN DLCLP.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion calificada';
COMMENT ON COLUMN DLCLP.monto_original IS
    'Monto original de la operacion calificada';
COMMENT ON COLUMN DLCLP.saldo_actual IS
    'Saldo vigente de la operacion al momento de la calificacion';
COMMENT ON COLUMN DLCLP.tasa_interes IS
    'Tasa de interes de la operacion calificada';
COMMENT ON COLUMN DLCLP.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN DLCLP.dias_mora IS
    'Dias de mora de la operacion al momento de la calificacion';
COMMENT ON COLUMN DLCLP.estado_operacion IS
    'Estado de la operacion: VIGENTE, VENCIDA, MORA, CASTIGADA';
COMMENT ON COLUMN DLCLP.usuario_creacion IS
    'Usuario que registro la calificacion de cartera';
COMMENT ON COLUMN DLCLP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la calificacion';
COMMENT ON COLUMN DLCLP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN DLCLP.observaciones IS
    'Notas sobre la calificacion, ajustes o excepciones aplicadas';
COMMENT ON COLUMN DLCLP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN DLCLP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN DLCLP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN DLCLP (
    id_cliente               TEXT IS 'ID Cliente',
    numero_cuenta            TEXT IS 'No. Cuenta',
    referencia               TEXT IS 'Referencia',
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

CREATE INDEX IDLCLPCLI ON DLCLP (id_cliente, numero_cuenta);
CREATE INDEX IDLCLPCAT ON DLCLP (created_at);

-- =============================================================================
-- Fin de script: DLCLP_CREATE.sql
-- =============================================================================
