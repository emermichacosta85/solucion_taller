-- =============================================================================
-- Nombre de la Tabla  : LCMST
-- DESCRIPCION         : Maestro de Cartas de Credito. Registra la informacion principal de cada
--                       carta de credito documentaria emitida o recibida.
-- Objetivo            : Almacenar el encabezado unico de cada carta de credito, sirviendo como
--                       tabla padre de documentos, enmiendas, negociaciones
--                       y documentos recibidos del modulo.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Apertura y emision de cartas de credito por operadores de comercio exterior
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Consulta de operaciones, calculo de saldos, reporteria regulatoria
--                       y base para submodulos de documentos y negociaciones
-- Restricciones       : id es PK tecnica autoincremental; numero_carta_credito es clave funcional
--                       unica referenciada por tablas hijas del modulo.
--                       No se permite crear PF ni LF. Solo SQL DDL.
-- -----------------------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-12
-- Proyecto            : Taller IBM i - Modulo 5 Cartas de Credito
-- =============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/LCMST (
    id                      BIGINT          NOT NULL    FOR COLUMN LCMSTID,
    numero_carta_credito    VARCHAR(30)     NOT NULL    FOR COLUMN LCMSTNCC,
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN LCMSTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN LCMSTSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN LCMSTMON,
    tipo_carta              VARCHAR(20)     NOT NULL    FOR COLUMN LCMSTTCO,
    tipo_producto           VARCHAR(20)                 FOR COLUMN LCMSTTPR,
    id_cliente              VARCHAR(30)     NOT NULL    FOR COLUMN LCMSTCLI,
    fecha_emision           DATE                        FOR COLUMN LCMSTFEM,
    fecha_vencimiento       DATE                        FOR COLUMN LCMSTFVE,
    monto_original          DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCMSTMOR,
    saldo_actual            DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN LCMSTSAL,
    banco_corresponsal      VARCHAR(80)                 FOR COLUMN LCMSTBCR,
    pais_destino            VARCHAR(80)                 FOR COLUMN LCMSTPDS,
    estado_carta            VARCHAR(20)     NOT NULL    FOR COLUMN LCMSTEST,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN LCMSTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN LCMSTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN LCMSTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN LCMSTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN LCMSTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCMSTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN LCMSTUAT,
    CONSTRAINT PK_LCMST     PRIMARY KEY (id),
    CONSTRAINT UQ_LCMST_NCC UNIQUE      (numero_carta_credito)
)
RCDFMT LCMSTR;

RENAME TABLE HNEACOSTA1/LCMST
    TO LCMST FOR SYSTEM NAME LCMST;

COMMENT ON TABLE HNEACOSTA1/LCMST IS
    'Maestro de Cartas de Credito - Modulo 5 Cartas de Credito';

LABEL ON TABLE HNEACOSTA1/LCMST
    IS 'Maestro Cartas Cred';

COMMENT ON COLUMN HNEACOSTA1/LCMST.id IS
    'Identificador tecnico unico autoincremental de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.numero_carta_credito IS
    'Numero funcional unico de la carta de credito, referenciado por tablas hijas';
COMMENT ON COLUMN HNEACOSTA1/LCMST.codigo_banco IS
    'Codigo del banco emisor de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.codigo_sucursal IS
    'Codigo de la sucursal donde fue aperturada la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.tipo_carta IS
    'Clasificacion de la carta: IMPORTACION, EXPORTACION, STAND_BY, GARANTIA';
COMMENT ON COLUMN HNEACOSTA1/LCMST.tipo_producto IS
    'Codigo del producto bancario especifico segun catalogo APCLS';
COMMENT ON COLUMN HNEACOSTA1/LCMST.id_cliente IS
    'Identificador del cliente ordenante de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.fecha_emision IS
    'Fecha de emision de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.fecha_vencimiento IS
    'Fecha de vencimiento pactada de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.monto_original IS
    'Monto original de la carta de credito en la moneda pactada';
COMMENT ON COLUMN HNEACOSTA1/LCMST.saldo_actual IS
    'Saldo vigente disponible de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.banco_corresponsal IS
    'Nombre o codigo del banco corresponsal en el exterior';
COMMENT ON COLUMN HNEACOSTA1/LCMST.pais_destino IS
    'Pais de destino o del beneficiario de la carta de credito';
COMMENT ON COLUMN HNEACOSTA1/LCMST.estado_carta IS
    'Estado operativo de la carta: ABIERTA, UTILIZADA, VENCIDA, CANCELADA';
COMMENT ON COLUMN HNEACOSTA1/LCMST.usuario_creacion IS
    'Usuario del sistema que registro el registro';
COMMENT ON COLUMN HNEACOSTA1/LCMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/LCMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/LCMST.observaciones IS
    'Notas libres o anotaciones operativas del registro';
COMMENT ON COLUMN HNEACOSTA1/LCMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/LCMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/LCMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/LCMST (
    id                           TEXT IS 'ID Carta',
    numero_carta_credito         TEXT IS 'No. Carta Cred',
    codigo_banco                 TEXT IS 'Banco',
    codigo_sucursal              TEXT IS 'Sucursal',
    codigo_moneda                TEXT IS 'Moneda',
    tipo_carta                   TEXT IS 'Tipo Carta',
    tipo_producto                TEXT IS 'Tipo Prod',
    id_cliente                   TEXT IS 'ID Cliente',
    fecha_emision                TEXT IS 'Fec Emision',
    fecha_vencimiento            TEXT IS 'Fec Vencim',
    monto_original               TEXT IS 'Monto Orig',
    saldo_actual                 TEXT IS 'Saldo Actual',
    banco_corresponsal           TEXT IS 'Banco Corresp',
    pais_destino                 TEXT IS 'Pais Destino',
    estado_carta                 TEXT IS 'Estado Carta',
    usuario_creacion             TEXT IS 'Usr Creacion',
    usuario_actualizacion        TEXT IS 'Usr Actualiz',
    version_registro             TEXT IS 'Version Reg',
    observaciones                TEXT IS 'Observacion',
    estado_registro              TEXT IS 'Estado Reg',
    created_at                   TEXT IS 'Fec Creacion',
    updated_at                   TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/ILCMSTCAT ON HNEACOSTA1/LCMST (created_at);
CREATE INDEX HNEACOSTA1/ILCMSTCLI ON HNEACOSTA1/LCMST (id_cliente);
CREATE INDEX HNEACOSTA1/ILCMSTFVE ON HNEACOSTA1/LCMST (fecha_vencimiento);
CREATE INDEX HNEACOSTA1/ILCMSTBNK ON HNEACOSTA1/LCMST (codigo_banco);

-- =============================================================================
-- Fin de script: LCMST_CREATE.sql
-- =============================================================================
