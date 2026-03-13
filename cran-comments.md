## Release summary

This is a major update (0.3.3 -> 0.4.0) that modernizes the package for current
R ecosystem standards. This release includes breaking changes related to minimum
R version requirements and pipe operator exports.

### Breaking Changes
* Minimum R version increased from 3.1 to 4.1.0
* No longer re-exports the `%>%` pipe operator (users should use native `|>` or
  load magrittr explicitly)

### Major Improvements
* Updated all dependencies to modern versions (dplyr >= 1.0.0, rlang >= 1.0.0, etc.)
* Migrated CI from Travis CI to GitHub Actions
* Modernized test suite to testthat 3e
* Enhanced documentation and examples (now using DuckDB instead of SQLite)
* Added community guidelines (CODE_OF_CONDUCT.md, CONTRIBUTING.md)

## Previous CRAN check issues

The issues reported at https://cran.r-project.org/web/checks/check_results_dbplot.html
have been addressed in this release:

* Updated deprecated dependency versions (dplyr, rlang, dbplyr) to modern versions
* Fixed compatibility with current R and tidyverse ecosystem
* All examples now run successfully on current R versions
* Package now passes R CMD check with 0 errors, 0 warnings, 0 notes

## Test environments

* Local: macOS 14.x (darwin), R 4.5.2
* GitHub Actions:
  - macOS-latest (release)
  - Windows-latest (release)
  - Ubuntu-latest (devel, release, oldrel-1)

## R CMD check results

0 errors ✓ | 0 warnings ✓ | 0 notes ✓

## Downstream dependencies

I have checked that there are no downstream dependencies for this package
(checked using `tools::package_dependencies(reverse = TRUE)`).
