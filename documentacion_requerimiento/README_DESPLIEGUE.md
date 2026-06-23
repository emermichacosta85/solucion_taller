# Conciliación de Cuentas Mayores GLBLN — Conjunto SQLRPGLE (Taller IBM i)

Proceso batch que concilia las cuentas mayores del archivo de balances **GLBLN**
contra el detalle de movimientos (**TRANS**/**TRDSC**) y las partidas en tránsito
(**TTRAN**), clasifica el estado financiero de cada cuenta y **genera un documento
JSON mediante SQL (Db2 for i)** que se publica en el **IFS** en UTF-8.

> Estado de la entrega: código fuente `*full free`, JSON de ejemplo real,
> pruebas de cuadratura y documentación técnica. Sin objetos PF/LF: toda
> estructura de datos temporal se crea vía SQL DDL (tablas temporales de sesión).

---

## 1. Arquitectura de componentes (SOLID)

El diseño separa responsabilidades en capas; cada capa es un objeto IBM i
independiente y desacoplado por contratos (el copybook `GLCNCPY`).

| Componente | Tipo IBM i | Responsabilidad | Principio |
|---|---|---|---|
| `GLPNCPY`  | Copybook `.rpgleinc` | Contratos: constantes, templates de DS y prototipos. | ISP / DIP |
| `GLPNUTL`  | Módulo → `*SRVPGM` | Utilidades: id de ejecución, ISO timestamp, ruta/nombre IFS, bitácora. | SRP |
| `GLPNDAO`  | Módulo | Todo el SQL de dominio; crea las tablas de trabajo de sesión y carga datos set-based. | SRP / DIP |
| `GLPNBUS`  | Módulo | Reglas de negocio puras (clasificación, incidentes, estado de ejecución). | SRP / OCP |
| `GLPNJSON` | Módulo | Serializa el JSON con SQL sobre las tablas de trabajo y lo escribe al IFS. | SRP / DIP |
| `GLPN001`  | Programa `*PGM` | Orquestador batch del flujo completo. | SRP |

El **negocio (`GLPNBUS`) no conoce SQL ni IFS**; el **acceso a datos (`GLPNDAO`)
no contiene reglas**; la **salida (`GLPNJSON`) sólo serializa**. El contrato de
datos entre negocio y salida son las tablas de trabajo de sesión
(`SESSION.GLWRKCTA`, `GLWRKPAR`, `GLWRKINC`), lo que cumple DIP: la salida
depende de una abstracción (la estructura de las tablas), no de la lógica.

```
                        +------------------+
                        |     GLPN001      |  (orquestador *PGM)
                        +--------+---------+
                                 |
     +---------------+-----------+-----------+----------------+
     v               v                       v                v
+----------+   +-----------+           +-----------+    +-----------+
| GLPNUTL  |   | GLPNDAO   |           | GLPNBUS   |    | GLPNJSON  |
| (utils)  |   | (SQL DAO) |           | (reglas)  |    | (JSON/IFS)|
+----------+   +-----+-----+           +-----+-----+    +-----+-----+
                     |                       |                |
                     v                       |                v
        SESSION.GLWRKCTA / GLWRKPAR <--------+-------->  IFS .json (SQL)
                 GLWRKINC  (tablas temporales de sesión = contrato de datos)
```

---

## 2. Flujo de ejecución (batch)

1. `utl_genIdEjecucion` → identidad trazable `YYYYMMDD_HHMMSS_NNN`.
2. Resolución de parámetros (con valores por defecto del taller).
3. `dao_prepararEntorno` → declara las 3 tablas temporales de sesión.
4. `dao_cargarCuentas` → calcula saldos, diferencias, conteos y hash por cuenta
   (set-based, una sola sentencia con CTEs).
5. `dao_cargarPartidas` → materializa las partidas en tránsito enriquecidas.
6. Por cada cuenta (cursor): `bus_clasificarCuenta` → `dao_cuentaUpdateClasif`
   → `bus_incidenteCuenta` → `dao_insertarIncidente`.
7. `dao_calcularTotales` → cuadratura global (`controlTotales`).
8. `bus_estadoEjecucion` → `FINALIZADO` / `PARCIAL` / `ERROR`.
9. `jsn_generarDocumento` → arma el JSON con SQL y lo escribe al IFS.
10. `jsn_validarUltimo` → validación estructural mínima del JSON.
11. Bitácora y resumen final.

---

## 3. Requisitos previos

- IBM i **7.4 o superior** (uso de `JSON_OBJECT`, `JSON_ARRAYAGG`, `JSON_EXISTS`,
  `QSYS2.IFS_WRITE_UTF8` y `HASH_SHA256`).
- Datos semilla cargados (`seed_conciliacion_glbln.sql`) en la librería destino.
- Autorización de lectura sobre `GLBLN`, `GLMST`, `TRANS`, `TRDSC`, `TTRAN` y de
  escritura sobre la ruta IFS de salida.
- Fuentes cargados en la librería destino:
  - `GLCNCPY`, `GLCNUTL`, `GLCNBUS`, `GLCNDAO`, `GLCNJSON`, `GLCN001` en `QRPGLESRC`.
  - `GLCNBND` (binder source) en `QSRVSRC`.

---

## 4. Compilación y enlace

Orden de dependencias (automatizado en `GLCNBLD.clle`):

1. Módulos: `CRTSQLRPGI ... OBJTYPE(*MODULE)` para `GLPNUTL`, `GLPNBUS`,
   `GLCNDAO`, `GLCNJSON`.
2. Programa de servicio: `CRTSRVPGM` con los 4 módulos y `EXPORT(*SRCFILE)`
   apuntando a `GLPNBND`.
3. Registrar el `*SRVPGM` en el binding directory `GLPNBND`.
4. Programa principal: `CRTSQLRPGI ... OBJTYPE(*PGM)` para `GLPN001`.

Compilación manual equivalente (ejemplo, librería `HNEACOSTA2`):

```
CRTSQLRPGI OBJ(HNEACOSTA2/GLPNUTL)  SRCFILE(HNEACOSTA2/QRPGLESRC) OBJTYPE(*MODULE) COMMIT(*NONE)
CRTSQLRPGI OBJ(HNEACOSTA2/GLPNBUS)  SRCFILE(HNEACOSTA2/QRPGLESRC) OBJTYPE(*MODULE) COMMIT(*NONE)
CRTSQLRPGI OBJ(HNEACOSTA2/GLPNDAO)  SRCFILE(HNEACOSTA2/QRPGLESRC) OBJTYPE(*MODULE) COMMIT(*NONE)
CRTSQLRPGI OBJ(HNEACOSTA2/GLPNJSON) SRCFILE(HNEACOSTA2/QRPGLESRC) OBJTYPE(*MODULE) COMMIT(*NONE)
CRTSRVPGM  SRVPGM(HNEACOSTA2/GLPNUTL) MODULE(HNEACOSTA2/GLPNUTL HNEACOSTA2/GLPNBUS HNEACOSTA2/GLPNDAO HNEACOSTA2/GLPNJSON) EXPORT(*SRCFILE) SRCFILE(HNEACOSTA2/QSRVSRC) SRCMBR(GLPNBND)
CRTBNDDIR  BNDDIR(HNEACOSTA2/GLPNBND)
ADDBNDDIRE BNDDIR(HNEACOSTA2/GLPNBND) OBJ((HNEACOSTA2/GLPNUTL *SRVPGM))
CRTSQLRPGI OBJ(HNEACOSTA2/GLPN001) SRCFILE(HNEACOSTA2/QRPGLESRC) OBJTYPE(*PGM) COMMIT(*NONE)
```

> Nota: los fuentes `.sqlrpgle` se cargan como miembros de `QRPGLESRC`; el
> `.rpgleinc` como miembro `GLCNCPY`; el `.bnd` como miembro `GLCNBND` en
> `QSRVSRC`; el `.clle` como miembro en `QCLSRC`.

---

## 5. Ejecución

Parámetros (todos opcionales; si se omiten o llegan en blanco se aplican los
valores por defecto del taller). Ver también `qtxtsrc/GLCNPARM.txt`.

| # | Parámetro | Ejemplo | Defecto |
|---|---|---|---|
| 1 | Banco | `01` | `01` |
| 2 | Sucursal | `001` | `001` |
| 3 | Moneda | `USD` | `USD` |
| 4 | Cuenta desde | `11000000` | `11000000` |
| 5 | Cuenta hasta | `11999999` | `11999999` |
| 6 | Fecha proceso | `2026-05-19` | fecha actual |
| 7 | Ruta IFS | `/tmp/conciliacion` | `/tmp/conciliacion` |
| 8 | Modo | `PRODUCTIVO` | `PRODUCTIVO` |
| 9 | Ambiente | `QA` | `QA` |
| 10| Tolerancia | `1.00` | `1.00` |

``` Invocacion de Programa
CALL PGM(HNEACOSTA2/GLPN001) PARM(
     '01' '001' 'USD' '11000000' '11999999'
     '2026-05-19' '/HOME/HNEACOSTA/' 'PRODUCTIVO' 'QA' '1.00')
```

Salidas en la ruta IFS:
- `concilia_glbln_<idEjecucion>.json` — documento de conciliación.
- `glcn001_<idEjecucion>.log` — bitácora de la corrida.

---

## 6. Reglas de negocio implementadas

Clasificación por cuenta (tolerancia parametrizable, defecto `1.00`):

| Condición | Estado | Severidad | requiereRevisión |
|---|---|---|---|
| `|diferencia| > tolerancia` | `NO_CONCILIADA` | `ALTA` | `true` |
| `|diferencia| <= tolerancia` y (`dif<>0` o hay partidas) | `PARCIAL` | `MEDIA` | `true` |
| `dif = 0` y sin partidas | `CONCILIADA` | `BAJA` | `false` |

- `saldoFinalConciliado = saldoFinalCalculado` (las partidas en tránsito **no**
  se aplican al mayor todavía).
- `saldoFinalCalculado = saldoInicial + débitosPeriodo − créditosPeriodo`.
- `saldoInicial` = `saldo_anterior` del primer movimiento APLICADA (por fecha/hora).
- `estadoEjecucion`: `ERROR` si hubo falla técnica; `PARCIAL` si existe ≥1
  incidente ALTA/CRÍTICA; `FINALIZADO` en otro caso.
- `centroCosto` derivado por prefijo: `1101`/`1102` → `CC001`; `1103` → `CC002`;
  resto → `CC000`.

---

## 7. Estándar de nomenclatura

- Prefijo del proyecto: **`GLCN`** (General Ledger CoNciliación).
- Procedimientos: `modulo_verboSustantivo` en camelCase
  (`dao_cargarCuentas`, `bus_clasificarCuenta`, `jsn_generarDocumento`).
- Variables: `p*` parámetro, `w*` trabajo, `g*` global de módulo, `c*`/`CN_*`
  constante.
- Tablas de trabajo de sesión: `SESSION.GLWRK<contexto>` (`CTA`, `PAR`, `INC`).
- Archivo JSON: `concilia_glbln_<idEjecucion>.json`; bitácora:
  `glcn001_<idEjecucion>.log`.

---

## 8. Generación del JSON mediante SQL

`GLCNJSON` arma el documento con un único `SELECT ... FROM SYSIBM.SYSDUMMY1`
combinando:
- `JSON_OBJECT(...)` para los objetos (metadata, ejecución, contexto, saldos…).
- `JSON_ARRAYAGG(... ORDER BY ...)` para `cuentas[]` e `incidentes[]`.
- Sub-consulta correlacionada con `FORMAT JSON` para
  `cuentas[].partidasConciliatorias[]`.
- `COALESCE(<subquery>, JSON_ARRAY()) FORMAT JSON` para arrays potencialmente
  vacíos (cuenta sin partidas → `[]`).
- Booleanos reales (`excedeTolerancia`, `requiereRevision`) emitidos con
  `FORMAT JSON` a partir de los literales `'true'`/`'false'`.

El CLOB resultante se publica con
`QSYS2.IFS_WRITE_UTF8(PATH_NAME, LINE, OVERWRITE => 'REPLACE', END_OF_LINE => 'NONE')`
(CCSID 1208, UTF-8). `jsn_validarUltimo` confirma con `JSON_EXISTS` la presencia
de las seis claves obligatorias: `metadata`, `ejecucion`, `contexto`, `cuentas`,
`controlTotales`, `incidentes`.

---

## 9. Matriz de trazabilidad JSON → programa → BD

| Campo JSON | Origen BD | Obtención | Procedimiento |
|---|---|---|---|
| `metadata.*` | constantes | Generado | `GLCNJSON` (constantes `GLCNCPY`) |
| `metadata.ambiente` | parámetro | Generado | `GLCN001` → `GLCNJSON` |
| `ejecucion.idEjecucion` | — | Generado | `utl_genIdEjecucion` |
| `ejecucion.fechaHoraInicio/Fin` | — | Generado | `utl_isoAhora` |
| `ejecucion.usuario` | `CURRENT_USER` | Generado | `GLCN001` |
| `ejecucion.libreria` | `CURRENT_SCHEMA` | Generado | `GLCN001` |
| `ejecucion.estadoEjecucion` | — | Derivado | `bus_estadoEjecucion` |
| `contexto.banco/sucursal/moneda` | `GLBLN.codigo_*` | Directo/Parámetro | `GLCN001` |
| `contexto.periodo.*` | fecha de proceso | Derivado | `GLCN001` |
| `cuentas[].cuentaMayor.*` | `GLBLN` + `GLMST` | Directo | `dao_cargarCuentas` |
| `cuentas[].cuentaMayor.centroCosto` | prefijo de cuenta | Derivado | `dao_cargarCuentas` |
| `cuentas[].saldos.saldoInicial` | `TRANS.saldo_anterior` (1er mov) | Derivado | `dao_cargarCuentas` |
| `cuentas[].saldos.debitosPeriodo` | `SUM(TRANS.monto)` D | Derivado | `dao_cargarCuentas` |
| `cuentas[].saldos.creditosPeriodo` | `SUM(TRANS.monto)` C | Derivado | `dao_cargarCuentas` |
| `cuentas[].saldos.saldoFinalCalculado` | inicial+D−C | Derivado | `dao_cargarCuentas` |
| `cuentas[].saldos.saldoFinalFuente` | `GLBLN.saldo_actual` | Directo | `dao_cargarCuentas` |
| `cuentas[].saldos.saldoFinalConciliado` | = calculado | Derivado | `dao_cargarCuentas` |
| `cuentas[].resumenMovimientos.*` | `TRANS` (count/min/max ts) | Derivado | `dao_cargarCuentas` |
| `cuentas[].partidasConciliatorias[]` | `TTRAN` PENDIENTE + `TRDSC` seq 2 | Derivado | `dao_cargarPartidas` |
| `cuentas[].diferencias.diferenciaNeta` | fuente − conciliado | Derivado | `dao_cargarCuentas` |
| `cuentas[].diferencias.excedeTolerancia` | regla tolerancia | Derivado | `bus_clasificarCuenta` |
| `cuentas[].estadoConciliacion.*` | regla de negocio | Derivado | `bus_clasificarCuenta` |
| `cuentas[].trazabilidad.hashCuenta` | `HASH_SHA256` campos clave | Derivado | `dao_cargarCuentas` |
| `cuentas[].trazabilidad.registrosFuente.*` | conteos por tabla | Derivado | `dao_cargarCuentas` |
| `controlTotales.*` | agregados `SESSION.GLWRKCTA/INC` | Derivado | `dao_calcularTotales` |
| `incidentes[]` | clasificación por cuenta | Derivado | `bus_incidenteCuenta` |

---

## 10. Pruebas y evidencia

- `qsqlsrc/pruebas_conciliacion.sql` — replica con SQL puro los cálculos del
  conjunto y los contrasta con los valores esperados del seed. Cada prueba
  devuelve `RESULTADO = 'OK' | 'FALLA'`:
  1. Saldos calculados por cuenta.
  2. Clasificación por tolerancia.
  3. Cuadratura global de `controlTotales`.
  4. Partidas en tránsito esperadas.
  5. Serialización `JSON_OBJECT` por cuenta.
- `evidencia/concilia_glbln_20260519_120342_001.json` — JSON de salida real
  calculado de los datos semilla (cuadratura verificada:
  fuente `765150.50`, conciliado `765000.00`, diferencia neta `150.50`).

Resultado esperado con el seed: 3 cuentas; 1 `CONCILIADA`, 1 `PARCIAL`,
1 `NO_CONCILIADA`; 2 incidentes (1 BAJA, 1 ALTA); `estadoEjecucion = PARCIAL`.

---

## 11. Troubleshooting

| Síntoma | Causa probable | Acción |
|---|---|---|
| `SQL0204` objeto no encontrado | falta el seed o librería no en *LIBL | cargar seed; `ADDLIBLE` |
| JSON no aparece en IFS | sin permiso de escritura en la ruta | otorgar `*WX` sobre el directorio IFS |
| JSON con caracteres extraños | lector no interpreta UTF-8 | el archivo es CCSID 1208; abrir como UTF-8 |
| `estadoEjecucion = ERROR` | excepción técnica (ver `.log`) | revisar bitácora `glcn001_<id>.log` |
| Cuenta no aparece | `estado_registro <> 'A'` o fuera de rango | validar filtros/rango de cuentas |
| Diferencia inesperada | movimientos no `APLICADA` | sólo TRANS `APLICADA` suma al cálculo |

---

## 12. Cumplimiento de la guía de revisión

- **Sólo tablas/vistas SQL**: las estructuras de datos son tablas temporales de
  sesión (`DECLARE GLOBAL TEMPORARY TABLE`, SQL DDL) y una vista de pruebas.
  **No se crean PF/LF** (sección 14 de `Revision_IBMi.md`). Por ello no aplica
  la metadata pesada de tablas permanentes (sección 13), reservada a
  `CREATE OR REPLACE TABLE` de objetos persistentes.
- **SOLID** y separación de capas (sección 6.1/6.2): documentadas arriba.
- **JSON válido y consistente** (sección 7): estructura mínima verificada por
  `jsn_validarUltimo`; cuadratura de `sumatoriaDiferenciaNeta` probada.
- **Pruebas y evidencia** (sección 6.4/11): script de pruebas + JSON real.
- **Nomenclatura** (sección 6.6): estándar `GLCN` documentado.
