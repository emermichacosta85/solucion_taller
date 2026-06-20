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

CREATE OR REPLACE TABLE RCLNB (
    codigo_banco            FOR COLUMN RCLNBBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN RCLNBSUC VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN RCLNBMON VARCHAR(20)     NOT NULL    ,
    cuenta_contable         FOR COLUMN RCLNBCTC VARCHAR(24)     NOT NULL    ,
    numero_cuenta           FOR COLUMN RCLNBCTA VARCHAR(24)     NOT NULL    ,
    fecha                   FOR COLUMN RCLNBFEC DATE            NOT NULL    ,
    secuencia               FOR COLUMN RCLNBSEQ INT             NOT NULL
                                            DEFAULT 1   ,
    tipo_transaccion        FOR COLUMN RCLNBTTR VARCHAR(20)                 ,
    monto                   FOR COLUMN RCLNBMNT DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    debito_credito          FOR COLUMN RCLNBDC CHAR(1)                     ,
    estado_reconciliacion   FOR COLUMN RCLNBEST VARCHAR(20)                 ,
    referencia_externa      FOR COLUMN RCLNBREF VARCHAR(50)                 ,
    fecha_apertura          FOR COLUMN RCLNBFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN RCLNBFUT DATE                       ,
    saldo_actual            FOR COLUMN RCLNBSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN RCLNBSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN RCLNBLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN RCLNBESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN RCLNBUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN RCLNBUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN RCLNBVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN RCLNBOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN RCLNBERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN RCLNBCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN RCLNBUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        
    --CONSTRAINT PK_RCLNB PRIMARY KEY (codigo_banco, codigo_sucursal,
    --                                 codigo_moneda, cuenta_contable,
    --                                 numero_cuenta, fecha, secuencia),
    --CONSTRAINT FK_RCLNB_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT RCLNBR;

RENAME TABLE RCLNB
    TO RCLNB_TABLE FOR SYSTEM NAME RCLNB;

COMMENT ON TABLE RCLNB IS
    'Transacciones de Cuentas Reconciliables - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE RCLNB
    IS 'Trans Ctas Reconcil';

COMMENT ON COLUMN RCLNB.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta reconciliable';
COMMENT ON COLUMN RCLNB.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN RCLNB.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta y la transaccion';
COMMENT ON COLUMN RCLNB.cuenta_contable IS
    'Codigo de cuenta contable del plan de cuentas asociado';
COMMENT ON COLUMN RCLNB.numero_cuenta IS
    'Numero de cuenta bancaria sujeta a reconciliacion (FK ACMST)';
COMMENT ON COLUMN RCLNB.fecha IS
    'Fecha del movimiento o transaccion a reconciliar';
COMMENT ON COLUMN RCLNB.secuencia IS
    'Numero de orden para multiples movimientos en la misma fecha';
COMMENT ON COLUMN RCLNB.tipo_transaccion IS
    'Tipo de transaccion que origino el movimiento en la cuenta';
COMMENT ON COLUMN RCLNB.monto IS
    'Valor monetario del movimiento en la moneda de la cuenta';
COMMENT ON COLUMN RCLNB.debito_credito IS
    'Naturaleza contable del movimiento: D=Debito, C=Credito';
COMMENT ON COLUMN RCLNB.estado_reconciliacion IS
    'Estado del movimiento en proceso de reconciliacion: PENDIENTE, CONCILIADO, DIFERENCIA';
COMMENT ON COLUMN RCLNB.referencia_externa IS
    'Referencia del documento o sistema externo para cruce en reconciliacion';
COMMENT ON COLUMN RCLNB.fecha_apertura IS
    'Fecha de apertura de la cuenta reconciliable';
COMMENT ON COLUMN RCLNB.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado sobre la cuenta';
COMMENT ON COLUMN RCLNB.saldo_actual IS
    'Saldo contable de la cuenta al momento del movimiento';
COMMENT ON COLUMN RCLNB.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del movimiento';
COMMENT ON COLUMN RCLNB.limite_sobregiro IS
    'Limite de sobregiro vigente en la cuenta al momento del movimiento';
COMMENT ON COLUMN RCLNB.estado_cuenta IS
    'Estado operativo de la cuenta al momento del movimiento';
COMMENT ON COLUMN RCLNB.usuario_creacion IS
    'Usuario del sistema que registro el movimiento';
COMMENT ON COLUMN RCLNB.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion sobre el movimiento';
COMMENT ON COLUMN RCLNB.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN RCLNB.observaciones IS
    'Notas sobre el movimiento o su proceso de reconciliacion';
COMMENT ON COLUMN RCLNB.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN RCLNB.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN RCLNB.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN RCLNB (
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

CREATE INDEX IRCLNBFEC ON RCLNB (fecha);
CREATE INDEX IRCLNBPK ON RCLNB (codigo_banco, codigo_sucursal);
