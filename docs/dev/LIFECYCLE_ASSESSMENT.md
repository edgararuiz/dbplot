# Lifecycle Package Assessment - dbplot

**Date**: 2026-03-12 **Status**: ❌ NOT NEEDED

## Assessment Summary

The `lifecycle` package is **not required** for dbplot at this time.
There are no deprecated, superseded, or experimental functions that need
lifecycle badges.

## Current Function Status

### All Functions Active ✅

The package exports 13 functions/methods, all of which are actively
supported:

**Computation Functions:** -
[`db_compute_bins()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_bins.md) -
Active -
[`db_compute_boxplot()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_boxplot.md) -
Active -
[`db_compute_count()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_count.md) -
Active -
[`db_compute_raster()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_raster.md) -
Active -
[`db_compute_raster2()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_raster.md) -
Active

**Plot Functions:** -
[`dbplot_histogram()`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_histogram.md) -
Active -
[`dbplot_boxplot()`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_boxplot.md) -
Active -
[`dbplot_bar()`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_bar.md) -
Active -
[`dbplot_line()`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_line.md) -
Active -
[`dbplot_raster()`](https://edgararuiz.github.io/dbplot/dev/reference/dbplot_raster.md) -
Active

**Utility Functions:** -
[`db_bin()`](https://edgararuiz.github.io/dbplot/dev/reference/db_bin.md) -
Active

**S3 Methods:** - `db_compute_boxplot.tbl_spark()` - Active -
`db_compute_boxplot.tbl_sql()` - Active

### No Deprecated Functions ✅

Search results for deprecation-related terms:

``` r

# grep -i "deprecated|superseded|defunct|replace" R/*.R
# Result: No matches found
```

### No Breaking Function Changes ✅

Review of NEWS.md shows: - No function renamings - No function
replacements - No superseded functionality - Breaking changes are
limited to: - Removal of `%>%` re-export (not a function deprecation) -
Increased minimum versions (dependency change, not function change)

## When Lifecycle Would Be Needed

The `lifecycle` package should be added IF any of these occur:

1.  **Deprecating a function**: Mark with
    [`lifecycle::deprecate_warn()`](https://lifecycle.r-lib.org/reference/deprecate_soft.html)

    ``` r

    #' @description
    #' `r lifecycle::badge("deprecated")`
    #'
    #' This function has been deprecated. Use [new_function()] instead.
    ```

2.  **Superseding a function**: Mark with
    `lifecycle::badge("superseded")`

    ``` r

    #' @description
    #' `r lifecycle::badge("superseded")`
    #'
    #' This function has been superseded by [new_function()].
    ```

3.  **Experimental features**: Mark with
    `lifecycle::badge("experimental")`

    ``` r

    #' @description
    #' `r lifecycle::badge("experimental")`
    ```

4.  **Soft-deprecation**: Argument deprecation

    ``` r

    if (lifecycle::is_present(old_arg)) {
      lifecycle::deprecate_warn("1.0.0", "func(old_arg)", "func(new_arg)")
    }
    ```

## Examples of Future Scenarios

### Scenario 1: Renaming a Function

If we decided to rename
[`db_compute_bins()`](https://edgararuiz.github.io/dbplot/dev/reference/db_compute_bins.md)
to `compute_bins()`:

``` r

#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' This function has been deprecated. Use [compute_bins()] instead.
#' @export
db_compute_bins <- function(...) {
  lifecycle::deprecate_warn("0.5.0", "db_compute_bins()", "compute_bins()")
  compute_bins(...)
}
```

### Scenario 2: Changing Argument Name

If we wanted to rename `binwidth` to `bin_width`:

``` r

db_bin <- function(var, bins = 30, binwidth = lifecycle::deprecated(),
                   bin_width = NULL) {
  if (lifecycle::is_present(binwidth)) {
    lifecycle::deprecate_warn("0.5.0", "db_bin(binwidth)", "db_bin(bin_width)")
    bin_width <- binwidth
  }
  # ... rest of function
}
```

## Recommendation

**Do NOT add lifecycle at this time** because:

1.  ✅ All functions are actively supported
2.  ✅ No deprecation warnings needed
3.  ✅ No experimental features
4.  ✅ Clean API with no redundant functions
5.  ✅ Avoids unnecessary dependencies

**Instead, proceed with:** - Creating package-level documentation
(`R/dbplot-package.R`) - Documenting minimum versions and
compatibility - Keeping lifecycle in mind for future API changes

## Future Considerations

If any of these situations arise in the future, revisit this assessment:

Planning to deprecate a function

Planning to rename a function

Adding experimental features

Changing argument names (breaking change)

Superseding functionality with better alternatives

## References

- [lifecycle package documentation](https://lifecycle.r-lib.org/)
- [Managing change in R
  packages](https://lifecycle.r-lib.org/articles/manage.html)
- [tidyverse lifecycle
  stages](https://lifecycle.r-lib.org/articles/stages.html)

## Conclusion

**The lifecycle package is not currently needed for dbplot.** The
package has a clean, stable API with no deprecated or superseded
functions. This assessment should be revisited if any API changes are
planned in the future.
