# Returns a dataframe with boxplot calculations

Uses dplyr operations to create boxplot calculations. Because of this
approach, the calculations automatically run inside the database if
\`data\` has a database or sparklyr connection. The \`class()\` of such
tables in R are: tbl_sql, tbl_dbi, tbl_spark

Requires database support for percentile/quantile functions. Confirmed
to work with:

- DuckDB (recommended for local examples) - uses quantile()

- Spark/Hive (via sparklyr) - uses percentile_approx()

- SQL Server (2012+) - uses PERCENTILE_CONT()

- PostgreSQL (9.4+) - uses percentile_cont()

- Oracle (9i+) - uses PERCENTILE_CONT()

Does NOT work with SQLite, MySQL \< 8.0, or MariaDB (no percentile
support).

Note that this function supports input tbl that already contains
grouping variables. This can be useful when creating faceted boxplots.

## Usage

``` r
db_compute_boxplot(data, x, var, coef = 1.5)
```

## Arguments

- data:

  A table (tbl) that can already contain grouping variables

- x:

  A discrete variable in which to group the boxplots

- var:

  A continuous variable

- coef:

  Length of the whiskers as multiple of IQR. Defaults to 1.5

## Examples

``` r
# \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

db_mtcars |>
  db_compute_boxplot(am, mpg)
#> # A tibble: 2 × 12
#>      am     n lower middle upper max_raw min_raw   iqr min_iqr max_iqr  ymax
#>   <dbl> <dbl> <dbl>  <dbl> <dbl>   <dbl>   <dbl> <dbl>   <dbl>   <dbl> <dbl>
#> 1     0    19  15.0   17.3  19.2    24.4    10.4  6.38    8.57    25.6  24.4
#> 2     1    13  21     22.8  30.4    33.9    15   14.1     6.9     44.5  33.9
#> # ℹ 1 more variable: ymin <dbl>

dbDisconnect(con)
# }
```
