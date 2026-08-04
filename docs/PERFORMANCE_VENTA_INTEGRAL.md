# Plan de performance - Tablero Venta Integral

Objetivo: que el tablero cargue al instante moviendo los calculos pesados desde
Looker/BigQuery-al-vuelo hacia estructuras precalculadas en BigQuery. Looker
quedaria solo leyendo columnas ya listas y agregando sumas simples.

## 1. Diagnostico (por que hoy tarda)

Las vistas `vw_fct_ventas` / `vw_fct_remitos` / `vw_fct_stock` son pasarelas finas
(SELECT * con filtro de años) sobre `bss_oracle.*`, que estan particionadas por
`fec_dia`. El scan en si prunea bien (se midio: ~1.3 GB para un mes). El tiempo se
va en el **computo por tile**, no en leer datos. Los tres focos:

1. **`COUNT(DISTINCT ...)` sobre claves de texto concatenadas** (`ticket_key`,
   `remito_key`). Contar distintos sobre un STRING largo es lo mas caro de la query
   y se repite en cada tarjeta/tabla que muestre Tickets o Remitos.
2. **Join a `dim_tipocomprobante` en cada tile** solo para traer los flags
   `es_venta` / `resta_stock` que filtran casi todas las medidas.
3. **Comparacion interanual (YoY) de doble ventana**: cada medida `_periodo` y su
   par `_periodo_aa` usa `DATE_ADD(fec_dia, +1 año)`, obligando a escanear dos
   ventanas de año por tile y a recalcular todo al vuelo.

A esto se suma la reserva de slots chica/variable de `lakehouse-dev` y la
concurrencia de muchos tiles a la vez. **Nada de esto se resuelve solo con LookML**;
requiere precalculo en BigQuery.

## 2. Calculos a mover a BigQuery

Prioridad: A = mayor impacto. Todo esto se materializa en tablas nuevas (ver
seccion 3), no en las vistas finas actuales.

| # | Prio | Calculo (LookML actual) | Tabla/vista origen | Columnas de origen | Que hacer en BigQuery | Beneficio |
|---|------|-------------------------|--------------------|--------------------|-----------------------|-----------|
| 1 | A | `ticket_key` -> `COUNT(DISTINCT)` en `tickets`, `tickets_periodo`, `tickets_periodo_aa` | `vw_fct_ventas` | `id_ventaunica`, `id_sucursal`, `id_caja`, `id_tipocomprobante`, `cd_nrocomprobante`, `fec_dia`, `id_nroapertura` | Precalcular una **clave numerica** `nk_ticket = FARM_FINGERPRINT(<mismo concat>)` como columna fisica INT64. Contar distintos sobre INT64 es mucho mas barato que sobre STRING. | Baja fuerte el costo del distinct de tickets |
| 2 | A | `remito_key` -> `COUNT(DISTINCT)` en `remitos`, `remitos_periodo`, `remitos_periodo_aa` | `vw_fct_remitos` | `id_sucursal`, `fec_dia`, `id_nroremito` | Igual que #1: columna `nk_remito = FARM_FINGERPRINT(...)` INT64. | Idem |
| 3 | A | Filtros `dim_tipocomprobante.es_venta` / `.resta_stock` (join en cada medida) | join a `dim_tipocomprobante` por `id_tipocomprobante` | `id_tipocomprobante` -> `ID_TKT_ESVENTA`, `ID_TKT_RESTASTOCK` | **Denormalizar** los flags como columnas `flg_esventa` / `flg_restastock` (INT64/BOOL) dentro de los hechos. Ya esta anotado como recomendacion en `fct_ventas.view.lkml`. | Elimina el join de tipocomprobante en todos los tiles |
| 4 | A | Comparacion YoY `_periodo` vs `_periodo_aa` (`en_periodo_aa` con `DATE_ADD +1 año`) | `vw_fct_ventas`, `vw_fct_remitos` | `fec_dia` + todas las medidas base | Construir **tabla resumen diaria** preagregada (seccion 3). El YoY pasa a ser un self-join a nivel dia contra pocas filas, no un doble scan del hecho linea a linea. | El mayor cambio estructural; hace que las tablas Formato/Canal/Tienda y los KPIs sean casi instantaneos |
| 5 | B | Sumas de importes y unidades (`venta_neta`, `unidades`, `costo`, `mto_total`, etc.) | `vw_fct_ventas`, `vw_fct_remitos` | `mto_totalsinivaantesdescuento`, `cnt_unidades`, `mto_costo`, `mto_total`, `mto_costofarmacia` | Preagregar `SUM(...)` en la tabla resumen (seccion 3) al grano dia x dimensiones. En Looker quedan como `type: sum` sobre columnas ya sumadas. | Menos filas a agregar por tile |
| 6 | B | `margen_pesos` = neto - costo; `margen_pct` | calculado al vuelo | `mto_totalsinivaantesdescuento`, `mto_costo` (y equivalentes remitos) | Guardar `mto_margen` como columna en el resumen (o dejar la resta en Looker, es barata). El % sigue calculandose en Looker sobre las sumas. | Menor; consistencia de negocio |
| 7 | C | `tipo_cobertura` (CASE) y `cliente_identificado` (yesno) | `vw_fct_ventas` | `id_obrasocial`, `id_cliente` | Precalcular como columnas fisicas si se usan para cortar/filtrar mucho. | Menor |
| 8 | C | Jerarquia de producto por snowflake (`dim_articulo` -> `dim_marca`/`dim_categoria`/`dim_subcategoria`/`dim_departamento`) | joins del explore | `id_marca`, `id_categoria`, `id_subcategoria`, `id_departamento` | Denormalizar los nombres (marca, categoria, etc.) dentro de la tabla resumen para evitar la cadena de joins en las tablas del tablero. | Menos joins en Home/Categoria |

