# Bin formula

Uses the rlang package to build the formula needed to create the bins of
a numeric variable in an unevaluated fashion. This way, the formula can
be then passed inside a dplyr verb.

## Usage

``` r
db_bin(var, bins = 30, binwidth = NULL)
```

## Arguments

- var:

  Variable name or formula

- bins:

  Number of bins. Defaults to 30.

- binwidth:

  Fixed width for each bin, in the same units as the data. Overrides
  bins when specified

## Value

An unevaluated expression (rlang quosure) that calculates bin membership
for the specified variable. This expression is designed to be used
within dplyr verbs using the \`!!\` operator.

## Examples

``` r
# \dontrun{
library(DBI)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Important: Always name the field and
# prefix the function with `!!` (See Details)

# Uses the default 30 bins
db_mtcars |>
  group_by(x = !!db_bin(mpg)) |>
  count()
#> # Source:   SQL [?? x 2]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.14.0-1017-azure:R 4.5.3/:memory:]
#> # Groups:   x
#>        x     n
#>    <dbl> <dbl>
#>  1  22.2     2
#>  2  23.7     1
#>  3  15.9     1
#>  4  32.3     1
#>  5  33.1     1
#>  6  20.6     2
#>  7  13.5     1
#>  8  16.7     1
#>  9  30.0     2
#> 10  21.4     3
#> 11  12.8     1
#> 12  25.3     1
#> 13  18.2     1
#> 14  17.4     2
#> 15  19.0     3
#> 16  15.1     4
#> 17  10.4     2
#> 18  14.3     2
#> 19  26.8     1

# Uses binwidth which overrides bins
db_mtcars |>
  group_by(x = !!db_bin(mpg, binwidth = 10)) |>
  count()
#> # Source:   SQL [?? x 2]
#> # Database: DuckDB 1.4.4 [unknown@Linux 6.14.0-1017-azure:R 4.5.3/:memory:]
#> # Groups:   x
#>       x     n
#>   <dbl> <dbl>
#> 1  10.4    18
#> 2  20.4    14

dbDisconnect(con)
# }
```
