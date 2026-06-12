-- ================================================================
-- Nombre de la Tabla  : RCOLL
-- DESCRIPCION         : Relaciones entre Garantias
-- Objetivo            : Registrar las vinculaciones entre garantias y
--                       las operaciones de credito que respaldan,
--                       permitiendo que una garantia cubra multiples
--                       operaciones y que una operacion este respaldada
--                       por multiples garantias (relacion N a N).
-- Tipo de Tabla       : Relacional / Tabla de Union
-- Origen de los Datos : Proceso de afectacion de garantias al originar
--                       o modificar operaciones de credito
-- Permanencia de Datos: Permanente (durante la vigencia de la garantia
--                       y de la operacion asociada)
-- Uso de los datos    : Calculo de cobertura de garantias por operacion,
--                       reportes regulatorios de suficiencia de garantias
-- Restricciones       : FK hacia ROCOL por (codigo_banco, numero_garantia)
--                       en ambas columnas cuenta_a_garantizar y
--                       cuenta_que_garantiza
--                       (segun ERD: ROCOL ||--o{ RCOLL)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 8 Garantias
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/RCOLL (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN RCOLLBNK,
    cuenta_a_garantizar      VARCHAR(50)    NOT NULL     FOR COLUMN RCOLLCAG,
    cuenta_que_garantiza     VARCHAR(50)    NOT NULL     FOR COLUMN RCOLLCQG,
    secuencia                INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN RCOLLSEQ,
    tipo_relacion            VARCHAR(20)                 FOR COLUMN RCOLLTRL,
    tipo_garantia            VARCHAR(20)                 FOR COLUMN RCOLLTGA,
    valor_garantia           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN RCOLLVAL,
    valor_afectado           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN RCOLLVAF,
    porcentaje_afectacion    DECIMAL(10,4)  NOT NULL
                                            DEFAULT 100  FOR COLUMN RCOLLPAF,
    fecha_avaluo             DATE                        FOR COLUMN RCOLLFA,
    fecha_afectacion         DATE                        FOR COLUMN RCOLLFC,
    fecha_vencimiento        DATE                        FOR COLUMN RCOLLFV,
    estado_garantia          VARCHAR(20)    NOT NULL     FOR COLUMN RCOLLEST,
    observaciones            VARCHAR(120)                FOR COLUMN RCOLLOBS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN RCOLLUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN RCOLLUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN RCOLLVRS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN RCOLLERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN RCOLLCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN RCOLLUAT,
    CONSTRAINT PK_RCOLL PRIMARY KEY (codigo_banco, cuenta_a_garantizar,
                                     cuenta_que_garantiza, secuencia),
    CONSTRAINT FK_RCOLL_ROCOL_CAG FOREIGN KEY (codigo_banco, cuenta_a_garantizar)
        REFERENCES HNEACOSTA1/ROCOL (codigo_banco, numero_garantia),
    CONSTRAINT FK_RCOLL_ROCOL_CQG FOREIGN KEY (codigo_banco, cuenta_que_garantiza)
        REFERENCES HNEACOSTA1/ROCOL (codigo_banco, numero_garantia)
)
RCDFMT RCOLLR;

RENAME TABLE HNEACOSTA1/RCOLL
    TO RCOLL FOR SYSTEM NAME RCOLL;

COMMENT ON TABLE HNEACOSTA1/RCOLL IS
    'Relaciones entre Garantias y Operaciones - Modulo 8 Garantias';

LABEL ON TABLE HNEACOSTA1/RCOLL
    IS 'Relaciones Garantias';

COMMENT ON COLUMN HNEACOSTA1/RCOLL.codigo_banco IS
    'Codigo del banco al que pertenecen ambas garantias vinculadas';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.cuenta_a_garantizar IS
    'Numero de garantia o operacion que recibe la cobertura (FK ROCOL.numero_garantia)';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.cuenta_que_garantiza IS
    'Numero de garantia que provee la cobertura a la operacion (FK ROCOL.numero_garantia)';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.secuencia IS
    'Numero de secuencia para multiples vinculaciones entre el mismo par de garantias';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.tipo_relacion IS
    'Naturaleza de la vinculacion: TOTAL, PARCIAL, SUBSIDIARIA, SOLIDARIA';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.tipo_garantia IS
    'Tipo de la garantia que provee la cobertura en esta relacion';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.valor_garantia IS
    'Valor total de la garantia que provee la cobertura al momento de la afectacion';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.valor_afectado IS
    'Monto del valor de la garantia comprometido en esta vinculacion especifica';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.porcentaje_afectacion IS
    'Porcentaje del valor de la garantia afectado en esta vinculacion';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.fecha_avaluo IS
    'Fecha del avaluo que respalda el valor de la garantia en esta relacion';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.fecha_afectacion IS
    'Fecha en que se constituyo formalmente la vinculacion entre garantias';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.fecha_vencimiento IS
    'Fecha de vencimiento de la vinculacion o de la garantia asociada';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.estado_garantia IS
    'Estado de la vinculacion: VIGENTE, LIBERADA, SUSTITUIDA, EJECUTADA';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.observaciones IS
    'Notas sobre la vinculacion, condiciones especiales o historial de cambios';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.usuario_creacion IS
    'Usuario del sistema que registro la vinculacion entre garantias';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la vinculacion';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/RCOLL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/RCOLL (
    codigo_banco             TEXT IS 'Banco',
    cuenta_a_garantizar      TEXT IS 'Cta Garantiz',
    cuenta_que_garantiza     TEXT IS 'Cta Garante',
    secuencia                TEXT IS 'Secuencia',
    tipo_relacion            TEXT IS 'Tipo Relac',
    tipo_garantia            TEXT IS 'Tipo Garant',
    valor_garantia           TEXT IS 'Valor Garant',
    valor_afectado           TEXT IS 'Valor Afect',
    porcentaje_afectacion    TEXT IS 'Porc Afect',
    fecha_avaluo             TEXT IS 'Fec Avaluo',
    fecha_afectacion         TEXT IS 'Fec Afectac',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_garantia          TEXT IS 'Estado',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IRCOLLCAG ON HNEACOSTA1/RCOLL (cuenta_a_garantizar);
CREATE INDEX HNEACOSTA1/IRCOLLCQG ON HNEACOSTA1/RCOLL (cuenta_que_garantiza);
CREATE INDEX HNEACOSTA1/IRCOLLCAT ON HNEACOSTA1/RCOLL (created_at);
CREATE INDEX HNEACOSTA1/IRCOLLFV  ON HNEACOSTA1/RCOLL (fecha_vencimiento);
CREATE INDEX HNEACOSTA1/IRCOLLEST ON HNEACOSTA1/RCOLL (estado_garantia);
