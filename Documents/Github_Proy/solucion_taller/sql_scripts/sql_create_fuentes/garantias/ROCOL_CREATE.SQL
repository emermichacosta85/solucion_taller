-- ================================================================
-- Nombre de la Tabla  : ROCOL
-- DESCRIPCION         : Maestro de Garantias
-- Objetivo            : Registrar y administrar todas las garantias
--                       aportadas por clientes del banco para respaldar
--                       operaciones de credito, incluyendo garantias
--                       reales (hipotecas, prendas), personales (avales,
--                       fianzas) y liquidas (depositos en garantia),
--                       con su valoracion y estado vigente.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Proceso de constitucion de garantias en la
--                       originacion y modificacion de creditos
-- Permanencia de Datos: Permanente (durante la vida de la garantia)
-- Uso de los datos    : Calculo de cobertura de garantias, reportes
--                       prudenciales, auditoria y gestion de cobro
-- Restricciones       : PK compuesta por banco, id_cliente y
--                       numero_garantia; FK hacia CUMST por id_cliente;
--                       UNIQUE sobre (codigo_banco, numero_garantia)
--                       para permitir referencia desde RCOLL
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 8 Garantias
-- ================================================================

CREATE OR REPLACE TABLE ROCOL (
    codigo_banco             FOR COLUMN ROCOLBNK VARCHAR(20)    NOT NULL     ,
    id_cliente               FOR COLUMN ROCOLCLI VARCHAR(30)    NOT NULL     ,
    numero_garantia          FOR COLUMN ROCOLNRG VARCHAR(30)    NOT NULL     ,
    tipo_garantia            FOR COLUMN ROCOLTGA VARCHAR(20)                 ,
    valor_garantia           FOR COLUMN ROCOLVGA DEC(13,2)            NOT NULL
                                            DEFAULT 0.00    ,
    fecha_avaluo             FOR COLUMN ROCOLFA DATE                        ,
    fecha_vencimiento        FOR COLUMN ROCOLFE DATE                        ,
    estado_garantia          FOR COLUMN ROCOLEST VARCHAR(20)    NOT NULL     ,
    observaciones            FOR COLUMN ROCOLOBS VARCHAR(120)                ,
    usuario_creacion         FOR COLUMN ROCOLUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN ROCOLUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN ROCOLVRS INT            NOT NULL
                                            DEFAULT 1    ,
    estado_registro          FOR COLUMN ROCOLERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN ROCOLCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    updated_at               FOR COLUMN ROCOLUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    CONSTRAINT PK_ROCOL     PRIMARY KEY (codigo_banco, id_cliente,
                                         numero_garantia)
    --CONSTRAINT UQ_ROCOL_NRG UNIQUE      (codigo_banco, numero_garantia),
    --CONSTRAINT FK_ROCOL_CUMST FOREIGN KEY (id_cliente)
    --   REFERENCES CUMST (id_cliente)
)
RCDFMT ROCOLR;

RENAME TABLE ROCOL
    TO ROCOL_TABLE FOR SYSTEM NAME ROCOL;

COMMENT ON TABLE ROCOL IS
    'Maestro de Garantias de Clientes - Modulo 8 Garantias';

LABEL ON TABLE ROCOL
    IS 'Maestro Garantias';

COMMENT ON COLUMN ROCOL.codigo_banco IS
    'Codigo del banco ante el cual esta constituida la garantia';
COMMENT ON COLUMN ROCOL.id_cliente IS
    'Identificador del cliente propietario o garante de la garantia (FK CUMST)';
COMMENT ON COLUMN ROCOL.numero_garantia IS
    'Numero unico de la garantia asignado por el banco al momento de constituirla';
COMMENT ON COLUMN ROCOL.tipo_garantia IS
    'Tipo principal de la garantia: REAL, PERSONAL, LIQUIDA, MIXTA';
COMMENT ON COLUMN ROCOL.valor_garantia IS
    'Valor total del bien o garantia segun ultimo avaluo o tasacion';
COMMENT ON COLUMN ROCOL.fecha_avaluo IS
    'Fecha del primer avaluo o tasacion que determino el valor de la garantia';
COMMENT ON COLUMN ROCOL.fecha_vencimiento IS
    'Fecha de vencimiento de la garantia cuando tiene vigencia limitada';
COMMENT ON COLUMN ROCOL.estado_garantia IS
    'Estado actual de la garantia: VIGENTE, VENCIDA, LIBERADA, EJECUTADA, SUSTITUIDA';
COMMENT ON COLUMN ROCOL.observaciones IS
    'Notas sobre la garantia, sus condiciones o restricciones especiales';
COMMENT ON COLUMN ROCOL.usuario_creacion IS
    'Usuario del sistema que registro la garantia';
COMMENT ON COLUMN ROCOL.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN ROCOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN ROCOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN ROCOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN ROCOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN ROCOL (
    codigo_banco             TEXT IS 'Banco',
    id_cliente               TEXT IS 'ID Cliente',
    numero_garantia          TEXT IS 'No. Garantia',
    tipo_garantia            TEXT IS 'Tipo Garant',
    valor_garantia            TEXT IS 'Valor Garant',
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

CREATE INDEX IROCOLCLI ON ROCOL (codigo_banco, id_cliente);
CREATE INDEX IROCOLCAT ON ROCOL (created_at);
