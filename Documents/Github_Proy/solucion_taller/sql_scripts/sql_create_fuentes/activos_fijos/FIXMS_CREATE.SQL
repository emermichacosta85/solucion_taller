-- ================================================================
-- Nombre de la Tabla  : FIXMS
-- DESCRIPCION         : Maestro de Activos Fijos
-- Objetivo            : Registrar el inventario completo de activos fijos
--                       del banco con toda la informacion necesaria para
--                       su identificacion, valoracion, depreciacion,
--                       control de ubicacion y seguimiento del ciclo
--                       de vida desde su adquisicion hasta su baja o
--                       disposicion final.
-- Tipo de Tabla       : Maestra
-- Origen de los Datos : Alta de activos por adquisicion, donacion,
--                       aportacion o revaluacion
-- Permanencia de Datos: Permanente (durante la vida util del activo)
-- Uso de los datos    : Calculo de depreciacion, inventario fisico,
--                       reportes regulatorios y contabilizacion de bajas
-- Restricciones       : PK por numero_activo; FK hacia CLSMS por
--                       codigo_clase; FK hacia LOCMS por
--                       numero_localizacion; FK hacia CNTRLFIX por
--                       codigo_banco (relaciones funcionales del modulo
--                       no declaradas en ERD pero derivadas del dominio)
-- ----------------------------------------------------------------
-- Hecho por           : Equipo Taller IBM i
-- Fecha               : 2025-06-11
-- Proyecto            : Taller IBM i - Modulo 10 Activos Fijos
-- ================================================================

CREATE OR REPLACE TABLE HNEACOSTA1/FIXMS (
    numero_activo            VARCHAR(30)    NOT NULL     FOR COLUMN FIXMSNAC,
    codigo_banco             VARCHAR(20)    NOT NULL     FOR COLUMN FIXMSBNK,
    codigo_sucursal          VARCHAR(20)    NOT NULL     FOR COLUMN FIXMSSUC,
    codigo_clase             VARCHAR(20)    NOT NULL     FOR COLUMN FIXMSCLS,
    numero_localizacion      VARCHAR(30)    NOT NULL     FOR COLUMN FIXMSLOC,
    codigo_moneda            VARCHAR(20)    NOT NULL     FOR COLUMN FIXMSMON,
    descripcion              VARCHAR(120)   NOT NULL     FOR COLUMN FIXMSDSC,
    marca                    VARCHAR(50)                 FOR COLUMN FIXMSMRC,
    modelo                   VARCHAR(50)                 FOR COLUMN FIXMSMDL,
    numero_serie             VARCHAR(50)                 FOR COLUMN FIXMSNSR,
    numero_placa             VARCHAR(30)                 FOR COLUMN FIXMSNPL,
    proveedor                VARCHAR(80)                 FOR COLUMN FIXMSPRO,
    numero_factura           VARCHAR(50)                 FOR COLUMN FIXMSNFA,
    fecha_adquisicion        DATE           NOT NULL     FOR COLUMN FIXMSFAD,
    fecha_inicio_depreciacion DATE                       FOR COLUMN FIXMSFID,
    fecha_baja               DATE                       FOR COLUMN FIXMSFBA,
    valor_adquisicion        DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSVAD,
    valor_residual           DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSVRS,
    valor_libros             DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSVLB,
    valor_revaluacion        DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSVRE,
    vida_util_meses          INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSVU,
    meses_depreciados        INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSMDE,
    meses_restantes          INT            NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSMRS,
    depreciacion_mensual     DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSDME,
    depreciacion_acumulada   DECIMAL(18,2)  NOT NULL
                                            DEFAULT 0    FOR COLUMN FIXMSDAC,
    responsable_custodio     VARCHAR(80)                 FOR COLUMN FIXMSRCU,
    asegurado                CHAR(1)        NOT NULL
                                            DEFAULT 'N'  FOR COLUMN FIXMSASE,
    numero_poliza            VARCHAR(50)                 FOR COLUMN FIXMSPOL,
    aseguradora              VARCHAR(80)                 FOR COLUMN FIXMSASEG,
    fecha_vencimiento_poliza DATE                        FOR COLUMN FIXMSFVP,
    estado_activo            VARCHAR(20)    NOT NULL     FOR COLUMN FIXMSEST,
    usuario_creacion         VARCHAR(30)                 FOR COLUMN FIXMSUSC,
    usuario_actualizacion    VARCHAR(30)                 FOR COLUMN FIXMSUSA,
    version_registro         INT            NOT NULL
                                            DEFAULT 1    FOR COLUMN FIXMSVR,
    observaciones            VARCHAR(120)                FOR COLUMN FIXMSOBS,
    estado_registro          CHAR(1)        NOT NULL
                                            DEFAULT 'A'  FOR COLUMN FIXMSERG,
    created_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN FIXMSCAT,
    updated_at               TIMESTAMP      NOT NULL
                                            DEFAULT CURRENT_TIMESTAMP
                                                         FOR COLUMN FIXMSUAT,
    CONSTRAINT PK_FIXMS PRIMARY KEY (numero_activo),
    CONSTRAINT FK_FIXMS_CLSMS   FOREIGN KEY (codigo_clase)
        REFERENCES HNEACOSTA1/CLSMS (codigo_clase),
    CONSTRAINT FK_FIXMS_LOCMS   FOREIGN KEY (numero_localizacion)
        REFERENCES HNEACOSTA1/LOCMS (numero_localizacion),
    CONSTRAINT FK_FIXMS_CNTRLFIX FOREIGN KEY (codigo_banco)
        REFERENCES HNEACOSTA1/CNTRLFIX (codigo_banco)
)
RCDFMT FIXMSR;

