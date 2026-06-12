-- ==============================================================================
-- Nombre de la Tabla  : PLPRD
-- DESCRIPCION         : Detalle de Productos asociados a una propuesta de
--                       credito. Registra cada producto financiero incluido
--                       en la propuesta (prestamo, linea, etc.).
-- Objetivo            : Detallar los productos financieros que componen cada
--                       propuesta de credito, con su monto, plazo y tasa
--                       individuales.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso por oficial de crédito al crear la propuesta
-- Permanencia de Datos: Permanente con histórico
-- Uso de los datos    : Módulo de Propuesta de Crédito - desglose por producto
-- Restricciones       : FK a PLPCR.numero_propuesta; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Crédito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/PLPRD (
    numero_propuesta      FOR COLUMN NUMPROP  VARCHAR(30)    NOT NULL,
    codigo_producto       FOR COLUMN CODPROD  VARCHAR(20)    NOT NULL,
    tipo_producto         FOR COLUMN TIPPROD  VARCHAR(20)    NOT NULL,
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
    CONSTRAINT PK_PLPRD  PRIMARY KEY (numero_propuesta, codigo_producto, tipo_producto),
    CONSTRAINT FK_PLPRD_PLPCR FOREIGN KEY (numero_propuesta)
        REFERENCES HNEACOSTA1/PLPCR (numero_propuesta)
)
RCDFMT PLPRDR;

RENAME TABLE HNEACOSTA1/PLPRD
    TO PLPRD FOR SYSTEM NAME PLPRD;

COMMENT ON TABLE HNEACOSTA1/PLPRD IS
    'Detalle de Productos por Propuesta de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE HNEACOSTA1/PLPRD IS
    'Detalle Productos Propuesta';

COMMENT ON COLUMN HNEACOSTA1/PLPRD.numero_propuesta      IS 'Numero de propuesta al que pertenece este producto (FK PLPCR)';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.codigo_producto       IS 'Codigo del producto financiero incluido en la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.tipo_producto         IS 'Tipo del producto: PRESTAMO, LINEA, CERTIFICADO, etc.';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.fecha_propuesta       IS 'Fecha en que se registro este producto en la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.monto_solicitado      IS 'Monto solicitado para este producto dentro de la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.plazo_meses           IS 'Plazo en meses solicitado para este producto';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.tasa_propuesta        IS 'Tasa de interes propuesta para este producto';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.dictamen_credito      IS 'Dictamen especifico para este producto dentro de la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.estado_propuesta      IS 'Estado del producto en la propuesta: PENDIENTE, APROBADO, RECHAZADO';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.usuario_creacion      IS 'Usuario que registro el detalle del producto';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al detalle';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.observaciones         IS 'Notas adicionales sobre este producto en la propuesta';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN HNEACOSTA1/PLPRD.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/PLPRD (
    numero_propuesta      TEXT IS 'Numero de Propuesta',
    codigo_producto       TEXT IS 'Codigo de Producto',
    tipo_producto         TEXT IS 'Tipo de Producto',
    fecha_propuesta       TEXT IS 'Fecha de Propuesta',
    monto_solicitado      TEXT IS 'Monto Solicitado',
    plazo_meses           TEXT IS 'Plazo en Meses',
    tasa_propuesta        TEXT IS 'Tasa Propuesta',
    dictamen_credito      TEXT IS 'Dictamen de Credito',
    estado_propuesta      TEXT IS 'Estado de Propuesta',
    usuario_creacion      TEXT IS 'Usuario de Creacion',
    usuario_actualizacion TEXT IS 'Usuario de Actualizacion',
    version_registro      TEXT IS 'Version del Registro',
    observaciones         TEXT IS 'Observaciones',
    estado_registro       TEXT IS 'Estado del Registro',
    created_at            TEXT IS 'Fecha Creacion',
    updated_at            TEXT IS 'Fecha Actualizacion'
);

CREATE INDEX HNEACOSTA1/IDX_PLPRD_C ON HNEACOSTA1/PLPRD (created_at);
