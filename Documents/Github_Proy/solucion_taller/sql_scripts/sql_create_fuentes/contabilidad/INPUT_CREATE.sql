-- ================================================================
-- Nombre de la Tabla  : INPUT
-- DESCRIPCION         : Archivo de Asientos Contables Aprobados
-- Objetivo            : Registrar los asientos contables aprobados y
--                       listos para contabilizacion definitiva,
--                       provenientes de todos los modulos del sistema
--                       bancario (archivos derivados), garantizando
--                       el principio de partida doble en cada asiento.
-- Tipo de Tabla       : Transaccional / Operativa
-- Origen de los Datos : Generacion automatica desde todos los modulos
--                       del sistema al procesar transacciones
-- Permanencia de Datos: Transitoria durante el dia; historica en cierre
-- Uso de los datos    : Contabilizacion en linea y proceso de cierre diario
-- Restricciones       : FK hacia GLMST por cuenta_contable
--                       (segun ERD: GLMST ||--o{ INPUT)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/INPUT (
    numero_del_lote          VARCHAR(30)    NOT NULL     FOR COLUMN INPUTLOT,
    secuencia_dentro_del_lote VARCHAR(50)   NOT NULL     FOR COLUMN INPUTSEQ,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN INPUTCTC,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN INPUTBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN INPUTSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN INPUTMON,
    fecha_asiento            DATE           NOT NULL     FOR COLUMN INPUTFAS,
    tipo_movimiento          CHAR(1)        NOT NULL     FOR COLUMN INPUTTMV,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN INPUTMNT,
    modulo_origen            VARCHAR(20)                 FOR COLUMN INPUTMOD,
    referencia_origen        VARCHAR(50)                 FOR COLUMN INPUTREF,
    centro_costo             VARCHAR(50)                 FOR COLUMN INPUTCC,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN INPUTDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN INPUTNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN INPUTNIV,
    saldo_actual             DECIMAL(18,2)               FOR COLUMN INPUTSAL,
    estado_asiento           VARCHAR(20)    NOT NULL     FOR COLUMN INPUTEAS,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN INPUTFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN INPUTUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN INPUTUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN INPUTVRS,
    observaciones            VARCHAR(120)                FOR COLUMN INPUTOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN INPUTERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN INPUTCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN INPUTUAT,
    CONSTRAINT PK_INPUT PRIMARY KEY (numero_del_lote,
                                     secuencia_dentro_del_lote),
    CONSTRAINT FK_INPUT_GLMST FOREIGN KEY (cuenta_contable)
        REFERENCES HNEACOSTA1/GLMST (cuenta_contable)
)
RCDFMT INPUTR;

RENAME TABLE HNEACOSTA1/INPUT
    TO INPUT FOR SYSTEM NAME INPUT;

COMMENT ON TABLE HNEACOSTA1/INPUT IS
    'Asientos Contables Aprobados (Archivos Derivados) - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/INPUT
    IS 'Asientos Contab Apro';

COMMENT ON COLUMN HNEACOSTA1/INPUT.numero_del_lote IS
    'Identificador del lote de asientos contables del dia o proceso';
COMMENT ON COLUMN HNEACOSTA1/INPUT.secuencia_dentro_del_lote IS
    'Numero de secuencia del asiento dentro del lote de procesamiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.cuenta_contable IS
    'Numero de cuenta contable afectada por el asiento (FK GLMST)';
COMMENT ON COLUMN HNEACOSTA1/INPUT.codigo_banco IS
    'Codigo del banco al que pertenece el asiento contable';
COMMENT ON COLUMN HNEACOSTA1/INPUT.codigo_sucursal IS
    'Codigo de la sucursal que genera el asiento contable';
COMMENT ON COLUMN HNEACOSTA1/INPUT.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el asiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.fecha_asiento IS
    'Fecha contable del asiento, que puede diferir de la fecha de registro';
COMMENT ON COLUMN HNEACOSTA1/INPUT.tipo_movimiento IS
    'Naturaleza del movimiento contable: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/INPUT.monto IS
    'Monto del movimiento contable en la moneda del asiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.modulo_origen IS
    'Modulo del sistema que genero el asiento (CUENTAS, PRESTAMOS, CAJA, etc.)';
COMMENT ON COLUMN HNEACOSTA1/INPUT.referencia_origen IS
    'Numero de transaccion u operacion del modulo que origino el asiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.centro_costo IS
    'Centro de costo al que se imputa el asiento cuando la cuenta lo requiere';
COMMENT ON COLUMN HNEACOSTA1/INPUT.descripcion_cuenta IS
    'Descripcion de la cuenta contable afectada (referencia informativa)';
COMMENT ON COLUMN HNEACOSTA1/INPUT.naturaleza_cuenta IS
    'Naturaleza de la cuenta afectada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/INPUT.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/INPUT.saldo_actual IS
    'Saldo de la cuenta contable antes de aplicar este asiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.estado_asiento IS
    'Estado del asiento: PENDIENTE, CONTABILIZADO, REVERSADO, RECHAZADO';
COMMENT ON COLUMN HNEACOSTA1/INPUT.fecha_proceso_sistema IS
    'Marca de tiempo del procesamiento o contabilizacion del asiento';
COMMENT ON COLUMN HNEACOSTA1/INPUT.usuario_creacion IS
    'Usuario o proceso que genero el asiento contable';
COMMENT ON COLUMN HNEACOSTA1/INPUT.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/INPUT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/INPUT.observaciones IS
    'Notas sobre el asiento, su origen o condiciones especiales';
COMMENT ON COLUMN HNEACOSTA1/INPUT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/INPUT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/INPUT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/INPUT (
    numero_del_lote          TEXT IS 'No. Lote',
    secuencia_dentro_del_lote TEXT IS 'Secuencia',
    cuenta_contable          TEXT IS 'Cta Contable',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_asiento            TEXT IS 'Fec Asiento',
    tipo_movimiento          TEXT IS 'D/C',
    monto                    TEXT IS 'Monto',
    modulo_origen            TEXT IS 'Modulo',
    referencia_origen        TEXT IS 'Referencia',
    centro_costo             TEXT IS 'Centro Costo',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Prev',
    estado_asiento           TEXT IS 'Estado',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IINPUTCTC ON HNEACOSTA1/INPUT (cuenta_contable);
CREATE INDEX HNEACOSTA1/IINPUTFAS ON HNEACOSTA1/INPUT (fecha_asiento);
CREATE INDEX HNEACOSTA1/IINPUTCAT ON HNEACOSTA1/INPUT (created_at);
CREATE INDEX HNEACOSTA1/IINPUTEAS ON HNEACOSTA1/INPUT (estado_asiento);
CREATE INDEX HNEACOSTA1/IINPUTMOD ON HNEACOSTA1/INPUT (modulo_origen);
