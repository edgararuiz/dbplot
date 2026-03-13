# Calculate histogram bins

Uses dplyr operations to create histogram bins. Because of this
approach, the calculations automatically run inside the database if
\`data\` has a database or sparklyr connection. The \`class()\` of such
tables in R are: tbl_sql, tbl_dbi, tbl_spark

## Usage

``` r
db_compute_bins(data, x, bins = 30, binwidth = NULL)
```

## Arguments

- data:

  A table (tbl)

- x:

  A continuous variable

- bins:

  Number of bins. Defaults to 30.

- binwidth:

  Fixed width for each bin, in the same units as the data. Overrides
  bins when specified

## See also

[`db_bin`](https://edgararuiz.github.io/dbplot/reference/db_bin.md),

## Examples

``` r
if (FALSE) { # \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Returns record count for 30 bins in mpg
db_mtcars |>
  db_compute_bins(mpg)

# Returns record count for bins of size 10
db_mtcars |>
  db_compute_bins(mpg, binwidth = 10)

dbDisconnect(con)
} # }
```
