-- ================================================================
-- Nombre de la Tabla  : DCMST
-- DESCRIPCION         : Maestro de Cobranzas Documentarias
-- Objetivo            : Centralizar la informacion de las cobranzas
--                       documentarias gestionadas por el banco, tanto
--                       de importacion como de exportacion, registrando
--                       el documento de cobro, su monto, vencimiento y
--                       estado de gestion hasta su liquidacion.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Recepcion de documentos de cobranza de bancos
--                       corresponsales o clientes exportadores
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Gestion de cobro, seguimiento de vencimientos
--                       y generacion de comisiones por servicio
-- Restricciones       : PK tecnica (id BIGINT); numero_cobranza unico;
--                       FK hacia CUMST por id_cliente
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/DCMST (
    id                       BIGINT         NOT NULL     FOR COLUMN DCMSTID,
    numero_cobranza          VARCHAR(30)    NOT NULL     FOR COLUMN DCMSTNCO,
    id_cliente               VARCHAR(30)                 FOR COLUMN DCMSTCLI,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN DCMSTBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN DCMSTSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN DCMSTMON,
    tipo_cobranza            VARCHAR(20)                 FOR COLUMN DCMSTTCO,
    banco_remitente          VARCHAR(80)                 FOR COLUMN DCMSTBRO,
    referencia_remitente     VARCHAR(50)                 FOR COLUMN DCMSTREF,
    nombre_girador           VARCHAR(80)                 FOR COLUMN DCMSTGIR,
    nombre_girado            VARCHAR(80)                 FOR COLUMN DCMSTGDO,
    fecha_recepcion          DATE                        FOR COLUMN DCMSTFRP,
    fecha_vencimiento        DATE                        FOR COLUMN DCMSTFVE,
    monto_original           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN DCMSTMOR,
    saldo_pendiente          DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN DCMSTSPD,
    tipo_documento           VARCHAR(20)                 FOR COLUMN DCMSTTDO,
    instrucciones_cobro      VARCHAR(120)                FOR COLUMN DCMSTICO,
    estado_operacion         VARCHAR(20)    NOT NULL     FOR COLUMN DCMSTESO,
    fecha_liquidacion        DATE                        FOR COLUMN DCMSTFLQ,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN DCMSTUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN DCMSTUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN DCMSTVRS,
    observaciones            VARCHAR(120)                FOR COLUMN DCMSTOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN DCMSTERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN DCMSTCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN DCMSTUAT,
    CONSTRAINT PK_DCMST      PRIMARY KEY (id),
    CONSTRAINT UQ_DCMST_NCO  UNIQUE      (numero_cobranza),
    CONSTRAINT FK_DCMST_CUMST FOREIGN KEY (id_cliente)
        REFERENCES HNEACOSTA1/CUMST (id_cliente)
)
RCDFMT DCMSTR;

RENAME TABLE HNEACOSTA1/DCMST
    TO DCMST FOR SYSTEM NAME DCMST;

COMMENT ON TABLE HNEACOSTA1/DCMST IS
    'Maestro de Cobranzas Documentarias - Modulo 6 Cobranzas';

LABEL ON TABLE HNEACOSTA1/DCMST
    IS 'Maestro Cobranzas Doc';

COMMENT ON COLUMN HNEACOSTA1/DCMST.id IS
    'Identificador tecnico unico autoincremental de la cobranza documentaria';
COMMENT ON COLUMN HNEACOSTA1/DCMST.numero_cobranza IS
    'Numero de cobranza asignado por el banco, unico en el sistema';
COMMENT ON COLUMN HNEACOSTA1/DCMST.id_cliente IS
    'Identificador del cliente (girador o girado) relacionado (FK CUMST)';
COMMENT ON COLUMN HNEACOSTA1/DCMST.codigo_banco IS
    'Codigo del banco que recibe y gestiona la cobranza documentaria';
COMMENT ON COLUMN HNEACOSTA1/DCMST.codigo_sucursal IS
    'Codigo de la sucursal donde se registro la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominada la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.tipo_cobranza IS
    'Clasificacion: IMPORTACION, EXPORTACION, LOCAL, DOCUMENTARIA, LIMPIA';
COMMENT ON COLUMN HNEACOSTA1/DCMST.banco_remitente IS
    'Nombre o codigo del banco corresponsal que envio la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.referencia_remitente IS
    'Numero de referencia asignado por el banco remitente a la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.nombre_girador IS
    'Nombre del exportador o emisor que origina la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.nombre_girado IS
    'Nombre del importador o deudor sobre quien recae el cobro';
COMMENT ON COLUMN HNEACOSTA1/DCMST.fecha_recepcion IS
    'Fecha en que el banco recibio los documentos de cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.fecha_vencimiento IS
    'Fecha limite para que el girado acepte o pague la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.monto_original IS
    'Monto total de la cobranza segun los documentos recibidos';
COMMENT ON COLUMN HNEACOSTA1/DCMST.saldo_pendiente IS
    'Saldo aun no cobrado de la cobranza documentaria';
COMMENT ON COLUMN HNEACOSTA1/DCMST.tipo_documento IS
    'Tipo de documento principal: LETRA, PAGARE, FACTURA, GIRO, OTRO';
COMMENT ON COLUMN HNEACOSTA1/DCMST.instrucciones_cobro IS
    'Instrucciones especiales del banco remitente para el cobro';
COMMENT ON COLUMN HNEACOSTA1/DCMST.estado_operacion IS
    'Estado de la cobranza: PENDIENTE, ACEPTADA, PAGADA, PROTESTADA, DEVUELTA';
COMMENT ON COLUMN HNEACOSTA1/DCMST.fecha_liquidacion IS
    'Fecha en que se liquido o cerro definitivamente la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.usuario_creacion IS
    'Usuario del sistema que registro la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN HNEACOSTA1/DCMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/DCMST.observaciones IS
    'Notas operativas o condiciones especiales de la cobranza';
COMMENT ON COLUMN HNEACOSTA1/DCMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/DCMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/DCMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/DCMST (
    id                       TEXT IS 'ID Cobranza',
    numero_cobranza          TEXT IS 'No. Cobranza',
    id_cliente               TEXT IS 'ID Cliente',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    tipo_cobranza            TEXT IS 'Tipo Cobran',
    banco_remitente          TEXT IS 'Banco Remit',
    referencia_remitente     TEXT IS 'Ref Remit',
    nombre_girador           TEXT IS 'Girador',
    nombre_girado            TEXT IS 'Girado',
    fecha_recepcion          TEXT IS 'Fec Recep',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    monto_original           TEXT IS 'Monto Orig',
    saldo_pendiente          TEXT IS 'Saldo Pend',
    tipo_documento           TEXT IS 'Tipo Doc',
    instrucciones_cobro      TEXT IS 'Instrucciones',
    estado_operacion         TEXT IS 'Estado Oper',
    fecha_liquidacion        TEXT IS 'Fec Liquid',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IDCMSTCAT ON HNEACOSTA1/DCMST (created_at);
CREATE INDEX HNEACOSTA1/IDCMSTCLI ON HNEACOSTA1/DCMST (id_cliente);
CREATE INDEX HNEACOSTA1/IDCMSTFVE ON HNEACOSTA1/DCMST (fecha_vencimiento);
CREATE INDEX HNEACOSTA1/IDCMSTESO ON HNEACOSTA1/DCMST (estado_operacion);
