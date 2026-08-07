# Lakehouse - Proyecto LookML (Venta Integral)

Modelo LookML sobre BigQuery (`lakehouse-dev-483619`) que reproduce el reporte
Power BI "Venta Integral" (Farmacity).

La mayoria de las vistas son **planas** (una por entidad, con dimensiones y
medidas juntas). Los hechos **`fct_ventas`** y **`fct_remitos`** son la excepcion:
usan un patron de **dos capas** (BAS = base cruda / ANL = analisis) para separar el
espejo del origen (crudo, con `fields_hidden_by_default: yes`) de la capa semantica
con el PDT, los labels y las medidas.

## Estructura del repositorio

```
/
|-- README.md                     # este archivo (estandares y convenciones)
|-- /models/
|   `-- lakehouse.model.lkml       # conexion + includes + datagroups
|-- /explores/                     # logica de JOINs de la estrella
|   |-- fct_ventas.explore.lkml
|   |-- fct_remitos.explore.lkml
|   `-- fct_stock.explore.lkml
|-- /views/                        # vistas PLANAS (dims + fct_stock)
|   |-- dim_fecha.view.lkml ... dim_obrasocial.view.lkml
|   `-- fct_stock.view.lkml
|-- /views_BAS/                    # capa BASE cruda (fct_ventas + fct_remitos)
|   `-- /bas_bss_comercial/
|       |-- bas_fct_ventas.view.lkml   # espejo crudo de vw_fct_ventas, fields_hidden_by_default
|       `-- bas_fct_remitos.view.lkml  # espejo crudo de vw_fct_remitos, fields_hidden_by_default
|-- /views_ANL/                    # capa ANALISIS (fct_ventas + fct_remitos)
|   `-- /anl_bss_comercial/
|       |-- anl_fct_ventas.view.lkml   # extends bas_fct_ventas, agrega PDT, labels y medidas
|       `-- anl_fct_remitos.view.lkml  # extends bas_fct_remitos, PDT + hk_remito, labels y medidas
`-- /dashboards/
    `-- venta_integral.dashboard.lookml
