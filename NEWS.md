# dbplot 0.4.0

## Breaking Changes

* Package no longer re-exports the `%>%` pipe operator. Users should use R's
  native `|>` pipe (available in R >= 4.1.0) or load magrittr explicitly if
  they prefer `%>%`.
* Minimum R version increased from 3.1 to 4.1.0

## Improvements

### Dependencies and Infrastructure
* Updated all package dependencies to modern versions:
  - dplyr >= 1.0.0 (was >= 0.7)
  - rlang >= 1.0.0 (was >= 0.3)
  - ggplot2 >= 3.3.0 (was unversioned)
  - dbplyr >= 2.0.0 (was >= 1.4.0)
  - testthat >= 3.0.0 (was unversioned)
* Removed magrittr dependency (using native pipe)
* Migrated CI from Travis CI to GitHub Actions with multi-platform testing
  (macOS, Windows, Ubuntu with R devel/release/oldrel)
* Added automated test coverage reporting via codecov
* Added pkgdown site deployment automation

### Code Quality
* All examples now use native pipe `|>` instead of `%>%`
* Fixed typos in code and documentation
* Improved S3 method exports using modern roxygen2 patterns
* Consolidated `globalVariables()` declarations for better maintainability
* Added input validation for bins, binwidth, and resolution parameters
* Modernized test suite to use testthat 3e patterns

### Documentation
* Examples now use DuckDB instead of SQLite for better performance and boxplot
  support. DuckDB's native quantile() function enables complete database workflow
  demonstrations including boxplot examples
* Added comprehensive package-level documentation
* Updated all URLs to current Posit documentation sites
* Added CODE_OF_CONDUCT.md and CONTRIBUTING.md
* Enhanced pkgdown site with Bootstrap 5 theme and improved organization


# dbplot 0.3.3

- Exports the pipe operator

- Adds missing examples

- Example in README now uses SQLite (#17)

- Adds support for `vars()` in the `x` argument in `db_compute_boxplot()` (#27)

- Expands support for `db_compute_boxplot` to `dbplyr` backends (#23 @mkirzon)

- `db_compute_boxplot` can now return boxplots for `tbl` objects with existing grouping (eg useful for facetted boxplots) (#23 @mkirzon)

# dbplot 0.3.2

- Addresses issue of `'symbol' is not subsettable` (#24)

# dbplot 0.3.1

- New `db_compute_raster2()` function includes upper limit

- Removes dependencies on pipes

- Improves compliance with rlangs `quo()` vs `expr()` usage rules

- Separates Spark and default behaivor of `db_compute_boxplot()` and adds tests

# dbplot 0.3.0

- Supports multiple aggregations for bar and line charts

- Supports naming aggregations for bar and line charts

# dbplot 0.2.1

- Adds compatability with rlang 0.2.0 upgrade

- Improves dependency management

# dbplot 0.2.0

## Bug Fixes

- Adds compatability with dbplyr 1.2.0 upgrade

- Adds `complete` argument to `db_compute_raster()` and `dbplot_raster()` which fills in empty bins (#5)

- Coerce aggregate results using `as.numeric()` to handle `integer64` results (#6)

- `compute` functions now return an ungrouped `data.frame`

# dbplot 0.1.1

## Bug Fixes

- Fixed `unused argument (na.rm = TRUE)` message when used with the CRAN version of `dbplyr` (#3)
