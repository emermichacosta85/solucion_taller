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

CREATE OR REPLACE TABLE HNEACOSTA1/ROCOL (
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN ROCOLBNK,
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN ROCOLCLI,
    numero_garantia          VARCHAR(30)    NOT NULL     FOR COLUMN ROCOLNRG,
    tipo_garantia            VARCHAR(20)                 FOR COLUMN ROCOLTGA,
    subtipo_garantia         VARCHAR(30)                 FOR COLUMN ROCOLSTG,
    descripcion_garantia     VARCHAR(120)                FOR COLUMN ROCOLDSC,
    codigo_moneda            VARCHAR(20)                 FOR COLUMN ROCOLMON,
    valor_garantia           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN ROCOLVAL,
    valor_aceptado           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN ROCOLVACP,
    porcentaje_cobertura     DECIMAL(10,4)  NOT NULL
                                            DEFAULT 100  FOR COLUMN ROCOLPCB,
    fecha_constitucion       DATE                        FOR COLUMN ROCOLFC,
    fecha_avaluo             DATE                        FOR COLUMN ROCOLFA,
    fecha_vencimiento        DATE                        FOR COLUMN ROCOLFE,
    fecha_ultimo_avaluo      DATE                        FOR COLUMN ROCOLFU,
    numero_escritura         VARCHAR(50)                 FOR COLUMN ROCOLNE,
    notaria                  VARCHAR(80)                 FOR COLUMN ROCOLNOT,
    numero_registro          VARCHAR(50)                 FOR COLUMN ROCOLNREG,
    ubicacion                VARCHAR(120)                FOR COLUMN ROCOLUBI,
    asegurado                CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN ROCOLASE,
    numero_poliza            VARCHAR(50)                 FOR COLUMN ROCOLPOL,
    estado_garantia          VARCHAR(20)    NOT NULL     FOR COLUMN ROCOLEST,
    observaciones            VARCHAR(120)                FOR COLUMN ROCOLOBS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN ROCOLUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN ROCOLUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN ROCOLVRS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN ROCOLERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN ROCOLCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN ROCOLUAT,
    CONSTRAINT PK_ROCOL     PRIMARY KEY (codigo_banco, id_cliente,
                                         numero_garantia),
    CONSTRAINT UQ_ROCOL_NRG UNIQUE      (codigo_banco, numero_garantia),
    CONSTRAINT FK_ROCOL_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente)
)
RCDFMT ROCOLR;

RENAME TABLE HNEACOSTA1/ROCOL
    TO ROCOL FOR SYSTEM NAME ROCOL;

COMMENT ON TABLE HNEACOSTA1/ROCOL IS
    'Maestro de Garantias de Clientes - Modulo 8 Garantias';

LABEL ON TABLE HNEACOSTA1/ROCOL
    IS 'Maestro Garantias';

COMMENT ON COLUMN HNEACOSTA1/ROCOL.codigo_banco IS
    'Codigo del banco ante el cual esta constituida la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.id_cliente IS
    'Identificador del cliente propietario o garante de la garantia (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.numero_garantia IS
    'Numero unico de la garantia asignado por el banco al momento de constituirla';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.tipo_garantia IS
    'Tipo principal de la garantia: REAL, PERSONAL, LIQUIDA, MIXTA';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.subtipo_garantia IS
    'Clasificacion especifica: HIPOTECA, PRENDA, AVAL, FIANZA, DEPOSITO, BONO';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.descripcion_garantia IS
    'Descripcion detallada del bien o derecho que constituye la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.codigo_moneda IS
    'Codigo ISO de la moneda en que esta valorada la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.valor_garantia IS
    'Valor total del bien o garantia segun ultimo avaluo o tasacion';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.valor_aceptado IS
    'Valor aceptado por el banco como cobertura efectiva de la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.porcentaje_cobertura IS
    'Porcentaje del valor de garantia aceptado para cobertura crediticia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.fecha_constitucion IS
    'Fecha en que la garantia fue formalmente constituida ante el banco';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.fecha_avaluo IS
    'Fecha del primer avaluo o tasacion que determino el valor de la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.fecha_vencimiento IS
    'Fecha de vencimiento de la garantia cuando tiene vigencia limitada';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.fecha_ultimo_avaluo IS
    'Fecha del avaluo mas reciente para actualizar el valor de la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.numero_escritura IS
    'Numero de escritura publica o documento legal que formaliza la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.notaria IS
    'Nombre o numero de la notaria ante la que se otorgo la escritura';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.numero_registro IS
    'Numero de inscripcion en el registro de la propiedad o mercantil';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.ubicacion IS
    'Direccion o ubicacion fisica del bien dado en garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.asegurado IS
    'Indica si el bien en garantia cuenta con seguro vigente: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.numero_poliza IS
    'Numero de poliza de seguro que ampara el bien en garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.estado_garantia IS
    'Estado actual de la garantia: VIGENTE, VENCIDA, LIBERADA, EJECUTADA, SUSTITUIDA';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.observaciones IS
    'Notas sobre la garantia, sus condiciones o restricciones especiales';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.usuario_creacion IS
    'Usuario del sistema que registro la garantia';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/ROCOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/ROCOL (
    codigo_banco             TEXT IS 'Banco',
    id_cliente               TEXT IS 'ID Cliente',
    numero_garantia          TEXT IS 'No. Garantia',
    tipo_garantia            TEXT IS 'Tipo Garant',
    subtipo_garantia         TEXT IS 'Subtipo',
    descripcion_garantia     TEXT IS 'Descripcion',
    codigo_moneda            TEXT IS 'Moneda',
    valor_garantia           TEXT IS 'Valor Garant',
    valor_aceptado           TEXT IS 'Valor Acept',
    porcentaje_cobertura     TEXT IS 'Porc Coburt',
    fecha_constitucion       TEXT IS 'Fec Constit',
    fecha_avaluo             TEXT IS 'Fec Avaluo',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    fecha_ultimo_avaluo      TEXT IS 'Fec Ult Aval',
    numero_escritura         TEXT IS 'No. Escritur',
    notaria                  TEXT IS 'Notaria',
    numero_registro          TEXT IS 'No. Registro',
    ubicacion                TEXT IS 'Ubicacion',
    asegurado                TEXT IS 'Asegurado',
    numero_poliza            TEXT IS 'No. Poliza',
    estado_garantia          TEXT IS 'Estado',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IROCOLCLI ON HNEACOSTA1/ROCOL (id_cliente);
CREATE INDEX HNEACOSTA1/IROCOLEST ON HNEACOSTA1/ROCOL (estado_garantia);
CREATE INDEX HNEACOSTA1/IROCOLCAT ON HNEACOSTA1/ROCOL (created_at);
CREATE INDEX HNEACOSTA1/IROCOLFE  ON HNEACOSTA1/ROCOL (fecha_vencimiento);
