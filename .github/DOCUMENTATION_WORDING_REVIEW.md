# Documentation Wording Review - dbplot Package

**Date**: 2026-03-12
**Reviewer**: Claude (Sonnet 4.5)
**Status**: Recommendations for improvement

## Executive Summary

A comprehensive review of all user-facing documentation has identified opportunities to improve clarity, consistency, grammar, and technical accuracy. Most issues are minor, but addressing them will significantly improve the user experience.

## Priority Issues

### 🔴 High Priority - Technical Accuracy

#### 1. Inconsistent Database Support Claims (Boxplot)

**Issue**: Conflicting information about which databases support boxplot functionality.

**Root Cause**: Boxplot requires `quantile()` function, which dbplyr translates to database-specific percentile functions (e.g., `PERCENTILE_CONT()`, `percentile_approx()`). Not all databases have these functions.

**Locations**:
- `R/boxplot.R:11` - Says "only works with Spark, Hive, and SQL Server"
- `R/boxplot.R:114` - Says "only works with Spark and Hive"
- `README.Rmd` (line 174-179) - Says "tested with MS SQL Server, PostgreSQL, Oracle, sparklyr"

**Analysis** (see `.github/BOXPLOT_BACKEND_ANALYSIS.md`):
- ✅ **Confirmed working**: Spark/Hive (sparklyr), SQL Server 2012+, PostgreSQL 9.4+, Oracle 9i+
- ❌ **Does NOT work**: SQLite, MySQL < 8.0, MariaDB

**Recommendation**:

For `db_compute_boxplot()` (R/boxplot.R:11):
```r
#' Requires database support for percentile/quantile functions. Confirmed to work with:
#' - Spark/Hive (via sparklyr) - uses percentile_approx()
#' - SQL Server (2012+) - uses PERCENTILE_CONT()
#' - PostgreSQL (9.4+) - uses percentile_cont()
#' - Oracle (9i+) - uses PERCENTILE_CONT()
#'
#' Does NOT work with SQLite, MySQL < 8.0, or MariaDB (no percentile support).
```

For `dbplot_boxplot()` (R/boxplot.R:114):
```r
#' Requires database support for percentile/quantile functions.
#' See \code{\link{db_compute_boxplot}} for supported database backends.
```

For README.Rmd:
```
Boxplot functions require database support for percentile/quantile calculations.

**Supported databases** (tested):
- Spark/Hive (via sparklyr) - uses `percentile_approx()`
- SQL Server (2012+) - uses `PERCENTILE_CONT()`
- PostgreSQL (9.4+) - uses `percentile_cont()`
- Oracle (9i+) - uses `PERCENTILE_CONT()`

**Not supported**:
- SQLite (no percentile functions)
- MySQL < 8.0 (no percentile functions)
- MariaDB (limited/no percentile support)
```

**Files to update**:
- `R/boxplot.R` (both `db_compute_boxplot` and `dbplot_boxplot`)
- `README.Rmd` (line 174-180)
- Regenerate documentation

#### 2. Duplicate/Incorrect Class Names

**Issue**: Documentation lists incorrect or duplicate class names for database tables.

**Locations**:
- `R/discrete.R:8` - Lists `tbl_sql, tbl_dbi, tbl_sql` (duplicate `tbl_sql`)
- `R/raster.R:13` - Lists `tbl_sql, tbl_dbi, tbl_sql` (duplicate `tbl_sql`)

**Recommendation**:
```r
# Standard wording for all functions:
"The `class()` of such tables in R are: tbl_sql, tbl_dbi, tbl_spark"

# Or more accurately:
"Such tables have classes like: tbl_sql, tbl_dbi (for DBI connections),
or tbl_spark (for Spark connections)"
```

**Files to update**:
- `R/discrete.R:8`
- `R/raster.R:13`

### 🟡 Medium Priority - Grammar & Typos

#### 3. Typo: "ouput" → "output"

**Location**: `README.Rmd:41`

**Current**:
```
1. Functions that ouput a `ggplot2` object
```

**Recommended**:
```
1. Functions that output a `ggplot2` object
```

#### 4. Typo: Double "the"

**Location**: `README.Rmd:52`

**Current**:
```
Or the the development version from GitHub
```

**Recommended**:
```
Or the development version from GitHub
```

#### 5. Inconsistent Verb Forms

**Location**: `README.Rmd:41-43`

**Current**:
```
1. Functions that ouput a `ggplot2` object
2. Functions that outputs a `data.frame` object with the calculations
3. Creates the formula needed to calculate bins
```

