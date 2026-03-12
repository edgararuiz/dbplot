# Aggregates intersections of two variables

To visualize two continuous variables, we typically resort to a Scatter
plot. However, this may not be practical when visualizing millions or
billions of dots representing the intersections of the two variables. A
Raster plot may be a better option, because it concentrates the
intersections into squares that are easier to parse visually.

Uses dplyr operations to aggregate data. Because of this approach, the
calculations automatically run inside the database if \`data\` has a
database or sparklyr connection. The \`class()\` of such tables in R
are: tbl_sql, tbl_dbi, tbl_spark

## Usage

``` r
db_compute_raster(data, x, y, fill = n(), resolution = 100, complete = FALSE)

db_compute_raster2(data, x, y, fill = n(), resolution = 100, complete = FALSE)
```

## Arguments

- data:

  A table (tbl)

- x:

  A continuous variable

- y:

  A continuous variable

- fill:

  The aggregation formula. Defaults to count (n)

- resolution:

  The number of bins created per variable. The higher the number, the
  more records will be imported from the source

- complete:

  Uses tidyr::complete to include empty bins. Inserts value of 0.

## Details

There are two considerations when using a Raster plot with a database.
Both considerations are related to the size of the results downloaded
from the database:

\- The number of bins requested: The higher the bins value is, the more
data is downloaded from the database.

\- How concentrated the data is: This refers to how many intersections
return a value. The more intersections without a value, the less data is
downloaded from the database.

## Examples

``` r


# Returns a 100x100 grid of record count of intersections of eruptions and waiting
faithful |>
  db_compute_raster(eruptions, waiting)
#> # A tibble: 246 × 3
#>    eruptions waiting `n()`
#>        <dbl>   <dbl> <dbl>
#>  1      1.6     51.5     1
#>  2      1.64    63.7     1
#>  3      1.67    58.9     1
#>  4      1.70    53.6     1
#>  5      1.74    46.7     2
#>  6      1.74    47.8     1
#>  7      1.74    53.6     1
#>  8      1.74    57.8     1
#>  9      1.74    61.6     1
#> 10      1.78    45.6     1
#> # ℹ 236 more rows

# Returns a 50x50 grid of eruption averages of intersections of eruptions and waiting
faithful |>
  db_compute_raster(eruptions, waiting, fill = mean(eruptions), resolution = 50)
#> # A tibble: 220 × 3
#>    eruptions waiting `mean(eruptions)`
#>        <dbl>   <dbl>             <dbl>
#>  1      1.6     51.5              1.6 
#>  2      1.6     63.1              1.67
#>  3      1.67    53.6              1.73
#>  4      1.67    58.9              1.7 
#>  5      1.74    45.1              1.78
#>  6      1.74    46.2              1.75
#>  7      1.74    47.2              1.75
#>  8      1.74    50.4              1.8 
#>  9      1.74    51.5              1.78
#> 10      1.74    52.5              1.8 
#> # ℹ 210 more rows
```
