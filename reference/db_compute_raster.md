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

## Value

An ungrouped data.frame with three columns: the x variable bins, the y
variable bins, and the aggregated fill values for each x-y intersection.

For \`db_compute_raster2\`: A data.frame with five columns - the x and y
variable bins, the fill values, and additional columns for the upper
bounds of each bin (x_2 and y_2), useful for defining precise tile
boundaries.

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
# \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_faithful <- copy_to(con, faithful, "faithful")

# Returns a 100x100 grid of record count of intersections of eruptions and waiting
db_faithful |>
  db_compute_raster(eruptions, waiting)
#> # A tibble: 246 × 3
#>    eruptions waiting `n()`
#>        <dbl>   <dbl> <dbl>
#>  1      3.60    78.5     1
#>  2      4.68    87.5     1
#>  3      3.60    84.9     1
#>  4      1.92    51.0     1
#>  5      4.33    84.9     1
#>  6      1.74    46.7     2
#>  7      4.68    82.8     1
#>  8      1.74    61.6     1
#>  9      1.95    54.7     1
#> 10      4.05    75.9     1
#> # ℹ 236 more rows

# Returns a 50x50 grid of eruption averages of intersections of eruptions and waiting
db_faithful |>
  db_compute_raster(eruptions, waiting, fill = mean(eruptions), resolution = 50)
#> # A tibble: 220 × 3
#>    eruptions waiting `mean(eruptions)`
#>        <dbl>   <dbl>             <dbl>
#>  1      2.23    61.0              2.28
#>  2      4.68    87.5              4.7 
#>  3      1.74    61.0              1.75
#>  4      4.75    83.3              4.8 
#>  5      4.47    73.7              4.53
#>  6      1.95    54.7              1.98
#>  7      4.05    75.9              4.08
#>  8      4.4     78.0              4.43
#>  9      4.33    79.0              4.35
#> 10      4.54    83.3              4.57
#> # ℹ 210 more rows

dbDisconnect(con)
# }
```
