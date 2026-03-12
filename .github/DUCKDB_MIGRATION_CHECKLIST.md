# DuckDB Migration Implementation Checklist

**Date**: 2026-03-12
**Objective**: Migrate all examples from SQLite to DuckDB
**Estimated Time**: ~1.5 hours

## Phase 1: Update Code Examples

Update the actual R code in example sections to use DuckDB instead of SQLite.

### README.Rmd
- [ ] Line 72: Remove `library(odbc)` (not needed)
- [ ] Line 75: Change `RSQLite::SQLite()` → `duckdb::duckdb()`
  - Before: `con <- dbConnect(RSQLite::SQLite(), ":memory:")`
  - After: `con <- dbConnect(duckdb::duckdb(), ":memory:")`
- [ ] Line 76: Keep `copy_to()` call unchanged (works with DuckDB)
- [ ] Line 249: Keep `dbDisconnect(con)` unchanged

### R/dbplot-package.R
- [ ] Update package-level example code (search for `RSQLite::SQLite()`)
- [ ] Change to `duckdb::duckdb()`
- [ ] Remove `library(odbc)` if present
- [ ] Verify example still demonstrates all plot types

**Verification Point 1**: Run examples manually in clean R session to confirm they execute without errors.

---

## Phase 2: Update Documentation Text

Update documentation strings, help text, and analysis documents to reflect DuckDB support.

### R/boxplot.R
- [ ] Update "Supported databases" section in function documentation
- [ ] Add DuckDB to supported list:
  - "DuckDB (recommended for local examples)"
- [ ] Keep "Not supported" list as-is (SQLite, MySQL < 8.0, MariaDB)
- [ ] Update description to mention DuckDB as recommended local backend

### README.Rmd
- [ ] Line 67: Update example intro text
  - Change: "A local `RSQLite` database will be used"
  - To: "A local DuckDB database will be used"
- [ ] Line 185: Update boxplot supported databases list
  - Add DuckDB entry at top: "DuckDB (recommended for local examples)"
- [ ] Add new boxplot database example section (after line 192)
  ```r
  # Boxplot also works with database connections that support quantile()
  # DuckDB is a great local option:
  con_duck <- dbConnect(duckdb::duckdb(), ":memory:")
  db_flights_duck <- copy_to(con_duck, nycflights13::flights, "flights_duck")

  db_flights_duck |>
    dbplot_boxplot(origin, distance)

  dbDisconnect(con_duck)
  ```

### .github/BOXPLOT_BACKEND_ANALYSIS.md
- [ ] Update "Recommended Documentation" section
- [ ] Add DuckDB to list of supported databases
- [ ] Note DuckDB's quantile() support and performance benefits

### CLAUDE.md
- [ ] Update database support context
- [ ] Note that examples now use DuckDB instead of SQLite
- [ ] Update any SQLite-specific notes

**Verification Point 2**: Review all documentation changes for accuracy and consistency.

---

## Phase 3: Update Dependencies

Update package dependencies to include DuckDB.

### DESCRIPTION
- [ ] Add `duckdb` to Suggests section
- [ ] Add `nycflights13` to Suggests (make explicit - used in examples)
- [ ] Keep `RSQLite` in Suggests for backward compatibility
- [ ] Suggested order:
  ```
  Suggests:
      dbplyr (>= 2.0.0),
      testthat (>= 3.0.0),
      tidyr,
      covr,
      lifecycle,
      duckdb,
      RSQLite,
      nycflights13
  ```

### NEWS.md
- [ ] Add entry for this change under version 0.3.3.9001
- [ ] Note: "Examples now use DuckDB instead of SQLite for better performance and boxplot support"
- [ ] Mention this is not a breaking change (examples only, not API)

**Verification Point 3**: Run `devtools::check()` to ensure package still passes all checks.

---

## Phase 4: Regenerate Documentation

Rebuild all generated documentation and site.

### Regenerate R Documentation
- [ ] Run `devtools::document()` to regenerate .Rd files
- [ ] Verify man/dbplot-package.Rd updated correctly
- [ ] Verify man/dbplot_boxplot.Rd updated correctly

