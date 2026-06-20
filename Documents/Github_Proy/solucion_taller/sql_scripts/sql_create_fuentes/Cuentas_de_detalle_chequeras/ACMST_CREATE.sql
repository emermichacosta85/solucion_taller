-- ============================================================
-- Nombre de la Tabla  : ACMST
-- DESCRIPCION         : Archivo Maestro de Cuentas de Detalle
-- Objetivo            : Almacenar la informacion maestra de todas las
--                       cuentas de detalle (ahorro, corriente, etc.)
--                       incluyendo saldos, estado y trazabilidad.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Apertura de cuentas bancarias
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Consulta y mantenimiento de cuentas de clientes
-- Restricciones       : Clave primaria tecnica (id BIGINT);
--                       FK hacia CUMST por numero de cliente.
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE ACMST (
    id                      FOR COLUMN ACMSTID BIGINT          NOT NULL    ,
    id_cliente              FOR COLUMN ACMSTCLI VARCHAR(30)     NOT NULL    ,
    numero_cuenta           FOR COLUMN ACMSTCTA VARCHAR(24)     NOT NULL    ,
    codigo_banco            FOR COLUMN ACMSTBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN ACMSTSUC VARCHAR(20)     NOT NULL    ,
    codigo_moneda           FOR COLUMN ACMSTMON VARCHAR(20)     NOT NULL    ,
    cuenta_contable         FOR COLUMN ACMSTCTC VARCHAR(24)     NOT NULL    ,
    tipo_producto           FOR COLUMN ACMSTPRD VARCHAR(20)     NOT NULL    ,
    fecha_apertura          FOR COLUMN ACMSTFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN ACMSTFUT DATE                       ,
    saldo_actual            FOR COLUMN ACMSTSAL DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    saldo_disponible        FOR COLUMN ACMSTSDP DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    limite_sobregiro        FOR COLUMN ACMSTLSO DECIMAL(18,2)   NOT NULL
                                            DEFAULT 0   ,
    estado_cuenta           FOR COLUMN ACMSTESC VARCHAR(20)     NOT NULL    ,
    usuario_creacion        FOR COLUMN ACMSTUSC VARCHAR(30)     NOT NULL    , 
    usuario_actualizacion   FOR COLUMN ACMSTUSA VARCHAR(30)     NOT NULL   ,
    version_registro        FOR COLUMN ACMSTVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN ACMSTOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN ACMSTERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN ACMSTCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at              FOR COLUMN ACMSTUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
                                                        
    CONSTRAINT PK_ACMST PRIMARY KEY (id)
)
RCDFMT ACMSTR;

RENAME TABLE ACMST
    TO ACMST_TABLE FOR SYSTEM NAME ACMST;

COMMENT ON TABLE ACMST IS
    'Archivo Maestro de Cuentas de Detalle - Modulo 3 Cuentas/Chequeras';

LABEL ON TABLE ACMST
    IS 'Maestro Cuentas Detalle';

COMMENT ON COLUMN ACMST.id IS
    'Identificador tecnico unico autoincremental de la cuenta de detalle';
COMMENT ON COLUMN ACMST.id_cliente IS
    'Identificador del cliente titular de la cuenta (FK CUMST)';
COMMENT ON COLUMN ACMST.numero_cuenta IS
    'Numero de cuenta bancaria unico asignado al momento de apertura';
COMMENT ON COLUMN ACMST.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta';
COMMENT ON COLUMN ACMST.codigo_sucursal IS
    'Codigo de la sucursal donde fue abierta la cuenta';
COMMENT ON COLUMN ACMST.codigo_moneda IS
    'Codigo ISO de la moneda de la cuenta (ej: HNL, USD)';
COMMENT ON COLUMN ACMST.cuenta_contable IS
    'Codigo de cuenta contable asociada para registros GL';
COMMENT ON COLUMN ACMST.tipo_producto IS
    'Tipo de producto bancario (ahorro, corriente, etc.)';
COMMENT ON COLUMN ACMST.fecha_apertura IS
    'Fecha en que fue abierta la cuenta en el sistema';
COMMENT ON COLUMN ACMST.fecha_ultima_transaccion IS
    'Fecha de la ultima transaccion registrada en la cuenta';
COMMENT ON COLUMN ACMST.saldo_actual IS
    'Saldo contable actual de la cuenta en la moneda de la cuenta';
COMMENT ON COLUMN ACMST.saldo_disponible IS
    'Saldo disponible para retiro descontando retenciones y reservas';
COMMENT ON COLUMN ACMST.limite_sobregiro IS
    'Limite maximo autorizado de sobregiro en la cuenta';
COMMENT ON COLUMN ACMST.estado_cuenta IS
    'Estado operativo de la cuenta (ACTIVA, INACTIVA, BLOQUEADA, CERRADA)';
COMMENT ON COLUMN ACMST.usuario_creacion IS
    'Usuario del sistema que creo el registro';
COMMENT ON COLUMN ACMST.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN ACMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN ACMST.observaciones IS
    'Notas libres o anotaciones operativas sobre la cuenta';
COMMENT ON COLUMN ACMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN ACMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN ACMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN ACMST (
    id                       TEXT IS 'ID Cuenta',
    id_cliente               TEXT IS 'ID Cliente',
    numero_cuenta            TEXT IS 'No. Cuenta',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    cuenta_contable          TEXT IS 'Cta Contable',
    tipo_producto            TEXT IS 'Tipo Producto',
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

CREATE INDEX IACMSTCLI ON ACMST (id_cliente);
CREATE INDEX IACMSTCTA ON ACMST (numero_cuenta);
CREATE INDEX IACMSTCAT ON ACMST (created_at);
