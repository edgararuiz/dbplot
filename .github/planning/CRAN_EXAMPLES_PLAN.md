# CRAN Examples Strategy: DuckDB + Don't Run

**Date**: 2026-03-12
**Objective**: Convert all roxygen examples to use DuckDB and prevent them from running on CRAN
**Priority**: Medium (improves consistency, reduces CRAN check time)
**Decision**: ✅ **Approach 2 (Full DuckDB + Snapshot Tests)**

## Executive Summary

**What**: Replace ALL function examples with DuckDB-only versions, wrapped in `\dontrun{}`. Add comprehensive testthat snapshot tests to ensure proper testing coverage.

**Why**:
- User feedback: "Proving it can run locally is not a priority"
- Examples are for documentation, not testing
- Snapshot tests provide superior testing coverage
- Clear focus on package's main purpose (database plotting)

**Testing Strategy**: Use testthat's built-in `expect_snapshot_file()` for visual regression testing instead of running examples on CRAN. No extra dependencies needed!

**Timeline**: ~2-2.5 hours (includes writing comprehensive tests)

**Impact**:
- ✅ Better documentation (shows real use case)
- ✅ Better testing (PNG snapshots catch regressions)
- ✅ CRAN compliant (examples don't run)
- ✅ Maximum consistency (all examples use DuckDB)
- ✅ No extra dependencies (uses built-in testthat features)

## Current State

### Package Documentation (R/dbplot-package.R)
- ✅ Already uses DuckDB
- ✅ Already wrapped in `\dontrun{}`
- Status: **Complete**

### Individual Function Examples
Currently use local data frames (mtcars, faithful) which work but don't demonstrate database functionality:

| File | Functions | Current Data | Database Example |
|------|-----------|--------------|------------------|
| R/discrete.R | db_compute_count, dbplot_bar, dbplot_line | mtcars | ❌ No |
| R/histogram.R | db_compute_bins, dbplot_histogram | mtcars | ❌ No |
| R/raster.R | db_compute_raster, db_compute_raster2, dbplot_raster | faithful | ❌ No |
| R/boxplot.R | db_compute_boxplot, dbplot_boxplot | mtcars | ❌ No |
| R/dbbin.R | db_bin | mtcars | ❌ No |

**Issue**: Examples work but don't showcase the main value proposition (database plotting).

## Why Change?

### Current Approach (Local Data Frames)
**Pros:**
- ✅ Fast to run
- ✅ No dependencies needed
- ✅ Examples run on CRAN without issues

**Cons:**
- ❌ Doesn't demonstrate database functionality
- ❌ Misleading - suggests package is for local data frames
- ❌ Users miss the point of the package
- ❌ Inconsistent with README and package docs

### Proposed Approach (DuckDB + \dontrun{})
**Pros:**
- ✅ Shows real database usage
- ✅ Consistent with README examples
- ✅ Demonstrates the package's purpose
- ✅ Users understand when/why to use dbplot
- ✅ Won't run on CRAN (no time penalty, no dependency issues)

**Cons:**
- ⚠️ Examples won't be tested by R CMD check on CRAN
  - **Mitigation**: README examples run in CI, manual testing, test script exists

## CRAN Policy on Examples

### R CMD check Behavior
From "Writing R Extensions" manual:
- Examples wrapped in `\dontrun{}` are **not executed** during R CMD check
- `\dontrun{}` is appropriate when:
  - Examples require external resources (databases, network)
  - Examples require packages in Suggests
  - Examples take significant time

### Appropriate Use of \dontrun{}
✅ **Our case qualifies** because:
1. Requires `duckdb` package (in Suggests, not Imports)
2. Creates database connection (external resource)
3. Demonstrates integration, not unit testing

### Alternative: \donttest{}
- `\donttest{}` runs locally but not on CRAN
- Could be used, but `\dontrun{}` is clearer for database examples

## Implementation Strategy

### Approach 1: Hybrid
Keep simple examples for basic functions, add DuckDB examples for advanced usage.

**Verdict**: ❌ Rejected - "Proving it can run locally is not a priority" (user feedback)

### Approach 2: Full DuckDB (Recommended) ✅
Replace all examples with DuckDB, wrap all in \dontrun{}. Add testthat snapshot tests for proper testing coverage.

**Pros**:
- ✅ Maximum consistency
- ✅ All examples demonstrate database functionality
- ✅ Clear focus on package's main purpose
- ✅ Testing handled properly via testthat snapshots

**Cons addressed**:
- ⚠️ No examples run on CRAN → **Mitigated by adding testthat snapshot tests**
- ⚠️ Loses basic testing → **Mitigated by comprehensive test suite**

**Rationale**:
- Examples are for documentation, not testing
- Test suite (including snapshot tests) provides proper coverage
- Database examples show real-world usage
- Consistent with README and package philosophy

### Approach 3: Status Quo
Keep current local data frame examples.

**Verdict**: ❌ Doesn't address the problem

## Recommended Implementation Plan (Approach 2: Full DuckDB)

### Phase 1: Update All Function Examples with DuckDB

Replace all examples with DuckDB-only versions, wrapped in `\dontrun{}`.

#### Template for db_compute_* functions:
```r
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Returns the row count per am
#' db_mtcars |>
#'   db_compute_count(am)
#'
#' # Returns the average mpg per am
#' db_mtcars |>
#'   db_compute_count(am, mean(mpg))
#'
#' dbDisconnect(con)
#' }
```

#### Template for dbplot_* functions:
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

**Functions to update (11 total):**

**Computation functions (5):**
1. `db_compute_count()` - R/discrete.R:15
2. `db_compute_bins()` - R/histogram.R:16
3. `db_compute_raster()` - R/raster.R:33
4. `db_compute_raster2()` - R/raster.R (if has examples)
5. `db_compute_boxplot()` - R/boxplot.R:30

**Plot functions (5):**
6. `dbplot_bar()` - R/discrete.R:58
7. `dbplot_line()` - R/discrete.R:143
8. `dbplot_histogram()` - R/histogram.R:67
9. `dbplot_raster()` - R/raster.R:160
10. `dbplot_boxplot()` - R/boxplot.R:135

**Utility functions (1):**
11. `db_bin()` - R/dbbin.R:11

### Phase 2: Add Snapshot Tests for Plot Functions

Create comprehensive snapshot tests to ensure plot outputs are correct. This addresses the testing concern from removing local examples.

#### Create tests/testthat/test-plot-snapshots.R:

```r
# Visual regression tests using testthat snapshot files

test_that("dbplot_histogram creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg)

  # Test plot structure
  expect_s3_class(p, "ggplot")
  expect_snapshot(p$data)
  expect_snapshot(p$labels)

  # Visual snapshot - saves plot as PNG
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

#### Benefits of expect_snapshot_file() over vdiffr:

1. **No Extra Dependency**: Built into testthat (no vdiffr needed)
2. **Visual Regression Detection**: Saves PNG snapshots of plots, catches visual changes
3. **Data Structure Verification**: `expect_snapshot()` still captures plot data and labels
4. **Simpler Setup**: Just save plot to temp file and snapshot it
5. **Automated**: Runs in CI, catches unintended changes
6. **Skip on CRAN**: All tests wrapped with `skip_on_cran()`
7. **Better than Examples**: Actually tests correctness, not just "doesn't error"

### Phase 3: Add Computation Function Tests

Add tests for computation functions to ensure data correctness:

#### Add to tests/testthat/test-duckdb-computations.R:

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

### Phase 4: Regenerate Documentation

```r
devtools::document()
```

### Phase 5: Run Tests and Verify

1. **Run snapshot tests locally:**
```r
devtools::test()
# First run will create snapshot files (PNG images and data snapshots)
# Subsequent runs will compare against snapshots
```

2. **Review generated snapshots:**
```bash
ls tests/testthat/_snaps/
# Should see:
# - test-plot-snapshots/ with PNG files
# - Markdown files with data snapshots

ls tests/testthat/_snaps/test-plot-snapshots/
# Should see PNG files: histogram-basic.png, bar-basic.png, etc.
```

3. **Review snapshot changes (if plots change):**
```r
# testthat will show you diffs in test output
# To accept new snapshots:
testthat::snapshot_accept()

# To review what changed:
testthat::snapshot_review()
```

4. **Verify examples are wrapped:**
```r
?db_compute_count
?dbplot_bar
# Should show "# Not run:" before examples
```

5. **Run R CMD check:**
```r
devtools::check()
# Examples won't run (wrapped in \dontrun{})
# Tests will run (except on CRAN with skip_on_cran())
```

### Phase 6: Update CI Configuration (Optional)

No changes needed! `expect_snapshot_file()` is built into testthat, so CI will work automatically. Snapshots are committed to the repo and used for comparison.

## Testing Strategy (Approach 2)

### What Gets Tested
- ✅ **Snapshot tests** for plot structure and visual output (comprehensive)
- ✅ **Computation tests** for data correctness with DuckDB
- ✅ README examples (run in CI via GitHub Actions)
- ✅ Existing test suite (run on CRAN)
- ✅ Manual testing with test script
- ⏹️ DuckDB roxygen examples (NOT run on CRAN - they're documentation)

### Testing Coverage Breakdown

| Component | Tested By | Runs on CRAN | Purpose |
|-----------|-----------|--------------|---------|
| Plot visual output | PNG snapshots (expect_snapshot_file) | ❌ (skip_on_cran) | Regression detection |
| Plot data structure | testthat snapshots | ❌ (skip_on_cran) | Data validation |
| Computation results | Unit tests | ❌ (skip_on_cran) | Correctness |
| Package internals | Existing tests | ✅ | Core functionality |
| README examples | CI knitting | ✅ (via CI) | Integration |
| DuckDB integration | All above + manual script | ✅ (via CI) | End-to-end |

### Why This Is Better Than Running Examples

1. **Snapshot tests are proper tests** - They verify correctness, not just "doesn't error"
2. **Visual regression detection** - Catches unintended plot changes
3. **Data validation** - Ensures correct calculations
4. **Runs in CI** - Automated on every commit
5. **Better coverage** - Tests multiple scenarios, not just one example per function

### Rationale
- **Examples are documentation**, not tests - they show users how to use functions
- **Tests are tests** - they verify functions work correctly
- **Snapshot tests** provide better coverage than running examples ever could
- **DuckDB examples** demonstrate real-world usage without CRAN penalty

## Benefits (Approach 2 over Approach 1)

### 1. Better Documentation
- ✅ **Focus on real use case**: All examples show database usage (the package's purpose)
- ✅ **No confusion**: Users don't wonder if local data frames are the main use case
- ✅ **Consistent messaging**: Examples match README and package philosophy
- ✅ **Clear value proposition**: Shows why users would choose dbplot over base plotting

### 2. Superior Testing
- ✅ **Proper test coverage**: Snapshot tests verify correctness, not just "doesn't error"
- ✅ **Visual regression detection**: PNG snapshots catch unintended plot changes
- ✅ **Better than running examples**: Tests are comprehensive, automated, and catch real bugs
- ✅ **CI integration**: Tests run on every commit
- ✅ **Data validation**: Tests verify computation results are correct
- ✅ **No extra dependencies**: `expect_snapshot_file()` built into testthat

### 3. CRAN Compliance
- ✅ **Won't run during R CMD check**: No time penalty on CRAN servers
- ✅ **No dependency issues**: DuckDB not required for CRAN checks
- ✅ **Tests skip on CRAN**: `skip_on_cran()` ensures tests only run where appropriate
- ✅ **Follows best practices**: `\dontrun{}` is appropriate for database examples

### 4. Maintenance Benefits
- ✅ **Single source of truth**: One example pattern (DuckDB), easier to maintain
- ✅ **Less duplication**: Don't maintain both local and database examples
- ✅ **Clear intent**: Examples show intended use case
- ✅ **Easier updates**: Change DuckDB pattern once, applies everywhere

### 5. Educational Value
- ✅ **Shows connection setup**: Users learn proper database connection patterns
- ✅ **Shows proper cleanup**: Examples include `dbDisconnect()`
- ✅ **Demonstrates best practices**: Connection management, memory databases
- ✅ **Real-world applicable**: Examples translate directly to user's code

### Why Not Hybrid (Approach 1)?
As user noted: "Proving it can run locally is not a priority"
- ❌ **Mixed messaging**: Suggests local data frames are equally important
- ❌ **Dilutes focus**: Package purpose is database plotting, not local data frame plotting
- ❌ **More maintenance**: Need to maintain both local and database examples
- ❌ **Confusing**: Users may think they need to choose between approaches
- ❌ **False testing**: Running examples isn't real testing anyway

## Timeline (Approach 2)

- Phase 1 (Update all examples to DuckDB): 45 minutes
- Phase 2 (Create snapshot tests): 50 minutes (simpler with expect_snapshot_file)
- Phase 3 (Create computation tests): 30 minutes
- Phase 4 (Regenerate docs): 5 minutes
- Phase 5 (Run tests & verify): 15 minutes
- Phase 6 (Update CI config): Not needed! (testthat built-in)

**Total**: ~2-2.5 hours (proper testing, no extra dependencies)

## Alternatives Considered

### Alternative 1: Use testthat::skip_on_cran() in Examples
**Verdict**: ❌ Can't use in roxygen examples, that's for tests

### Alternative 2: Use @examplesIf
```r
#' @examplesIf requireNamespace("duckdb", quietly = TRUE)
```
**Verdict**: ⚠️ Possible but less clear than \dontrun{} for this use case

### Alternative 3: Create Vignettes Instead
**Verdict**: ⚠️ Could do both - vignettes complement examples

## Decision

✅ **Proceed with Approach 2 (Full DuckDB + Snapshot Tests)**

Based on user feedback: "I do not like approach 1, proving that it can run locally is not a priority"

**Implementation:**
- Replace ALL examples with DuckDB versions
- Wrap all examples in `\dontrun{}`
- Add comprehensive testthat snapshot tests for plot validation
- Add unit tests for computation functions with DuckDB
- Use `expect_snapshot_file()` for visual regression testing

**Key Points:**
- Examples are documentation, not tests
- Testing handled properly via testthat + snapshots
- Maximum consistency across all documentation
- Clear focus on database functionality

## Success Criteria

- ✅ All functions have DuckDB-only examples
- ✅ All examples wrapped in `\dontrun{}`
- ✅ Comprehensive snapshot tests for all plot functions (7 PNG snapshot tests)
- ✅ Unit tests for all computation functions with DuckDB
- ✅ Visual regression tests using `expect_snapshot_file()`
- ✅ Help files show database usage exclusively
- ✅ Package passes R CMD check (examples don't run on CRAN)
- ✅ Tests pass locally and in CI
- ✅ PNG snapshot files committed to repo in `tests/testthat/_snaps/`
- ✅ No regression in plot output (verified by PNG snapshots)
- ✅ Documentation consistent with README

## About expect_snapshot_file() (Visual Regression Testing)

### What is expect_snapshot_file()?
- Built-in testthat function for binary file snapshots
- Saves plots as PNG images
- Compares new plots against saved snapshots
- Detects any visual changes in plot output
- No external dependencies needed

### How It Works
1. First run: Creates baseline PNG snapshots in `tests/testthat/_snaps/`
2. Subsequent runs: Compares current plot against baseline
3. If different: Test fails, shows you need to review
4. Accept changes: `testthat::snapshot_accept()`
5. Snapshots committed to repo alongside tests

### Benefits for dbplot
- ✅ Catches unintended visual changes (colors, layouts, scales, data)
- ✅ Ensures plot output remains consistent
- ✅ Works with any plot (uses PNG files)
- ✅ Runs in CI automatically
- ✅ No extra dependencies (built into testthat)
- ✅ Simple workflow (save plot, snapshot file)

### Example Workflow
```r
# Run tests
devtools::test()

# If plots changed, review what changed
testthat::snapshot_review()

# Accept new snapshots (if intentional)
testthat::snapshot_accept()

# Or reject (if bug) and fix the code
```

### CRAN Compatibility
- Tests wrapped in `skip_on_cran()` - won't run on CRAN
- Snapshots committed to repo
- No external dependencies needed at CRAN check time
- Works with standard testthat framework

## Future Enhancements

### Consider Adding Vignettes
Could create:
1. "Introduction to dbplot with DuckDB" vignette
2. "Database Plotting Best Practices" vignette
3. "Connecting to Different Databases" vignette

Vignettes complement but don't replace examples.

### Consider Parameterized Tests
Could expand snapshot tests to cover:
- Different bin counts
- Different resolutions
- Different aggregations
- Multiple database backends (PostgreSQL, Spark)

## References

### Documentation
- [Writing R Extensions - \dontrun{}](https://cran.r-project.org/doc/manuals/R-exts.html#Documenting-functions)
- [roxygen2 documentation tags](https://roxygen2.r-lib.org/articles/rd.html#examples)
- [R Packages book on examples](https://r-pkgs.org/man.html#man-examples)

### Testing
- [testthat snapshot testing](https://testthat.r-lib.org/articles/snapshotting.html)
- [expect_snapshot_file() documentation](https://testthat.r-lib.org/reference/expect_snapshot_file.html)
- [R Packages book on testing](https://r-pkgs.org/testing-design.html)
- [testthat skip functions](https://testthat.r-lib.org/reference/skip.html)

## Next Steps

1. ✅ Review and approve this plan (Updated to Approach 2 with expect_snapshot_file)
2. Implement Phase 1: Update all examples to DuckDB + \dontrun{}
3. Implement Phase 2: Create snapshot tests for plot functions
4. Implement Phase 3: Create computation tests for DuckDB
5. Implement Phase 4: Regenerate documentation
6. Implement Phase 5: Run tests and verify
   - Run `devtools::test()` to create initial PNG snapshots
   - Review generated snapshots in `tests/testthat/_snaps/`
   - If changes needed: `testthat::snapshot_review()` and `testthat::snapshot_accept()`
   - Run `devtools::check()` to verify package passes
7. Commit changes:
   - Commit 1: Update examples to DuckDB
   - Commit 2: Add snapshot tests
   - Commit 3: Add computation tests
   - Commit 4: Commit snapshot files (PNG images)
   - Commit 5: Regenerate docs
8. Push and monitor CI tests (no configuration changes needed!)

## Checklist Template

```markdown
### Phase 1: Update Examples
- [ ] Update db_compute_count() examples
- [ ] Update db_compute_bins() examples
- [ ] Update db_compute_raster() examples
- [ ] Update db_compute_raster2() examples (if exists)
- [ ] Update db_compute_boxplot() examples
- [ ] Update dbplot_bar() examples
- [ ] Update dbplot_line() examples
- [ ] Update dbplot_histogram() examples
- [ ] Update dbplot_raster() examples
- [ ] Update dbplot_boxplot() examples
- [ ] Update db_bin() examples

### Phase 2: Snapshot Tests
- [ ] Create test-plot-snapshots.R
- [ ] Add histogram snapshot tests (2 tests)
- [ ] Add bar plot snapshot tests (2 tests)
- [ ] Add line plot snapshot tests (1 test)
- [ ] Add raster plot snapshot tests (1 test)
- [ ] Add boxplot snapshot tests (1 test)

### Phase 3: Computation Tests
- [ ] Create test-duckdb-computations.R
- [ ] Add db_compute_bins test
- [ ] Add db_compute_count test
- [ ] Add db_compute_raster test
- [ ] Add db_compute_boxplot test

### Phase 4: Documentation
- [ ] Run devtools::document()
- [ ] Verify .Rd files updated

### Phase 5: Verification
- [ ] Run devtools::test() - create PNG snapshots
- [ ] Review snapshots in tests/testthat/_snaps/test-plot-snapshots/
- [ ] Use testthat::snapshot_review() if needed
- [ ] Run devtools::check() - verify passes
- [ ] Check examples show "# Not run:"

### Phase 6: CI Configuration
- [ ] No changes needed - expect_snapshot_file() is built into testthat!
```
