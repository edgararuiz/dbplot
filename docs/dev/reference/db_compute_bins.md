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

[`db_bin`](https://edgararuiz.github.io/dbplot/dev/reference/db_bin.md),

## Examples

``` r

# Returns record count for 30 bins in mpg
mtcars |>
  db_compute_bins(mpg)
#>         mpg count
#> 1  10.40000     2
#> 2  12.75000     1
#> 3  13.53333     1
#> 4  14.31667     2
#> 5  15.10000     4
#> 6  15.88333     1
#> 7  16.66667     1
#> 8  17.45000     2
#> 9  18.23333     1
#> 10 19.01667     3
#> 11 20.58333     2
#> 12 21.36667     3
#> 13 22.15000     2
#> 14 23.71667     1
#> 15 25.28333     1
#> 16 26.85000     1
#> 17 29.98333     2
#> 18 32.33333     1
#> 19 33.11667     1

# Returns record count for bins of size 10
mtcars |>
  db_compute_bins(mpg, binwidth = 10)
#>    mpg count
#> 1 10.4    18
#> 2 20.4    14
```
