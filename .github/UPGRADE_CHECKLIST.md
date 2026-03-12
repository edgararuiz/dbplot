# dbplot Package Upgrade Checklist

Use this checklist to track progress on upgrading the dbplot package.

## Phase 1: Critical Infrastructure ⚠️

### Dependencies (DESCRIPTION)
- [x] Update R requirement from `>= 3.1` to `>= 4.1.0`
- [x] Update dplyr from `>= 0.7` to `>= 1.0.0`
- [x] Update rlang from `>= 0.3` to `>= 1.0.0`
- [x] Update dbplyr from `>= 1.4.0` to `>= 2.0.0` (in Suggests)
- [x] Add explicit ggplot2 version requirement (>= 3.3.0)
- [x] Add `testthat (>= 3.0.0)` version requirement
- [x] Add `lifecycle` to Suggests
- [x] Remove `magrittr` from Imports (using native pipe)
- [x] Update RoxygenNote from 7.0.2 to 7.3.2
- [ ] Consider adding `cli` to Imports for better messages
- [ ] Run `devtools::document()` to regenerate documentation

### GitHub Actions
- [ ] Create `.github/workflows/` directory
- [ ] Add `R-CMD-check.yaml` (multi-platform testing)
- [ ] Add `test-coverage.yaml` (codecov integration)
- [ ] Add `pkgdown.yaml` (documentation site)
- [ ] Update `.Rbuildignore` to include `.github/`
- [ ] Remove `.travis.yml`
- [ ] Test all workflows run successfully

### Test Suite Modernization
- [ ] Add `edition: 3` to `tests/testthat.R`
- [ ] `test-boxplots.R`: Remove `context("boxplots")` (line 1)
- [ ] `test-boxplots.R`: Replace `expect_is()` with `expect_s3_class()` (lines 4, 13, 19)
- [ ] `test-dbbin.R`: Remove `context("db_bin")` (line 1)
- [ ] `test-dbplots.R`: Remove `context("dbplots")` (line 1)
- [ ] `test-dbplots.R`: Replace `expect_is()` with `expect_s3_class()` (lines 4-9, 20, 29)
- [ ] `test-discrete.R`: Remove `context("discrete")` (line 1)
- [ ] `test-discrete.R`: Replace `expect_is()` with `expect_s3_class()` (lines 19, 20, 28, 29)
- [ ] `test-raster.R`: Remove `context("raster")` (line 1)
- [ ] `test-raster.R`: Replace `expect_is()` with `expect_s3_class()` (line 4)
- [ ] Run `devtools::test()` to verify all pass

## Phase 2: Code Quality 🔧

### Migrate to Native Pipe
- [ ] Delete or update `R/utils-pipe.R` (removes %>% re-export)
- [ ] Update all examples in .R files to use |> instead of %>%
- [ ] Update README.md examples to use |> instead of %>%
- [ ] Search for any vignettes using %>%
- [ ] Update NEWS.md to note breaking change (no longer exports %>%)
- [ ] Test all examples still work

### Fix Typos
- [ ] `test-raster.R` line 8: "complte" → "complete"
- [ ] `test-raster.R` line 23: "rignt" → "right"
- [ ] `R/raster.R` line 153: "sourd" → "source"

### Consolidate globalVariables
- [ ] Move all `globalVariables()` to single location in `R/dbplot.R`
- [ ] Remove redundant declarations from:
  - [ ] `R/histogram.R` (line 99)
  - [ ] `R/boxplot.R` (lines 169-186)
- [ ] Verify no R CMD check NOTEs about undefined globals

### Code Consistency
- [ ] Review `enquo()` vs `enexpr()` usage consistency:
  - [ ] `R/histogram.R` uses both - determine correct pattern
  - [ ] `R/raster.R` uses both - ensure consistency
- [ ] Add input validation where missing:
  - [ ] Check bins > 0
  - [ ] Check resolution > 0
  - [ ] Check binwidth > 0 if provided
- [ ] Consider adding `cli` for better error messages

### Documentation
- [ ] Fix `R/discrete.R` line 123: "Bar plot" → "Line plot" in docs
- [ ] Review all function documentation for accuracy
- [ ] Ensure all examples run successfully
- [ ] Add more details to descriptions where needed

## Phase 3: Documentation & Testing 📚

### README.md Updates
- [ ] Remove Travis CI badge (line 5)
- [ ] Add GitHub Actions badges
- [ ] Update `db.rstudio.com` → `solutions.posit.co` (line 49)
- [ ] Update `spark.rstudio.com` → `spark.posit.co` (line 52)
- [ ] Update codecov badge URL if needed
- [ ] Test that all code examples run
- [ ] Regenerate README figures if needed

### Expand Test Coverage
- [ ] Add tests for database connections (SQLite)
- [ ] Add error handling tests:
  - [ ] Invalid bins parameter
  - [ ] Invalid binwidth parameter
  - [ ] Missing required columns
  - [ ] Empty data frames
