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

CREATE OR REPLACE TABLE HNEACOSTA1/AUDIT (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN AUDITBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN AUDITSUC,
    codigo_cajero           VARCHAR(20)     NOT NULL    FOR COLUMN AUDITCAJ,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN AUDITMON,
    referencia              VARCHAR(50)     NOT NULL    FOR COLUMN AUDITREF,
    fecha_transaccion       DATE            NOT NULL    FOR COLUMN AUDITFTX,
    hora_transaccion        TIME                        FOR COLUMN AUDITHTX,
    codigo_transaccion      VARCHAR(20)                 FOR COLUMN AUDITCTX,
    numero_cuenta           VARCHAR(24)                 FOR COLUMN AUDITCTA,
    monto                   DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN AUDITMNT,
    debito_credito          CHAR(1)                     FOR COLUMN AUDITDC,
    numero_documento        VARCHAR(30)                 FOR COLUMN AUDITNDO,
    saldo_caja_antes        DECIMAL(18,2)               FOR COLUMN AUDITSCA,
    saldo_caja_despues      DECIMAL(18,2)               FOR COLUMN AUDITSCD,
    fecha_apertura          DATE                        FOR COLUMN AUDITFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN AUDITFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN AUDITSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN AUDITSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN AUDITLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN AUDITESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN AUDITUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN AUDITUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN AUDITVRS,
    observaciones           VARCHAR(120)                FOR COLUMN AUDITOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN AUDITERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN AUDITCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN AUDITUAT,
    CONSTRAINT PK_AUDIT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_cajero, codigo_moneda, referencia),
    CONSTRAINT FK_AUDIT_TLMST FOREIGN KEY (codigo_cajero, codigo_moneda)
        REFERENCES HNEACOSTA1/TLMST (codigo_de_cajero, codigo_moneda),
    CONSTRAINT FK_AUDIT_TDRCR FOREIGN KEY (codigo_transaccion)
        REFERENCES HNEACOSTA1/TDRCR (codigo_de_transaccion)
)
RCDFMT AUDITR;

RENAME TABLE HNEACOSTA1/AUDIT
    TO AUDIT FOR SYSTEM NAME AUDIT;

COMMENT ON TABLE HNEACOSTA1/AUDIT IS
    'Detalle Diario de Transacciones de Caja - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/AUDIT
    IS 'Trans Diarias Caja';

COMMENT ON COLUMN HNEACOSTA1/AUDIT.codigo_banco IS
    'Codigo del banco donde se realizo la transaccion de caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.codigo_sucursal IS
    'Codigo de la sucursal donde opera el cajero';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.codigo_cajero IS
    'Codigo del cajero que proceso la transaccion (FK TLMST)';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.codigo_moneda IS
    'Codigo ISO de la moneda de la transaccion de caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.referencia IS
    'Referencia unica de la transaccion en la jornada del cajero';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.fecha_transaccion IS
    'Fecha en que se proceso la transaccion en caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.hora_transaccion IS
    'Hora exacta del procesamiento de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.codigo_transaccion IS
    'Codigo del tipo de transaccion segun catalogo TDRCR (FK)';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.numero_cuenta IS
    'Numero de cuenta del cliente afectada por la transaccion';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.monto IS
    'Valor monetario de la transaccion procesada en caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.debito_credito IS
    'Naturaleza del movimiento: D=Debito (pago/retiro), C=Credito (deposito)';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.numero_documento IS
    'Numero de cheque, voucher u otro documento soporte de la transaccion';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.saldo_caja_antes IS
    'Saldo de la caja del cajero antes de procesar la transaccion';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.saldo_caja_despues IS
    'Saldo de la caja del cajero despues de procesar la transaccion';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.fecha_apertura IS
    'Fecha de apertura de la jornada o cuenta relacionada';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado en la caja del cajero';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.saldo_actual IS
    'Saldo actual de la caja al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.saldo_disponible IS
    'Saldo disponible en caja al momento del procesamiento';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.limite_sobregiro IS
    'Limite de manejo de efectivo en la caja del cajero';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.estado_cuenta IS
    'Estado de la jornada del cajero: ABIERTA, CERRADA, CUADRADA';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.usuario_creacion IS
    'Usuario o proceso que registro la transaccion de caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.observaciones IS
    'Notas adicionales sobre la transaccion de caja';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/AUDIT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/AUDIT (
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

CREATE INDEX HNEACOSTA1/IAUDITFTX ON HNEACOSTA1/AUDIT (fecha_transaccion);
CREATE INDEX HNEACOSTA1/IAUDITCTA ON HNEACOSTA1/AUDIT (numero_cuenta);
CREATE INDEX HNEACOSTA1/IAUDITCAT ON HNEACOSTA1/AUDIT (created_at);
