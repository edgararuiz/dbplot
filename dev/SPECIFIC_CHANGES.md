# Specific Code Changes Required

This document lists the exact changes needed in each file, organized by
phase.

## Phase 1: Critical Infrastructure

### DESCRIPTION ✅ COMPLETED

**Issues**: Old dependency versions, old RoxygenNote

``` diff
 Package: dbplot
-Version: 0.3.3
+Version: 0.3.3.9000
 Title: Simplifies Plotting Data Inside Databases
 Description: Leverages 'dplyr' to process the calculations of a plot inside a database.
     This package provides helper functions that abstract the work at three levels:
     outputs a 'ggplot', outputs the calculations, outputs the formula
     needed to calculate bins.
 Authors@R:
     person("Edgar", "Ruiz", email = "edgararuiz@gmail.com", role = c("aut", "cre"))
 Depends:
-    R (>= 3.1)
+    R (>= 4.1.0)
 Imports:
-    dplyr (>= 0.7),
-    rlang (>= 0.3),
-    ggplot2,
+    dplyr (>= 1.0.0),
+    rlang (>= 1.0.0),
+    ggplot2 (>= 3.3.0),
-    purrr,
-    magrittr
+    purrr
 Suggests:
-    dbplyr (>= 1.4.0),
-    testthat,
+    dbplyr (>= 2.0.0),
+    testthat (>= 3.0.0),
     tidyr,
-    covr
+    covr,
+    lifecycle
 License: GPL-3
 URL: https://github.com/edgararuiz/dbplot
 BugReports: https://github.com/edgararuiz/dbplot/issues
-RoxygenNote: 7.0.2
+RoxygenNote: 7.3.2
 Encoding: UTF-8
```

### tests/testthat.R

**Current issues**: Missing edition specification

``` diff
 library(testthat)
 library(dbplot)

+# Use testthat 3rd edition
+testthat::local_edition(3)
+
 test_check("dbplot")
```

### tests/testthat/test-dbplots.R

**Current issues**: deprecated context(), expect_is()

``` diff
-context("dbplots")
-
 test_that("A ggplot2 object is returned", {
-  expect_is(dbplot_bar(mtcars, am), "ggplot")
-  expect_is(dbplot_bar(mtcars, am, mean(wt)), "ggplot")
-  expect_is(dbplot_line(mtcars, am), "ggplot")
-  expect_is(dbplot_histogram(mtcars, mpg), "ggplot")
-  expect_is(dbplot_raster(mtcars, wt, mpg), "ggplot")
+  expect_s3_class(dbplot_bar(mtcars, am), "ggplot")
+  expect_s3_class(dbplot_bar(mtcars, am, mean(wt)), "ggplot")
+  expect_s3_class(dbplot_line(mtcars, am), "ggplot")
+  expect_s3_class(dbplot_histogram(mtcars, mpg), "ggplot")
+  expect_s3_class(dbplot_raster(mtcars, wt, mpg), "ggplot")
 })

-test_that("A no warnings or errors are returned", {
+test_that("No warnings or errors are returned", {
   expect_silent(dbplot_bar(mtcars, am))
   expect_silent(dbplot_bar(mtcars, am, mean(wt)))
   expect_silent(dbplot_line(mtcars, am))
   expect_silent(dbplot_histogram(mtcars, mpg))
   expect_silent(dbplot_raster(mtcars, wt, mpg))
 })
```

### tests/testthat/test-boxplots.R

**Current issues**: deprecated context(), expect_is()

``` diff
-context("boxplots")
-
 test_that("dbplot_boxplot() returns a ggplot", {
-  expect_is(dbplot_boxplot(mtcars, am, mpg), "ggplot")
+  expect_s3_class(dbplot_boxplot(mtcars, am, mpg), "ggplot")
 })

 test_that("db_compute_boxplot() returns the right number of rows", {
   expect_equal(nrow(db_compute_boxplot(mtcars, am, mpg)), 2)
   expect_equal(nrow(db_compute_boxplot(group_by(mtcars, gear), am, mpg)), 4)
 })

 test_that("calc_boxplot_mssql() returns the right number of rows", {
   expect_equal(nrow(calc_boxplot_mssql(group_by(mtcars, am), expr(mpg))), 2)
   expect_equal(nrow(calc_boxplot_mssql(group_by(mtcars, am, gear), expr(mpg))), 4)
 })

 test_that("calc_boxplot_sparklyr() returns the right number of rows", {
   percentile_approx <<- function(x, ...) quantile(x, ...)
   expect_equal(nrow(calc_boxplot_sparklyr(group_by(mtcars, am), expr(mpg))), 2)
   expect_equal(nrow(calc_boxplot_sparklyr(group_by(mtcars, am, gear), expr(mpg))), 4)
 })
```

