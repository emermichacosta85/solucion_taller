-- ================================================================
-- Nombre de la Tabla  : LNECR
-- DESCRIPCION         : Maestro de Lineas de Credito
-- Objetivo            : Registrar y administrar las lineas de credito
--                       aprobadas para los clientes del banco, controlando
--                       el monto autorizado, la utilizacion acumulada,
--                       el saldo disponible y las condiciones pactadas,
--                       de modo que multiples operaciones de credito
--                       (prestamos, garantias, cartas de credito) puedan
--                       imputarse contra el cupo aprobado de cada linea.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Proceso de aprobacion de credito y gestion de
--                       lineas por el area de riesgo crediticio
-- Permanencia de Datos: Permanente (durante la vigencia de la linea)
-- Uso de los datos    : Control de cupo disponible en originacion de
--                       creditos, reportes de exposicion crediticia
--                       por cliente y consolidado por portafolio
-- Restricciones       : PK compuesta por id_cliente y numero_linea;
--                       FK hacia CUMST por id_cliente
--                       (segun ERD: CUMST ||--o{ LNECR)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 9 Lineas de Credito
-- ================================================================

CREATE OR REPLACE TABLE LNECR (
    id_cliente               FOR COLUMN LNECRCLI VARCHAR(30)    NOT NULL     ,
    numero_linea             FOR COLUMN LNECRNLN VARCHAR(30)    NOT NULL     ,
    fecha_aprobacion         FOR COLUMN LNECRFAP DATE                        ,
    fecha_vencimiento        FOR COLUMN LNECRFVE DATE                        ,
    monto_aprobado           FOR COLUMN LNECRMAO DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    monto_utilizado          FOR COLUMN LNECRMUT DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    monto_disponible         FOR COLUMN LNECRMDP DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    ,
    estado_linea             FOR COLUMN LNECRELN VARCHAR(20)    NOT NULL     ,
    usuario_creacion         FOR COLUMN LNECRUSC VARCHAR(30)                 ,
    usuario_actualizacion    FOR COLUMN LNECRUSA VARCHAR(30)                 ,
    version_registro         FOR COLUMN LNECRVRS INT            NOT NULL
                                            DEFAULT 1    ,
    observaciones            FOR COLUMN LNECROBS VARCHAR(120)               ,
    estado_registro          FOR COLUMN LNECRERG CHAR(1)        NOT NULL
                                            DEFAULT 'A'  ,
    created_at               FOR COLUMN LNECRCAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    updated_at               FOR COLUMN LNECRUAT TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         ,
    CONSTRAINT PK_LNECR PRIMARY KEY (id_cliente, numero_linea)
    --CONSTRAINT FK_LNECR_CUMST FOREIGN KEY (id_cliente)
    --    REFERENCES CUMST (id_cliente)
)
RCDFMT LNECRR;

RENAME TABLE LNECR
    TO LNECR_TABLE FOR SYSTEM NAME LNECR;

COMMENT ON TABLE LNECR IS
    'Maestro de Lineas de Credito de Clientes - Modulo 9 Lineas de Credito';

LABEL ON TABLE LNECR
    IS 'Maestro Lineas Credito';

COMMENT ON COLUMN LNECR.id_cliente IS
    'Identificador del cliente titular de la linea de credito (FK CUMST)';
COMMENT ON COLUMN LNECR.numero_linea IS
    'Numero de la linea de credito asignado por el banco, unico por cliente';
COMMENT ON COLUMN LNECR.fecha_aprobacion IS
    'Fecha en que el comite o instancia competente aprobo la linea de credito';
COMMENT ON COLUMN LNECR.fecha_vencimiento IS
    'Fecha limite de vigencia de la linea de credito aprobada';
COMMENT ON COLUMN LNECR.monto_aprobado IS
    'Monto total del cupo aprobado por el comite para la linea de credito';
COMMENT ON COLUMN LNECR.monto_utilizado IS
    'Monto del cupo actualmente utilizado por operaciones imputadas a la linea';
COMMENT ON COLUMN LNECR.monto_disponible IS
    'Saldo disponible para nuevas utilizaciones: aprobado menos utilizado y comprometido';
COMMENT ON COLUMN LNECR.estado_linea IS
    'Estado actual de la linea: APROBADA, VIGENTE, SUSPENDIDA, VENCIDA, CANCELADA';
COMMENT ON COLUMN LNECR.usuario_creacion IS
    'Usuario del sistema que registro la linea de credito';
COMMENT ON COLUMN LNECR.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN LNECR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LNECR.observaciones IS
    'Notas sobre la linea de credito, sus condiciones especiales o historial';
COMMENT ON COLUMN LNECR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LNECR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LNECR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LNECR (
    id_cliente               TEXT IS 'ID Cliente',
    numero_linea             TEXT IS 'No. Linea',
    fecha_aprobacion         TEXT IS 'Fec Aprobac',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_aprobado           TEXT IS 'Mto Aprobado',
    monto_utilizado          TEXT IS 'Mto Utilizado',
    monto_disponible         TEXT IS 'Mto Dispon',
    estado_linea             TEXT IS 'Estado Linea',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX ILNECRCLI ON LNECR (id_cliente, numero_linea);
CREATE INDEX ILNECRCAT ON LNECR (created_at);
