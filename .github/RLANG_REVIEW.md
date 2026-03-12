# rlang Patterns Review - dbplot Package

**Date**: 2026-03-12
**rlang Version**: 1.0+ compatible
**Status**: ✅ PASSED - All patterns are correct and compatible

## Executive Summary

The dbplot package uses tidy evaluation correctly and is fully compatible with rlang 1.0+. All patterns follow best practices, and no deprecated APIs are in use.

## Tidy Evaluation Patterns Used

### 1. ✅ `enquo()` + `!!` Pattern
**Purpose**: Capture and unquote function arguments
**Files**: All R files
**Status**: CORRECT

```r
# Pattern
x <- enquo(x)
group_by(data, !!x)

# Modern alternative: {{ x }}
# Current pattern is preferred when:
# - Passing quosures between functions
# - Need to use quo_name() for labels
# - Code clarity and explicitness
```

**Examples**:
- `R/discrete.R:30-33` - db_compute_count()
- `R/boxplot.R:27-36` - db_compute_boxplot()
- `R/raster.R:56-58` - db_compute_raster()

### 2. ✅ `enexpr()` Pattern
**Purpose**: Capture raw expressions (for plot labeling)
**Files**: histogram.R, raster.R
**Status**: CORRECT (fixed incompatibility with quo_name)

```r
# Pattern
x <- enexpr(x)
labs(x = as_label(x))  # ✅ Correct: use as_label() with expressions

# Previously was using quo_name() which expects quosures
```

**Examples**:
- `R/histogram.R:92` - dbplot_histogram() ✅ Fixed to use as_label()
- `R/raster.R:189-191` - dbplot_raster()

### 3. ✅ `enquos()` + `!!!` Pattern
**Purpose**: Capture and splice multiple arguments from `...`
**Files**: discrete.R
**Status**: CORRECT

```r
# Pattern
vars <- enquos(...)
summarise(res, !!!vars)
```

**Examples**:
- `R/discrete.R:32,35` - db_compute_count()
- `R/discrete.R:82,87` - dbplot_bar()
- `R/discrete.R:167,172` - dbplot_line()

### 4. ✅ Dynamic Column Naming with `:=`
**Purpose**: Create columns with computed names
**Files**: histogram.R, raster.R
**Status**: CORRECT

```r
# Pattern
count(res, !!x := !!xf)  # Dynamic left-hand side naming
!!paste0(quo_name(x), "_2") := !!x + size_x  # Computed column names
```

**Examples**:
- `R/histogram.R:46` - Using `:=` for dynamic grouping
- `R/raster.R:121-122` - Creating computed column names

### 5. ✅ Advanced: `quo_squash()` Pattern
**Purpose**: Remove one level of quoting for complex expression building
**Files**: dbbin.R
**Status**: CORRECT - necessary for formula construction

```r
# Pattern
var <- enquo(var)
var <- quo_squash(var)  # Extract expression from quosure
range <- expr((max(!!var, na.rm = TRUE) - min(!!var, na.rm = TRUE)))
```

**Example**:
- `R/dbbin.R:36-55` - Building binning formula programmatically

### 6. ✅ `quo_name()` Pattern
**Purpose**: Extract symbol name from quosure for labeling
**Files**: raster.R, discrete.R
**Status**: CORRECT

```r
# Pattern
x <- enquo(x)
quo_name(x)  # Get the name as string
```

**Examples**:
- `R/raster.R:76-79,121-122` - Column naming in db_compute_raster()
- `R/discrete.R:115,200` - Plot labeling in dbplot functions

## Compatibility Check

### ✅ No Deprecated APIs
Confirmed NO usage of deprecated rlang patterns:
- ❌ `UQ()`, `UQS()`, `UQE()` - Old unquoting operators (now use `!!`, `!!!`)
- ❌ `quo_text()` - Deprecated (now use `quo_name()` or `as_label()`)
- ❌ `lang_*()`, `is_lang()` - Deprecated (now use `call_*()`, `is_call()`)

### ✅ Modern rlang 1.0+ APIs
All APIs used are current:
- ✅ `enquo()`, `enexpr()`, `enquos()` - Defusal operators
- ✅ `!!`, `!!!` - Injection operators
- ✅ `:=` - Definition operator
- ✅ `quo_name()`, `as_label()` - Name extraction
- ✅ `quo_squash()` - Advanced quosure manipulation
- ✅ `expr()` - Expression creation

## Optional Modernization with `{{ }}`

The **embrace operator** `{{ }}` is syntactic sugar that combines `enquo()` + `!!`:

### Could Use {{ }} (Optional)
```r
# Current
db_compute_count <- function(data, x, ..., y = n()) {
  x <- enquo(x)
  res <- group_by(data, !!x)
  ...
}

# Modern alternative
db_compute_count <- function(data, x, ..., y = n()) {
  res <- group_by(data, {{ x }})
  ...
}
```

### Should NOT Use {{ }} (Current Pattern Preferred)
1. **When passing between functions**:
   ```r
   x <- enquo(x)
   db_compute_foo(data, !!x)  # Explicit quosure passing
   ```

2. **When using quo_name()**:
   ```r
   x <- enquo(x)
   labs(x = quo_name(x))  # Need the quosure object
   ```

3. **When using quo_squash()**:
   ```r
   var <- enquo(var)
   var <- quo_squash(var)  # Advanced manipulation
   ```

## Recommendations

### ✅ Current Status: EXCELLENT
1. All patterns are **correct and compatible** with rlang 1.0+
2. Code is **explicit and clear** about what's happening
3. No deprecated APIs in use
4. Proper use of advanced features (quo_squash, dynamic naming)

### 🔄 Optional Future Improvements
1. **Consider `{{ }}` for simple cases** - purely cosmetic improvement
2. **Add comments for complex patterns** - especially in db_bin()
3. **Document rlang patterns** - add to package documentation

### ❌ Do Not Change
1. Keep `quo_squash()` pattern in db_bin() - necessary for formula construction
2. Keep explicit `enquo()` when using `quo_name()` - required for name extraction
3. Keep explicit `enquo()` + `!!` when passing between functions - clearer intent

## Testing with rlang 1.0+

### ✅ Verified Compatibility
- Package builds successfully with current rlang (1.0+)
- All tests pass (29 tests)
- R CMD check: 0 errors, 0 warnings, 0 notes
- No rlang-related deprecation warnings

### Testing Commands Used
```r
devtools::test()        # All 29 tests pass
devtools::check()       # Clean check
```

## Conclusion

**The dbplot package uses tidy evaluation correctly and is fully compatible with rlang 1.0+.** All patterns follow best practices, and the code is production-ready. Optional modernization to `{{ }}` syntax would be purely cosmetic and is not necessary.

## References

- [rlang 1.0.0 announcement](https://www.tidyverse.org/blog/2022/03/rlang-1-0-0/)
- [Tidy evaluation book](https://tidyeval.tidyverse.org/)
- [Programming with dplyr](https://dplyr.tidyverse.org/articles/programming.html)
