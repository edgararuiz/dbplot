# dbplot Package Upgrade Plan

> **Location**: Planning documents are in `.github/` to keep root directory clean
> - `.github/UPGRADE_PLAN.md` - This strategic overview
> - `.github/UPGRADE_CHECKLIST.md` - Detailed task checklist
> - `.github/SPECIFIC_CHANGES.md` - Exact code changes

## Executive Summary

The `dbplot` package (v0.3.3) requires significant modernization to align with current R package development best practices. This package was last updated around 2020 and uses deprecated tooling and patterns.

## Current State Assessment

### Critical Issues
1. **Deprecated CI**: Using Travis CI (sunset in 2021)
2. **Outdated Dependencies**: R >= 3.1, dplyr >= 0.7, rlang >= 0.3
3. **Old Testing Framework**: Using testthat v2 patterns (context(), expect_is())
4. **Documentation**: Links to deprecated RStudio URLs, outdated badges

### Package Information
- **Current Version**: 0.3.3
- **Development Version**: 0.3.3.9000 (during upgrade)
- **Target Release Version**: 0.4.0 (when ready)
- **Last Update**: ~2020
- **RoxygenNote**: 7.0.2 (current is 7.3+)
- **Current R Version Available**: 4.5.2
- **Current testthat Version**: 3.3.2

## Upgrade Priorities

### Phase 1: Critical Infrastructure (High Priority)
**Goal**: Get the package building and testing in modern environment

1. **Update DESCRIPTION Dependencies**
   - Bump R requirement: 3.1 → 4.1.0
   - Update dplyr: 0.7 → 1.0.0
   - Update rlang: 0.3 → 1.0.0
   - Update dbplyr: 1.4.0 → 2.0.0
   - Update RoxygenNote: 7.0.2 → 7.3+
   - Remove magrittr (use native |> pipe instead)

2. **Migrate to GitHub Actions**
   - Remove `.travis.yml`
   - Create `.github/workflows/R-CMD-check.yaml`
   - Create `.github/workflows/test-coverage.yaml`
   - Create `.github/workflows/pkgdown.yaml`

3. **Modernize Test Suite**
   - Remove all `context()` calls
   - Replace `expect_is()` with `expect_s3_class()`
   - Add `edition: 3` to `tests/testthat.R`
   - Fix typos (rignt → right, complte → complete)

### Phase 2: Code Quality (Medium Priority)
**Goal**: Improve maintainability and code quality

4. **Code Quality Improvements**
   - Consolidate `globalVariables()` declarations
   - Fix enquo/enexpr inconsistencies
   - Add input validation
   - Fix typos in comments and docs
   - Migrate from %>% to |> in all examples and documentation

5. **Documentation Updates**
   - Update README badges
   - Fix deprecated URLs:
     - `db.rstudio.com` → `solutions.posit.co`
     - `spark.rstudio.com` → `spark.posit.co`
   - Regenerate all `.Rd` files

6. **Expand Test Coverage**
   - Add database connection tests
   - Test edge cases and error conditions
   - Add tests for grouped data
   - Target >80% coverage

### Phase 3: Modern R Practices (Lower Priority)
**Goal**: Align with current R ecosystem best practices

7. **Add Lifecycle Management**
   - Add lifecycle package
   - Mark deprecated/superseded functions
   - Add package-level documentation

8. **Community Guidelines**
   - Add CODE_OF_CONDUCT.md
   - Add CONTRIBUTING.md
   - Add GitHub issue/PR templates

9. **Review rlang Patterns**
   - Audit tidy evaluation usage
   - Consider modern `{{ }}` syntax
   - Ensure compatibility with rlang 1.0+

10. **Prepare Release**
    - Update version from 0.3.3.9000 to 0.4.0
    - Update NEWS.md for v0.4.0
    - Update cran-comments.md
    - Run R CMD check --as-cran
    - Test on multiple platforms

## Detailed Issues Found

### Code Issues

#### R/histogram.R
- Line 78: Inconsistent use of `enexpr()` vs `enquo()`
- Line 99: Unnecessary `globalVariables()` declaration

#### R/boxplot.R
- Lines 169-186: Large scattered `globalVariables()` list
- Inconsistent pattern handling for different backends

#### R/raster.R
- Line 153: Typo "sourd" → "source"
- Multiple `globalVariables()` needed

#### R/discrete.R
- Documentation typo in line 123: "Bar plot" for line plot function
- Could benefit from better error messages