### Nota importante sobre Tickets/Remitos en la tabla resumen (#1, #2, #4)

`COUNT(DISTINCT ticket)` **no es aditivo**: no se puede sumar el conteo de dos
grupos para obtener el total (un mismo ticket puede aparecer en varias filas). Si
se preagrega por dia x sucursal x formato x canal x categoria, el conteo de tickets
a un nivel mas alto (ej. solo por formato) no se puede reconstruir sumando.

Dos salidas, elegir segun necesidad:

- **Exacto y aditivo con sketches HLL** (recomendado): en la tabla resumen guardar
  `tickets_sketch = HLL_COUNT.INIT(nk_ticket)` (BYTES) por grano. En Looker la
  medida es `type: number` con `sql: HLL_COUNT.MERGE(${TABLE}.tickets_sketch) ;;`,
  que rolea correctamente a cualquier nivel con error ~1%. Igual para remitos.
- **Conteo fijo por grano**: guardar `tickets` como INT64 solo valido al grano
  exacto del resumen. Simple, pero si el usuario quita un corte el numero no
  rolea. Solo sirve si el tablero siempre muestra el mismo grano.

## 3. Estructura recomendada (el cambio de fondo)

Crear una **tabla resumen materializada** que alimente al tablero, reconstruida por
el `datagroup` diario (ya existe `venta_integral_datagroup`, cache 24h):

```
Tabla:      lakehouse-dev-483619.bss_comercial.agg_venta_integral_diario
Grano:      fec_dia x id_sucursal x id_formato x id_canal(origenventa) x id_categoria
Particion:  PARTITION BY fec_dia
Cluster:    CLUSTER BY id_formato, id_canal, id_categoria
Columnas:   dims (ids + nombres denormalizados de formato/canal/categoria/marca/region/provincia)
            flg_esventa, flg_restastock (ya aplicados en el WHERE del build)
            venta_neta, unidades, costo, mto_margen            (SUM preagregado)
            tickets_sketch  = HLL_COUNT.INIT(nk_ticket)         (para distinct aditivo)
```

Analogo para remitos (`agg_remitos_diario`) y, si hace falta, para stock del
ultimo dia (`agg_stock_ultimo_dia`, resolviendo el `MAX(fec_dia)` una sola vez en
el build en vez de con la subquery correlacionada del view actual).

Con esto los tiles del tablero leen miles de filas preagregadas en vez de decenas
de millones de lineas de comprobante. El YoY se vuelve un self-join a nivel dia.

### Como lo consume Looker

- Opcion simple: apuntar los views del tablero a estas tablas `agg_*` (mismas
  medidas, pero `type: sum` sobre columnas ya sumadas y HLL para los distintos).
- Opcion nativa Looker: **aggregate awareness** (`aggregate_table` en el explore).
  Se dejan los explores actuales apuntando al detalle y se declara la agregada;
  Looker enruta automaticamente los tiles del tablero a la tabla chica y deja el
  detalle disponible para drill-down. Es lo mas prolijo pero requiere una pasada de
  configuracion.

## 4. Otras recomendaciones de performance

**BigQuery / infraestructura**
- Materializar en vez de vistas finas para lo que consume el tablero (las `vw_*`
  actuales no precalculan nada; solo acotan años).
- Denormalizar nombres en el resumen para matar los joins snowflake de producto.
- Reservar slots estables o autoscaling para `lakehouse-dev`: hoy la reserva es
  chica/variable y castiga la concurrencia de tiles. Es la causa no-codigo mas
  grande de latencia.
- **BI Engine**: una reserva chica (1-2 GB) sobre las tablas `agg_*` puede dar
  respuestas sub-segundo cacheadas para el tablero.
- Nunca `COUNT(DISTINCT)` sobre STRING; siempre INT64 o sketch HLL.
- Confirmar clustering de los hechos base por `id_sucursal`, `cd_sku` (remitos ya
  esta clusterizado; ventas conviene revisarlo).

**Looker**
- El cache diario (`venta_integral_datagroup`, 24h) ya esta bien; asegurar que la
  reconstruccion de las tablas `agg_*` dispare con el mismo trigger para que el
  cache sirva datos frescos.
- Filtro Fecha con un rango por defecto acotado (ej. mes en curso) para que ningun
  tile escanee toda la historia al abrir.
- Reducir la cantidad de tiles simultaneos por pestaña o usar Merge Results donde
  se pueda, para bajar la concurrencia de queries.
- Mantener las medidas derivadas (`margen_pct`, `ticket_promedio`, YoY) como
  calculos sobre sumas ya agregadas; son baratas y no conviene materializarlas.

## 5. Orden sugerido de implementacion

1. Denormalizar flags `flg_esventa` / `flg_restastock` y claves numericas
   `nk_ticket` / `nk_remito` en los hechos (items #1, #2, #3). Ganancia inmediata
   sin rearmar el modelo.
2. Construir `agg_venta_integral_diario` + `agg_remitos_diario` con HLL (items #4,
   #5, #8). Es el salto grande de performance.
3. Conectar Looker via aggregate awareness o apuntando los views a las `agg_*`.
4. Ajustes finos: BI Engine, reserva de slots, rango por defecto del filtro Fecha.