### Regenerate README
- [ ] Run `knitr::knit("README.Rmd")` to regenerate README.md
- [ ] Verify all plots render correctly
- [ ] Verify DuckDB connection code appears correctly
- [ ] Check that new boxplot database example section renders

### Rebuild pkgdown Site
- [ ] Run `pkgdown::clean_site()`
- [ ] Run `pkgdown::build_site()`
- [ ] Verify homepage shows updated examples
- [ ] Verify reference pages show updated documentation
- [ ] Check that boxplot reference shows DuckDB in supported list

**Verification Point 4**: Manually browse generated site to confirm all updates are visible.

---

## Phase 5: Testing & Verification

Comprehensive testing to ensure all examples work correctly.

### Install Dependencies
- [ ] Ensure DuckDB is installed: `install.packages("duckdb")`
- [ ] Ensure nycflights13 is installed: `install.packages("nycflights13")`

### Manual Testing - All Plot Types
- [ ] Start clean R session (`Restart R`)
- [ ] Load libraries: `library(DBI)`, `library(dplyr)`, `library(dbplot)`
- [ ] Create DuckDB connection: `con <- dbConnect(duckdb::duckdb(), ":memory:")`
- [ ] Load flights data: `db_flights <- copy_to(con, nycflights13::flights, "flights")`
- [ ] Test histogram: `db_flights |> dbplot_histogram(distance)` ✅
- [ ] Test bar plot: `db_flights |> dbplot_bar(origin)` ✅
- [ ] Test line plot: `db_flights |> dbplot_line(month)` ✅
- [ ] Test raster plot: `db_flights |> dbplot_raster(sched_dep_time, sched_arr_time)` ✅
- [ ] **Test boxplot (NEW!)**: `db_flights |> dbplot_boxplot(origin, distance)` ✅
- [ ] Disconnect: `dbDisconnect(con)` ✅

### Manual Testing - Boxplot with Local Data (Regression)
- [ ] Test boxplot still works with local data frame
- [ ] Run: `nycflights13::flights |> dbplot_boxplot(origin, distance)` ✅

### Package Check
- [ ] Run full R CMD check: `devtools::check()`
- [ ] Verify 0 errors, 0 warnings, 0 notes
- [ ] Verify all examples run successfully

### Documentation Check
- [ ] Run `?dbplot` and verify package help shows DuckDB
- [ ] Run `?dbplot_boxplot` and verify DuckDB in supported list
- [ ] Check that examples section uses DuckDB

**Verification Point 5**: All tests pass and examples work correctly.

---

## Final Verification

Before committing:
- [ ] All checkboxes above are complete ✅
- [ ] Package passes `devtools::check()` with no issues
- [ ] All examples tested manually and work
- [ ] Boxplot now works with DuckDB connection (KEY BENEFIT!)
- [ ] README.md regenerated and looks correct
- [ ] pkgdown site rebuilt and displays correctly
- [ ] Documentation is consistent across all files

---

## Git Commit Strategy

Suggested commit sequence (verify each before proceeding):

1. **Commit 1**: Update examples (README.Rmd, R/dbplot-package.R)
   - Message: "Switch examples from SQLite to DuckDB"

2. **Commit 2**: Update documentation (R/boxplot.R, analysis docs)
   - Message: "Update documentation to include DuckDB support"

3. **Commit 3**: Update dependencies (DESCRIPTION, NEWS.md)
   - Message: "Add duckdb and nycflights13 to Suggests"

4. **Commit 4**: Regenerate documentation (man/, README.md, docs/)
   - Message: "Regenerate documentation with DuckDB examples"

---

## Success Criteria

Migration is complete when:
- ✅ All examples use DuckDB instead of SQLite
- ✅ Boxplot examples work with database connections
- ✅ All documentation updated consistently
- ✅ Package passes R CMD check
- ✅ All manual tests pass
- ✅ pkgdown site displays correctly
- ✅ No regression in existing functionality

**Expected Outcome**: Users can now run boxplot examples with database connections, demonstrating the complete dbplot workflow from connection to visualization.
