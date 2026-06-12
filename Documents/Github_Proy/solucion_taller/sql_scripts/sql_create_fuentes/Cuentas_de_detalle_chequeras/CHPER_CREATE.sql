-- ============================================================
-- Nombre de la Tabla  : CHPER
-- DESCRIPCION         : Personalizacion de Chequeras
-- Objetivo            : Almacenar las preferencias y personalizaciones
--                       del cliente para la impresion de sus chequeras.
-- Tipo de Tabla       : Maestra / Configuracion
-- Origen de los Datos : Solicitudes de personalizacion del cuentahabiente
-- Permanencia de Datos: Permanente
-- Uso de los datos    : Impresion personalizada de chequeras
-- Restricciones       : FK hacia CHMST por numero_cuenta
-- ------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 3 Cuentas de Detalle
-- ============================================================

CREATE OR REPLACE TABLE HNEACOSTA1/CHPER (
    codigo_banco            VARCHAR(20)     NOT NULL    FOR COLUMN CHPERBNK,
    codigo_sucursal         VARCHAR(20)     NOT NULL    FOR COLUMN CHPERSUC,
    numero_cuenta           VARCHAR(24)     NOT NULL    FOR COLUMN CHPERCTA,
    nombre_impresion        VARCHAR(80)                 FOR COLUMN CHPERNMP,
    direccion_impresion     VARCHAR(120)                FOR COLUMN CHPERDIR,
    telefono_impresion      VARCHAR(30)                 FOR COLUMN CHPERTLF,
    diseno_chequera         VARCHAR(20)                 FOR COLUMN CHPERDIS,
    tipo_papel              VARCHAR(20)                 FOR COLUMN CHPERTPA,
    color_preferido         VARCHAR(20)                 FOR COLUMN CHPERCLR,
    cantidad_copias         INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CHPERQCP,
    fecha_apertura          DATE                        FOR COLUMN CHPERFAP,
    fecha_ultima_transaccion DATE                       FOR COLUMN CHPERFUT,
    saldo_actual            DECIMAL(18,2)               FOR COLUMN CHPERSAL,
    saldo_disponible        DECIMAL(18,2)               FOR COLUMN CHPERSDP,
    limite_sobregiro        DECIMAL(18,2)               FOR COLUMN CHPERLSO,
    estado_cuenta           VARCHAR(20)                 FOR COLUMN CHPERESC,
    usuario_creacion        VARCHAR(30)                 FOR COLUMN CHPERUSC,
    usuario_actualizacion   VARCHAR(30)                 FOR COLUMN CHPERUSA,
    version_registro        INT             NOT NULL
                                            DEFAULT 1   FOR COLUMN CHPERVRS,
    observaciones           VARCHAR(120)                FOR COLUMN CHPEROBS,
    estado_registro         CHAR(1)         NOT NULL
                                            DEFAULT 'A' FOR COLUMN CHPERERG,
    created_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHPERCAT,
    updated_at              TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        FOR COLUMN CHPERUAT,
    CONSTRAINT PK_CHPER PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     numero_cuenta),
    CONSTRAINT FK_CHPER_CHMST FOREIGN KEY (numero_cuenta)
        REFERENCES HNEACOSTA1/CHMST (numero_cuenta)
)
RCDFMT CHPERR;

RENAME TABLE HNEACOSTA1/CHPER
    TO CHPER FOR SYSTEM NAME CHPER;

COMMENT ON TABLE HNEACOSTA1/CHPER IS
    'Personalizacion de Chequeras por Cuenta - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE HNEACOSTA1/CHPER
    IS 'Personalizac Chequeras';

COMMENT ON COLUMN HNEACOSTA1/CHPER.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta con personalizacion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN HNEACOSTA1/CHPER.numero_cuenta IS
    'Numero de cuenta corriente cuya chequera se personaliza (FK CHMST)';
COMMENT ON COLUMN HNEACOSTA1/CHPER.nombre_impresion IS
    'Nombre o razon social del cuentahabiente tal como se imprime en cheques';
COMMENT ON COLUMN HNEACOSTA1/CHPER.direccion_impresion IS
    'Direccion del cuentahabiente que se imprime en los cheques';
COMMENT ON COLUMN HNEACOSTA1/CHPER.telefono_impresion IS
    'Numero telefonico del cuentahabiente impreso en los cheques';
COMMENT ON COLUMN HNEACOSTA1/CHPER.diseno_chequera IS
    'Codigo del diseno o plantilla seleccionada para la impresion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.tipo_papel IS
    'Tipo de papel o soporte fisico para la impresion de la chequera';
COMMENT ON COLUMN HNEACOSTA1/CHPER.color_preferido IS
    'Color de impresion o acabado seleccionado por el cuentahabiente';
COMMENT ON COLUMN HNEACOSTA1/CHPER.cantidad_copias IS
    'Numero de copias adicionales a imprimir por cada cheque';
COMMENT ON COLUMN HNEACOSTA1/CHPER.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente asociada';
COMMENT ON COLUMN HNEACOSTA1/CHPER.fecha_ultima_transaccion IS
    'Fecha de la ultima actualizacion de la personalizacion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.saldo_actual IS
    'Saldo actual de la cuenta corriente al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/CHPER.saldo_disponible IS
    'Saldo disponible de la cuenta corriente al momento del registro';
COMMENT ON COLUMN HNEACOSTA1/CHPER.limite_sobregiro IS
    'Limite de sobregiro de la cuenta corriente asociada';
COMMENT ON COLUMN HNEACOSTA1/CHPER.estado_cuenta IS
    'Estado operativo de la cuenta corriente asociada';
COMMENT ON COLUMN HNEACOSTA1/CHPER.usuario_creacion IS
    'Usuario que registro la configuracion de personalizacion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la personalizacion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/CHPER.observaciones IS
    'Notas adicionales sobre las preferencias de personalizacion';
COMMENT ON COLUMN HNEACOSTA1/CHPER.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/CHPER.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/CHPER.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/CHPER (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    numero_cuenta            TEXT IS 'No. Cuenta',
    nombre_impresion         TEXT IS 'Nombre Imp',
    direccion_impresion      TEXT IS 'Direccion',
    telefono_impresion       TEXT IS 'Telefono',
    diseno_chequera          TEXT IS 'Diseno',
    tipo_papel               TEXT IS 'Tipo Papel',
    color_preferido          TEXT IS 'Color',
    cantidad_copias          TEXT IS 'Cant Copias',
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

CREATE INDEX HNEACOSTA1/ICHPERCAT ON HNEACOSTA1/CHPER (created_at);