### tests/testthat/test-discrete.R

**Current issues**: deprecated context(), expect_is()

``` diff
-context("discrete")
-
 test_that("Multiple aggregations are supported", {
   expect_equal(
     ncol(db_compute_count(mtcars,
       am,
       sum_wt = sum(wt),
       sum_mpg = sum(mpg)
     )),
     3
   )
 })

 test_that("Multiple aggregations work with bar plots", {
   x <- dbplot_bar(mtcars,
     am,
     sum_wt = sum(wt), sum_mpg = sum(mpg)
   )
-  expect_is(x, "list")
-  expect_is(x[[1]], "ggplot")
+  expect_type(x, "list")
+  expect_s3_class(x[[1]], "ggplot")
 })

 test_that("Multiple aggregations work with line plots", {
   x <- dbplot_line(mtcars,
     am,
     sum_wt = sum(wt), sum_mpg = sum(mpg)
   )
-  expect_is(x, "list")
-  expect_is(x[[1]], "ggplot")
+  expect_type(x, "list")
+  expect_s3_class(x[[1]], "ggplot")
 })
```

### tests/testthat/test-raster.R

**Current issues**: deprecated context(), expect_is(), typos

``` diff
-context("raster")
-
 test_that("Setting the complete argument returns a ggplot", {
-  expect_is(dbplot_raster(mtcars, wt, mpg, complete = TRUE), "ggplot")
+  expect_s3_class(dbplot_raster(mtcars, wt, mpg, complete = TRUE), "ggplot")
 })


-test_that("The correct number of rows are returned when using complte", {
+test_that("The correct number of rows are returned when using complete", {
   expect_equal(
     nrow(db_compute_raster(mtcars, wt, mpg, complete = TRUE)),
     600
   )
   expect_equal(
     nrow(db_compute_raster(mtcars,
       wt, mpg,
       complete = TRUE,
       resolution = 10
     )),
     80
   )
 })

-test_that("Compute raster 2 returns the rignt number of rows", {
+test_that("Compute raster 2 returns the right number of rows", {
   expect_equal(
     nrow(db_compute_raster2(mtcars, wt, mpg, complete = TRUE)),
     600
   )
   expect_equal(
     nrow(db_compute_raster2(mtcars,
       wt, mpg,
       complete = TRUE,
       resolution = 10
     )),
     80
   )
 })
```

### tests/testthat/test-dbbin.R

**Current issues**: deprecated context()

``` diff
-context("db_bin")
-
 test_that(
   "Correct binwidth formula is returned",
   expect_equal(
     db_bin(var, binwidth = 10),
     rlang::expr((10 * ifelse(as.integer(floor((var - min(var, na.rm = TRUE)) / 10)) ==
       as.integer((max(var, na.rm = TRUE) - min(var, na.rm = TRUE)) / 10),
     as.integer(floor((var - min(var, na.rm = TRUE)) / 10)) - 1,
     as.integer(floor((var - min(var, na.rm = TRUE)) / 10))
     )) +
       min(var, na.rm = TRUE))
   )
 )

 test_that(
   "No error or warning when translated to SQL",
   expect_silent(
     dbplyr::translate_sql(!!db_bin(field), con = dbplyr::simulate_dbi())
   )
 )
```

## Necessary Code Quality Improvements (Phase 1)

### Pipe Migration

#### R/utils-pipe.R

**Action**: DELETE this file entirely

The package no longer re-exports `%>%`. Users should use R’s native `|>`
pipe (available in R \>= 4.1.0) or load magrittr themselves.

#### All .R files with examples

