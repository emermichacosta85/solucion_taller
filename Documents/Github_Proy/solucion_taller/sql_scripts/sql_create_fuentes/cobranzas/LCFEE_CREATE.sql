-- ================================================================
-- Nombre de la Tabla  : LCFEE
-- DESCRIPCION         : Control de Cobro de Comisiones de Cobranzas
-- Objetivo            : Registrar y controlar las comisiones generadas por
--                       la gestion de cartas de credito y cobranzas
--                       documentarias, conforme a la estructura definida
--                       en estructura_bd.md (Modulo 6).
-- Tipo de Tabla       : Transaccional / Control
-- Origen de los Datos : Proceso de calculo de comisiones al gestionar
--                       cartas de credito y cobranzas
-- Permanencia de Datos: Historica
-- Uso de los datos    : Cobro de comisiones, conciliacion de ingresos
--                       y auditoria
-- Restricciones       : PK compuesta (numero_carta_credito, codigo_de_comision).
--                       FK numero_carta_credito hacia LCMST
--                       (segun ERD: LCMST ||--o{ LCFEE).
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 6 Cobranzas
-- ================================================================

CREATE OR REPLACE TABLE LCFEE (
    numero_carta_credito     FOR COLUMN LCFEENCC   VARCHAR(30)    NOT NULL,
    codigo_de_comision       FOR COLUMN LCFEECCO   VARCHAR(20)    NOT NULL,
    fecha_recepcion          FOR COLUMN LCFEEFRP   DATE,
    fecha_vencimiento        FOR COLUMN LCFEEFVE   DATE,
    monto_original           FOR COLUMN LCFEEMOR   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    saldo_pendiente          FOR COLUMN LCFEESPD   DECIMAL(18,2)  NOT NULL
                                                   DEFAULT 0,
    tipo_documento           FOR COLUMN LCFEETDO   VARCHAR(20),
    estado_operacion         FOR COLUMN LCFEEESO   VARCHAR(20)    NOT NULL,
    usuario_creacion         FOR COLUMN LCFEEUSC   VARCHAR(30),
    usuario_actualizacion    FOR COLUMN LCFEEUSA   VARCHAR(30),
    version_registro         FOR COLUMN LCFEEVRS   INT            NOT NULL
                                                   DEFAULT 1,
    observaciones            FOR COLUMN LCFEEOBS   VARCHAR(120),
    estado_registro          FOR COLUMN LCFEEERG   CHAR(1)        NOT NULL
                                                   DEFAULT 'A',
    created_at               FOR COLUMN LCFEECAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    updated_at               FOR COLUMN LCFEEUAT   TIMESTAMP      NOT NULL
                                                   DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK_LCFEE PRIMARY KEY (numero_carta_credito, codigo_de_comision)
    --CONSTRAINT FK_LCFEE_LCMST FOREIGN KEY (numero_carta_credito)
    --    REFERENCES LCMST (numero_carta_credito)
)
RCDFMT LCFEER;

RENAME TABLE LCFEE
    TO LCFEE_TABLE FOR SYSTEM NAME LCFEE;

COMMENT ON TABLE LCFEE IS
    'Control de Cobro de Comisiones de Cartas de Credito y Cobranzas - Modulo 6';

LABEL ON TABLE LCFEE
    IS 'Control Comisiones LC';

COMMENT ON COLUMN LCFEE.numero_carta_credito IS
    'Numero de la carta de credito a la que corresponde la comision (FK LCMST)';
COMMENT ON COLUMN LCFEE.codigo_de_comision IS
    'Codigo del tipo de comision segun el catalogo de cargos vigente';
COMMENT ON COLUMN LCFEE.fecha_recepcion IS
    'Fecha de recepcion de la carta de credito o cobranza que origina la comision';
COMMENT ON COLUMN LCFEE.fecha_vencimiento IS
    'Fecha de vencimiento de la carta de credito asociada';
COMMENT ON COLUMN LCFEE.monto_original IS
    'Monto total original de la carta de credito que genera la comision';
COMMENT ON COLUMN LCFEE.saldo_pendiente IS
    'Saldo no utilizado de la carta de credito al momento del calculo';
COMMENT ON COLUMN LCFEE.tipo_documento IS
    'Tipo de documento que origina el cobro de la comision';
COMMENT ON COLUMN LCFEE.estado_operacion IS
    'Estado de la comision: PENDIENTE, COBRADA, EXONERADA, ANULADA';
COMMENT ON COLUMN LCFEE.usuario_creacion IS
    'Usuario o proceso que genero el registro de comision';
COMMENT ON COLUMN LCFEE.usuario_actualizacion IS
    'Usuario que realizo la ultima modificacion del registro';
COMMENT ON COLUMN LCFEE.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN LCFEE.observaciones IS
    'Notas sobre la comision, exoneraciones o condiciones especiales de cobro';
COMMENT ON COLUMN LCFEE.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN LCFEE.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN LCFEE.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN LCFEE (
    numero_carta_credito     IS 'No. Carta Cred',
    codigo_de_comision       IS 'Cod Comision',
    fecha_recepcion          IS 'Fec Recep',
    fecha_vencimiento        IS 'Fec Vencim',
    monto_original           IS 'Monto Orig',
    saldo_pendiente          IS 'Saldo Pend',
    tipo_documento           IS 'Tipo Doc',
    estado_operacion         IS 'Estado Oper',
    usuario_creacion         IS 'Usr Creacion',
    usuario_actualizacion    IS 'Usr Actualiz',
    version_registro         IS 'Version Reg',
    observaciones            IS 'Observacion',
    estado_registro          IS 'Estado Reg',
    created_at               IS 'Fec Creacion',
    updated_at               IS 'Fec Actualiz'
);

LABEL ON COLUMN LCFEE (
    numero_carta_credito     TEXT IS 'Numero de carta de credito asociada (FK LCMST)',
    codigo_de_comision       TEXT IS 'Codigo del tipo de comision',
    fecha_recepcion          TEXT IS 'Fecha de recepcion que origina la comision',
    fecha_vencimiento        TEXT IS 'Fecha de vencimiento de la carta asociada',
    monto_original           TEXT IS 'Monto original de la carta de credito',
    saldo_pendiente          TEXT IS 'Saldo no utilizado al momento del calculo',
    tipo_documento           TEXT IS 'Tipo de documento que origina la comision',
    estado_operacion         TEXT IS 'Estado de la comision',
    usuario_creacion         TEXT IS 'Usuario o proceso que genero el registro',
    usuario_actualizacion    TEXT IS 'Usuario de la ultima modificacion',
    version_registro         TEXT IS 'Version para concurrencia optimista',
    observaciones            TEXT IS 'Notas sobre la comision o exoneraciones',
    estado_registro          TEXT IS 'Estado logico A/I/B del registro',
    created_at               TEXT IS 'Fecha y hora de creacion del registro',
    updated_at               TEXT IS 'Fecha y hora de ultima actualizacion'
);

CREATE INDEX ILCFEECAT ON LCFEE (created_at);
