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

CREATE OR REPLACE TABLE HNEACOSTA1/DLCLP (
    id_cliente              VARCHAR(30)     NOT NULL    FOR COLUMN DLCLPCLI,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN DLCLPCTA,
    referencia              VARCHAR(50)     NOT NULL    FOR COLUMN DLCLPREF,
    categoria_riesgo        VARCHAR(10)                 FOR COLUMN DLCLPCAT,
    porcentaje_prevision    DECIMAL(10,6)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPPVS,
    monto_prevision         DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPMPV,
    fecha_calificacion      DATE                        FOR COLUMN DLCLPFCL,
    periodo_calificacion    VARCHAR(10)                 FOR COLUMN DLCLPPER,
    fecha_desembolso        DATE                        FOR COLUMN DLCLPFDS,
    fecha_vencimiento       DATE                        FOR COLUMN DLCLPFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPSAL,
    tasa_interes            DECIMAL(18,4)   NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPTSA,
    plazo_meses             INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPPLA,
    dias_mora               INT             NOT NULL
                                            DEFAULT 0   FOR COLUMN DLCLPDMR,
    estado_operacion        VARCHAR(20)     NOT NULL    FOR COLUMN DLCLPEOP,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN DLCLPUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN DLCLPUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN DLCLPVRS,
    observaciones           VARCHAR(120)                FOR COLUMN DLCLPOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN DLCLPERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLCLPCAT2,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN DLCLPUAT,
    CONSTRAINT PK_DLCLP PRIMARY KEY (id_cliente, numero_cuenta, referencia),
    CONSTRAINT FK_DLCLP_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente)
        ON DELETE RESTRICT
        ON UPDATE RESTRICT
)
RCDFMT DLCLPR;

RENAME TABLE HNEACOSTA1/DLCLP
    TO DLCLP FOR SYSTEM NAME DLCLP;

COMMENT ON TABLE HNEACOSTA1/DLCLP IS
    'Calificacion y Prevision de Cartera - Modulo 4 Contratos/Certificados/Giros';

LABEL ON TABLE HNEACOSTA1/DLCLP
    IS 'Calificacion Cartera';

COMMENT ON COLUMN HNEACOSTA1/DLCLP.id_cliente IS
    'Identificador del cliente titular de la operacion calificada (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.numero_cuenta IS
    'Numero de cuenta o identificador de la operacion calificada';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.referencia IS
    'Referencia interna o externa de la operacion en el proceso de calificacion';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.categoria_riesgo IS
    'Categoria de riesgo segun normativa: A, B, C, D, E';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.porcentaje_prevision IS
    'Porcentaje de prevision aplicado segun la categoria de riesgo';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.monto_prevision IS
    'Monto de la prevision calculada en la moneda de la operacion';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.fecha_calificacion IS
    'Fecha en que se realizo la calificacion de riesgo';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.periodo_calificacion IS
    'Periodo contable de la calificacion formato AAAAMM';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.fecha_desembolso IS
    'Fecha de desembolso de la operacion calificada';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.fecha_vencimiento IS
    'Fecha de vencimiento de la operacion calificada';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.monto_original IS
    'Monto original de la operacion calificada';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.saldo_actual IS
    'Saldo vigente de la operacion al momento de la calificacion';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.tasa_interes IS
    'Tasa de interes de la operacion calificada';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.plazo_meses IS
    'Plazo de la operacion en meses';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.dias_mora IS
    'Dias de mora de la operacion al momento de la calificacion';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.estado_operacion IS
    'Estado de la operacion: VIGENTE, VENCIDA, MORA, CASTIGADA';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.usuario_creacion IS
    'Usuario que registro la calificacion de cartera';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la calificacion';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.observaciones IS
    'Notas sobre la calificacion, ajustes o excepciones aplicadas';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DLCLP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DLCLP (
    id_cliente               TEXT IS 'ID Cliente',
    numero_cuenta            TEXT IS 'No. Cuenta',
    referencia               TEXT IS 'Referencia',
    categoria_riesgo         TEXT IS 'Categoria',
    porcentaje_prevision     TEXT IS 'Porc Prevision',
    monto_prevision          TEXT IS 'Monto Prev',
    fecha_calificacion       TEXT IS 'Fec Calif',
    periodo_calificacion     TEXT IS 'Periodo',
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

CREATE INDEX HNEACOSTA1/IDLCLPCLI ON HNEACOSTA1/DLCLP (id_cliente);
CREATE INDEX HNEACOSTA1/IDLCLPCAT ON HNEACOSTA1/DLCLP (created_at);

-- =============================================================================
-- Fin de script: DLCLP_CREATE.sql
-- =============================================================================
