# Lakehouse - Proyecto LookML (Venta Integral)

Modelo LookML sobre BigQuery (`lakehouse-dev-483619`) que reproduce el reporte
Power BI "Venta Integral" (Farmacity). Sigue el **Sistema Multicapa Looker** de
Corebi: separacion clara entre la capa cruda (RAW) y la capa transformada (TRD).

## Estructura del repositorio

```
/
|-- README.md                     # este archivo (estandares y convenciones)
|-- /models/
|   `-- lakehouse.model.lkml       # conexion + includes + datagroups
|-- /explores/                     # logica de JOINs (consume solo vistas TRD)
|   |-- fct_ventas.explore.lkml
|   |-- fct_remitos.explore.lkml
|   `-- fct_stock.explore.lkml
|-- /views_raw/                    # capa CRUDA (mirror del origen BigQuery)
|   |-- /bss_referencial/          #   raw_dim_fecha, raw_dim_horas
|   |-- /bss_comercial/            #   raw_fct_ventas ... raw_dim_origenventa
|   |-- /bss_sucursales/           #   raw_dim_sucursal ... raw_dim_region
|   `-- /bss_salud/                #   raw_dim_obrasocial
|-- /views_trd/                    # capa TRD (transformada / semantica / metricas)
|   |-- /bss_referencial/          #   dim_fecha, dim_horas
|   |-- /bss_comercial/            #   fct_ventas ... dim_origenventa
|   |-- /bss_sucursales/           #   dim_sucursal ... dim_region
|   `-- /bss_salud/                #   dim_obrasocial
`-- /dashboards/
    `-- venta_integral.dashboard.lookml
```

Las vistas se agrupan en subcarpetas por **dataset BigQuery** (`bss_referencial`,
`bss_comercial`, `bss_sucursales`, `bss_salud`), tanto en RAW como en TRD. El nombre
de la vista NO lleva el area (esa se ve en el `label` / `view_label`); la subcarpeta
es solo organizacion. El modelo incluye `"/views_trd/**/*.view.lkml"` (recursivo).

## Capas

### RAW (`views_raw/raw_*.view.lkml`) - interno, desarrolladores
- Refleja la tabla/vista de BigQuery **tal como se lee del origen**. No cambia las
  fuentes: cada `raw_*` apunta a su `sql_table_name` en los datasets `bss_*`.
- `fields_hidden_by_default: yes`: todos los campos ocultos por defecto.
- Contiene claves, dimensiones y dimension_groups. **No define medidas.**

### TRD (`views_trd/*.view.lkml`) - expuesto al usuario
- `include` + `extends` de su vista raw (espejo de la tabla).
- Expone los campos necesarios con `hidden: no` (heredan tipo y SQL de la raw).
- **Define TODAS las metricas** (measures), incluidas las dinamicas por periodo y
  las YoY.
- Lleva el `label` de area para el viewer: `"<Area> - <Nombre>"`.

### Explores (`explores/*.explore.lkml`)
- Definen los JOINs de la estrella. Consumen **solo** vistas TRD.
- Cada `join` fija `view_label` con el prefijo de area.

## Areas (datasets BigQuery)

| Area (label)  | Dataset BigQuery       | Vistas |
|---------------|------------------------|--------|
| Referencial   | `bss_referencial`      | dim_fecha, dim_horas |
| Comercial     | `bss_comercial`        | fct_ventas, fct_remitos, fct_stock, dim_tipocomprobante, dim_articulo, dim_marca, dim_categoria, dim_subcategoria, dim_departamento, dim_origenventa |
| Sucursales    | `bss_sucursales`       | dim_sucursal, dim_formato, dim_provincia, dim_region |
| Salud         | `bss_salud`            | dim_obrasocial |

## Como agregar un campo (patron multicapa)

1. En la vista **RAW**: agregar la `dimension` con su `type` + `sql: ${TABLE}.col`
   (queda oculta por `fields_hidden_by_default`).
2. En la vista **TRD**: exponerla con `dimension: <campo> { hidden: no }`
   (hereda tipo y SQL de la raw; opcionalmente re-etiquetar con `label`).
3. Si es una **metrica nueva**: definir el `measure` directamente en la vista TRD.

## Convenciones

- Nombres de vistas/campos en ASCII. La `ñ` solo en `label` (texto visible).
- Vistas TRD conservan el nombre "limpio" (`fct_ventas`, `dim_fecha`); las raw
  llevan prefijo `raw_`. El dashboard referencia los nombres TRD.
- No se cambian las fuentes: la migracion multicapa es solo de organizacion.
