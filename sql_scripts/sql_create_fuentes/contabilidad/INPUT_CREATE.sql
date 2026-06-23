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

CREATE OR REPLACE TABLE INPUT (
    numero_del_lote          FOR COLUMN INPUTLOT VARCHAR(30)    NOT NULL,
    secuencia_dentro_del_lote FOR COLUMN INPUTSEQ VARCHAR(50)   NOT NULL,
    descripcion_cuenta       FOR COLUMN INPUTDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN INPUTNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN INPUTNIV VARCHAR(50),
    saldo_actual             FOR COLUMN INPUTSAL DECIMAL(18,2), 
    fecha_proceso_sistema    FOR COLUMN INPUTFPS TIMESTAMP,
    observaciones            FOR COLUMN INPUTOBS VARCHAR(120),
    usuario_creacion         FOR COLUMN INPUTUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN INPUTUSA VARCHAR(30),
    version_registro         FOR COLUMN INPUTVRS INT            NOT NULL DEFAULT 1,
    estado_registro          FOR COLUMN INPUTERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN INPUTCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN INPUTUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_INPUT PRIMARY KEY (numero_del_lote)
    --CONSTRAINT FK_INPUT_GLMST FOREIGN KEY (cuenta_contable)
    --    REFERENCES GLMST (cuenta_contable)
)
RCDFMT INPUTR;

RENAME TABLE INPUT
    TO INPUT_TABLE FOR SYSTEM NAME INPUT;

COMMENT ON TABLE INPUT IS
    'Asientos Contables Aprobados (Archivos Derivados) - Modulo 7 Contabilidad';

LABEL ON TABLE INPUT
    IS 'Asientos Contab Apro';

COMMENT ON COLUMN INPUT.numero_del_lote IS
    'Identificador del lote de asientos contables del dia o proceso';
COMMENT ON COLUMN INPUT.secuencia_dentro_del_lote IS
    'Numero de secuencia del asiento dentro del lote de procesamiento';
COMMENT ON COLUMN INPUT.descripcion_cuenta IS
    'Descripcion de la cuenta contable afectada (referencia informativa)';
COMMENT ON COLUMN INPUT.naturaleza_cuenta IS
    'Naturaleza de la cuenta afectada: DEUDORA o ACREEDORA';
COMMENT ON COLUMN INPUT.nivel_cuenta IS
    'Nivel jerarquico de la cuenta en el plan de cuentas';
COMMENT ON COLUMN INPUT.saldo_actual IS
    'Saldo de la cuenta contable antes de aplicar este asiento';
COMMENT ON COLUMN INPUT.fecha_proceso_sistema IS
    'Marca de tiempo del procesamiento o contabilizacion del asiento';
COMMENT ON COLUMN INPUT.observaciones IS
    'Notas sobre el asiento, su origen o condiciones especiales';
COMMENT ON COLUMN INPUT.usuario_creacion IS
    'Usuario o proceso que genero el asiento contable';
COMMENT ON COLUMN INPUT.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN INPUT.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN INPUT.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN INPUT.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN INPUT.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN INPUT (
    numero_del_lote          TEXT IS 'No. Lote',
    secuencia_dentro_del_lote TEXT IS 'Secuencia',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Prev',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    observaciones            TEXT IS 'Observacion',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IINPUTLOT ON INPUT (numero_del_lote,secuencia_dentro_del_lote);
CREATE INDEX IINPUTCAT ON INPUT (created_at);

