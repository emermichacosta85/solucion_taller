-- ================================================================
-- Nombre de la Tabla  : FIXMS
-- DESCRIPCION         : Maestro de Activos Fijos
-- Objetivo            : Registrar el inventario completo de activos fijos
--                       del banco con toda la informacion necesaria para
--                       su identificacion, valoracion, depreciacion,
--                       control de ubicacion y seguimiento del ciclo
--                       de vida desde su adquisicion hasta su baja o
--                       disposicion final.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Alta de activos por adquisicion, donacion,
--                       aportacion o revaluacion
-- Permanencia de Datos: Permanente (durante la vida util del activo)
-- Uso de los datos    : Calculo de depreciacion, inventario fisico,
--                       reportes regulatorios y contabilizacion de bajas
-- Restricciones       : PK por numero_activo; FK hacia CLSMS por
--                       codigo_clase; FK hacia LOCMS por
--                       numero_localizacion; FK hacia CNTRLFIX por
--                       codigo_banco (relaciones funcionales del modulo
--                       no declaradas en ERD pero derivadas del dominio)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 10 Activos Fijos
-- ================================================================

CREATE OR REPLACE TABLE FIXMS (
    numero_activo            FOR COLUMN FIXMSNAC VARCHAR(30)    NOT NULL     ,
    descripcion              FOR COLUMN FIXMSDSC VARCHAR(120)   NOT NULL     ,
    fecha_adquisicion        FOR COLUMN FIXMSFAD DATE           NOT NULL     ,
    valor_adquisicion        FOR COLUMN FIXMSVAD DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    vida_util_meses          FOR COLUMN FIXMSVU INT            NOT NULL
                                            DEFAULT 0    ,
    depreciacion_acumulada   FOR COLUMN FIXMSDAC DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    estado_activo            FOR COLUMN FIXMSEST VARCHAR(20)    NOT NULL     ,
    usuario_creacion         FOR COLUMN FIXMSUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN FIXMSUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN FIXMSVR INT            NOT NULL
                                            DEFAULT 1    ,
    observaciones            FOR COLUMN FIXMSOBS VARCHAR(120)                ,
    estado_registro          FOR COLUMN FIXMSERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN FIXMSCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    updated_at               FOR COLUMN FIXMSUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    CONSTRAINT PK_FIXMS PRIMARY KEY (numero_activo)
    --CONSTRAINT FK_FIXMS_CLSMS   FOREIGN KEY (codigo_clase)
    --    REFERENCES CLSMS (codigo_clase),
    --CONSTRAINT FK_FIXMS_LOCMS   FOREIGN KEY (numero_localizacion)
    --    REFERENCES LOCMS (numero_localizacion),
    --CONSTRAINT FK_FIXMS_CNTRLFIX FOREIGN KEY (codigo_banco)
    --    REFERENCES CNTRLFIX (codigo_banco)
)
RCDFMT FIXMSR;

RENAME TABLE FIXMS
    TO FIXMS_TABLE FOR SYSTEM NAME FIXMS;

COMMENT ON TABLE FIXMS IS
    'Maestro de Activos Fijos del Banco - Modulo 10 Activos Fijos';

LABEL ON TABLE FIXMS
    IS 'Maestro Activos Fijos';

COMMENT ON COLUMN FIXMS.numero_activo IS
    'Numero unico del activo fijo asignado por el banco al momento del alta';
COMMENT ON COLUMN FIXMS.descripcion IS
    'Descripcion detallada del activo fijo para su identificacion';
COMMENT ON COLUMN FIXMS.fecha_adquisicion IS
    'Fecha en que el banco adquirio o recibio el activo';
COMMENT ON COLUMN FIXMS.valor_adquisicion IS
    'Costo original de adquisicion del activo incluyendo gastos de internacion';
COMMENT ON COLUMN FIXMS.vida_util_meses IS
    'Vida util del activo en meses, tomada de la clase o ajustada individualmente';
COMMENT ON COLUMN FIXMS.depreciacion_acumulada IS
    'Total acumulado de depreciacion registrada desde el inicio hasta la fecha';
COMMENT ON COLUMN FIXMS.estado_activo IS
    'Estado actual del activo: EN_USO, ALMACENADO, EN_REPARACION, DADO_DE_BAJA, SINIESTRADO';
COMMENT ON COLUMN FIXMS.usuario_creacion IS
    'Usuario del sistema que registro el alta del activo';
COMMENT ON COLUMN FIXMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN FIXMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN FIXMS.observaciones IS
    'Notas sobre el activo, su condicion fisica o historial de movimientos';
COMMENT ON COLUMN FIXMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN FIXMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN FIXMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN FIXMS (
    numero_activo            TEXT IS 'No. Activo',
    descripcion              TEXT IS 'Descripcion',
    fecha_adquisicion        TEXT IS 'Fec Adquis',
    valor_adquisicion        TEXT IS 'Valor Adquis',
    vida_util_meses          TEXT IS 'Vida Util',
    depreciacion_acumulada   TEXT IS 'Deprec Acum',
    estado_activo            TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IFIXMSNAC ON FIXMS (numero_activo);
CREATE INDEX IFIXMSCAT ON FIXMS (created_at);
