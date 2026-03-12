# Histogram

Uses dplyr operations to aggregate data and then \`ggplot2\` to create
the histogram. Because of this approach, the calculations automatically
run inside the database if \`data\` has a database or sparklyr
connection. The \`class()\` of such tables in R are: tbl_sql, tbl_dbi,
tbl_spark

## Usage

``` r
dbplot_histogram(data, x, bins = 30, binwidth = NULL)
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

[`dbplot_bar`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_bar.md),
[`dbplot_line`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_line.md)
,
[`dbplot_raster`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_raster.md)

## Examples

``` r
library(ggplot2)
library(dplyr)

# A ggplot histogram with 30 bins
mtcars |>
  dbplot_histogram(mpg)


# A ggplot histogram with bins of size 10
mtcars |>
  dbplot_histogram(mpg, binwidth = 10)
```
