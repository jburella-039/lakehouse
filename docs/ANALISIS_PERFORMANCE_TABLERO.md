# Analisis de performance - Tablero Venta Integral

## 1. drill_fields en Fact Ventas

No afecta la performance de carga del tablero. drill_fields solo dispara una query cuando el usuario hace clic para drillear sobre venta_neta; no se ejecuta al renderizar el tile.

## 2. Stock en el tablero

No. El dashboard venta_integral tiene 5 tabs (Home, Ventas, Tickets, Unidades, Remitos) y ningun tile usa el explore fct_stock. La vista y el explore de stock existen en el modelo pero no los consume este tablero.

## 3. Performance Stock vs Ventas vs Remitos (costo de queries)

| Hecho | En el tablero | Costo por tile | Por que |
|---|---|---|---|
| Ventas | Si, ~4 tabs (Home/Ventas/Tickets/Unidades) | 2134 ms / 15.75 GB (metrica $ Ventas) | Tabla mas grande (linea de comprobante), COUNT(DISTINCT ticket_key) sobre STRING, join obligado a dim_tipocomprobante en todos los measures, mas la mayor concurrencia de tiles simultaneos |
| Remitos | Si, 1 tab | 9430 ms / 2.73 GB (metrica Venta Remitos $) | Subconjunto farmacia (menos filas), mismo COUNT(DISTINCT remito_key) STRING y mismos joins, pero muchos menos tiles |
| Stock | No | N/A (no esta en el tablero) | Snapshot diario (392 suc x SKU x dias); subquery correlacionado sin pruning; COUNT(DISTINCT cd_sku) |

## 4. Que llevar a BigQuery (ticket_key / remito_key)

En la fuente original el conteo de tickets se arma asi: id_ventaunica viene NULL en la fct, por eso se usa una key interina por combinacion id_sucursal|id_caja|id_tipocomprobante|cd_nrocomprobante|fec_dia|id_nroapertura. Cuando se pueble id_ventaunica, el measure ya la prioriza via COALESCE. Esa combinacion la tenemos igual en el ticket_key actual de Looker.

| | Como esta hoy en Looker | Como deberia estar en BigQuery |
|---|---|---|
| Fact Ventas (ticket_key) | COALESCE(CAST(id_ventaunica AS STRING), CONCAT(id_sucursal, id_caja, id_tipocomprobante, cd_nrocomprobante, YYYYMMDD(fec_dia), id_nroapertura)) | Poblar id_ventaunica como columna INT64 en la fct (replica exacto el DISTINCTCOUNT(Id Venta) de la fuente y el distinct queda sobre entero). Plan B, si no se puede poblar: nk_ticket = FARM_FINGERPRINT(mismo concat) como columna fisica INT64 |
| Fact Remitos (remito_key) | CONCAT(id_sucursal, YYYYMMDD(fec_dia), id_nroremito) | No hay columna unica equivalente (la fuente lo arma como COUNTROWS(SUMMARIZE por Fecha+Sucursal+NroRemito)), por lo que nk_remito = FARM_FINGERPRINT(id_sucursal, fec_dia, id_nroremito) como columna fisica INT64 |

## 5. Cruces con dimensiones

La lentitud no viene de "muchos cruces entre dimensiones" (son chicas y broadcast). Viene de (a) el join universal a dim_tipocomprobante por los flags embebidos, y (b) el COUNT(DISTINCT) sobre string, ambos ya priorizados en el plan.

### Posible mejora

Denormalizar los flags es_venta y resta_stock como columnas fisicas (flg_esventa, flg_restastock) dentro de las fct de Ventas y Remitos, resueltos en el build del ETL. Hoy esos flags viven en dim_tipocomprobante y como los measures base los llevan embebidos en sus filtros, el join a dim_tipocomprobante se agrega en el 100% de los tiles, incluso en uno tan simple como "Ventas por dia". Al tener los flags en el propio hecho, ese join desaparece de todas las queries del tablero y los measures pasan a filtrar por una columna local. Es el cruce de mayor redito porque es el unico join que esta presente en todos los tiles.