```

El modelo incluye `"/views/*.view.lkml"` + `"/views_ANL/**/*.view.lkml"`. La capa
`views_BAS` entra de forma transitiva via el `include` de `anl_fct_ventas`. El
explore se sigue llamando `fct_ventas` (usa `from: anl_fct_ventas`), asi que el
dashboard no cambia.

## Vistas planas (`views/*.view.lkml`)

- Una vista por entidad: dimensiones, claves y medidas en el mismo archivo.
- Apuntan a su `sql_table_name` en los datasets `bss_*` (no cambian las fuentes).
- `fct_stock` es plano y no esta en el dashboard (explore aparte).

## fct_ventas y fct_remitos en dos capas (views_BAS / views_ANL)

### BAS - `views_BAS/bas_bss_comercial/bas_fct_ventas.view.lkml` (base cruda, interna)
- Espejo 1:1 de `bss_comercial.vw_fct_ventas` via `sql_table_name`, generado como lo
  arma el IDE de Looker desde la vista (todas las columnas, sin comentarios). **SIN
  labels, SIN campos calculados, SIN sectores, SIN PDT.** El grano de fecha son los
  dimension_group `fec_dia` y `fec_venta` (nombre crudo del origen).

### ANL - `views_ANL/anl_bss_comercial/anl_fct_ventas.view.lkml` (analisis, expuesto)
- `include` + `extends` de la BASE (`bas_fct_ventas`).
- Se queda con el **PDT** (`derived_table` particionado por `fec_dia`, clusterizado):
  sobreescribe el `sql_table_name` crudo de BAS. Passthrough (`SELECT f.*`), sin hash.
- Agrega **labels legibles** (sin sectores tipo Comercial/Referencial/Salud), los
  campos calculados (pk, cobertura, periodos) y **define TODAS las medidas**.
- El explore `fct_ventas` la consume via `from: anl_fct_ventas` (mantiene el nombre
  `fct_ventas.*` que usa el dashboard).

### fct_remitos - mismo patron
- BAS `bas_fct_remitos` = espejo crudo de `vw_fct_remitos` (`fields_hidden_by_default`).
- ANL `anl_fct_remitos` `extends` la base; su **PDT** hace `SELECT r.*` y precomputa
  `hk_remito` (`FARM_FINGERPRINT` de sucursal + dia + nro remito), particionado por
  `fec_dia` y clusterizado por `id_sucursal` + `id_tipocomprobante`. Agrega labels,
  las calculadas (tipo_dispensa, es_psicotropico, es_receta_digital) y las medidas.
- El explore `fct_remitos` la consume via `from: anl_fct_remitos`. El grano de fecha
  es el dimension_group `fec_dia` (antes se llamaba `dia`).

### Explores (`explores/*.explore.lkml`)
- Definen los JOINs de la estrella. Cada `join` fija `view_label` con el area
  (`Comercial - ...`, `Referencial - ...`, `Sucursales - ...`, `Salud - ...`).

## Areas (datasets BigQuery, se ven via `view_label` en los explores)

| Area (label)  | Dataset BigQuery       | Vistas |
|---------------|------------------------|--------|
| Referencial   | `bss_referencial`      | dim_fecha, dim_horas |
| Comercial     | `bss_comercial`        | fct_ventas, fct_remitos, fct_stock, dim_tipocomprobante, dim_articulo, dim_marca, dim_categoria, dim_subcategoria, dim_departamento, dim_origenventa |
| Sucursales    | `bss_sucursales`       | dim_sucursal, dim_formato, dim_provincia, dim_region |
| Salud         | `bss_salud`            | dim_obrasocial |

## Performance: PK unica de Ventas + PDT

Los conteos de Tickets / Remitos son `count_distinct`. Contarlos sobre un string
ancho armado en cada consulta (sucursal-caja-tipocomp-nrocomp-dia-apertura) es
caro. Para acelerarlos:

- **Ventas - clave nativa (`id_venta`)**: la vista `vw_fct_ventas` ya expone
  `id_venta` (INT64), la clave de ticket del origen. La medida Tickets hace
  `COUNT(DISTINCT id_venta)`. Antes se calculaba en Looker un hash
  (`FARM_FINGERPRINT` de 6 campos de cabecera); se validó biyección 1:1 exacta
  entre `id_venta` y ese hash sobre la vista (0 NULLs en 693M filas, 2023-2026) y
  se reemplazó: menos bytes y menos CPU (escanea 1 columna vs 6, sin computar hash).
- **Remitos - hash key (`hk_remito`)**: sigue usando `FARM_FINGERPRINT` de
  sucursal + dia + nro remito (la vista de remitos no tiene una PK nativa de remito;
  `id_venta` alli es la venta, otro grano).
- **PDT persistido**: `anl_fct_ventas` y `anl_fct_remitos` (ambos en views_ANL) son
  `derived_table` persistidos por `venta_integral_datagroup` (rebuild diario),
  **particionados por `fec_dia`** y **clusterizados** por las claves.
- **BigQuery** (`bigquery/pk_ventas_unica.sql`): vistas `vw_fct_ventas_hk` /
  `vw_fct_remitos_hk` (hash reutilizable por otros consumidores) y la tabla
  `map_vta_tickets_cab_id` (grano cabecera, `es_venta`, con surrogate denso
  `id_vta_venta`), refrescada por MERGE idempotente (resiste recargas).

Requiere **PDTs habilitados** en la conexion (dataset temporal `looker_scratch` en
`southamerica-east1`, misma region que los datasets). El LookML precomputa el hash
leyendo de las vistas base, asi que se despliega sin depender del SQL de BigQuery.

## Convenciones

- Nombres de vistas/campos en ASCII. La `ñ` solo en `label` (texto visible).
- El dashboard referencia los nombres de vista finales (`fct_ventas`, `fct_remitos`,
  `dim_*`). Las capas de fct_ventas llevan prefijo `fnd_` (fundacion) y `mrt_` (mart).
- No se cambian las fuentes: la organizacion es solo de carpetas.
