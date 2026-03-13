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
# \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Returns record count for 30 bins in mpg
db_mtcars |>
  db_compute_bins(mpg)
#> # A tibble: 19 × 2
#>      mpg count
#>    <dbl> <dbl>
#>  1  21.4     3
#>  2  12.8     1
#>  3  25.3     1
#>  4  22.2     2
#>  5  23.7     1
#>  6  15.9     1
#>  7  32.3     1
#>  8  33.1     1
#>  9  18.2     1
#> 10  17.4     2
#> 11  19.0     3
#> 12  15.1     4
#> 13  10.4     2
#> 14  14.3     2
#> 15  26.8     1
#> 16  20.6     2
#> 17  13.5     1
#> 18  16.7     1
#> 19  30.0     2

# Returns record count for bins of size 10
db_mtcars |>
  db_compute_bins(mpg, binwidth = 10)
#> # A tibble: 2 × 2
#>     mpg count
#>   <dbl> <dbl>
#> 1  20.4    14
#> 2  10.4    18

dbDisconnect(con)
# }
```
