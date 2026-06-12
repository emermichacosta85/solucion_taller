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

CREATE OR REPLACE TABLE HNEACOSTA1/LNECR (
    id_cliente               VARCHAR(30)    NOT NULL     FOR COLUMN LNECRCLI,
    numero_linea             VARCHAR(30)    NOT NULL     FOR COLUMN LNECRNLN,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN LNECRBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN LNECRSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN LNECRMON,
    tipo_linea               VARCHAR(20)                 FOR COLUMN LNECRTLN,
    tipo_producto            VARCHAR(20)                 FOR COLUMN LNECRTPR,
    descripcion_linea        VARCHAR(120)                FOR COLUMN LNECRDSC,
    numero_resolucion        VARCHAR(50)                 FOR COLUMN LNECRNRS,
    fecha_aprobacion         DATE                        FOR COLUMN LNECRFAP,
    fecha_vigencia_desde     DATE                        FOR COLUMN LNECRFVD,
    fecha_vencimiento        DATE                        FOR COLUMN LNECRFVE,
    monto_aprobado           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRMAO,
    monto_utilizado          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRMUT,
    monto_comprometido       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRMCO,
    monto_disponible         DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRMDP,
    tasa_interes             DECIMAL(10,6)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRTIS,
    tasa_moratoria           DECIMAL(10,6)  NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRTMO,
    plazo_maximo_meses       INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRPMX,
    requiere_garantia        CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN LNECRRGA,
    renovable                CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN LNECRREN,
    numero_renovaciones      INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN LNECRNRV,
    funcionario_aprobador    VARCHAR(30)                 FOR COLUMN LNECRFUN,
    nivel_aprobacion         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN LNECRNAP,
    estado_linea             VARCHAR(20)    NOT NULL     FOR COLUMN LNECRELN,
    observaciones            VARCHAR(120)                FOR COLUMN LNECROBS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN LNECRUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN LNECRUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN LNECRVRS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN LNECRERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LNECRCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN LNECRUAT,
    CONSTRAINT PK_LNECR PRIMARY KEY (id_cliente, numero_linea),
    CONSTRAINT FK_LNECR_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente)
)
RCDFMT LNECRR;

RENAME TABLE HNEACOSTA1/LNECR
    TO LNECR FOR SYSTEM NAME LNECR;

COMMENT ON TABLE HNEACOSTA1/LNECR IS
    'Maestro de Lineas de Credito de Clientes - Modulo 9 Lineas de Credito';

LABEL ON TABLE HNEACOSTA1/LNECR
    IS 'Maestro Lineas Credito';

COMMENT ON COLUMN HNEACOSTA1/LNECR.id_cliente IS
    'Identificador del cliente titular de la linea de credito (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/LNECR.numero_linea IS
    'Numero de la linea de credito asignado por el banco, unico por cliente';
COMMENT ON COLUMN HNEACOSTA1/LNECR.codigo_banco IS
    'Codigo del banco que aprueba y administra la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.codigo_sucursal IS
    'Codigo de la sucursal responsable de la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.tipo_linea IS
    'Clasificacion de la linea: REVOLVENTE, NO_REVOLVENTE, CONTINGENTE, MIXTA';
COMMENT ON COLUMN HNEACOSTA1/LNECR.tipo_producto IS
    'Tipo de producto crediticio asociado segun catalogo APCLS';
COMMENT ON COLUMN HNEACOSTA1/LNECR.descripcion_linea IS
    'Descripcion del proposito o uso autorizado de la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.numero_resolucion IS
    'Numero de la resolucion de credito o acta del comite que aprueba la linea';
COMMENT ON COLUMN HNEACOSTA1/LNECR.fecha_aprobacion IS
    'Fecha en que el comite o instancia competente aprobo la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.fecha_vigencia_desde IS
    'Fecha desde la que la linea de credito esta habilitada para su utilizacion';
COMMENT ON COLUMN HNEACOSTA1/LNECR.fecha_vencimiento IS
    'Fecha limite de vigencia de la linea de credito aprobada';
COMMENT ON COLUMN HNEACOSTA1/LNECR.monto_aprobado IS
    'Monto total del cupo aprobado por el comite para la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.monto_utilizado IS
    'Monto del cupo actualmente utilizado por operaciones imputadas a la linea';