RENAME TABLE HNEACOSTA1/FIXMS
    TO FIXMS FOR SYSTEM NAME FIXMS;

COMMENT ON TABLE HNEACOSTA1/FIXMS IS
    'Maestro de Activos Fijos del Banco - Modulo 10 Activos Fijos';

LABEL ON TABLE HNEACOSTA1/FIXMS
    IS 'Maestro Activos Fijos';

COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_activo IS
    'Numero unico del activo fijo asignado por el banco al momento del alta';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.codigo_banco IS
    'Codigo del banco propietario del activo fijo (FK CNTRLFIX)';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.codigo_sucursal IS
    'Codigo de la sucursal a la que esta asignado presupuestariamente el activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.codigo_clase IS
    'Codigo de la clase de amortizacion que rige la depreciacion del activo (FK CLSMS)';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_localizacion IS
    'Codigo de la ubicacion fisica actual del activo (FK LOCMS)';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.codigo_moneda IS
    'Codigo ISO de la moneda en que esta valorado el activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.descripcion IS
    'Descripcion detallada del activo fijo para su identificacion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.marca IS
    'Marca o fabricante del activo cuando aplica';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.modelo IS
    'Modelo especifico del activo dentro de la marca';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_serie IS
    'Numero de serie del fabricante para identificacion unica del bien';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_placa IS
    'Numero de placa o etiqueta interna del banco asignada al activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.proveedor IS
    'Nombre del proveedor o vendedor del activo al momento de la adquisicion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_factura IS
    'Numero de factura o documento de compra que respalda la adquisicion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.fecha_adquisicion IS
    'Fecha en que el banco adquirio o recibio el activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.fecha_inicio_depreciacion IS
    'Fecha desde la que se comienza a calcular la depreciacion del activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.fecha_baja IS
    'Fecha en que el activo fue dado de baja del inventario del banco';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.valor_adquisicion IS
    'Costo original de adquisicion del activo incluyendo gastos de internacion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.valor_residual IS
    'Valor estimado del activo al terminar su vida util segun clase de amortizacion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.valor_libros IS
    'Valor neto en libros del activo: adquisicion menos depreciacion acumulada';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.valor_revaluacion IS
    'Ajuste por revaluacion aplicado al activo segun politica contable vigente';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.vida_util_meses IS
    'Vida util del activo en meses, tomada de la clase o ajustada individualmente';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.meses_depreciados IS
    'Numero de meses transcurridos desde el inicio de la depreciacion';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.meses_restantes IS
    'Meses de vida util restantes: vida util total menos meses depreciados';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.depreciacion_mensual IS
    'Monto de depreciacion calculado y aplicado mensualmente al activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.depreciacion_acumulada IS
    'Total acumulado de depreciacion registrada desde el inicio hasta la fecha';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.responsable_custodio IS
    'Nombre del funcionario custodio o responsable directo del activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.asegurado IS
    'Indica si el activo cuenta con poliza de seguro vigente: S=Si, N=No';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.numero_poliza IS
    'Numero de poliza de seguro que ampara el activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.aseguradora IS
    'Nombre de la aseguradora que emitio la poliza del activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.fecha_vencimiento_poliza IS
    'Fecha de vencimiento de la poliza de seguro del activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.estado_activo IS
    'Estado actual del activo: EN_USO, ALMACENADO, EN_REPARACION, DADO_DE_BAJA, SINIESTRADO';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.usuario_creacion IS
    'Usuario del sistema que registro el alta del activo';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.usuario_actualizacion IS
    'Usuario del sistema que realizo la ultima modificacion del registro';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.version_registro IS
    'Version del registro para control de concurrencia optimista';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.observaciones IS
    'Notas sobre el activo, su condicion fisica o historial de movimientos';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.estado_registro IS
    'Estado logico del registro: A=Activo, I=Inactivo, B=Borrado';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.created_at IS
    'Marca de tiempo de creacion del registro en base de datos';
