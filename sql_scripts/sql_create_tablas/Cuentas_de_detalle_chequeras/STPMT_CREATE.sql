-- ============================================================
-- Nombre de la Tabla  : STPMT
-- DESCRIPCION         : Ordenes de No Pago de Cheques
-- Objetivo            : Registrar instrucciones de suspension de pago
--                       sobre cheques emitidos por cuentahabientes.
-- Tipo de Tabla       : Transaccional
-- Origen de los Datos : Solicitudes de cuentahabientes y mandatos legales
-- Permanencia de Datos: Historica
-- Uso de los datos    : Control y consulta de cheques bloqueados
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE STPMT (
    codigo_banco            FOR COLUMN STPMTBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN STPMTSUC VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN STPMTMON VARCHAR(20)     NOT NULL    ,
    cuenta_contable         FOR COLUMN STPMTCTC VARCHAR(24)     NOT NULL    ,
    numero_cuenta           FOR COLUMN STPMTCTA VARCHAR(24)     NOT NULL    ,
    secuencia               FOR COLUMN STPMTSEQ INT             NOT NULL,
    fecha_apertura          FOR COLUMN STPMTFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN STPMTFUT DATE                       ,
    saldo_actual            FOR COLUMN STPMTSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN STPMTSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN STPMTLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN STPMTESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN STPMTUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN STPMTUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN STPMTVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN STPMTOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN STPMTERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN STPMTCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN STPMTUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_STPMT PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, cuenta_contable,
                                     numero_cuenta, secuencia)
    --CONSTRAINT FK_STPMT_ACMST FOREIGN KEY (numero_cuenta)
     --   REFERENCES ACMST (numero_cuenta)
)
RCDFMT STPMTR;

RENAME TABLE STPMT
    TO STPMT_TABLE FOR SYSTEM NAME STPMT;

COMMENT ON TABLE STPMT IS
    'Ordenes de No Pago de Cheques - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE STPMT
    IS 'Ordenes No Pago Cheques';

COMMENT ON COLUMN STPMT.codigo_banco IS
    'Codigo del banco emisor de la orden de suspension';
COMMENT ON COLUMN STPMT.codigo_sucursal IS
    'Codigo de la sucursal que registra la orden de suspension';
COMMENT ON COLUMN STPMT.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta asociada';
COMMENT ON COLUMN STPMT.cuenta_contable IS
    'Cuenta contable del plan de cuentas asociada a la cuenta';
COMMENT ON COLUMN STPMT.numero_cuenta IS
    'Numero de cuenta bancaria sobre la que aplica la suspension (FK ACMST)';
COMMENT ON COLUMN STPMT.secuencia IS
    'Numero de secuencia para permitir multiples ordenes por cuenta';
COMMENT ON COLUMN STPMT.fecha_apertura IS
    'Fecha de apertura de la cuenta asociada (referencia informativa)';
COMMENT ON COLUMN STPMT.fecha_ultima_transaccion IS
    'Fecha de la ultima transaccion sobre la orden de suspension';
COMMENT ON COLUMN STPMT.saldo_actual IS
    'Saldo actual de la cuenta al momento del registro de la orden';
COMMENT ON COLUMN STPMT.saldo_disponible IS
    'Saldo disponible de la cuenta al momento del bloqueo';
COMMENT ON COLUMN STPMT.limite_sobregiro IS
    'Limite de sobregiro vigente en la cuenta al momento del registro';
COMMENT ON COLUMN STPMT.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro de la orden';
COMMENT ON COLUMN STPMT.usuario_creacion IS
    'Usuario del sistema que registro la orden de suspension';
COMMENT ON COLUMN STPMT.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN STPMT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN STPMT.observaciones IS
    'Notas libres adicionales sobre la orden de suspension';
COMMENT ON COLUMN STPMT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN STPMT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN STPMT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN STPMT (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    numero_cuenta            TEXT IS 'No. Cuenta',
    secuencia                TEXT IS 'Secuencia',
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

CREATE INDEX ISTPMTPK ON STPMT (codigo_banco, codigo_sucursal);
CREATE INDEX ISTPMTCAT ON STPMT (created_at);
