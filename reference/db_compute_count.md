# Aggregates over a discrete field

Uses dplyr operations to aggregate data. Because of this approach, the
calculations automatically run inside the database if \`data\` has a
database or sparklyr connection. The \`class()\` of such tables in R
are: tbl_sql, tbl_dbi, tbl_spark

## Usage

``` r
db_compute_count(data, x, ..., y = n())
```

## Arguments

- data:

  A table (tbl)

- x:

  A discrete variable

- ...:

  A set of named or unnamed aggregations

- y:

  The aggregation formula. Defaults to count (n)

## Value

An ungrouped data.frame with the discrete variable and one or more
aggregation columns. The first column is the grouping variable (x),
followed by the aggregated values.

## Examples

``` r
# \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Returns the row count per am
db_mtcars |>
  db_compute_count(am)
#> # A tibble: 2 × 2
#>      am `n()`
#>   <dbl> <dbl>
#> 1     0    19
#> 2     1    13

# Returns the average mpg per am
db_mtcars |>
  db_compute_count(am, mean(mpg))
#> Warning: Missing values are always removed in SQL aggregation functions.
#> Use `na.rm = TRUE` to silence this warning
#> This warning is displayed once every 8 hours.
#> # A tibble: 2 × 2
#>      am `mean(mpg)`
#>   <dbl>       <dbl>
#> 1     0        17.1
#> 2     1        24.4

# Returns the average and sum of mpg per am
db_mtcars |>
  db_compute_count(am, mean(mpg), sum(mpg))
#> # A tibble: 2 × 3
#>      am `mean(mpg)` `sum(mpg)`
#>   <dbl>       <dbl>      <dbl>
#> 1     0        17.1       326.
#> 2     1        24.4       317.

dbDisconnect(con)
# }
```
