# Lakehouse - Proyecto LookML (Venta Integral)

Modelo LookML sobre BigQuery (`lakehouse-dev-483619`) que reproduce el reporte
Power BI "Venta Integral" (Farmacity).

**Todas** las entidades (hechos y dimensiones) usan un patron de **dos capas**
(BAS = base cruda / ANL = analisis): la capa BAS es el espejo 1:1 del origen
BigQuery con `fields_hidden_by_default: yes`, y la capa ANL la extiende para exponer
lo curado con `hidden: no` + labels, campos calculados, PDT (en los hechos) y
medidas. Lo unico plano que queda es `fct_ventas_pktest` (vista de prueba).

## Estructura del repositorio

```
/
|-- README.md                     # este archivo (estandares y convenciones)
|-- /models/
|   `-- lakehouse.model.lkml       # conexion + includes + datagroups
|-- /views/                        # solo fct_ventas_pktest (prueba, no productiva)
|   `-- fct_ventas_pktest.view.lkml
|-- /views_BAS/                    # capa BASE cruda (todas las entidades)
|   |-- /bas_bss_comercial/        # bas_fct_ventas, bas_fct_remitos, bas_fct_stock,
|   |                              #   bas_dim_articulo, bas_dim_tipocomprobante, ...
|   |-- /bas_bss_referencial/      # bas_dim_fecha, bas_dim_horas
|   |-- /bas_bss_sucursales/       # bas_dim_sucursal, bas_dim_formato, ...
|   `-- /bas_bss_salud/            # bas_dim_obrasocial
|-- /views_ANL/                    # capa ANALISIS (todas las entidades, mismo arbol)
|   |-- /anl_bss_comercial/        # anl_fct_ventas, anl_fct_remitos, anl_fct_stock, anl_dim_*
|   |-- /anl_bss_referencial/
|   |-- /anl_bss_sucursales/
|   `-- /anl_bss_salud/
`-- /dashboards/
    `-- venta_integral.dashboard.lookml
```

El modelo incluye `"/views/**"` + `"/views_BAS/**"` + `"/views_ANL/**"`. Los explores
(`fct_ventas` / `fct_remitos` / `fct_stock`) usan la capa ANL via `from: anl_<fct>`;
cada `join` usa `from: anl_<dim>`. El nombre del join y las referencias (`dim_*.campo`)
NO cambian, asi que el dashboard no cambia.

## Dos capas BAS/ANL (todas las entidades)

Patron: `bas_<entidad>` (espejo crudo, `fields_hidden_by_default: yes`) +
`anl_<entidad>` (`include` + `extends: [bas_<entidad>]`, expone lo curado con
`hidden: no` + labels y calculados; los hechos agregan el PDT y las medidas). Las
dimensiones renombran el campo de negocio (ej: `categoria` desde `dsc_categoria`) y
lo definen fresco en ANL; los join keys quedan ocultos y se heredan de BAS (siguen
resolviendo en los `sql_on` aunque esten `hidden`).

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
- ANL `anl_fct_remitos` `extends` la base; su **PDT** hace `SELECT r.*` (usa la clave
  nativa `id_remito` de la fuente, ver seccion Performance), particionado por
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
- **Remitos - clave nativa (`id_remito`)**: la vista `vw_fct_remitos` ya expone
  `id_remito` (INT64), la clave de cabecera de remito del origen (`bss_oracle.fct_remitos`,
  se propaga por el `SELECT *` de la vista). La medida Remitos hace
  `COUNT(DISTINCT id_remito)`. Antes se calculaba en Looker un hash (`FARM_FINGERPRINT`
  de sucursal + dia + nro remito); se validó 1:1 exacto entre `id_remito` y ese hash
  sobre la vista (0 NULLs, 2.582.649 = 2.582.649 en junio 2026) y se reemplazó.
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
