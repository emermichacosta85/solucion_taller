-- ============================================================
-- Nombre de la Tabla  : UNCOL
-- DESCRIPCION         : Maestro de Retenciones sobre Cuentas
-- Objetivo            : Registrar y controlar las retenciones aplicadas
--                       sobre saldos de cuentas de detalle por diferentes
--                       conceptos (judiciales, garantias, embargos).
-- Tipo de Tabla       : Maestra / Operativa
-- Origen de los Datos : Ordenes judiciales, garantias y controles internos
-- Permanencia de Datos: Permanente mientras la retencion este vigente
-- Uso de los datos    : Calculo de saldo disponible en cuentas
-- Restricciones       : FK hacia ACMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE UNCOL (
    codigo_banco            FOR COLUMN UNCOLBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN UNCOLSUC VARCHAR(20)     NOT NULL    ,
    numero_cuenta           FOR COLUMN UNCOLCTA VARCHAR(24)     NOT NULL    ,
    fecha_apertura          FOR COLUMN UNCOLFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN UNCOLFUT DATE                       ,
    saldo_actual            FOR COLUMN UNCOLSAL DECIMAL(18,2)               ,
    saldo_disponible        FOR COLUMN UNCOLSDP DECIMAL(18,2)               ,
    limite_sobregiro        FOR COLUMN UNCOLLSO DECIMAL(18,2)               ,
    estado_cuenta           FOR COLUMN UNCOLESC VARCHAR(20)                 ,
    usuario_creacion        FOR COLUMN UNCOLUSC VARCHAR(30)                 ,
    usuario_actualizacion   FOR COLUMN UNCOLUSA VARCHAR(30)                 ,
    version_registro        FOR COLUMN UNCOLVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN UNCOLOBS VARCHAR(120)                ,
    estado_registro         FOR COLUMN UNCOLERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN UNCOLCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN UNCOLUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    CONSTRAINT PK_UNCOL PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     numero_cuenta)
    --CONSTRAINT FK_UNCOL_ACMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES ACMST (numero_cuenta)
)
RCDFMT UNCOLR;

RENAME TABLE UNCOL
    TO UNCOL_TABLE FOR SYSTEM NAME UNCOL;

COMMENT ON TABLE UNCOL IS
    'Maestro de Retenciones sobre Cuentas de Detalle - Modulo 3';

LABEL ON TABLE UNCOL
    IS 'Maestro Retenciones';

COMMENT ON COLUMN UNCOL.codigo_banco IS
    'Codigo del banco donde esta radicada la cuenta con retencion';
COMMENT ON COLUMN UNCOL.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN UNCOL.numero_cuenta IS
    'Numero de cuenta bancaria sobre la que aplica la retencion (FK ACMST)';
COMMENT ON COLUMN UNCOL.fecha_apertura IS
    'Fecha de apertura de la cuenta sobre la que se aplica la retencion';
COMMENT ON COLUMN UNCOL.fecha_ultima_transaccion IS
    'Fecha de la ultima modificacion o movimiento relacionado con la retencion';
COMMENT ON COLUMN UNCOL.saldo_actual IS
    'Saldo contable de la cuenta al momento de registrar la retencion';
COMMENT ON COLUMN UNCOL.saldo_disponible IS
    'Saldo disponible de la cuenta despues de descontar la retencion';
COMMENT ON COLUMN UNCOL.limite_sobregiro IS
    'Limite de sobregiro vigente de la cuenta al registrar la retencion';
COMMENT ON COLUMN UNCOL.estado_cuenta IS
    'Estado operativo de la cuenta al momento del registro de la retencion';
COMMENT ON COLUMN UNCOL.usuario_creacion IS
    'Usuario del sistema que registro la retencion';
COMMENT ON COLUMN UNCOL.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion';
COMMENT ON COLUMN UNCOL.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN UNCOL.observaciones IS
    'Notas adicionales sobre la retencion o su origen legal';
COMMENT ON COLUMN UNCOL.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN UNCOL.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN UNCOL.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN UNCOL (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    numero_cuenta            TEXT IS 'No. Cuenta',
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

CREATE INDEX IUNCOLPK ON UNCOL (codigo_banco, codigo_sucursal);
CREATE INDEX IUNCOLCAT ON UNCOL (created_at);