#### R/dbbin.R
- Line 51-62: `bin_size()` function has complex logic that could use comments

### Test Issues

#### All test files
- Using deprecated `context()` function
- Using deprecated `expect_is()` instead of `expect_s3_class()`
- Typos: "rignt", "complte"
- Limited edge case testing

### Documentation Issues

#### README.md
- Line 5: Travis CI badge (deprecated)
- Lines 49, 52: Old RStudio URLs
- Could use more modern formatting

#### DESCRIPTION
- Old package versions
- Missing modern packages (lifecycle, cli)

## Breaking Changes to Consider

### Versioning Strategy
- **During Development**: Use version 0.3.3.9000 (indicates development version)
- **At Release**: Bump to 0.4.0 (indicates new features and modern dependencies)

### Breaking Changes in 0.4.0
- **R >= 4.1.0 required** (users on old R will need old package version)
- **No longer re-exports %>% pipe** (use native |> or load magrittr explicitly)
- **dplyr >= 1.0.0 required**
- **rlang >= 1.0.0 required**

These changes are necessary to modernize the package and reduce dependencies.

### Potential Future Breaking Changes
- Standardize function naming (all use db_* prefix consistently)
- Improve error messages (might change exact text)
- Add stricter input validation

## Testing Strategy

### Pre-upgrade Testing
```r
# Run current tests
devtools::test()

# Check package
devtools::check()

# Test with databases
# - SQLite (in-memory)
# - Mock connections via dbplyr::simulate_*()
```

### Post-upgrade Testing
```r
# After each phase
devtools::test()
devtools::check()

# Before release
devtools::check(cran = TRUE)
rhub::check_for_cran()
```

## Timeline Estimate

- **Phase 1** (Critical): 4-6 hours
  - Dependencies: 1 hour
  - GitHub Actions: 2 hours
  - Test modernization: 1-3 hours

- **Phase 2** (Quality): 4-6 hours
  - Code cleanup: 2 hours
  - Documentation: 2 hours
  - Test expansion: 2-4 hours

- **Phase 3** (Polish): 2-4 hours
  - Lifecycle: 1 hour
  - Community docs: 1 hour
  - rlang review: 1-2 hours
  - Release prep: 1 hour

**Total Estimate**: 10-16 hours

## Success Criteria

- [ ] Package passes `R CMD check` with no errors, warnings, or notes
- [ ] All tests pass with testthat 3.x
- [ ] GitHub Actions CI runs successfully
- [ ] Test coverage >70% (stretch: >80%)
- [ ] All documentation renders correctly
- [ ] pkgdown site builds without errors
- [ ] Examples all run successfully
- [ ] Compatible with current R (4.5+) and tidyverse packages

## Risk Assessment

### Low Risk
- Dependency updates (well-tested upgrade path)
- Test framework updates (mechanical changes)
- Documentation updates

### Medium Risk
- rlang pattern changes (requires careful testing)
- GitHub Actions setup (might need tweaking)

### High Risk
- None identified (this is a maintenance upgrade)

## Recommendations

### Immediate Actions
1. Start with Phase 1 (Critical Infrastructure)
2. Set up GitHub Actions first to enable automated testing
3. Update dependencies incrementally, testing after each

### Best Practices Going Forward
1. Set up Dependabot to track dependency updates
2. Add pre-commit hooks for code quality
3. Schedule quarterly maintenance reviews
4. Consider using usethis for package development tasks

### Optional Enhancements
- Add hex sticker logo
- Create vignettes for common use cases
- Add more database backend examples
- Consider performance benchmarks
- Add GitHub Discussions for community support

## Compatibility Notes

### Backward Compatibility
- Old R versions: Users on R < 4.1 can continue using dbplot 0.3.3
- Old dplyr: Document minimum versions clearly in NEWS.md
- Breaking changes should be minimal and well-documented

### Forward Compatibility
- Use stable APIs from dependencies
- Avoid experimental features
- Test with development versions of key packages

## Resources

- [R Packages book (2e)](https://r-pkgs.org/)
- [tidyverse style guide](https://style.tidyverse.org/)
- [GitHub Actions for R](https://github.com/r-lib/actions)
- [testthat 3e changes](https://testthat.r-lib.org/articles/third-edition.html)
- [rlang 1.0.0 changes](https://www.tidyverse.org/blog/2022/03/rlang-1-0-0/)

---

**Document Version**: 1.0
**Date**: 2026-03-12
**Author**: Claude Code Analysis
