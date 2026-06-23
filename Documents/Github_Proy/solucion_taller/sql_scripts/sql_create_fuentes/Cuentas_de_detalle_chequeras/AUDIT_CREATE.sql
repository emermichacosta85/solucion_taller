-- ============================================================
-- Nombre de la Tabla  : AUDIT
-- DESCRIPCION         : Detalle diario de transacciones de caja
-- Objetivo            : Registrar el detalle de cada transaccion realizada
--                       por un cajero durante la jornada operativa para
--                       auditoria y cierre de caja diario.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Procesamiento en linea de transacciones de caja
-- Permanencia de Datos: Historica (retener segun politica de auditoria)
-- Uso de los datos    : Cierre diario, cuadre de caja, auditoria interna
-- Restricciones       : FK hacia TLMST por cajero; FK hacia TDRCR por transaccion
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE AUDIT (
    codigo_banco            FOR COLUMN AUDITBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN AUDITSUC VARCHAR(20)     NOT NULL    ,
    codigo_cajero           FOR COLUMN AUDITCAJ VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN AUDITMON VARCHAR(20)     NOT NULL    ,
    referencia              FOR COLUMN AUDITREF VARCHAR(50)     NOT NULL    ,
    fecha_transaccion       FOR COLUMN AUDITFTX DATE            NOT NULL    ,
    hora_transaccion        FOR COLUMN AUDITHTX TIME                  ,
    codigo_transaccion      FOR COLUMN AUDITCTX VARCHAR(20)                 ,
    numero_cuenta           FOR COLUMN AUDITCTA VARCHAR(24)                 ,
    monto                   FOR COLUMN AUDITMNT DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    debito_credito          FOR COLUMN AUDITDC CHAR(1)                     ,
    numero_documento        FOR COLUMN AUDITNDO VARCHAR(30)                 ,
    saldo_caja_antes        FOR COLUMN AUDITSCA DECIMAL(18,2)               ,
    saldo_caja_despues      FOR COLUMN AUDITSCD DECIMAL(18,2)               ,
    fecha_apertura          FOR COLUMN AUDITFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN AUDITFUT DATE                       ,
    saldo_actual            FOR COLUMN AUDITSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN AUDITSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN AUDITLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN AUDITESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN AUDITUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN AUDITUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN AUDITVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN AUDITOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN AUDITERG CHAR(1)  DEFAULT 'A'
    created_at              FOR COLUMN AUDITCAT TIMESTAMP NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN AUDITUAT TIMESTAMP NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_AUDIT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_cajero, codigo_moneda, referencia)
    --CONSTRAINT FK_AUDIT_TLMST FOREIGN KEY (codigo_cajero, codigo_moneda)
    --    REFERENCES TLMST (codigo_de_cajero, codigo_moneda),
    --CONSTRAINT FK_AUDIT_TDRCR FOREIGN KEY (codigo_transaccion)
    --    REFERENCES TDRCR (codigo_de_transaccion)
)
RCDFMT AUDITR;

RENAME TABLE AUDIT
    TO AUDIT_TABLE FOR SYSTEM NAME AUDIT;

COMMENT ON TABLE AUDIT IS
    'Detalle Diario de Transacciones de Caja - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE AUDIT
    IS 'Trans Diarias Caja';

COMMENT ON COLUMN AUDIT.codigo_banco IS
    'Codigo del banco donde se realizo la transaccion de caja';
COMMENT ON COLUMN AUDIT.codigo_sucursal IS
    'Codigo de la sucursal donde opera el cajero';
COMMENT ON COLUMN AUDIT.codigo_cajero IS
    'Codigo del cajero que proceso la transaccion (FK TLMST)';
COMMENT ON COLUMN AUDIT.codigo_moneda IS
    'Codigo ISO de la moneda de la transaccion de caja';
COMMENT ON COLUMN AUDIT.referencia IS
    'Referencia unica de la transaccion en la jornada del cajero';
COMMENT ON COLUMN AUDIT.fecha_transaccion IS
    'Fecha en que se proceso la transaccion en caja';
COMMENT ON COLUMN AUDIT.hora_transaccion IS
    'Hora exacta del procesamiento de la transaccion';
COMMENT ON COLUMN AUDIT.codigo_transaccion IS
    'Codigo del tipo de transaccion segun catalogo TDRCR (FK)';
COMMENT ON COLUMN AUDIT.numero_cuenta IS
    'Numero de cuenta del cliente afectada por la transaccion';
COMMENT ON COLUMN AUDIT.monto IS
    'Valor monetario de la transaccion procesada en caja';
COMMENT ON COLUMN AUDIT.debito_credito IS
    'Naturaleza del movimiento: D=Debito (pago/retiro), C=Credito (deposito)';
COMMENT ON COLUMN AUDIT.numero_documento IS
    'Numero de cheque, voucher u otro documento soporte de la transaccion';
COMMENT ON COLUMN AUDIT.saldo_caja_antes IS
    'Saldo de la caja del cajero antes de procesar la transaccion';
COMMENT ON COLUMN AUDIT.saldo_caja_despues IS
    'Saldo de la caja del cajero despues de procesar la transaccion';
COMMENT ON COLUMN AUDIT.fecha_apertura IS
    'Fecha de apertura de la jornada o cuenta relacionada';
COMMENT ON COLUMN AUDIT.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado en la caja del cajero';
COMMENT ON COLUMN AUDIT.saldo_actual IS
    'Saldo actual de la caja al momento del registro';
COMMENT ON COLUMN AUDIT.saldo_disponible IS
    'Saldo disponible en caja al momento del procesamiento';
COMMENT ON COLUMN AUDIT.limite_sobregiro IS
    'Limite de manejo de efectivo en la caja del cajero';
COMMENT ON COLUMN AUDIT.estado_cuenta IS
    'Estado de la jornada del cajero: ABIERTA, CERRADA, CUADRADA';
COMMENT ON COLUMN AUDIT.usuario_creacion IS
    'Usuario o proceso que registro la transaccion de caja';
COMMENT ON COLUMN AUDIT.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN AUDIT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN AUDIT.observaciones IS
    'Notas adicionales sobre la transaccion de caja';
COMMENT ON COLUMN AUDIT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN AUDIT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN AUDIT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN AUDIT (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_cajero            TEXT IS 'Cajero',
    codigo_moneda            TEXT IS 'Moneda',
    referencia               TEXT IS 'Referencia',
    fecha_transaccion        TEXT IS 'Fec Transacc',
    hora_transaccion         TEXT IS 'Hora Transac',
    codigo_transaccion       TEXT IS 'Cod Transacc',
    numero_cuenta            TEXT IS 'No. Cuenta',
    monto                    TEXT IS 'Monto',
    debito_credito           TEXT IS 'D/C',
    numero_documento         TEXT IS 'No. Document',
    saldo_caja_antes         TEXT IS 'Saldo Antes',
    saldo_caja_despues       TEXT IS 'Saldo Desp',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Caj',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IAUDITFTX ON AUDIT (fecha_transaccion);
CREATE INDEX IAUDITCTA ON AUDIT (numero_cuenta);
CREATE INDEX IAUDITCAT ON AUDIT (created_at);
