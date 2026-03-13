# Bar plot

Uses dplyr operations to aggregate data and then \`ggplot2\` to create
the plot. Because of this approach, the calculations automatically run
inside the database if \`data\` has a database or sparklyr connection.
The \`class()\` of such tables in R are: tbl_sql, tbl_dbi, tbl_spark

## Usage

``` r
dbplot_bar(data, x, ..., y = n())
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

## See also

[`dbplot_line`](https://edgararuiz.github.io/dbplot/reference/dbplot_line.md)
,
[`dbplot_histogram`](https://edgararuiz.github.io/dbplot/reference/dbplot_histogram.md),
[`dbplot_raster`](https://edgararuiz.github.io/dbplot/reference/dbplot_raster.md)

## Examples

``` r
if (FALSE) { # \dontrun{
library(DBI)
library(dplyr)
library(ggplot2)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Returns a plot of the row count per am
db_mtcars |>
  dbplot_bar(am)

# Returns a plot of the average mpg per am
db_mtcars |>
  dbplot_bar(am, mean(mpg))

# Returns the average and sum of mpg per am
db_mtcars |>
  dbplot_bar(am, avg_mpg = mean(mpg), sum_mpg = sum(mpg))

dbDisconnect(con)
} # }
```
