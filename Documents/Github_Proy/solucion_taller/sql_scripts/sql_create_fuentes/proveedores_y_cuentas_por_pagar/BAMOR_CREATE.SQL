-- ================================================================
-- Nombre de la Tabla  : BAMOR
-- DESCRIPCION         : Amortizaciones de Cuentas por Pagar
-- Objetivo            : Registrar el detalle de cada pago parcial o
--                       amortizacion realizada sobre una cuenta por pagar,
--                       permitiendo el seguimiento cronologico de la
--                       cancelacion de obligaciones y la conciliacion
--                       de pagos con los registros bancarios.
-- Tipo de Tabla       : Transaccional / Historica
-- Origen de los Datos : Proceso de pago o abono parcial a cuentas por pagar
-- Permanencia de Datos: Historica
-- Uso de los datos    : Conciliacion de pagos, auditoria y reportes
--                       de obligaciones canceladas o en proceso
-- Restricciones       : FK hacia BAPRC por clave compuesta
--                       (segun ERD: BAPRC ||--o{ BAMOR)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 11 Proveedores/CxP
-- ================================================================

CREATE OR REPLACE TABLE BAMOR (
    codigo_banco             FOR COLUMN BAMORBNK   VARCHAR(20)   NOT NULL,
    codigo_sucursal          FOR COLUMN BAMORSUC   VARCHAR(20)   NOT NULL,
    origen_cuenta            FOR COLUMN BAMORORG   VARCHAR(20)   NOT NULL,
    tipo_cuenta              FOR COLUMN BAMORTCU   VARCHAR(20)   NOT NULL,
    id_cliente               FOR COLUMN BAMORCLI   VARCHAR(30)   NOT NULL,
    numero_referencia        FOR COLUMN BAMORREF   VARCHAR(30)   NOT NULL,
    tipo_registro            FOR COLUMN BAMORTGR   VARCHAR(20)   NOT NULL,
    numero_identificacion    FOR COLUMN BAMORNID   VARCHAR(30),
    razon_social             FOR COLUMN BAMORRS    VARCHAR(80),
    email                    FOR COLUMN BAMOREM    VARCHAR(80),
    telefono                 FOR COLUMN BAMORTLF   VARCHAR(80),
    monto_original           FOR COLUMN BAMORMOR   DECIMAL(18,2),
    saldo_pendiente          FOR COLUMN BAMORSPD   DECIMAL(18,2),
    fecha_emision            FOR COLUMN BAMORFE    DATE,
    fecha_vencimiento        FOR COLUMN BAMORFV    DATE,
    estado_cxp               FOR COLUMN BAMOREST   VARCHAR(20)   NOT NULL,
    usuario_creacion         FOR COLUMN BAMORUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BAMORUSA   VARCHAR(30),
    version_registro         FOR COLUMN BAMORVRS   INT           NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BAMOROBS   VARCHAR(120),
    estado_registro          FOR COLUMN BAMORERG   CHAR(1)       NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BAMORCAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BAMORUAT   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BAMOR PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     origen_cuenta, tipo_cuenta,
                                     id_cliente, numero_referencia,
                                     tipo_registro)
    --CONSTRAINT FK_BAMOR_BAPRC FOREIGN KEY (codigo_banco, codigo_sucursal,
    --                                        origen_cuenta, tipo_cuenta,
    --                                        id_cliente, numero_referencia,
    --                                       tipo_registro)
    --    REFERENCES BAPRC (codigo_banco, codigo_sucursal,
    --                                origen_cuenta, tipo_cuenta,
    --                                id_cliente, numero_referencia,
    --                                tipo_registro)
)
RCDFMT BAMORR;

RENAME TABLE BAMOR
    TO BAMOR_TABLE FOR SYSTEM NAME BAMOR;

COMMENT ON TABLE BAMOR IS
    'Amortizaciones de Cuentas por Pagar - Modulo 11 Proveedores y CxP';

LABEL ON TABLE BAMOR
    IS 'Amortizaciones CxP';

COMMENT ON COLUMN BAMOR.codigo_banco IS
    'Codigo del banco que registra la amortizacion de la cuenta por pagar';
COMMENT ON COLUMN BAMOR.codigo_sucursal IS
    'Codigo de la sucursal que proceso el pago o amortizacion';
COMMENT ON COLUMN BAMOR.origen_cuenta IS
    'Origen de la cuenta por pagar sobre la que se aplica la amortizacion';
COMMENT ON COLUMN BAMOR.tipo_cuenta IS
    'Tipo de la cuenta por pagar amortizada (FK BAPRC)';
COMMENT ON COLUMN BAMOR.id_cliente IS
    'Identificador del cliente o contraparte de la cuenta amortizada (FK BAPRC)';
COMMENT ON COLUMN BAMOR.numero_referencia IS
    'Numero de referencia de la cuenta por pagar que se amortiza (FK BAPRC)';
COMMENT ON COLUMN BAMOR.tipo_registro IS
    'Tipo de registro de la cuenta por pagar padre (FK BAPRC)';
COMMENT ON COLUMN BAMOR.numero_identificacion IS
    'Numero de identificacion del beneficiario del pago (referencia informativa)';
