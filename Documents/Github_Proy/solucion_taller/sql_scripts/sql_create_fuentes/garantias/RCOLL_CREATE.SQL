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

CREATE OR REPLACE TABLE RCOLL (
    codigo_banco             FOR COLUMN RCOLLBNK VARCHAR(20)    NOT NULL     ,
    cuenta_a_garantizar      FOR COLUMN RCOLLCAG VARCHAR(50)    NOT NULL     ,
    cuenta_que_garantiza     FOR COLUMN RCOLLCQG VARCHAR(50)    NOT NULL     ,
    tipo_garantia            FOR COLUMN RCOLLTGA VARCHAR(20)                 ,
    valor_garantia           FOR COLUMN RCOLLVAL DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    fecha_avaluo             FOR COLUMN RCOLLFA DATE                        ,
    fecha_vencimiento        FOR COLUMN RCOLLFV DATE                        ,
    estado_garantia          FOR COLUMN RCOLLEST VARCHAR(20)    NOT NULL     ,
    observaciones            FOR COLUMN RCOLLOBS VARCHAR(120)                ,
    usuario_creacion         FOR COLUMN RCOLLUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN RCOLLUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN RCOLLVRS INT            NOT NULL
                                            DEFAULT 1    ,
    estado_registro          FOR COLUMN RCOLLERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN RCOLLCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    updated_at               FOR COLUMN RCOLLUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    CONSTRAINT PK_RCOLL PRIMARY KEY (codigo_banco, cuenta_a_garantizar,
                                     cuenta_que_garantiza)
    --CONSTRAINT FK_RCOLL_ROCOL_CAG FOREIGN KEY (codigo_banco, cuenta_a_garantizar)
    --    REFERENCES ROCOL (codigo_banco, numero_garantia),
    --CONSTRAINT FK_RCOLL_ROCOL_CQG FOREIGN KEY (codigo_banco, cuenta_que_garantiza)
    --    REFERENCES ROCOL (codigo_banco, numero_garantia)
)
RCDFMT RCOLLR;

RENAME TABLE RCOLL
    TO RCOLL_TABLE FOR SYSTEM NAME RCOLL;

COMMENT ON TABLE RCOLL IS
    'Relaciones entre Garantias y Operaciones - Modulo 8 Garantias';

LABEL ON TABLE RCOLL
    IS 'Relaciones Garantias';

COMMENT ON COLUMN RCOLL.codigo_banco IS
    'Codigo del banco al que pertenecen ambas garantias vinculadas';
COMMENT ON COLUMN RCOLL.cuenta_a_garantizar IS
    'Numero de garantia o operacion que recibe la cobertura (FK ROCOL.numero_garantia)';
COMMENT ON COLUMN RCOLL.cuenta_que_garantiza IS
    'Numero de garantia que provee la cobertura a la operacion (FK ROCOL.numero_garantia)';
COMMENT ON COLUMN RCOLL.tipo_garantia IS
    'Tipo de la garantia que provee la cobertura en esta relacion';
COMMENT ON COLUMN RCOLL.valor_garantia IS
    'Valor total de la garantia que provee la cobertura al momento de la afectacion';
COMMENT ON COLUMN RCOLL.fecha_avaluo IS
    'Fecha en que se constituyo formalmente la vinculacion entre garantias';
COMMENT ON COLUMN RCOLL.fecha_vencimiento IS
    'Fecha de vencimiento de la vinculacion o de la garantia asociada';
COMMENT ON COLUMN RCOLL.estado_garantia IS
    'Estado de la vinculacion: VIGENTE, LIBERADA, SUSTITUIDA, EJECUTADA';
COMMENT ON COLUMN RCOLL.observaciones IS
    'Notas sobre la vinculacion, condiciones especiales o historial de cambios';
COMMENT ON COLUMN RCOLL.usuario_creacion IS
    'Usuario del sistema que registro la vinculacion entre garantias';
COMMENT ON COLUMN RCOLL.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la vinculacion';
COMMENT ON COLUMN RCOLL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN RCOLL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN RCOLL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN RCOLL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN RCOLL (
    codigo_banco             TEXT IS 'Banco',
    cuenta_a_garantizar      TEXT IS 'Cta Garantiz',
    cuenta_que_garantiza     TEXT IS 'Cta Garante',
    tipo_garantia            TEXT IS 'Tipo Garant',
    valor_garantia           TEXT IS 'Valor Garant',
    fecha_avaluo             TEXT IS 'Fec Avaluo',
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

CREATE INDEX IRCOLLCAG ON RCOLL (codigo_banco, cuenta_a_garantizar);
CREATE INDEX IRCOLLCAT ON RCOLL (created_at);