COMMENT ON COLUMN HNEACOSTA1/LNECR.monto_comprometido IS
    'Monto comprometido por operaciones en tramite pero aun no desembolsadas';
COMMENT ON COLUMN HNEACOSTA1/LNECR.monto_disponible IS
    'Saldo disponible para nuevas utilizaciones: aprobado menos utilizado y comprometido';
COMMENT ON COLUMN HNEACOSTA1/LNECR.tasa_interes IS
    'Tasa de interes nominal anual aplicable a las utilizaciones de la linea';
COMMENT ON COLUMN HNEACOSTA1/LNECR.tasa_moratoria IS
    'Tasa de interes moratoria anual aplicable a los saldos vencidos de la linea';
COMMENT ON COLUMN HNEACOSTA1/LNECR.plazo_maximo_meses IS
    'Plazo maximo en meses permitido para las operaciones individuales imputadas';
COMMENT ON COLUMN HNEACOSTA1/LNECR.requiere_garantia IS
    'Indica si las utilizaciones de esta linea requieren garantia especifica: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/LNECR.renovable IS
    'Indica si la linea puede ser renovada al vencer: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/LNECR.numero_renovaciones IS
    'Numero de veces que la linea ha sido renovada desde su aprobacion original';
COMMENT ON COLUMN HNEACOSTA1/LNECR.funcionario_aprobador IS
    'Nombre o codigo del funcionario o comite que aprobo la linea';
COMMENT ON COLUMN HNEACOSTA1/LNECR.nivel_aprobacion IS
    'Nivel jerarquico de aprobacion requerido segun el monto: 1=Gerente, 2=Comite, etc.';
COMMENT ON COLUMN HNEACOSTA1/LNECR.estado_linea IS
    'Estado actual de la linea: APROBADA, VIGENTE, SUSPENDIDA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LNECR.observaciones IS
    'Notas sobre la linea de credito, sus condiciones especiales o historial';
COMMENT ON COLUMN HNEACOSTA1/LNECR.usuario_creacion IS
    'Usuario del sistema que registro la linea de credito';
COMMENT ON COLUMN HNEACOSTA1/LNECR.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/LNECR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LNECR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LNECR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LNECR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LNECR (
    id_cliente               TEXT IS 'ID Cliente',
    numero_linea             TEXT IS 'No. Linea',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    tipo_linea               TEXT IS 'Tipo Linea',
    tipo_producto            TEXT IS 'Tipo Product',
    descripcion_linea        TEXT IS 'Descripcion',
    numero_resolucion        TEXT IS 'No. Resolucion',
    fecha_aprobacion         TEXT IS 'Fec Aprobac',
    fecha_vigencia_desde     TEXT IS 'Fec Vig Desde',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_aprobado           TEXT IS 'Mto Aprobado',
    monto_utilizado          TEXT IS 'Mto Utilizado',
    monto_comprometido       TEXT IS 'Mto Comprom',
    monto_disponible         TEXT IS 'Mto Dispon',
    tasa_interes             TEXT IS 'Tasa Interes',
    tasa_moratoria           TEXT IS 'Tasa Mora',
    plazo_maximo_meses       TEXT IS 'Plazo Max',
    requiere_garantia        TEXT IS 'Req Garantia',
    renovable                TEXT IS 'Renovable',
    numero_renovaciones      TEXT IS 'No. Renov',
    funcionario_aprobador    TEXT IS 'Aprobador',
    nivel_aprobacion         TEXT IS 'Nivel Aprob',
    estado_linea             TEXT IS 'Estado Linea',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ILNECRCLI ON HNEACOSTA1/LNECR (id_cliente);
CREATE INDEX HNEACOSTA1/ILNECRELN ON HNEACOSTA1/LNECR (estado_linea);
CREATE INDEX HNEACOSTA1/ILNECRFVE ON HNEACOSTA1/LNECR (fecha_vencimiento);
CREATE INDEX HNEACOSTA1/ILNECRCAT ON HNEACOSTA1/LNECR (created_at);
CREATE INDEX HNEACOSTA1/ILNECRTLN ON HNEACOSTA1/LNECR (tipo_linea);