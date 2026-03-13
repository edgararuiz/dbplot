# Changelog

## dbplot 0.4.0

### Breaking Changes

- Package no longer re-exports the `%>%` pipe operator. Users should use
  R’s native `|>` pipe (available in R \>= 4.1.0) or load magrittr
  explicitly if they prefer `%>%`.
- Minimum R version increased from 3.1 to 4.1.0

### Improvements

#### Dependencies and Infrastructure

- Updated all package dependencies to modern versions:
  - dplyr \>= 1.0.0 (was \>= 0.7)
  - rlang \>= 1.0.0 (was \>= 0.3)
  - ggplot2 \>= 3.3.0 (was unversioned)
  - dbplyr \>= 2.0.0 (was \>= 1.4.0)
  - testthat \>= 3.0.0 (was unversioned)
- Removed magrittr dependency (using native pipe)
- Migrated CI from Travis CI to GitHub Actions with multi-platform
  testing (macOS, Windows, Ubuntu with R devel/release/oldrel)
- Added automated test coverage reporting via codecov
- Added pkgdown site deployment automation

#### Code Quality

- All examples now use native pipe `|>` instead of `%>%`
- Fixed typos in code and documentation
- Improved S3 method exports using modern roxygen2 patterns
- Consolidated
  [`globalVariables()`](https://rdrr.io/r/utils/globalVariables.html)
  declarations for better maintainability
- Added input validation for bins, binwidth, and resolution parameters
- Modernized test suite to use testthat 3e patterns

#### Documentation

- Examples now use DuckDB instead of SQLite for better performance and
  boxplot support. DuckDB’s native quantile() function enables complete
  database workflow demonstrations including boxplot examples
- Added comprehensive package-level documentation
- Updated all URLs to current Posit documentation sites
- Added CODE_OF_CONDUCT.md and CONTRIBUTING.md
- Enhanced pkgdown site with Bootstrap 5 theme and improved organization

## dbplot 0.3.3

CRAN release: 2020-02-07

- Exports the pipe operator

- Adds missing examples

- Example in README now uses SQLite
  ([\#17](https://github.com/edgararuiz/dbplot/issues/17))

- Adds support for
  [`vars()`](https://ggplot2.tidyverse.org/reference/vars.html) in the
  `x` argument in
  [`db_compute_boxplot()`](https://edgararuiz.github.io/dbplot/reference/db_compute_boxplot.md)
  ([\#27](https://github.com/edgararuiz/dbplot/issues/27))

- Expands support for `db_compute_boxplot` to `dbplyr` backends
  ([\#23](https://github.com/edgararuiz/dbplot/issues/23)
  [@mkirzon](https://github.com/mkirzon))

- `db_compute_boxplot` can now return boxplots for `tbl` objects with
  existing grouping (eg useful for facetted boxplots)
  ([\#23](https://github.com/edgararuiz/dbplot/issues/23)
  [@mkirzon](https://github.com/mkirzon))

## dbplot 0.3.2

CRAN release: 2019-07-02

- Addresses issue of `'symbol' is not subsettable`
  ([\#24](https://github.com/edgararuiz/dbplot/issues/24))

## dbplot 0.3.1

CRAN release: 2019-03-03

- New
  [`db_compute_raster2()`](https://edgararuiz.github.io/dbplot/reference/db_compute_raster.md)
  function includes upper limit

- Removes dependencies on pipes

- Improves compliance with rlangs
  [`quo()`](https://rlang.r-lib.org/reference/defusing-advanced.html) vs
  [`expr()`](https://rlang.r-lib.org/reference/expr.html) usage rules

- Separates Spark and default behaivor of
  [`db_compute_boxplot()`](https://edgararuiz.github.io/dbplot/reference/db_compute_boxplot.md)
  and adds tests

## dbplot 0.3.0

CRAN release: 2018-05-06

- Supports multiple aggregations for bar and line charts

- Supports naming aggregations for bar and line charts

## dbplot 0.2.1

CRAN release: 2018-03-11

- Adds compatability with rlang 0.2.0 upgrade

- Improves dependency management

## dbplot 0.2.0

CRAN release: 2018-01-05

### Bug Fixes

- Adds compatability with dbplyr 1.2.0 upgrade

- Adds `complete` argument to
  [`db_compute_raster()`](https://edgararuiz.github.io/dbplot/reference/db_compute_raster.md)
  and
  [`dbplot_raster()`](https://edgararuiz.github.io/dbplot/reference/dbplot_raster.md)
  which fills in empty bins
  ([\#5](https://github.com/edgararuiz/dbplot/issues/5))

- Coerce aggregate results using
  [`as.numeric()`](https://rdrr.io/r/base/numeric.html) to handle
  `integer64` results
  ([\#6](https://github.com/edgararuiz/dbplot/issues/6))

- `compute` functions now return an ungrouped `data.frame`

## dbplot 0.1.1

CRAN release: 2017-11-27

### Bug Fixes

- Fixed `unused argument (na.rm = TRUE)` message when used with the CRAN
  version of `dbplyr`
  ([\#3](https://github.com/edgararuiz/dbplot/issues/3))
