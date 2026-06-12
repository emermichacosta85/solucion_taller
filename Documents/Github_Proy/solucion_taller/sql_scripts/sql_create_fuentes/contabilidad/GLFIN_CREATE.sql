-- ================================================================
-- Nombre de la Tabla  : GLFIN
-- DESCRIPCION         : Estados Financieros por Niveles
-- Objetivo            : Almacenar los estados financieros estructurados
--                       por niveles jerarquicos del plan de cuentas,
--                       listos para presentacion gerencial y regulatoria,
--                       incluyendo variaciones absolutas y porcentuales.
-- Tipo de Tabla       : Historica / Reportes Financieros
-- Origen de los Datos : Proceso de generacion desde GLBSE y GLBLN
-- Permanencia de Datos: Historica por periodo
-- Uso de los datos    : Presentacion a junta directiva, reguladores y auditores
-- Restricciones       : PK tecnica (id); tabla de reporte derivada
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 7 Contabilidad
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/GLFIN (
    id                       BIGINT         NOT NULL     FOR COLUMN GLFINID,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN GLFINBNK,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN GLFINMON,
    tipo_estado              VARCHAR(20)    NOT NULL     FOR COLUMN GLFINTES,
    fecha_estado             DATE           NOT NULL     FOR COLUMN GLFINFES,
    periodo                  VARCHAR(10)    NOT NULL     FOR COLUMN GLFINPER,
    nivel_presentacion       INT            NOT NULL     FOR COLUMN GLFINNIV,
    codigo_linea             VARCHAR(20)    NOT NULL     FOR COLUMN GLFINLIN,
    descripcion_cuenta       VARCHAR(120)                FOR COLUMN GLFINDSC,
    naturaleza_cuenta        VARCHAR(20)                 FOR COLUMN GLFINNCT,
    nivel_cuenta             VARCHAR(50)                 FOR COLUMN GLFINNCV,
    saldo_actual             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLFINSAL,
    saldo_periodo_anterior   DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLFINSP,
    variacion_absoluta       DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLFINVA,
    variacion_porcentual     DECIMAL(10,4)  NOT NULL
                                            DEFAULT 0    FOR COLUMN GLFINVP,
    fecha_proceso_sistema    TIMESTAMP                   FOR COLUMN GLFINFPS,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN GLFINUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN GLFINUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN GLFINVRS,
    observaciones            VARCHAR(120)                FOR COLUMN GLFINOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN GLFINERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLFINCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN GLFINUAT,
    CONSTRAINT PK_GLFIN PRIMARY KEY (id)
)
RCDFMT GLFINR;

RENAME TABLE HNEACOSTA1/GLFIN
    TO GLFIN FOR SYSTEM NAME GLFIN;

COMMENT ON TABLE HNEACOSTA1/GLFIN IS
    'Estados Financieros por Niveles - Modulo 7 Contabilidad';

LABEL ON TABLE HNEACOSTA1/GLFIN
    IS 'Estados Financieros';

COMMENT ON COLUMN HNEACOSTA1/GLFIN.id IS
    'Identificador tecnico unico autoincremental del registro de estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.codigo_banco IS
    'Codigo del banco al que corresponde el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.codigo_moneda IS
    'Codigo ISO de la moneda en que esta expresado el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.tipo_estado IS
    'Tipo de estado financiero: BALANCE, RESULTADOS, FLUJO_EFECTIVO, CAMBIOS_PATRIMONIO';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.fecha_estado IS
    'Fecha del cierre al que corresponde el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.periodo IS
    'Identificador del periodo: formato AAAA-MM para mensual o AAAA para anual';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.nivel_presentacion IS
    'Nivel de detalle: 1=Grupo, 2=Subgrupo, 3=Cuenta, 4=Subcuenta';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.codigo_linea IS
    'Codigo de la linea dentro del estado financiero para ordenamiento';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.descripcion_cuenta IS
    'Descripcion de la linea o rubro del estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.naturaleza_cuenta IS
    'Naturaleza contable de la linea: DEUDORA o ACREEDORA';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.nivel_cuenta IS
    'Nivel del plan de cuentas al que corresponde esta linea del estado';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.saldo_actual IS
    'Saldo de la linea al cierre del periodo del estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.saldo_periodo_anterior IS
    'Saldo de la misma linea en el periodo anterior para comparacion';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.variacion_absoluta IS
    'Diferencia absoluta entre el saldo actual y el periodo anterior';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.variacion_porcentual IS
    'Variacion porcentual del saldo respecto al periodo anterior';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.fecha_proceso_sistema IS
    'Marca de tiempo del proceso que genero el estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.usuario_creacion IS
    'Usuario o proceso que genero el registro del estado financiero';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.observaciones IS
    'Notas sobre ajustes, reexpresiones o condiciones especiales del estado';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/GLFIN.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/GLFIN (
    id                       TEXT IS 'ID Estado Fin',
    codigo_banco             TEXT IS 'Banco',
    codigo_moneda            TEXT IS 'Moneda',
    tipo_estado              TEXT IS 'Tipo Estado',
    fecha_estado             TEXT IS 'Fec Estado',
    periodo                  TEXT IS 'Periodo',
    nivel_presentacion       TEXT IS 'Nivel Pres',
    codigo_linea             TEXT IS 'Cod Linea',
    descripcion_cuenta       TEXT IS 'Descripcion',
    naturaleza_cuenta        TEXT IS 'Naturaleza',
    nivel_cuenta             TEXT IS 'Nivel Cta',
    saldo_actual             TEXT IS 'Saldo Actual',
    saldo_periodo_anterior   TEXT IS 'Sdo Ant',
    variacion_absoluta       TEXT IS 'Var Absoluta',
    variacion_porcentual     TEXT IS 'Var Porc',
    fecha_proceso_sistema    TEXT IS 'Fec Proceso',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IGLFINPER ON HNEACOSTA1/GLFIN (periodo);
CREATE INDEX HNEACOSTA1/IGLFINFES ON HNEACOSTA1/GLFIN (fecha_estado);
CREATE INDEX HNEACOSTA1/IGLFINCAT ON HNEACOSTA1/GLFIN (created_at);
CREATE INDEX HNEACOSTA1/IGLFINTES ON HNEACOSTA1/GLFIN (tipo_estado);
