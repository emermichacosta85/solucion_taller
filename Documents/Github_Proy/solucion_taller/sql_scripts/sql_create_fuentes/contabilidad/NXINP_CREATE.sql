-- ================================================================
-- Nombre de la Tabla  : NXINP
-- DESCRIPCION         : Transacciones Contables del Proximo Dia
-- Objetivo            : Registrar los asientos contables con fecha del
--                       dia siguiente, generados anticipadamente por el
--                       proceso de cierre o por transacciones programadas,
--                       para ser aplicados al abrir el siguiente dia operativo.
-- Tipo de Tabla       : Transaccional / Pre-cierre
-- Origen de los Datos : Proceso de cierre diario y transacciones programadas
-- Permanencia de Datos: Transitoria (se aplica al abrir el siguiente dia)
-- Uso de los datos    : Apertura del dia operativo siguiente
-- Restricciones       : FK hacia GLMST por cuenta_contable
--                       (segun ERD: GLMST ||--o{ NXINP)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/NXINP (
    numero_batch             VARCHAR(30)    NOT NULL     FOR COLUMN NXINPBAT,
    secuencia                INT            NOT NULL     FOR COLUMN NXINPSEQ,
    cuenta_contable          VARCHAR(24)    NOT NULL     FOR COLUMN NXINPCTC,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN NXINPBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN NXINPSUC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN NXINPMON,
    fecha_aplicacion         DATE           NOT NULL     FOR COLUMN NXINPFAP,
    tipo_movimiento          CHAR(1)        NOT NULL     FOR COLUMN NXINPTMV,
    monto                    DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN NXINPMNT,
    tipo_asiento             VARCHAR(20)                 FOR COLUMN NXINPTAS,
    modulo_origen            VARCHAR(20)                 FOR COLUMN NXINPMOD,
    referencia_origen        VARCHAR(50)                 FOR COLUMN NXINPREF,
    centro_costo             VARCHAR(50)                 FOR COLUMN NXINPCC,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN NXINPDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN NXINPNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN NXINPNIV,
    saldo_actual             DECIMAL(18,2)               FOR COLUMN NXINPSAL,
    estado_asiento           VARCHAR(20)    NOT NULL     FOR COLUMN NXINPEAS,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN NXINPFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN NXINPUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN NXINPUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN NXINPVRS,
    observaciones            VARCHAR(120)                FOR COLUMN NXINPOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN NXINPERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN NXINPCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN NXINPUAT,
    CONSTRAINT PK_NXINP PRIMARY KEY (numero_batch, secuencia),
    CONSTRAINT FK_NXINP_GLMST FOREIGN KEY (cuenta_contable)
        REFERENCES HNEACOSTA1/GLMST (cuenta_contable)
)
RCDFMT NXINPR;

RENAME TABLE HNEACOSTA1/NXINP
    TO NXINP FOR SYSTEM NAME NXINP;

COMMENT ON TABLE HNEACOSTA1/NXINP IS
    'Transacciones Contables del Proximo Dia - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/NXINP
    IS 'Trans Contab Prox Dia';

COMMENT ON COLUMN HNEACOSTA1/NXINP.numero_batch IS
    'Identificador del lote batch con las transacciones del dia siguiente';
COMMENT ON COLUMN HNEACOSTA1/NXINP.secuencia IS
    'Numero de secuencia del asiento dentro del batch de proximo dia';
COMMENT ON COLUMN HNEACOSTA1/NXINP.cuenta_contable IS
    'Numero de cuenta contable que sera afectada en el proximo dia (FK GLMST)';
COMMENT ON COLUMN HNEACOSTA1/NXINP.codigo_banco IS
    'Codigo del banco al que pertenece la transaccion programada';
COMMENT ON COLUMN HNEACOSTA1/NXINP.codigo_sucursal IS
    'Codigo de la sucursal en la que se aplicara el asiento';
COMMENT ON COLUMN HNEACOSTA1/NXINP.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresada la transaccion';
COMMENT ON COLUMN HNEACOSTA1/NXINP.fecha_aplicacion IS
    'Fecha del proximo dia operativo en que se aplicara el asiento';
COMMENT ON COLUMN HNEACOSTA1/NXINP.tipo_movimiento IS
    'Naturaleza del movimiento contable: D=Debito, C=Credito';
COMMENT ON COLUMN HNEACOSTA1/NXINP.monto IS
    'Monto del movimiento contable a aplicar en el proximo dia';
COMMENT ON COLUMN HNEACOSTA1/NXINP.tipo_asiento IS
    'Tipo de asiento programado: APERTURA, REVERSO, AJUSTE, PROVISION';
COMMENT ON COLUMN HNEACOSTA1/NXINP.modulo_origen IS
    'Modulo del sistema que genero la transaccion programada';
COMMENT ON COLUMN HNEACOSTA1/NXINP.referencia_origen IS
    'Referencia de la operacion del modulo que origino el asiento programado';
COMMENT ON COLUMN HNEACOSTA1/NXINP.centro_costo IS
    'Centro de costo al que se imputara el asiento al aplicarse';
COMMENT ON COLUMN HNEACOSTA1/NXINP.descripcion_cuenta IS
    'Descripcion de la cuenta contable del asiento programado';
COMMENT ON COLUMN HNEACOSTA1/NXINP.naturaleza_cuenta IS
    'Naturaleza de la cuenta: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/NXINP.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN HNEACOSTA1/NXINP.saldo_actual IS
    'Saldo de la cuenta al momento de programar el asiento del proximo dia';
COMMENT ON COLUMN HNEACOSTA1/NXINP.estado_asiento IS
    'Estado del asiento programado: PENDIENTE, APLICADO, CANCELADO, ERROR';
COMMENT ON COLUMN HNEACOSTA1/NXINP.fecha_proceso_sistema IS
    'Marca de tiempo del proceso que genero o programo el asiento';
COMMENT ON COLUMN HNEACOSTA1/NXINP.usuario_creacion IS
    'Usuario o proceso que programo el asiento del proximo dia';
COMMENT ON COLUMN HNEACOSTA1/NXINP.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/NXINP.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/NXINP.observaciones IS
    'Notas sobre el asiento programado o condiciones de su aplicacion';
COMMENT ON COLUMN HNEACOSTA1/NXINP.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/NXINP.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/NXINP.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/NXINP (
    numero_batch             TEXT IS 'No. Batch',
    secuencia                TEXT IS 'Secuencia',
    cuenta_contable          TEXT IS 'Cta Contable',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    fecha_aplicacion         TEXT IS 'Fec Aplicac',
    tipo_movimiento          TEXT IS 'D/C',
    monto                    TEXT IS 'Monto',
    tipo_asiento             TEXT IS 'Tipo Asiento',
    modulo_origen            TEXT IS 'Modulo',
    referencia_origen        TEXT IS 'Referencia',
    centro_costo             TEXT IS 'Centro Costo',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Prev',
    estado_asiento           TEXT IS 'Estado',
    fecha_proceso_sistema    TEXT IS 'Fec Sis',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/INXINPCTC ON HNEACOSTA1/NXINP (cuenta_contable);
CREATE INDEX HNEACOSTA1/INXINPFAP ON HNEACOSTA1/NXINP (fecha_aplicacion);
CREATE INDEX HNEACOSTA1/INXINPCAT ON HNEACOSTA1/NXINP (created_at);
CREATE INDEX HNEACOSTA1/INXINPEAS ON HNEACOSTA1/NXINP (estado_asiento);
