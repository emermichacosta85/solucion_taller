-- ============================================================
-- Nombre de la Tabla  : RCLNB
-- DESCRIPCION         : Transacciones de Cuentas Reconciliables
-- Objetivo            : Almacenar los movimientos de cuentas sujetas a
--                       proceso de reconciliacion periodica con registros
--                       externos o contables.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Procesamiento batch y transacciones en linea
-- Permanencia de Datos: Historica (ciclo de reconciliacion)
-- Uso de los datos    : Proceso de reconciliacion bancaria y auditorias
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/RCLNB (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN RCLNBBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN RCLNBSUC,
    codigo_moneda           VARCHAR(20)     NOT NULL    FOR COLUMN RCLNBMON,
    cuenta_contable         VARCHAR(24)     NOT NULL    FOR COLUMN RCLNBCTC,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN RCLNBCTA,
    fecha                   DATE            NOT NULL    FOR COLUMN RCLNBFEC,
    secuencia               INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN RCLNBSEQ,
    tipo_transaccion        VARCHAR(20)                 FOR COLUMN RCLNBTTR,
    monto                   DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN RCLNBMNT,
    debito_credito          CHAR(1)                     FOR COLUMN RCLNBDC,
    estado_reconciliacion   VARCHAR(20)                 FOR COLUMN RCLNBEST,
    referencia_externa      VARCHAR(50)                 FOR COLUMN RCLNBREF,
    fecha_apertura          DATE                        FOR COLUMN RCLNBFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN RCLNBFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN RCLNBSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN RCLNBSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN RCLNBLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN RCLNBESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN RCLNBUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN RCLNBUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN RCLNBVRS,
    observaciones           VARCHAR(120)                FOR COLUMN RCLNBOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN RCLNBERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN RCLNBCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN RCLNBUAT,
    CONSTRAINT PK_RCLNB PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     numero_cuenta, fecha, secuencia),
    CONSTRAINT FK_RCLNB_ACMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/ACMST (numero_cuenta)
)
RCDFMT RCLNBR;

RENAME TABLE HNEACOSTA1/RCLNB
    TO RCLNB FOR SYSTEM NAME RCLNB;

COMMENT ON TABLE HNEACOSTA1/RCLNB IS
    'Transacciones de Cuentas Reconciliables - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/RCLNB
    IS 'Trans Ctas Reconcil';

COMMENT ON COLUMN HNEACOSTA1/RCLNB.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta reconciliable';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta y la transaccion';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.cuenta_contable IS
    'Codigo de cuenta contable del plan de cuentas asociado';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.numero_cuenta IS
    'Numero de cuenta bancaria sujeta a reconciliacion (FK ACMST)';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.fecha IS
    'Fecha del movimiento o transaccion a reconciliar';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.secuencia IS
    'Numero de orden para multiples movimientos en la misma fecha';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.tipo_transaccion IS
    'Tipo de transaccion que origino el movimiento en la cuenta';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.monto IS
    'Valor monetario del movimiento en la moneda de la cuenta';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.debito_credito IS
    'Naturaleza contable del movimiento: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.estado_reconciliacion IS
    'Estado del movimiento en proceso de reconciliacion: PENDIENTE, CONCILIADO, DIFERENCIA';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.referencia_externa IS
    'Referencia del documento o sistema externo para cruce en reconciliacion';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.fecha_apertura IS
    'Fecha de apertura de la cuenta reconciliable';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado sobre la cuenta';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.saldo_actual IS
    'Saldo contable de la cuenta al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.limite_sobregiro IS
    'Limite de sobregiro vigente en la cuenta al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.estado_cuenta IS
    'Estado operativo de la cuenta al momento del movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.usuario_creacion IS
    'Usuario del sistema que registro el movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion sobre el movimiento';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.observaciones IS
    'Notas sobre el movimiento o su proceso de reconciliacion';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/RCLNB.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/RCLNB (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    numero_cuenta            TEXT IS 'No. Cuenta',
    fecha                    TEXT IS 'Fecha',
    secuencia                TEXT IS 'Secuencia',
    tipo_transaccion         TEXT IS 'Tipo Trans',
    monto                    TEXT IS 'Monto',
    debito_credito           TEXT IS 'D/C',
    estado_reconciliacion    TEXT IS 'Est Reconcil',
    referencia_externa       TEXT IS 'Ref Externa',
    fecha_apertura           TEXT IS 'Fec Apertura',
    fecha_ultima_transaccion TEXT IS 'Ult Transacc',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_disponible         TEXT IS 'Saldo Dispon',
    limite_sobregiro         TEXT IS 'Lim Sobregir',
    estado_cuenta            TEXT IS 'Estado Cta',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IRCLNBFEC ON HNEACOSTA1/RCLNB (fecha);
CREATE INDEX HNEACOSTA1/IRCLNBCAT ON HNEACOSTA1/RCLNB (created_at);