COMMENT ON COLUMN BAMOR.razon_social IS
    'Nombre del beneficiario del pago en esta amortizacion';
COMMENT ON COLUMN BAMOR.email IS
    'Correo del beneficiario para notificaciones de confirmacion de pago';
COMMENT ON COLUMN BAMOR.telefono IS
    'Telefono del beneficiario para contacto sobre el pago realizado';
COMMENT ON COLUMN BAMOR.monto_original IS
    'Monto original de la cuenta por pagar padre (referencia informativa)';
COMMENT ON COLUMN BAMOR.saldo_pendiente IS
    'Saldo pendiente de la cuenta por pagar antes de esta amortizacion';
COMMENT ON COLUMN BAMOR.fecha_emision IS
    'Fecha de emision de la cuenta por pagar padre (referencia informativa)';
COMMENT ON COLUMN BAMOR.fecha_vencimiento IS
    'Fecha de vencimiento de la cuenta por pagar padre';
COMMENT ON COLUMN BAMOR.estado_cxp IS
    'Estado de la amortizacion: APLICADA, REVERSADA, ANULADA, EN_PROCESO';
COMMENT ON COLUMN BAMOR.usuario_creacion IS
    'Usuario del sistema que proceso la amortizacion';
COMMENT ON COLUMN BAMOR.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro de amortizacion';
COMMENT ON COLUMN BAMOR.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BAMOR.observaciones IS
    'Notas sobre el pago, condiciones especiales o instrucciones del proveedor';
COMMENT ON COLUMN BAMOR.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BAMOR.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BAMOR.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BAMOR (
    codigo_banco              IS 'Banco',
    codigo_sucursal           IS 'Sucursal',
    origen_cuenta             IS 'Origen',
    tipo_cuenta               IS 'Tipo Cta',
    id_cliente                IS 'ID Cliente',
    numero_referencia         IS 'No. Referenc',
    tipo_registro             IS 'Tipo Reg',
    numero_identificacion     IS 'No. Identif',
    razon_social              IS 'Razon Social',
    email                     IS 'Email',
    telefono                  IS 'Telefono',
    monto_original            IS 'Monto Orig',
    saldo_pendiente           IS 'Saldo Prev',
    fecha_emision             IS 'Fec Emision',
    fecha_vencimiento         IS 'Fec Vencim',
    estado_cxp                IS 'Estado',
    usuario_creacion          IS 'Usr Creacion',
    usuario_actualizacion     IS 'Usr Actualiz',
    version_registro          IS 'Version Reg',
    observaciones             IS 'Observacion',
    estado_registro           IS 'Estado Reg',
    created_at                IS 'Fec Creacion',
    updated_at                IS 'Fec Actualiz'
);

-- ================================================================
-- Etiquetas de descripcion larga por columna (TEXT)
-- ================================================================
LABEL ON COLUMN BAMOR (
    codigo_banco              TEXT IS 'Codigo del banco que registra la amortizacion de',
    codigo_sucursal           TEXT IS 'Codigo de la sucursal que proceso el pago o',
    origen_cuenta             TEXT IS 'Origen de la cuenta por pagar sobre la que se',
    tipo_cuenta               TEXT IS 'Tipo de la cuenta por pagar amortizada (FK BAPRC)',
    id_cliente                TEXT IS 'Identificador del cliente o contraparte de la',
    numero_referencia         TEXT IS 'Numero de referencia de la cuenta por pagar que',
    tipo_registro             TEXT IS 'Tipo de registro de la cuenta por pagar padre (FK',
    numero_identificacion     TEXT IS 'Numero de identificacion del beneficiario del',
    razon_social              TEXT IS 'Nombre del beneficiario del pago en esta',
    email                     TEXT IS 'Correo del beneficiario para notificaciones de',
    telefono                  TEXT IS 'Telefono del beneficiario para contacto sobre el',
    monto_original            TEXT IS 'Monto original de la cuenta por pagar padre',
    saldo_pendiente           TEXT IS 'Saldo pendiente de la cuenta por pagar antes de',
    fecha_emision             TEXT IS 'Fecha de emision de la cuenta por pagar padre',
    fecha_vencimiento         TEXT IS 'Fecha de vencimiento de la cuenta por pagar padre',
    estado_cxp                TEXT IS 'Estado de la amortizacion: APLICADA, REVERSADA,',
    usuario_creacion          TEXT IS 'Usuario del sistema que proceso la amortizacion',
    usuario_actualizacion     TEXT IS 'Usuario que realizo la ultima modificacion del',
    version_registro          TEXT IS 'Version del registro para control de concurrencia',
    observaciones             TEXT IS 'Notas sobre el pago, condiciones especiales o',
    estado_registro           TEXT IS 'Estado logico del registro: A=Activo, I=Inactivo,',
    created_at                TEXT IS 'Marca de tiempo de creacion del registro en base',
    updated_at                TEXT IS 'Marca de tiempo de la ultima actualizacion del'
);

CREATE INDEX IBAMORCSU  ON BAMOR (codigo_banco, codigo_sucursal);
CREATE INDEX IBAMORCAT ON BAMOR (created_at);