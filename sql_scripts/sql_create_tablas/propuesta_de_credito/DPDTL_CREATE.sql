-- ==============================================================================
-- Nombre de la Tabla  : DPDTL
-- DESCRIPCION         : Detalle de la Declaracion Patrimonial de Personas
--                       Naturales. Contiene el desglose por tipo de registro
--                       (activos, pasivos, ingresos) de la declaracion.
-- Objetivo            : Almacenar el detalle linea a linea de activos, pasivos
--                       e ingresos de la declaracion patrimonial personal.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso manual por analista o cliente
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo de Propuesta de Credito - analisis patrimonial
-- Restricciones       : FK a DPMST(id_cliente, secuencia); estado_registro ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE DPDTL (
    id_cliente            FOR COLUMN DPDTLCLI  VARCHAR(30)    NOT NULL,
    secuencia             FOR COLUMN DPDTLSEQ  INT            NOT NULL,
    tipo_registro         FOR COLUMN DPDTLTRG  VARCHAR(20)    NOT NULL,
    fecha_propuesta       FOR COLUMN DPDTLFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN DPDTLMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN DPDTLPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN DPDTLTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN DPDTLDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN DPDTLEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN DPDTLUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN DPDTLUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN DPDTLVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN DPDTLOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN DPDTLERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN DPDTLCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN DPDTLUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_DPDTL PRIMARY KEY (id_cliente, secuencia, tipo_registro)
    --CONSTRAINT FK_DPDTL_DPMST FOREIGN KEY (id_cliente, secuencia)
    --    REFERENCES DPMST (id_cliente, secuencia)
)
RCDFMT DPDTLR;

RENAME TABLE DPDTL
    TO DPDTL_TABLE FOR SYSTEM NAME DPDTL;

COMMENT ON TABLE DPDTL IS
    'Detalle Declaracion Patrimonial Personas Naturales - Modulo 13 Taller IBM i';

LABEL ON TABLE DPDTL IS
    'Detalle Declaracion Patr. PN';

COMMENT ON COLUMN DPDTL.id_cliente            IS 'Identificacion del cliente - parte de FK a DPMST';
COMMENT ON COLUMN DPDTL.secuencia             IS 'Secuencia de la declaracion - parte de FK a DPMST';
COMMENT ON COLUMN DPDTL.tipo_registro         IS 'Tipo de partida patrimonial: ACTIVO, PASIVO, INGRESO, EGRESO';
COMMENT ON COLUMN DPDTL.fecha_propuesta       IS 'Fecha del detalle patrimonial ingresado';
COMMENT ON COLUMN DPDTL.monto_solicitado      IS 'Valor monetario de la partida patrimonial registrada';
COMMENT ON COLUMN DPDTL.plazo_meses           IS 'Plazo en meses asociado a la partida si aplica';
COMMENT ON COLUMN DPDTL.tasa_propuesta        IS 'Tasa de interes o rendimiento asociado a la partida';
COMMENT ON COLUMN DPDTL.dictamen_credito      IS 'Observacion del analista sobre la partida patrimonial';
COMMENT ON COLUMN DPDTL.estado_propuesta      IS 'Estado de la partida: VIGENTE, VERIFICADA, CUESTIONADA';
COMMENT ON COLUMN DPDTL.usuario_creacion      IS 'Usuario que registro la partida patrimonial';
COMMENT ON COLUMN DPDTL.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion';
COMMENT ON COLUMN DPDTL.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN DPDTL.observaciones         IS 'Notas adicionales sobre la partida patrimonial';
COMMENT ON COLUMN DPDTL.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN DPDTL.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN DPDTL.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN DPDTL (
    id_cliente            IS 'ID Cliente',
    secuencia             IS 'Secuencia',
    tipo_registro         IS 'Tipo Reg',
    fecha_propuesta       IS 'Fec Partida',
    monto_solicitado      IS 'Valor Partid',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Ref',
    dictamen_credito      IS 'Obs Analista',
    estado_propuesta      IS 'Estado Part',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN DPDTL (
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

CREATE INDEX IDX_DPDTL_C ON DPDTL (created_at);
