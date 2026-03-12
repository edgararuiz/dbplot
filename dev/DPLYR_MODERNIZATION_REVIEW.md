# dplyr Modernization Review - dbplot Package

**Date**: 2026-03-12 **dplyr Version**: \>= 1.0.0 **Status**: ✅
COMPLETE

## Summary

The dbplot package has been reviewed for modern dplyr patterns. All
user-facing examples and documentation have been updated to use current
best practices.

## Changes Made

### ✅ Fixed: `tally()` → `count()`

**File**: `R/dbbin.R`

**Before**:

``` r
mtcars |>
  group_by(x = !!db_bin(mpg)) |>
  tally()
```

**After**:

``` r
mtcars |>
  group_by(x = !!db_bin(mpg)) |>
  count()
```

**Rationale**: `count()` is the modern, recommended approach. `tally()`
is not deprecated but `count()` is more explicit and flexible.

### ✅ Already Modern: Native Pipe `|>`

All examples and documentation use the native pipe `|>` (R \>= 4.1.0)
instead of `%>%`. This was completed in Phase 1.

## Patterns Reviewed

### ✅ No Deprecated dplyr Functions

Searched for and confirmed **NO usage** of: - `tally()` - ✅ Fixed
(changed to `count()`) - `group_by_()`, `mutate_()`, `select_()`, etc. -
✅ None found (old SE functions) - `group_by_at()`, `mutate_at()`,
`select_at()` - ✅ None found (scoped verbs) - `mutate_if()`,
`select_if()` - ✅ None found - `mutate_all()`, `select_all()` - ✅ None
found - `funs()` - ✅ None found (old function list syntax)

### ✅ Modern Patterns Already in Use

The package correctly uses: - `count()` for counting by groups - `n()`
for inline counting in aggregations - Native pipe `|>` throughout -
Modern tidy evaluation (`enquo()`, `!!`, `!!!`) - Dynamic naming with
`:=`

## Internal Code Style

### Current Approach (Sequential Assignment)

Many functions use this pattern:

``` r
res <- select(data, !!x)
res <- count(res, !!x := !!xf)
res <- collect(res)
res <- ungroup(res)
rename(res, count = n)
```

### Modern Alternative (Piped)

Could be written as:

``` r
data |>
  select(!!x) |>
  count(!!x := !!xf) |>
  collect() |>
  ungroup() |>
  rename(count = n)
```

**Decision**: ✅ **Keep current style**

**Rationale**: 1. Sequential assignment is clearer for debugging (can
inspect `res` at each step) 2. Style is consistent throughout the
package 3. Both approaches are valid modern R 4. Internal code style is
less critical than user-facing examples 5. Current approach may be more
readable for contributors less familiar with pipes

## Database Compatibility Considerations

### Features NOT Used (Intentionally)

These modern dplyr features are **not appropriate** for dbplot because
they don’t work reliably with database backends:

#### ❌ `.by` Argument (dplyr 1.1.0+)

``` r
# Modern, but doesn't work with dbplyr
data |> summarise(mean = mean(x), .by = group)

# Current approach (works with databases)
data |> group_by(group) |> summarise(mean = mean(x))
```

#### ❌ `reframe()` (dplyr 1.1.0+)

``` r
# Doesn't work well with dbplyr
data |> reframe(values = quantile(x, probs = c(0.25, 0.5, 0.75)))

# Current approach works
data |> summarise(q25 = quantile(x, 0.25), ...)
```

#### ❌ `pick()` (dplyr 1.1.0+)

``` r
# Modern selection, limited dbplyr support
data |> mutate(across(pick(x, y), mean))

# Current approach more reliable
```

#### ⚠️ `drop_na()` (tidyr)

``` r
# May not translate well to SQL
data |> drop_na(x)

# Current approach (explicit, translates to SQL)
data |> filter(!is.na(x))
```

## Examples in Documentation

### ✅ All Examples Modern

Verified that all user-facing examples use: - Native pipe `|>` (not
`%>%`) - `count()` (not `tally()`) - Modern dplyr patterns - Clear,
explicit code

## Test Code

### Test Suite Already Modern

Tests use: - testthat 3e edition - Modern expectations
(`expect_s3_class()` not `expect_is()`) - Native pipe where
appropriate - Modern dplyr patterns

## Recommendations

### ✅ Current Status: EXCELLENT

1.  All user-facing code uses modern dplyr patterns
2.  Internal code is clear and maintainable
3.  Database compatibility is prioritized appropriately
4.  No deprecated functions in use

### 🔄 Optional Future Considerations

1.  **Internal code style** - Could convert to piped style if desired
    (purely cosmetic)
2.  **Monitor dbplyr support** - As dbplyr adds support for newer dplyr
    features, consider adoption
3.  **Keep examples current** - Continue using latest recommended
    patterns in documentation

### ❌ Do NOT Change

1.  Don’t use `.by` argument - doesn’t work with dbplyr
2.  Don’t use `reframe()` - limited database support
3.  Don’t use `drop_na()` for database data - use explicit
    `filter(!is.na())`
4.  Keep explicit `group_by()` for clarity and compatibility

## Testing Results

### ✅ All Tests Pass

``` r
devtools::test()
# ℹ Testing dbplot
# [ FAIL 0 | WARN 0 | SKIP 0 | PASS 29 ]
```

### ✅ Package Checks Pass

``` r
devtools::check()
# 0 errors ✔ | 0 warnings ✔ | 1 note ✖ (time check only)
```

## Files Modified

1.  `R/dbbin.R` - Updated examples: `tally()` → `count()`
2.  `man/db_bin.Rd` - Regenerated documentation

## References

- [dplyr 1.0.0 release
  notes](https://www.tidyverse.org/blog/2020/06/dplyr-1-0-0/)
- [dplyr 1.1.0 release
  notes](https://www.tidyverse.org/blog/2023/01/dplyr-1-1-0-is-out/)
- [dbplyr documentation](https://dbplyr.tidyverse.org/)
- [Programming with
  dplyr](https://dplyr.tidyverse.org/articles/programming.html)

## Conclusion

**The dbplot package uses modern dplyr patterns appropriately.** All
user-facing examples and documentation have been updated to current best
practices. Internal code prioritizes clarity and database compatibility
over stylistic preferences. The package is ready for release with modern
dplyr \>= 1.0.0 dependency.