- [ ] Add tests for edge cases:
  - [ ] Single row data
  - [ ] All NA values
  - [ ] Very large bins/resolution values
- [ ] Add tests for grouped data frames
- [ ] Test multiple aggregations in bar/line plots
- [ ] Test boxplot with different backends (mock)
- [ ] Run `covr::package_coverage()` and aim for >70%

### Man Pages
- [ ] Regenerate all .Rd files with `devtools::document()`
- [ ] Review generated documentation
- [ ] Check for broken links
- [ ] Ensure examples all run

## Phase 4: Modern Practices 🚀

### Lifecycle Management
- [ ] Add lifecycle to Suggests in DESCRIPTION
- [ ] Add lifecycle badges to any superseded functions
- [ ] Create package-level documentation: `R/dbplot-package.R`
- [ ] Document minimum versions and compatibility

### Community Documentation
- [ ] Add `CODE_OF_CONDUCT.md` (use `usethis::use_code_of_conduct()`)
- [ ] Add `CONTRIBUTING.md` with:
  - [ ] Development setup instructions
  - [ ] Testing guidelines
  - [ ] Code style guidelines
  - [ ] PR process
- [ ] Create `.github/ISSUE_TEMPLATE/bug_report.md`
- [ ] Create `.github/ISSUE_TEMPLATE/feature_request.md`
- [ ] Create `.github/PULL_REQUEST_TEMPLATE.md`

### rlang Review
- [ ] Audit all tidy evaluation code
- [ ] Consider using `{{ }}` where appropriate
- [ ] Ensure all `!!`, `!!!`, and `:=` usage is correct
- [ ] Test with rlang 1.0+ changes
- [ ] Document any breaking changes in tidy eval patterns

### pkgdown Site
- [ ] Review `_pkgdown.yml` configuration
- [ ] Test `pkgdown::build_site()` runs cleanly
- [ ] Check all vignettes render
- [ ] Update styling if needed
- [ ] Ensure logo displays correctly

## Phase 5: Release Preparation 📦

### Version & NEWS
- [ ] Update version in DESCRIPTION from 0.3.3.9000 to 0.4.0
- [ ] Add comprehensive release notes to NEWS.md:
  - [ ] Breaking changes section
  - [ ] New features
  - [ ] Bug fixes
  - [ ] Dependency updates
  - [ ] Deprecated functions
- [ ] Update cran-comments.md:
  - [ ] Current test environments
  - [ ] R CMD check results
  - [ ] Downstream dependencies check

### Quality Checks
- [ ] Run `devtools::check()` - 0 errors, 0 warnings, 0 notes
- [ ] Run `devtools::check(cran = TRUE)` - passes
- [ ] Run `urlchecker::url_check()` - all links valid
- [ ] Run `spelling::spell_check_package()` - no typos
- [ ] Test installation from source: `install.packages(".", repos = NULL, type = "source")`
- [ ] Test on multiple R versions (4.1, 4.2, 4.3, 4.4, 4.5)
- [ ] Check with `rhub::check_for_cran()` if available

### Final Review
- [ ] All examples run without errors
- [ ] All tests pass
- [ ] All vignettes build
- [ ] Documentation is complete and accurate
- [ ] No TODO or FIXME comments remain
- [ ] Git history is clean (consider squashing WIP commits)

## Optional Enhancements ✨

### Nice-to-Have
- [ ] Add hex sticker logo to `man/figures/`
- [ ] Create additional vignettes:
  - [ ] Introduction to dbplot
  - [ ] Working with different databases
  - [ ] Performance considerations
- [ ] Add performance benchmarks
- [ ] Set up Dependabot for automated dependency updates
- [ ] Add pre-commit hooks (styler, lintr)
- [ ] Consider adding GitHub Discussions

### Future Considerations
- [ ] Add support for more database backends
- [ ] Add more plot types (violin plots, density plots)
- [ ] Add theming capabilities
- [ ] Add interactive plot options (plotly)
- [ ] Consider adding arrow/polars support

## Testing Commands

```r
# Basic checks
devtools::load_all()
devtools::test()
devtools::check()

# Documentation
devtools::document()
pkgdown::build_site()

# Coverage
covr::package_coverage()
covr::report()

# CRAN checks
devtools::check(cran = TRUE)
urlchecker::url_check()
spelling::spell_check_package()

# Install and test
devtools::install()
library(dbplot)
?dbplot
```

## Notes

- Keep track of any issues encountered in UPGRADE_NOTES.md
- Document any decisions made about breaking changes
- Test with actual database connections (SQLite, PostgreSQL, etc.)
- Consider creating a branch for testing before merging to main

---

**Last Updated**: 2026-03-12
**Progress**: 0/100+ items completed
