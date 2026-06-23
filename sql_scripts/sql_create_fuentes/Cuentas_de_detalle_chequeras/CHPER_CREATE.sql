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

CREATE OR REPLACE TABLE CHPER (
    codigo_banco            FOR COLUMN CHPERBNK VARCHAR(20)     NOT NULL    ,
    codigo_sucursal         FOR COLUMN CHPERSUC VARCHAR(20)     NOT NULL    ,
    numero_cuenta           FOR COLUMN CHPERCTA VARCHAR(24)     NOT NULL    ,
    nombre_impresion        FOR COLUMN CHPERNMP VARCHAR(80)     NOT NULL    ,       
    direccion_impresion     FOR COLUMN CHPERDIR VARCHAR(120)    NOT NULL   ,
    telefono_impresion      FOR COLUMN CHPERTLF VARCHAR(30)     NOT NULL   ,
    diseno_chequera         FOR COLUMN CHPERDIS VARCHAR(20) NOT NULL,
    tipo_papel              FOR COLUMN CHPERTPA VARCHAR(20) NOT NULL,
    color_preferido         FOR COLUMN CHPERCLR VARCHAR(20) NOT NULL,
    cantidad_copias         FOR COLUMN CHPERQCP INT  NOT NULL DEFAULT 1   ,
                                            
    fecha_apertura          FOR COLUMN CHPERFAP DATE                        ,
    fecha_ultima_transaccion FOR COLUMN CHPERFUT DATE                       ,
    saldo_actual            FOR COLUMN CHPERSAL DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    saldo_disponible        FOR COLUMN CHPERSDP DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    limite_sobregiro        FOR COLUMN CHPERLSO DECIMAL(18,2)  NOT NULL DEFAULT 0.00,
    estado_cuenta           FOR COLUMN CHPERESC VARCHAR(20) NOT NULL DEFAULT ' ',
    usuario_creacion        FOR COLUMN CHPERUSC VARCHAR(30) NOT NULL DEFAULT ' ',
    usuario_actualizacion   FOR COLUMN CHPERUSA VARCHAR(30) NOT NULL DEFAULT ' ',
    version_registro        FOR COLUMN CHPERVRS INT             NOT NULL
                                            DEFAULT 1   ,
    observaciones           FOR COLUMN CHPEROBS VARCHAR(120) NOT NULL DEFAULT ' ',
    estado_registro         FOR COLUMN CHPERERG CHAR(1)         NOT NULL
                                            DEFAULT 'A' ,
    created_at              FOR COLUMN CHPERCAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                        ,
    updated_at              FOR COLUMN CHPERUAT TIMESTAMP       NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP,
                                                      
    CONSTRAINT PK_CHPER PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     numero_cuenta)
    --CONSTRAINT FK_CHPER_CHMST FOREIGN KEY (numero_cuenta)
    --    REFERENCES CHMST (numero_cuenta)
)
RCDFMT CHPERR;

RENAME TABLE CHPER
    TO CHPER_TABLE FOR SYSTEM NAME CHPER;

COMMENT ON TABLE CHPER IS
    'Personalizacion de Chequeras por Cuenta - Modulo 3 Cuentas de Detalle';

LABEL ON TABLE CHPER
    IS 'Personalizac Chequeras';

COMMENT ON COLUMN CHPER.codigo_banco IS
    'Codigo del banco al que pertenece la cuenta con personalizacion';
COMMENT ON COLUMN CHPER.codigo_sucursal IS
    'Codigo de la sucursal donde esta radicada la cuenta';
COMMENT ON COLUMN CHPER.numero_cuenta IS
    'Numero de cuenta corriente cuya chequera se personaliza (FK CHMST)';
COMMENT ON COLUMN CHPER.nombre_impresion IS
    'Nombre o razon social del cuentahabiente tal como se imprime en cheques';
COMMENT ON COLUMN CHPER.direccion_impresion IS
    'Direccion del cuentahabiente que se imprime en los cheques';
COMMENT ON COLUMN CHPER.telefono_impresion IS
    'Numero telefonico del cuentahabiente impreso en los cheques';
COMMENT ON COLUMN CHPER.diseno_chequera IS
    'Codigo del diseno o plantilla seleccionada para la impresion';
COMMENT ON COLUMN CHPER.tipo_papel IS
    'Tipo de papel o soporte fisico para la impresion de la chequera';
COMMENT ON COLUMN CHPER.color_preferido IS
    'Color de impresion o acabado seleccionado por el cuentahabiente';
COMMENT ON COLUMN CHPER.cantidad_copias IS
    'Numero de copias adicionales a imprimir por cada cheque';
COMMENT ON COLUMN CHPER.fecha_apertura IS
    'Fecha de apertura de la cuenta corriente asociada';
COMMENT ON COLUMN CHPER.fecha_ultima_transaccion IS
    'Fecha de la ultima actualizacion de la personalizacion';
COMMENT ON COLUMN CHPER.saldo_actual IS
    'Saldo actual de la cuenta corriente al momento del registro';
COMMENT ON COLUMN CHPER.saldo_disponible IS
    'Saldo disponible de la cuenta corriente al momento del registro';
COMMENT ON COLUMN CHPER.limite_sobregiro IS
    'Limite de sobregiro de la cuenta corriente asociada';
COMMENT ON COLUMN CHPER.estado_cuenta IS
    'Estado operativo de la cuenta corriente asociada';
COMMENT ON COLUMN CHPER.usuario_creacion IS
    'Usuario que registro la configuracion de personalizacion';
COMMENT ON COLUMN CHPER.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion de la personalizacion';
COMMENT ON COLUMN CHPER.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN CHPER.observaciones IS
    'Notas adicionales sobre las preferencias de personalizacion';
COMMENT ON COLUMN CHPER.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN CHPER.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN CHPER.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN CHPER (
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

CREATE INDEX ICHPERCAT ON CHPER (created_at);