**Recommended**:
```
1. Functions that output a `ggplot2` object
2. Functions that output a `data.frame` object with the calculations
3. Functions that create formulas for calculating bins
```

#### 6. Grammar: "a histogram bins"

**Location**: `R/histogram.R:1`

**Current**:
```r
#' Calculates a histogram bins
```

**Recommended**:
```r
#' Calculate histogram bins
# OR
#' Calculates histogram bins
```

#### 7. Typo: "unamed" → "unnamed"

**Location**: `R/discrete.R:12`

**Current**:
```r
#' @param ... A set of named or unamed aggregations
```

**Recommended**:
```r
#' @param ... A set of named or unnamed aggregations
```

#### 8. Incorrect: "side of the bins" → "width of the bins"

**Locations**:
- `R/histogram.R:14`
- `R/dbbin.R:9`

**Current**:
```r
#' @param binwidth Single value that sets the side of the bins
```

**Recommended**:
```r
#' @param binwidth Single value that sets the width of the bins
```

**Rationale**: Bins have width (along the x-axis), not "side". This is more technically accurate.

#### 9. Extra Backtick in Code Reference

**Location**: `R/dbbin.R:16`

**Current**:
```r
#' # prefix the function with `!!`` (See Details)
```

**Recommended**:
```r
#' # prefix the function with `!!` (See Details)
```

#### 10. Double Space

**Location**: `R/boxplot.R:109`

**Current**:
```r
#' to create the boxplot  Because of this approach,
```

**Recommended**:
```r
#' to create the boxplot. Because of this approach,
```

### 🟢 Low Priority - Clarity & Style

#### 11. Awkward Phrasing: "The highest the number"

**Location**: `R/raster.R:29`

**Current**:
```r
#' @param resolution The number of bins created by variable. The highest the number,
#' the more records can be potentially imported from the source
```

**Recommended**:
```r
#' @param resolution The number of bins created per variable. The higher the number,
#' the more records will be imported from the source
```

**Changes**:
- "by variable" → "per variable" (clearer)
- "The highest the number" → "The higher the number" (correct grammar)
- "can be potentially imported" → "will be imported" (more direct)

#### 12. Confusing Statement About sparklyr

**Location**: `README.Rmd:67`

**Current**:
```
In addition to database connections, the functions work with `sparklyr`.
```

**Issue**: This implies sparklyr is separate from database connections, but sparklyr IS a database connection method.

**Recommended**:
```
The functions work with standard database connections (via DBI/dbplyr)
and with Spark connections (via sparklyr).
```

**Alternative** (if emphasizing local testing):
```
While designed for database connections, the functions also work with
local data frames (as demonstrated in these examples using RSQLite).
```

#### 13. Awkward Phrasing: "Pass a formula, and column name"

**Location**: `README.Rmd:152`

**Current**:
```
Pass a formula, and column name, that will be operated for each value
```

**Recommended**:
```
Pass an aggregation formula that will be calculated for each value
```

#### 14. Awkward Parameter Description

**Location**: `R/boxplot.R:16`

**Current**:
```r
#' @param data A table (tbl), can already contain additional grouping vars specified
```

**Recommended**:
```r
#' @param data A table (tbl) that can already contain grouping variables
```

#### 15. Generic Phrase: "very generic dplyr code"

**Locations**: Multiple files (histogram.R, boxplot.R, discrete.R, raster.R)

**Current**:
```r
#' Uses very generic dplyr code to aggregate data.
```

**Issue**: "very generic" is vague and could sound negative.

**Recommended**:
```r
#' Uses standard dplyr code to aggregate data.
# OR
#' Uses dplyr operations to aggregate data.
# OR
#' Leverages dplyr to aggregate data.
```

**Rationale**: More professional and clearer about the benefit (compatibility).

## Consistency Recommendations

### Standardize Function Documentation

Create consistent patterns for similar functions:

**For `db_compute_*` functions**:
```r
#' Calculate [plot type] data
#'
#' @description
#' Aggregates data for [plot type] visualization using dplyr operations.
#' Calculations run inside the database, minimizing data transfer.
#'
#' @details
#' Works with database connections via DBI/dbplyr and Spark connections
#' via sparklyr. Supported classes: tbl_sql, tbl_dbi, tbl_spark.
```

**For `dbplot_*` functions**:
```r
#' Create [plot type]
#'
#' @description
#' Creates a [plot type] using data from a database or remote source.
#' Aggregations run inside the database, then results are visualized with ggplot2.
#'
#' @details
#' Returns a ggplot2 object that can be further customized with ggplot2 functions.
```

## Technical Accuracy Checks Needed

### Database Backend Support

**Action Required**: Verify and document which functions work with which backends.

**Test matrix needed**:
```
Function          | SQLite | PostgreSQL | SQL Server | Oracle | Spark |
------------------|--------|------------|------------|--------|-------|
db_compute_bins   |   ✓    |     ✓      |     ✓      |   ✓    |   ✓   |
db_compute_count  |   ✓    |     ✓      |     ✓      |   ✓    |   ✓   |
db_compute_raster |   ✓    |     ✓      |     ✓      |   ✓    |   ✓   |
db_compute_boxplot|   ?    |     ?      |     ✓      |   ?    |   ✓   |
```

**Update documentation based on actual testing results**.

## Quick Wins - Easy Fixes

Files that need simple find/replace:

1. **README.Rmd** (lines 41, 52):
   - Fix "ouput" → "output"
   - Remove duplicate "the the"

2. **R/dbbin.R** (lines 9, 16):
   - "side of the bins" → "width of the bins"
   - Remove extra backtick from `!!``