**Pattern to replace**: `%>%` → `|>`

Examples will need updates in: - `R/histogram.R` - `R/boxplot.R` -
`R/raster.R` - `R/discrete.R` - `R/dbbin.R`

Example changes:

``` diff
 #' # Returns record count for 30 bins in mpg
-#' mtcars %>%
+#' mtcars |>
 #'   db_compute_bins(mpg)
```

#### README.md (Phase 3 - will update with badges)

**Pattern to replace**: `%>%` → `|>`

Approximately 20+ instances throughout the README. Example:

``` diff
-db_flights %>%
+db_flights |>
   dbplot_histogram(distance)
```

### Typo Fixes

#### tests/testthat/test-raster.R

``` diff
-test_that("The correct number of rows are returned when using complte", {
+test_that("The correct number of rows are returned when using complete", {

-test_that("Compute raster 2 returns the rignt number of rows", {
+test_that("Compute raster 2 returns the right number of rows", {
```

#### R/raster.R

``` diff
 #' @param resolution The number of bins created by variable. The highest the number, the more records
-#' can be potentially imported from the sourd
+#' can be potentially imported from the source
```

### NEWS.md Breaking Changes Entry

Add to NEWS.md:

``` markdown
# dbplot 0.4.0

## Breaking Changes

* Package no longer re-exports the `%>%` pipe operator. Users should use R's
  native `|>` pipe (available in R >= 4.1.0) or load magrittr explicitly if
  they prefer `%>%`.

## Improvements

* Updated minimum R version to 4.1.0
* Updated all package dependencies to modern versions (dplyr >= 1.0.0, rlang >= 1.0.0)
* Added cli package for better error messages
* All examples now use native pipe `|>` instead of `%>%`
* Fixed typos in code and documentation
```

## Phase 2: Code Quality

### Code Consistency

### R/dbplot.R

**Current issues**: Should consolidate all globalVariables here

``` diff
 #' @import rlang
 #' @import ggplot2
 #' @importFrom purrr imap
 #' @importFrom dplyr mutate summarise
 #' @importFrom dplyr group_by count pull
 #' @importFrom dplyr ungroup collect rename
 #' @importFrom dplyr select n tibble distinct
 #' @importFrom stats quantile
 #' @keywords internal
-utils::globalVariables(c("."))
+
+# Consolidated globalVariables declarations
+utils::globalVariables(c(
+  ".",
+  "aes",
+  "count",
+  "fill",
+  "iqr",
+  "labs",
+  "lower",
+  "max_iqr",
+  "max_raw",
+  "middle",
+  "min_iqr",
+  "min_raw",
+  "n",
+  "percentile_approx",
+  "upper",
+  "w",
+  "weight",
+  "x",
+  "x_",
+  "y",
+  "ymax",
+  "ymin"
+))
```

### R/histogram.R

**Current issues**: Duplicate globalVariables, inconsistent quosure
handling

``` diff
 #' @export
 dbplot_histogram <- function(data, x, bins = 30, binwidth = NULL) {
-  x <- enexpr(x)
+  x <- enquo(x)

   df <- db_compute_bins(
     data = data,
     x = !!x,
     bins = bins,
     binwidth = binwidth
   )
   df <- mutate(
     df,
     x = !!x
   )

   ggplot(df) +
     geom_col(aes(x, count)) +
     labs(
       x = quo_name(x),
       y = "count"
     )
 }
-
-globalVariables(c("w", "labs"))
```

### R/boxplot.R

**Current issues**: Large globalVariables block, should be moved

``` diff
 #' @export
 #'
 #' mtcars %>%
 #'   dbplot_boxplot(am, mpg)
 #'
 dbplot_boxplot <- function(data, x, var, coef = 1.5) {
   x <- enquo(x)
   var <- enquo(var)

   df <- db_compute_boxplot(
     data = data,
     x = !!x,
     var = !!var,
     coef = coef
   )

   colnames(df) <- c(
     "x",
     "n",
     "lower",
     "middle",
     "upper",
     "max_raw",
     "min_raw",
     "iqr",
     "min_iqr",
     "max_iqr",
     "ymax",
     "ymin"
   )

   ggplot(df) +
     geom_boxplot(
       aes(
         x = x,
         ymin = ymin,
         lower = lower,
         middle = middle,
         upper = upper,
         ymax = ymax,
         group = x
       ),
       stat = "identity"
     ) +
     labs(x = x)
 }
-
-globalVariables(c(
-  "upper",
-  "ymax",
-  "weight",
-  "x_",
-  "y",
-  "aes",
-  "ymin",
-  "lower",
-  "middle",
-  "upper",
-  "iqr",
-  "max_raw",
-  "max_iqr",
-  "min_raw",
-  "min_iqr",
-  "percentile_approx"
-))
```

