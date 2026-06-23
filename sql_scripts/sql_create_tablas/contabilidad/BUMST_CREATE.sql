-- ================================================================
-- Nombre de la Tabla  : BUMST
-- DESCRIPCION         : Maestro de Presupuestos
-- Objetivo            : Registrar el presupuesto aprobado desglosado por
--                       banco, sucursal, moneda, periodo y centro de costo,
--                       permitiendo el control de ejecucion presupuestaria
--                       y el analisis de variaciones frente a lo real.
-- Tipo de Tabla       : Maestra / Control Presupuestario
-- Origen de los Datos : Carga del presupuesto aprobado por la gerencia
-- Permanencia de Datos: Permanente (por anio fiscal)
-- Uso de los datos    : Control presupuestario, reportes de ejecucion
--                       y analisis de variaciones real vs presupuesto
-- Restricciones       : FK hacia CCDSC por (centro_costo, codigo_banco)
--                       relacion funcional del modulo presupuestario
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE BUMST (
    codigo_banco             FOR COLUMN BUMSTBNK VARCHAR(20)    NOT NULL,
    codigo_sucursal          FOR COLUMN BUMSTSUC VARCHAR(20)    NOT NULL,
    codigo_moneda            FOR COLUMN BUMSTMON VARCHAR(20)    NOT NULL,
    numero_presupuesto       FOR COLUMN BUMSTPRS VARCHAR(30)    NOT NULL,
    centro_costo             FOR COLUMN BUMSTCC VARCHAR(50)    NOT NULL,
    descripcion_cuenta       FOR COLUMN BUMSTDSC VARCHAR(120),
    naturaleza_cuenta        FOR COLUMN BUMSTNCT VARCHAR(20),
    nivel_cuenta             FOR COLUMN BUMSTNIV VARCHAR(50),
    saldo_actual             FOR COLUMN BUMSTSAL DECIMAL(18,2),
    fecha_proceso_sistema    FOR COLUMN BUMSTFPS TIMESTAMP,
    usuario_creacion         FOR COLUMN BUMSTUSC VARCHAR(30),
    usuario_actualizacion    FOR COLUMN BUMSTUSA VARCHAR(30),
    version_registro         FOR COLUMN BUMSTVRS INT            NOT NULL DEFAULT 1,
    observaciones            FOR COLUMN BUMSTOBS VARCHAR(120),
    estado_registro          FOR COLUMN BUMSTERG CHAR(1)        NOT NULL DEFAULT 'A',
    created_at               FOR COLUMN BUMSTCAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN BUMSTUAT TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_BUMST PRIMARY KEY (codigo_banco, codigo_sucursal,
                                     codigo_moneda, numero_presupuesto,
                                     centro_costo)
    --CONSTRAINT FK_BUMST_CCDSC FOREIGN KEY (centro_costo, codigo_banco)
    --    REFERENCES CCDSC (codigo_centro, codigo_banco)
)
RCDFMT BUMSTR;

RENAME TABLE BUMST
    TO BUMST_TABLE FOR SYSTEM NAME BUMST;

COMMENT ON TABLE BUMST IS
    'Maestro de Presupuestos por Banco y Centro de Costo - Modulo 7 Contabilidad';

LABEL ON TABLE BUMST
    IS 'Maestro Presupuestos';

COMMENT ON COLUMN BUMST.codigo_banco IS
    'Codigo del banco al que pertenece el registro presupuestario';
COMMENT ON COLUMN BUMST.codigo_sucursal IS
    'Codigo de la sucursal a la que corresponde la asignacion presupuestaria';
COMMENT ON COLUMN BUMST.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el presupuesto';
COMMENT ON COLUMN BUMST.numero_presupuesto IS
    'Numero o codigo del presupuesto aprobado para el periodo fiscal';
COMMENT ON COLUMN BUMST.centro_costo IS
    'Centro de costo al que se asigna la partida presupuestaria (FK CCDSC)';
COMMENT ON COLUMN BUMST.descripcion_cuenta IS
    'Descripcion de la cuenta o concepto presupuestario';
COMMENT ON COLUMN BUMST.naturaleza_cuenta IS
    'Naturaleza de la cuenta: DEUDORA (gasto) o ACREEDORA (ingreso)';
COMMENT ON COLUMN BUMST.nivel_cuenta IS
    'Nivel de la cuenta contable en el plan de cuentas';
COMMENT ON COLUMN BUMST.saldo_actual IS
    'Saldo contable real de la cuenta en el periodo para comparacion';
COMMENT ON COLUMN BUMST.fecha_proceso_sistema IS
    'Marca de tiempo del ultimo proceso de actualizacion de ejecucion';
COMMENT ON COLUMN BUMST.usuario_creacion IS
    'Usuario que registro o cargo la partida presupuestaria';
COMMENT ON COLUMN BUMST.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro presupuestario';
COMMENT ON COLUMN BUMST.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN BUMST.observaciones IS
    'Notas sobre la partida presupuestaria, ajustes o reasignaciones';
COMMENT ON COLUMN BUMST.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN BUMST.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN BUMST.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN BUMST (
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_moneda            TEXT IS 'Moneda',
    numero_presupuesto       TEXT IS 'No. Presup',
    centro_costo             TEXT IS 'Centro Costo',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel',
    saldo_actual             TEXT IS 'Saldo Real',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX IBUMSTCAT ON BUMST (created_at);
CREATE INDEX IBUMSTPK ON BUMST (codigo_banco, codigo_sucursal);
