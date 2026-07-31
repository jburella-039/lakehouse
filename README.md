# Lakehouse - Proyecto LookML (Venta Integral)

Modelo LookML sobre BigQuery (`lakehouse-dev-483619`) que reproduce el reporte
Power BI "Venta Integral" (Farmacity).

La mayoria de las vistas son **planas** (una por entidad, con dimensiones y
medidas juntas). El hecho principal **`fct_ventas`** es la excepcion: conserva un
patron de **dos capas** (FND = fundacion / MRT = mart) para separar el mirror del
origen (con el PDT y el hash de cabecera) de la capa semantica con las medidas.

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
|-- /views/                        # vistas PLANAS (dims + fct_remitos + fct_stock)
|   |-- dim_fecha.view.lkml ... dim_obrasocial.view.lkml
|   |-- fct_remitos.view.lkml       #   plano, con PDT + hash (hk_remito)
|   `-- fct_stock.view.lkml
|-- /FND/                          # capa fundacion (SOLO fct_ventas)
|   `-- /bss_comercial/
|       `-- raw_fct_ventas.view.lkml   # mirror + PDT + hash de cabecera
|-- /MRT/                          # capa mart (SOLO fct_ventas)
|   `-- /bss_comercial/
|       `-- fct_ventas.view.lkml       # extends FND, expone campos y medidas
`-- /dashboards/
    `-- venta_integral.dashboard.lookml
```

El modelo incluye `"/views/*.view.lkml"` + `"/MRT/**/*.view.lkml"`. La capa `FND`
entra de forma transitiva via el `include` de `MRT/fct_ventas`.

## Vistas planas (`views/*.view.lkml`)

- Una vista por entidad: dimensiones, claves y medidas en el mismo archivo.
- Apuntan a su `sql_table_name` en los datasets `bss_*` (no cambian las fuentes).
- `fct_remitos` es plano pero mantiene el **PDT** (`derived_table` persistido,
  particionado por `fec_dia`, clusterizado) y el hash `hk_remito` para el conteo.
- `fct_stock` es plano y no esta en el dashboard (explore aparte).

## fct_ventas en dos capas (FND / MRT)

### FND - `FND/bss_comercial/raw_fct_ventas.view.lkml` (fundacion, interno)
- Mirror del origen + **PDT** persistido (particionado por `fec_dia`, clusterizado).
- Precomputa `hk_vta_venta` (INT64 = hash de la clave de cabecera). **No define medidas.**

### MRT - `MRT/bss_comercial/fct_ventas.view.lkml` (mart, expuesto)
- `include` + `extends` de la FND (`raw_fct_ventas`).
- Expone los campos y **define TODAS las medidas** (base, por periodo y YoY).

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

- **Hash key (`hk_vta_venta` / `hk_remito`)**: `FARM_FINGERPRINT` de la clave de
  cabecera -> un `INT64` determinista. Es el equivalente en BigQuery a la
  `HK_VTA_VENTA` del ADW (SP `SP_VTA_TICKETS_CAB_IDS_LOAD`). `COUNT(DISTINCT INT64)`
  es mucho mas barato que sobre string. Las medidas de conteo usan el hash.
- **PDT persistido**: `fct_ventas` (en FND) y `fct_remitos` (en views/) son
  `derived_table` persistidos por `venta_integral_datagroup` (rebuild diario),
  **particionados por `fec_dia`** y **clusterizados** por las claves. El PDT
  precomputa el hash como columna fisica.
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
  `dim_*`). La capa FND de fct_ventas lleva prefijo `raw_`.
- No se cambian las fuentes: la organizacion es solo de carpetas.