### R/discrete.R

**Current issues**: Wrong title in documentation

``` diff
-#' Bar plot
+#' Line plot
 #'
 #' @description
 #'
 #' Uses very generic dplyr code to aggregate data and then `ggplot2`
 #' to create a line plot.  Because of this approach,
```

## Phase 3: Documentation & Testing

### README.md

**Current issues**: Old badges, deprecated URLs, uses %\>% pipe

``` diff
 # dbplot <img src="man/figures/logo.png" align="right" alt="" width="220" />

-[![Build
-Status](https://travis-ci.org/edgararuiz/dbplot.svg?branch=master)](https://travis-ci.org/edgararuiz/dbplot)
+[![R-CMD-check](https://github.com/edgararuiz/dbplot/workflows/R-CMD-check/badge.svg)](https://github.com/edgararuiz/dbplot/actions)
 [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/dbplot)](https://cran.r-project.org/package=dbplot)
 [![Coverage
 status](https://codecov.io/gh/edgararuiz/dbplot/branch/master/graph/badge.svg)](https://codecov.io/github/edgararuiz/dbplot?branch=master)

 ...

 ## Connecting to a data source

-  - For more information on how to connect to databases, including Hive,
-    please visit <http://db.rstudio.com>
+  - For more information on how to connect to databases, including Hive, please visit
+    <https://solutions.posit.co/connections/db/>

-  - To use Spark, please visit the `sparklyr` official website:
-    <http://spark.rstudio.com>
+  - To use Spark, please visit the `sparklyr` official website:
+    <https://spark.posit.co/>
```

## Phase 1: GitHub Actions Setup

### Files to Delete

``` bash
rm .travis.yml
rm R/utils-pipe.R  # No longer re-exporting %>%, users should use |>
```

### New Files to Create

#### .github/workflows/R-CMD-check.yaml

Use `usethis::use_github_action("check-standard")` or create manually

#### .github/workflows/test-coverage.yaml

Use `usethis::use_github_action("test-coverage")` or create manually

#### .github/workflows/pkgdown.yaml

Use `usethis::use_github_action("pkgdown")` or create manually

## Phase 4: Modern Practices

### CODE_OF_CONDUCT.md

Use `usethis::use_code_of_conduct()`

### CONTRIBUTING.md

Create with development guidelines

### R/dbplot-package.R

Create package-level documentation:

``` r
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
```

## Commands to Run After Changes

``` r
# Update documentation
devtools::document()

# Check package
devtools::check()

# Run tests
devtools::test()

# Update README
if (file.exists("README.Rmd")) {
  rmarkdown::render("README.Rmd")
}

# Build site
pkgdown::build_site()
```

## Summary of Changes by Phase

**Phase 1: Critical Infrastructure** - Dependencies: DESCRIPTION updated
✅ - Pipe migration: ~50+ instances across R files, README, docs - Typo
fixes: 3 files - Test modernization: 6 test files, ~30 lines - GitHub
Actions: 3 new workflow files, 2 deleted files

**Phase 2: Code Quality** - globalVariables consolidation: 3 files -
Code consistency: 2-3 files - Documentation fixes: 2 files

**Phase 3: Documentation & Testing** - README updates: 1 file (~10
lines) - Test expansion: New test files to be created - Man pages:
Already regenerated ✅

**Phase 4: Modern Practices** - Community docs: 2-3 new files - Package
documentation: 1 new file - pkgdown review: Configuration updates

**Total Estimated Effort**: ~150-200 line changes across 20+ files

------------------------------------------------------------------------

**Note**: Use `git diff` frequently to review changes before committing.
