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
if (FALSE) { # \dontrun{
library(DBI)
library(dplyr)
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_mtcars <- copy_to(con, mtcars, "mtcars")

# Important: Always name the field and
# prefix the function with `!!` (See Details)

# Uses the default 30 bins
db_mtcars |>
  group_by(x = !!db_bin(mpg)) |>
  count()

# Uses binwidth which overrides bins
db_mtcars |>
  group_by(x = !!db_bin(mpg, binwidth = 10)) |>
  count()

dbDisconnect(con)
} # }
```
