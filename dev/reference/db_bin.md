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

## Examples

``` r
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

# Important: Always name the field and
# prefix the function with `!!` (See Details)

# Uses the default 30 bins
mtcars |>
  group_by(x = !!db_bin(mpg)) |>
  count()
#> # A tibble: 19 × 2
#> # Groups:   x [19]
#>        x     n
#>    <dbl> <int>
#>  1  10.4     2
#>  2  12.8     1
#>  3  13.5     1
#>  4  14.3     2
#>  5  15.1     4
#>  6  15.9     1
#>  7  16.7     1
#>  8  17.4     2
#>  9  18.2     1
#> 10  19.0     3
#> 11  20.6     2
#> 12  21.4     3
#> 13  22.2     2
#> 14  23.7     1
#> 15  25.3     1
#> 16  26.8     1
#> 17  30.0     2
#> 18  32.3     1
#> 19  33.1     1

# Uses binwidth which overrides bins
mtcars |>
  group_by(x = !!db_bin(mpg, binwidth = 10)) |>
  count()
#> # A tibble: 2 × 2
#> # Groups:   x [2]
#>       x     n
#>   <dbl> <int>
#> 1  10.4    18
#> 2  20.4    14
```
