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

CREATE OR REPLACE TABLE HNEACOSTA1/OFMST (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN OFMSTBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN OFMSTSUC,
    numero_cheque           VARCHAR(30)     NOT NULL    FOR COLUMN OFMSTCHE,
    tipo_cheque             VARCHAR(20)                 FOR COLUMN OFMSTTCH,
    nombre_beneficiario     VARCHAR(80)                 FOR COLUMN OFMSTNBE,
    monto                   DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   FOR COLUMN OFMSTMNT,
    codigo_moneda           VARCHAR(20)                 FOR COLUMN OFMSTMON,
    fecha_emision           DATE                        FOR COLUMN OFMSTFEM,
    fecha_vencimiento       DATE                        FOR COLUMN OFMSTFVE,
    estado_cheque           VARCHAR(20)                 FOR COLUMN OFMSTEST,
    numero_cuenta_origen    VARCHAR(24)                 FOR COLUMN OFMSTCTO,
    fecha_apertura          DATE                        FOR COLUMN OFMSTFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN OFMSTFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN OFMSTSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN OFMSTSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN OFMSTLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN OFMSTESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN OFMSTUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN OFMSTUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN OFMSTVRS,
    observaciones           VARCHAR(120)                FOR COLUMN OFMSTOBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN OFMSTERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN OFMSTCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN OFMSTUAT,
    CONSTRAINT PK_OFMST PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     numero_cheque)
)
RCDFMT OFMSTR;

RENAME TABLE HNEACOSTA1/OFMST
    TO OFMST FOR SYSTEM NAME OFMST;

COMMENT ON TABLE HNEACOSTA1/OFMST IS
    'Maestro de Cheques Certificados y Cheques de Gerencia - Modulo 3';

LABEL ON TABLE HNEACOSTA1/OFMST
    IS 'Maestro Cheques Certif';

COMMENT ON COLUMN HNEACOSTA1/OFMST.codigo_banco IS
    'Codigo del banco que emite el cheque certificado o de gerencia';
COMMENT ON COLUMN HNEACOSTA1/OFMST.codigo_sucursal IS
    'Codigo de la sucursal que emite el cheque oficial';
COMMENT ON COLUMN HNEACOSTA1/OFMST.numero_cheque IS
    'Numero consecutivo unico del cheque dentro del banco y sucursal';
COMMENT ON COLUMN HNEACOSTA1/OFMST.tipo_cheque IS
    'Clasificacion del cheque: CERTIFICADO, GERENCIA, VIAJERO';
COMMENT ON COLUMN HNEACOSTA1/OFMST.nombre_beneficiario IS
    'Nombre del beneficiario a cuyo favor se emite el cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.monto IS
    'Valor monetario del cheque en la moneda indicada';
COMMENT ON COLUMN HNEACOSTA1/OFMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta denominado el cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.fecha_emision IS
    'Fecha en que fue emitido el cheque por el banco';
COMMENT ON COLUMN HNEACOSTA1/OFMST.fecha_vencimiento IS
    'Fecha de vencimiento del cheque segun politica de caducidad';
COMMENT ON COLUMN HNEACOSTA1/OFMST.estado_cheque IS
    'Estado del cheque: EMITIDO, PAGADO, ANULADO, VENCIDO, DEVUELTO';
COMMENT ON COLUMN HNEACOSTA1/OFMST.numero_cuenta_origen IS
    'Numero de cuenta desde la que se debito el monto del cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.fecha_apertura IS
    'Fecha de apertura de la cuenta origen del debito del cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.fecha_ultima_transaccion IS
    'Fecha del ultimo movimiento registrado sobre el cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.saldo_actual IS
    'Saldo de la cuenta origen al momento de la emision del cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.saldo_disponible IS
    'Saldo disponible de la cuenta origen al momento de la emision';
COMMENT ON COLUMN HNEACOSTA1/OFMST.limite_sobregiro IS
    'Limite de sobregiro de la cuenta origen vigente al emitir el cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.estado_cuenta IS
    'Estado de la cuenta origen al momento de la emision del cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.usuario_creacion IS
    'Usuario del sistema que registro la emision del cheque';
COMMENT ON COLUMN HNEACOSTA1/OFMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/OFMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/OFMST.observaciones IS
    'Notas adicionales sobre el cheque o su proceso de emision';
COMMENT ON COLUMN HNEACOSTA1/OFMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/OFMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/OFMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/OFMST (
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

CREATE INDEX HNEACOSTA1/IOFMSTCAT ON HNEACOSTA1/OFMST (created_at);
CREATE INDEX HNEACOSTA1/IOFMSTFEM ON HNEACOSTA1/OFMST (fecha_emision);