3. **R/histogram.R** (line 14):
   - "side of the bins" → "width of the bins"

4. **R/discrete.R** (line 12):
   - "unamed" → "unnamed"

5. **All R files** with "very generic dplyr":
   - Consider changing to "standard dplyr" or "dplyr operations"

## Implementation Priority

### Phase 1: Critical Fixes (Do First)
1. Fix database support inconsistencies (boxplot)
2. Fix duplicate class names (tbl_sql, tbl_sql)
3. Fix typos that affect technical accuracy

### Phase 2: Grammar & Typos
1. Fix all spelling errors
2. Fix grammar issues
3. Fix inconsistent verb forms

### Phase 3: Clarity Improvements
1. Improve awkward phrasings
2. Standardize documentation patterns
3. Enhance parameter descriptions

## Files Requiring Updates

### High Priority
- [ ] `R/boxplot.R` (database support claims, class names, spacing)
- [ ] `R/discrete.R` (class names, typo "unamed")
- [ ] `R/raster.R` (class names, awkward phrasing)

### Medium Priority
- [ ] `README.Rmd` (typos, verb forms, sparklyr statement)
- [ ] `R/histogram.R` (grammar, parameter descriptions)
- [ ] `R/dbbin.R` (parameter descriptions, extra backtick)

### Low Priority
- [ ] All files with "very generic dplyr" phrase

## Regeneration Steps

After making changes to R files:
```r
# 1. Update roxygen documentation
devtools::document()

# 2. Regenerate README
rmarkdown::render("README.Rmd")

# 3. Verify changes
devtools::check()
```

## Style Recommendations

### Tone
- Professional and clear
- Avoid vague words like "very generic"
- Be specific about capabilities and limitations

### Technical Writing
- Use active voice when possible
- Be consistent with terminology
- Use parallel structure in lists
- Prefer "will" over "can be" for certainty

### Code Examples
- Keep examples simple and clear
- Use realistic variable names
- Show common use cases first

## Summary Statistics

**Total Issues Found**: 15
- High Priority (Technical Accuracy): 2
- Medium Priority (Grammar/Typos): 8
- Low Priority (Clarity/Style): 5

**Files Affected**: 7
- R/boxplot.R
- R/discrete.R
- R/raster.R
- R/histogram.R
- R/dbbin.R
- README.Rmd
- (Plus multiple for "very generic dplyr")

**Estimated Time to Fix**:
- Phase 1 (Critical): 30-45 minutes
- Phase 2 (Grammar): 15-20 minutes
- Phase 3 (Clarity): 30-45 minutes
- **Total**: ~1.5-2 hours

## Positive Observations

### What's Already Good ✅

1. **Consistent structure** - All functions follow similar documentation patterns
2. **Good examples** - All functions have clear, runnable examples
3. **Modern R** - All examples use native pipe `|>`
4. **Package-level docs** - The `dbplot-package.R` documentation is excellent
5. **Clear parameters** - Most parameter descriptions are clear and helpful
6. **Good @seealso links** - Cross-references between related functions

## Conclusion

The documentation is generally well-structured and informative. The identified issues are mostly minor and easily fixable. Addressing these recommendations will improve clarity, consistency, and technical accuracy, resulting in better user experience and easier maintenance.

**Priority**: Focus on fixing the database support inconsistencies and technical accuracy issues first, then address grammar/typos, and finally improve clarity and style.
