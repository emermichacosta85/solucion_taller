-- ==============================================================================
-- Nombre de la Tabla  : PLPRD
-- DESCRIPCION         : Detalle de Productos asociados a una propuesta de
--                       credito. Registra cada producto financiero incluido
--                       en la propuesta (prestamo, linea, etc.).
-- Objetivo            : Detallar los productos financieros que componen cada
--                       propuesta de credito, con su monto, plazo y tasa
--                       individuales.
-- Tipo de Tabla       : Detalle Transaccional
-- Origen de los Datos : Ingreso por oficial de credito al crear la propuesta
-- Permanencia de Datos: Permanente con historico
-- Uso de los datos    : Modulo de Propuesta de Credito - desglose por producto
-- Restricciones       : FK a PLPCR.numero_propuesta; estado_registro en ('A','I')
-- Hecho por           : Taller IBM i - Equipo Propuesta de Credito
-- Fecha               : 2025-06-01
-- Proyecto            : Taller IBM i - Sistema Bancario IBS
-- ==============================================================================

CREATE OR REPLACE TABLE PLPRD (
    numero_propuesta      FOR COLUMN PLPRDNPR  VARCHAR(30)    NOT NULL,
    codigo_producto       FOR COLUMN PLPRDCPR  VARCHAR(20)    NOT NULL,
    tipo_producto         FOR COLUMN PLPRDTPO  VARCHAR(20)    NOT NULL,
    fecha_propuesta       FOR COLUMN PLPRDFPR  DATE           NOT NULL,
    monto_solicitado      FOR COLUMN PLPRDMSO  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    plazo_meses           FOR COLUMN PLPRDPME  INT            NOT NULL WITH DEFAULT 0,
    tasa_propuesta        FOR COLUMN PLPRDTPR  DECIMAL(18,2)  NOT NULL WITH DEFAULT 0,
    dictamen_credito      FOR COLUMN PLPRDDCR  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_propuesta      FOR COLUMN PLPRDEPR  VARCHAR(20)    NOT NULL WITH DEFAULT '',
    usuario_creacion      FOR COLUMN PLPRDUSC  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    usuario_actualizacion FOR COLUMN PLPRDUSA  VARCHAR(30)    NOT NULL WITH DEFAULT '',
    version_registro      FOR COLUMN PLPRDVRS  INT            NOT NULL WITH DEFAULT 1,
    observaciones         FOR COLUMN PLPRDOBS  VARCHAR(120)   NOT NULL WITH DEFAULT '',
    estado_registro       FOR COLUMN PLPRDERG  CHAR(1)        NOT NULL WITH DEFAULT 'A',
    created_at            FOR COLUMN PLPRDCAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    updated_at            FOR COLUMN PLPRDUAT  TIMESTAMP      NOT NULL WITH DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_PLPRD PRIMARY KEY (numero_propuesta, codigo_producto, tipo_producto)
    --CONSTRAINT FK_PLPRD_PLPCR FOREIGN KEY (numero_propuesta)
    --    REFERENCES PLPCR (numero_propuesta)
)
RCDFMT PLPRDR;

RENAME TABLE PLPRD
    TO PLPRD_TABLE FOR SYSTEM NAME PLPRD;

COMMENT ON TABLE PLPRD IS
    'Detalle de Productos por Propuesta de Credito - Modulo 13 Taller IBM i';

LABEL ON TABLE PLPRD IS
    'Detalle Productos Propuesta';

COMMENT ON COLUMN PLPRD.numero_propuesta      IS 'Numero de propuesta al que pertenece este producto (FK PLPCR)';
COMMENT ON COLUMN PLPRD.codigo_producto       IS 'Codigo del producto financiero incluido en la propuesta';
COMMENT ON COLUMN PLPRD.tipo_producto         IS 'Tipo del producto: PRESTAMO, LINEA, CERTIFICADO, etc.';
COMMENT ON COLUMN PLPRD.fecha_propuesta       IS 'Fecha en que se registro este producto en la propuesta';
COMMENT ON COLUMN PLPRD.monto_solicitado      IS 'Monto solicitado para este producto dentro de la propuesta';
COMMENT ON COLUMN PLPRD.plazo_meses           IS 'Plazo en meses solicitado para este producto';
COMMENT ON COLUMN PLPRD.tasa_propuesta        IS 'Tasa de interes propuesta para este producto';
COMMENT ON COLUMN PLPRD.dictamen_credito      IS 'Dictamen especifico para este producto dentro de la propuesta';
COMMENT ON COLUMN PLPRD.estado_propuesta      IS 'Estado del producto en la propuesta: PENDIENTE, APROBADO, RECHAZADO';
COMMENT ON COLUMN PLPRD.usuario_creacion      IS 'Usuario que registro el detalle del producto';
COMMENT ON COLUMN PLPRD.usuario_actualizacion IS 'Usuario que realizo la ultima modificacion al detalle';
COMMENT ON COLUMN PLPRD.version_registro      IS 'Numero de version para control de concurrencia optimista';
COMMENT ON COLUMN PLPRD.observaciones         IS 'Notas adicionales sobre este producto en la propuesta';
COMMENT ON COLUMN PLPRD.estado_registro       IS 'Estado logico del registro: A=Activo, I=Inactivo';
COMMENT ON COLUMN PLPRD.created_at            IS 'Fecha y hora de creacion del registro';
COMMENT ON COLUMN PLPRD.updated_at            IS 'Fecha y hora de la ultima actualizacion del registro';

LABEL ON COLUMN PLPRD (
    numero_propuesta      IS 'No. Propuesta',
    codigo_producto       IS 'Cod Producto',
    tipo_producto         IS 'Tipo Prod',
    fecha_propuesta       IS 'Fec Propuesta',
    monto_solicitado      IS 'Monto Solic',
    plazo_meses           IS 'Plazo Meses',
    tasa_propuesta        IS 'Tasa Prop',
    dictamen_credito      IS 'Dictamen',
    estado_propuesta      IS 'Estado Prop',
    usuario_creacion      IS 'Usr Creacion',
    usuario_actualizacion IS 'Usr Actualiz',
    version_registro      IS 'Version Reg',
    observaciones         IS 'Observacion',
    estado_registro       IS 'Estado Reg',
    created_at            IS 'Fec Creacion',
    updated_at            IS 'Fec Actualiz'
);

LABEL ON COLUMN PLPRD (
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

CREATE INDEX IDX_PLPRD_C ON PLPRD (created_at);
