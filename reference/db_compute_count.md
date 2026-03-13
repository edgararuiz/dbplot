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

## Examples

``` r
if (FALSE) { # \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Returns the row count per am
db_mtcars |>
  db_compute_count(am)

# Returns the average mpg per am
db_mtcars |>
  db_compute_count(am, mean(mpg))

# Returns the average and sum of mpg per am
db_mtcars |>
  db_compute_count(am, mean(mpg), sum(mpg))

dbDisconnect(con)
} # }
```
