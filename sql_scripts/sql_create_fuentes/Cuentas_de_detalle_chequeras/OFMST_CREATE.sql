-- ============================================================
-- Nombre de la Tabla  : OFMST
-- DESCRIPCION         : Maestro de Cheques Certificados y Cheques de Gerencia
-- Objetivo            : Registrar y controlar los cheques certificados
--                       y cheques de gerencia emitidos por el banco.
-- Tipo de Tabla       : Maestra / Operativa
-- Origen de los Datos : Proceso de certificacion y emision de cheques
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Control de pago, consulta y auditoria de cheques oficiales
-- Restricciones       : PK compuesta por banco, sucursal y numero de cheque
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE OFMST (
    codigo_banco            FOR COLUMN OFMSTBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN OFMSTSUC VARCHAR(20)     NOT NULL    ,
    numero_cheque           FOR COLUMN OFMSTCHE VARCHAR(30)     NOT NULL    ,
    tipo_cheque             FOR COLUMN OFMSTTCH VARCHAR(20)                 ,
    nombre_beneficiario     FOR COLUMN OFMSTNBE VARCHAR(80)                 ,
    monto                   FOR COLUMN OFMSTMNT DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    codigo_moneda           FOR COLUMN OFMSTMON VARCHAR(20)                 ,
    fecha_emision           FOR COLUMN OFMSTFEM DATE                        ,
    fecha_vencimiento       FOR COLUMN OFMSTFVE DATE                        ,
    estado_cheque           FOR COLUMN OFMSTEST VARCHAR(20)                 ,
    numero_cuenta_origen    FOR COLUMN OFMSTCTO VARCHAR(24)                 ,
    fecha_apertura          FOR COLUMN OFMSTFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN OFMSTFUT DATE                       ,
    saldo_actual            FOR COLUMN OFMSTSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN OFMSTSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN OFMSTLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN OFMSTESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN OFMSTUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN OFMSTUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN OFMSTVRS INT NOT NULL DEFAULT 1   ,
    observaciones           FOR COLUMN OFMSTOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN OFMSTERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN OFMSTCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN OFMSTUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        
    --CONSTRAINT PK_OFMST PRIMARY KEY (codigo_banco, codigo_sucursal,
    --                                 numero_cheque)
)
RCDFMT OFMSTR;

RENAME TABLE OFMST
    TO OFMST_TABLE FOR SYSTEM NAME OFMST;

COMMENT ON TABLE OFMST IS
    'Maestro de Cheques Certificados y Cheques de Gerencia - Modulo 3';

LABEL ON TABLE OFMST
    IS 'Maestro Cheques Certif';

COMMENT ON COLUMN OFMST.codigo_banco IS
    'Codigo del banco que emite el cheque certificado o de gerencia';
COMMENT ON COLUMN OFMST.codigo_sucursal IS
    'Codigo de la sucursal que emite el cheque oficial';
COMMENT ON COLUMN OFMST.numero_cheque IS
    'Numero consecutivo unico del cheque dentro del banco y sucursal';
COMMENT ON COLUMN OFMST.tipo_cheque IS
    'Clasificacion del cheque: CERTIFICADO, GERENCIA, VIAJERO';
COMMENT ON COLUMN OFMST.nombre_beneficiario IS
    'Nombre del beneficiario a cuyo favor se emite el cheque';
COMMENT ON COLUMN OFMST.monto IS
    'Valor monetario del cheque en la moneda indicada';
COMMENT ON COLUMN OFMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominado el cheque';
COMMENT ON COLUMN OFMST.fecha_emision IS
    'Fecha en que fue emitido el cheque por el banco';
COMMENT ON COLUMN OFMST.fecha_vencimiento IS
    'Fecha de vencimiento del cheque segun politica de caducidad';
COMMENT ON COLUMN OFMST.estado_cheque IS
    'Estado del cheque: EMITIDO, PAGADO, ANULADO, VENCIDO, DEVUELTO';
COMMENT ON COLUMN OFMST.numero_cuenta_origen IS
    'Numero de cuenta desde la que se debito el monto del cheque';
COMMENT ON COLUMN OFMST.fecha_apertura IS
    'Fecha de apertura de la cuenta origen del debito del cheque';
COMMENT ON COLUMN OFMST.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado sobre el cheque';
COMMENT ON COLUMN OFMST.saldo_actual IS
    'Saldo de la cuenta origen al momento de la emision del cheque';
COMMENT ON COLUMN OFMST.saldo_disponible IS
    'Saldo disponible de la cuenta origen al momento de la emision';
COMMENT ON COLUMN OFMST.limite_sobregiro IS
    'Limite de sobregiro de la cuenta origen vigente al emitir el cheque';
COMMENT ON COLUMN OFMST.estado_cuenta IS
    'Estado de la cuenta origen al momento de la emision del cheque';
COMMENT ON COLUMN OFMST.usuario_creacion IS
    'Usuario del sistema que registro la emision del cheque';
COMMENT ON COLUMN OFMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN OFMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN OFMST.observaciones IS
    'Notas adicionales sobre el cheque o su proceso de emision';
COMMENT ON COLUMN OFMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN OFMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN OFMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN OFMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    numero_cheque            TEXT IS 'No. Cheque',
    tipo_cheque              TEXT IS 'Tipo Cheque',
    nombre_beneficiario      TEXT IS 'Beneficiario',
    monto                    TEXT IS 'Monto',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_emision            TEXT IS 'Fec Emision',
    fecha_vencimiento        TEXT IS 'Fec Vencim',
    estado_cheque            TEXT IS 'Estado Che',
    numero_cuenta_origen     TEXT IS 'Cta Origen',
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

CREATE INDEX IOFMSTCAT ON OFMST (created_at);
CREATE INDEX IOFMSTPK ON OFMST (codigo_banco, codigo_sucursal);
