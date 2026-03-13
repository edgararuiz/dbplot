# CRAN Examples Implementation: DuckDB + Snapshot Tests

**Date**: 2026-03-12
**Objective**: Convert all roxygen examples to use DuckDB wrapped in `\dontrun{}`, add snapshot tests for proper testing coverage
**Timeline**: ~2-2.5 hours

---

## Implementation Plan

### Phase 1: Update All Examples to DuckDB + \dontrun{} (45 min)

Replace all 11 function examples with DuckDB-only versions.

#### Template for Computation Functions (db_compute_*):
```r
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Example usage here
#' db_mtcars |>
#'   db_compute_count(am)
#'
#' dbDisconnect(con)
#' }
```

#### Template for Plot Functions (dbplot_*):
```r
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' library(ggplot2)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' db_mtcars |>
#'   dbplot_bar(am)
#'
#' dbDisconnect(con)
#' }
```

#### Files to Update:

**Computation functions:**
1. `db_compute_count()` - R/discrete.R:15
2. `db_compute_bins()` - R/histogram.R:16
3. `db_compute_raster()` - R/raster.R:33
4. `db_compute_raster2()` - R/raster.R (if has examples)
5. `db_compute_boxplot()` - R/boxplot.R:30

**Plot functions:**
6. `dbplot_bar()` - R/discrete.R:58
7. `dbplot_line()` - R/discrete.R:143
8. `dbplot_histogram()` - R/histogram.R:67
9. `dbplot_raster()` - R/raster.R:160
10. `dbplot_boxplot()` - R/boxplot.R:135

**Utility functions:**
11. `db_bin()` - R/dbbin.R:11

---

### Phase 2: Create Snapshot Tests for Plots (50 min)

#### Create tests/testthat/test-plot-snapshots.R:

```r
# Visual regression tests using testthat snapshot files

test_that("dbplot_histogram creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg)

  expect_s3_class(p, "ggplot")
  expect_snapshot(p$data)
  expect_snapshot(p$labels)

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "histogram-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_histogram with binwidth works", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg, binwidth = 5)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "histogram-binwidth.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_bar creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am)

  expect_s3_class(p, "ggplot")
  expect_snapshot(p$data)

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "bar-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_bar with aggregation works", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am, avg_mpg = mean(mpg))

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "bar-aggregation.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_line creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_line(cyl)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "line-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_raster creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_faithful <- dplyr::copy_to(con, faithful, "faithful")

  p <- db_faithful |> dbplot_raster(eruptions, waiting)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "raster-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_boxplot creates expected plot with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_boxplot(am, mpg)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "boxplot-duckdb.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})
```

---

### Phase 3: Create Computation Tests (30 min)

#### Create tests/testthat/test-duckdb-computations.R:

```r
test_that("db_compute_bins works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_bins(mpg)

  expect_s3_class(result, "data.frame")
  expect_true("mpg" %in% names(result))
  expect_true("count" %in% names(result))
  expect_equal(nrow(result), 30) # default bins

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_count works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_count(am)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2) # am has 2 levels
  expect_true("am" %in% names(result))

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_raster works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_faithful <- dplyr::copy_to(con, faithful, "faithful")

  result <- db_faithful |> db_compute_raster(eruptions, waiting)

  expect_s3_class(result, "data.frame")
  expect_true("eruptions" %in% names(result))
  expect_true("waiting" %in% names(result))
  expect_true("n" %in% names(result))

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_boxplot works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_boxplot(am, mpg)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2) # am has 2 levels
  expect_true(all(c("lower", "middle", "upper", "ymin", "ymax") %in% names(result)))

  DBI::dbDisconnect(con, shutdown = TRUE)
})
```

---

### Phase 4: Configure pkgdown to Run Examples (5 min)

Update `_pkgdown.yml` to run `\dontrun{}` examples when building the site.

Add to the top of the file (after `url:`):

```yaml
build:
  run_dont_run: true
```

This ensures examples appear in the pkgdown documentation website even though they won't run on CRAN.

---

### Phase 5: Regenerate Documentation (5 min)

```r
devtools::document()
```

Verify `.Rd` files show `\dontrun{}` sections.

---

### Phase 6: Run Tests and Verify (15 min)

1. **Create snapshots:**
```r
devtools::test()
```

2. **Review snapshots:**
```bash
ls tests/testthat/_snaps/test-plot-snapshots/
# Should see: histogram-basic.png, bar-basic.png, etc.
```

3. **Review changes (if needed):**
```r
testthat::snapshot_review()
testthat::snapshot_accept()
```

4. **Verify examples:**
```r
?db_compute_count
# Should show "# Not run:" before examples
```

5. **Run package check:**
```r
devtools::check()
```

---

## Implementation Checklist

### Phase 1: Update Examples
- [ ] db_compute_count()
- [ ] db_compute_bins()
- [ ] db_compute_raster()
- [ ] db_compute_raster2() (if exists)
- [ ] db_compute_boxplot()
- [ ] dbplot_bar()
- [ ] dbplot_line()
- [ ] dbplot_histogram()
- [ ] dbplot_raster()
- [ ] dbplot_boxplot()
- [ ] db_bin()

### Phase 2: Snapshot Tests
- [ ] Create test-plot-snapshots.R
- [ ] Add histogram tests (2 tests)
- [ ] Add bar plot tests (2 tests)
- [ ] Add line plot test (1 test)
- [ ] Add raster plot test (1 test)
- [ ] Add boxplot test (1 test)

### Phase 3: Computation Tests
- [ ] Create test-duckdb-computations.R
- [ ] Add db_compute_bins test
- [ ] Add db_compute_count test
- [ ] Add db_compute_raster test
- [ ] Add db_compute_boxplot test

### Phase 4: pkgdown Configuration
- [ ] Add `build: run_dont_run: true` to _pkgdown.yml

### Phase 5: Documentation
- [ ] Run devtools::document()
- [ ] Verify .Rd files updated

### Phase 6: Verification
- [ ] Run devtools::test() - create snapshots
- [ ] Review snapshots in _snaps/test-plot-snapshots/
- [ ] Run devtools::check() - verify passes
- [ ] Verify examples show "# Not run:"

---

## Commit Strategy

1. **Commit 1**: Update all examples to DuckDB
2. **Commit 2**: Configure pkgdown to run \dontrun examples
3. **Commit 3**: Add snapshot tests for plots
4. **Commit 4**: Add computation tests
5. **Commit 5**: Commit snapshot PNG files
6. **Commit 6**: Regenerate documentation

---

## Success Criteria

- ✅ All 11 function examples use DuckDB wrapped in `\dontrun{}`
- ✅ 7 PNG snapshot tests for plots
- ✅ 4 computation tests with DuckDB
- ✅ Package passes `devtools::check()`
- ✅ Tests pass locally
- ✅ Snapshot files committed to repo
- ✅ Help files show database usage exclusively
