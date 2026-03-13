# Boxplot

Uses dplyr operations to aggregate data and then \`ggplot2\` to create
the boxplot. Because of this approach, the calculations automatically
run inside the database if \`data\` has a database or sparklyr
connection. The \`class()\` of such tables in R are: tbl_sql, tbl_dbi,
tbl_spark

Requires database support for percentile/quantile functions. See
[`db_compute_boxplot`](https://edgararuiz.github.io/dbplot/reference/db_compute_boxplot.md)
for supported database backends.

## Usage

``` r
dbplot_boxplot(data, x, var, coef = 1.5)
```

## Arguments

- data:

  A table (tbl)

- x:

  A discrete variable in which to group the boxplots

- var:

  A continuous variable

- coef:

  Length of the whiskers as multiple of IQR. Defaults to 1.5

## See also

[`dbplot_bar`](https://edgararuiz.github.io/dbplot/reference/dbplot_bar.md),
[`dbplot_line`](https://edgararuiz.github.io/dbplot/reference/dbplot_line.md)
,
[`dbplot_raster`](https://edgararuiz.github.io/dbplot/reference/dbplot_raster.md),
[`dbplot_histogram`](https://edgararuiz.github.io/dbplot/reference/dbplot_histogram.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(DBI)
library(dplyr)
library(ggplot2)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

db_mtcars |>
  dbplot_boxplot(am, mpg)

dbDisconnect(con)
} # }
```