COMMENT ON COLUMN HNEACOSTA1/FIXMS.updated_at IS
    'Marca de tiempo de la ultima actualizacion del registro';

LABEL ON COLUMN HNEACOSTA1/FIXMS (
    numero_activo            TEXT IS 'No. Activo',
    codigo_banco             TEXT IS 'Banco',
    codigo_sucursal          TEXT IS 'Sucursal',
    codigo_clase             TEXT IS 'Clase',
    numero_localizacion      TEXT IS 'Localizacion',
    codigo_moneda            TEXT IS 'Moneda',
    descripcion              TEXT IS 'Descripcion',
    marca                    TEXT IS 'Marca',
    modelo                   TEXT IS 'Modelo',
    numero_serie             TEXT IS 'No. Serie',
    numero_placa             TEXT IS 'No. Placa',
    proveedor                TEXT IS 'Proveedor',
    numero_factura           TEXT IS 'No. Factura',
    fecha_adquisicion        TEXT IS 'Fec Adquis',
    fecha_inicio_depreciacion TEXT IS 'Fec Ini Dep',
    fecha_baja               TEXT IS 'Fec Baja',
    valor_adquisicion        TEXT IS 'Valor Adquis',
    valor_residual           TEXT IS 'Valor Resid',
    valor_libros             TEXT IS 'Valor Libros',
    valor_revaluacion        TEXT IS 'Valor Revalu',
    vida_util_meses          TEXT IS 'Vida Util',
    meses_depreciados        TEXT IS 'Meses Dep',
    meses_restantes          TEXT IS 'Meses Rest',
    depreciacion_mensual     TEXT IS 'Deprec Mens',
    depreciacion_acumulada   TEXT IS 'Deprec Acum',
    responsable_custodio     TEXT IS 'Custodio',
    asegurado                TEXT IS 'Asegurado',
    numero_poliza            TEXT IS 'No. Poliza',
    aseguradora              TEXT IS 'Aseguradora',
    fecha_vencimiento_poliza TEXT IS 'Fec Vto Pol',
    estado_activo            TEXT IS 'Estado',
    usuario_creacion         TEXT IS 'Usr Creacion',
    usuario_actualizacion    TEXT IS 'Usr Actualiz',
    version_registro         TEXT IS 'Version Reg',
    observaciones            TEXT IS 'Observacion',
    estado_registro          TEXT IS 'Estado Reg',
    created_at               TEXT IS 'Fec Creacion',
    updated_at               TEXT IS 'Fec Actualiz'
);

CREATE INDEX HNEACOSTA1/IFIXMSCLS ON HNEACOSTA1/FIXMS (codigo_clase);
CREATE INDEX HNEACOSTA1/IFIXMSLOC ON HNEACOSTA1/FIXMS (numero_localizacion);
CREATE INDEX HNEACOSTA1/IFIXMSBNK ON HNEACOSTA1/FIXMS (codigo_banco);
CREATE INDEX HNEACOSTA1/IFIXMSEST ON HNEACOSTA1/FIXMS (estado_activo);
CREATE INDEX HNEACOSTA1/IFIXMSFAD ON HNEACOSTA1/FIXMS (fecha_adquisicion);
CREATE INDEX HNEACOSTA1/IFIXMSCAT ON HNEACOSTA1/FIXMS (created_at);
