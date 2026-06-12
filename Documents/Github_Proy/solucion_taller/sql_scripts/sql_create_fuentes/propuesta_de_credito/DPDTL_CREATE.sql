-- ==============================================================================
-- Nombre de la Tabla  : DPDTL
-- DESCRIPCION         : Detalle de la Declaracion Patrimonial de Personas
--                       Naturales. Contiene el desglose por tipo de registro
--                       (activos, pasivos, ingresos) de la declaracion.
-- Objetivo            : Almacenar el detalle linea a linea de activos, pasivos
--                       e ingresos de la declaracion patrimonial personal.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso manual por analista o cliente
-- Permanencia de Datos: Permanente con histórico
-- Uso de los datos    : Módulo de Propuesta de Crédito - análisis patrimonial
-- Restricciones       : FK a DPMST(id_cliente, secuencia); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DPDTL (
    id_cliente            FOR COLUMN IDCLI    VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN SECUENC  INTEGER        NOT NULL,
    tipo_registro         FOR COLUMN TIPREG   VARCHAR(20)    NOT NULL,
    fecha_propuesta       FOR COLUMN FECPROP  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN MONTSOL  DECIMAL(18, 2) NOT NULL DEFAULT 0,
    plazo_meses           FOR COLUMN PLZMESES INTEGER        NOT NULL DEFAULT 0,
    tasa_propuesta        FOR COLUMN TASAPROP DECIMAL(18, 2) NOT NULL DEFAULT 0,
    dictamen_credito      FOR COLUMN DICTCRED VARCHAR(120)   NOT NULL DEFAULT '',
    estado_propuesta      FOR COLUMN ESTPROP  VARCHAR(20)    NOT NULL DEFAULT '',
    usuario_creacion      FOR COLUMN USRCREA  VARCHAR(30)    NOT NULL DEFAULT '',
    usuario_actualizacion FOR COLUMN USRACT   VARCHAR(30)    NOT NULL DEFAULT '',
    version_registro      FOR COLUMN VERSREG  INTEGER        NOT NULL DEFAULT 1,
    observaciones         FOR COLUMN OBSERVAC VARCHAR(120)   NOT NULL DEFAULT '',
    estado_registro       FOR COLUMN ESTREG   CHAR(1)        NOT NULL DEFAULT 'A',
    created_at            FOR COLUMN CRTDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN UPDDAT   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DPDTL  PRIMARY KEY (id_cliente, secuencia, tipo_registro),
    CONSTRAINT FK_DPDTL_DPMST FOREIGN KEY (id_cliente, secuencia)
        REFERENCES HNEACOSTA1/DPMST (id_cliente, secuencia)
)
RCDFMT DPDTLR;

RENAME TABLE HNEACOSTA1/DPDTL
    TO DPDTL FOR SYSTEM NAME DPDTL;

COMMENT ON TABLE HNEACOSTA1/DPDTL IS
    'Detalle Declaracion Patrimonial Personas Naturales - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/DPDTL IS
    'Detalle Declaracion Patr. PN';

COMMENT ON COLUMN HNEACOSTA1/DPDTL.id_cliente            IS 'Identificacion del cliente - parte de FK a DPMST';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.secuencia             IS 'Secuencia de la declaracion - parte de FK a DPMST';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.tipo_registro         IS 'Tipo de partida patrimonial: ACTIVO, PASIVO, INGRESO, EGRESO';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.fecha_propuesta       IS 'Fecha del detalle patrimonial ingresado';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.monto_solicitado      IS 'Valor monetario de la partida patrimonial registrada';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.plazo_meses           IS 'Plazo en meses asociado a la partida si aplica';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.tasa_propuesta        IS 'Tasa de interes o rendimiento asociado a la partida';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.dictamen_credito      IS 'Observacion del analista sobre la partida patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.estado_propuesta      IS 'Estado de la partida: VIGENTE, VERIFICADA, CUESTIONADA';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.usuario_creacion      IS 'Usuario que registro la partida patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.observaciones         IS 'Notas adicionales sobre la partida patrimonial';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/DPDTL.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DPDTL (
    id_cliente            TEXT IS 'ID Cliente',
    secuencia             TEXT IS 'Secuencia Declaracion',
    tipo_registro         TEXT IS 'Tipo de Registro',
    fecha_propuesta       TEXT IS 'Fecha Partida',
    monto_solicitado      TEXT IS 'Valor Partida',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Referencia',
    dictamen_credito      TEXT IS 'Observacion Analista',
    estado_propuesta      TEXT IS 'Estado Partida',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_DPDTL_C ON HNEACOSTA1/DPDTL (created_at);
