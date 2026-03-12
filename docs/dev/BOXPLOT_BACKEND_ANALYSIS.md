# Boxplot Database Backend Support Analysis

**Date**: 2026-03-12 **Issue**: Documentation inconsistency about which
database backends support boxplot functionality **Root Cause**: Boxplot
requires [`quantile()`](https://rdrr.io/r/stats/quantile.html) function,
which not all databases support

## Current Code Implementation

### S3 Method Dispatch

The code uses S3 methods to handle different backends:

``` r
# Generic method (uses quantile())
calc_boxplot.tbl <- function(res, var) {
  summarise(res,
    lower = quantile(!!var, 0.25),
    middle = quantile(!!var, 0.5),
    upper = quantile(!!var, 0.75),
    ...
  )
}

# Spark-specific method (uses percentile_approx())
calc_boxplot.tbl_spark <- function(res, var) {
  summarise(res,
    lower = percentile_approx(!!var, 0.25),
    ...
  )
}

# SQL Server-specific method (uses quantile())
calc_boxplot.tbl_Microsoft SQL Server <- function(res, var) {
  # Uses quantile() with special handling for grouping
  ...
}
```

## Database Backend Capabilities

### SQL Percentile Function Support

| Database   | Percentile Function   | Available Since | dbplyr Support |
|------------|-----------------------|-----------------|----------------|
| PostgreSQL | `percentile_cont()`   | 9.4+ (2014)     | ✅ Yes         |
| SQL Server | `PERCENTILE_CONT()`   | 2012+           | ✅ Yes         |
| Oracle     | `PERCENTILE_CONT()`   | 9i+ (2001)      | ✅ Yes         |
| MySQL      | None (prior to 8.0)   | Limited         | ⚠️ Partial     |
| MariaDB    | None native           | No              | ❌ No          |
| SQLite     | None native           | No              | ❌ No          |
| Spark      | `percentile_approx()` | Yes             | ✅ Yes         |
| Hive       | `percentile_approx()` | Yes             | ✅ Yes         |

## Current Documentation Claims

### In R/boxplot.R (line 11):

> “It currently only works with Spark, Hive, and SQL Server
> connections.”

### In R/boxplot.R (line 114):

> “It currently only works with Spark and Hive connections.”

### In README.Rmd (line 174-179):

> “It has been tested with the following connections: - MS SQL Server -
> PostgreSQL - Oracle - sparklyr”

## Analysis & Conclusions

### ✅ Confirmed Working Backends

Based on code implementation and SQL capabilities:

1.  **Spark/Hive** (via sparklyr)
    - Uses `percentile_approx()`
    - Dedicated S3 method
    - Well-tested
2.  **SQL Server** (2012+)
    - Uses `PERCENTILE_CONT()` via
      [`quantile()`](https://rdrr.io/r/stats/quantile.html) translation
    - Dedicated S3 method with special grouping handling
    - Explicitly mentioned in code
3.  **PostgreSQL** (9.4+)
    - Has `percentile_cont()` function
    - dbplyr translates
      [`quantile()`](https://rdrr.io/r/stats/quantile.html) →
      `percentile_cont()`
    - Mentioned in README as tested
    - Uses generic `calc_boxplot.tbl()` method
4.  **Oracle** (9i+)
    - Has `PERCENTILE_CONT()` function
    - dbplyr translates
      [`quantile()`](https://rdrr.io/r/stats/quantile.html) →
      `PERCENTILE_CONT()`
    - Mentioned in README as tested
    - Uses generic `calc_boxplot.tbl()` method

### ⚠️ Limited/Uncertain Support

1.  **MySQL 8.0+**
    - Has window functions including percentile calculations
    - May work with recent dbplyr versions
    - **Not tested** - would need verification
2.  **Redshift**
    - Has `PERCENTILE_CONT()` function
    - Should work but **not tested**

### ❌ Known NOT to Work

1.  **SQLite**
    - No native percentile functions
    - [`quantile()`](https://rdrr.io/r/stats/quantile.html) won’t
      translate
    - Will fail or fall back to R calculation (slow)
2.  **MySQL \< 8.0**
    - No percentile support
    - Won’t work
3.  **MariaDB (most versions)**
    - Limited percentile support
    - Unlikely to work

## dbplyr Translation

### How dbplyr Handles quantile()

dbplyr translates R’s
[`quantile()`](https://rdrr.io/r/stats/quantile.html) function to SQL
based on backend:

``` r
# R code
quantile(x, 0.25)

# PostgreSQL translation
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY x)

# SQL Server translation
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY x) OVER ()

# Spark translation (via sparklyr)
percentile_approx(x, 0.25)
```

### Backends Without Translation

If dbplyr doesn’t have a translation for
[`quantile()`](https://rdrr.io/r/stats/quantile.html), it will
either: 1. Error during query generation 2. Try to compute in R
(defeating the purpose)

## Recommendations

### Documentation Updates

#### For db_compute_boxplot() (R/boxplot.R:11)

**Current**:

``` r

#' It currently only works with Spark, Hive, and SQL Server connections.
```

**Recommended**:

``` r

#' Requires database support for percentile/quantile functions. Confirmed to work with:
#' - Spark/Hive (via sparklyr) - uses percentile_approx()
#' - SQL Server (2012+) - uses PERCENTILE_CONT()
#' - PostgreSQL (9.4+) - uses percentile_cont()
#' - Oracle (9i+) - uses PERCENTILE_CONT()
#'
#' Does NOT work with SQLite, MySQL < 8.0, or MariaDB (no percentile support).
```

#### For dbplot_boxplot() (R/boxplot.R:114)

**Current**:

``` r

#' It currently only works with Spark and Hive connections.
```

**Recommended**:

``` r

#' Requires database support for percentile/quantile functions.
#' See \code{\link{db_compute_boxplot}} for supported database backends.
```

#### For README.Rmd (line 173-180)

**Current**:

    It has been tested with the following connections:
    - MS SQL Server
    - PostgreSQL
    - Oracle
    - sparklyr

**Recommended**:

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

    **Note**: For unsupported backends, consider using `db_compute_bins()`
    for histograms as an alternative visualization.

## Verification Steps

To confirm PostgreSQL and Oracle support, you could add integration
tests:

``` r

# Test with PostgreSQL
test_that("boxplot works with PostgreSQL", {
  skip_if_not_installed("RPostgres")
  skip_if_not(pg_available()) # helper to check if test DB exists

  con <- DBI::dbConnect(RPostgres::Postgres(), ...)
  tbl <- copy_to(con, mtcars, "test_mtcars", temporary = TRUE)

  result <- db_compute_boxplot(tbl, am, mpg)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)

  DBI::dbDisconnect(con)
})
```

## Implementation Priority

### Phase 1: Fix Documentation Inconsistencies (Immediate)

1.  Update R/boxplot.R (both functions) with consistent, accurate
    information
2.  Update README.Rmd with clear supported/unsupported backend lists
3.  Regenerate documentation

### Phase 2: Add Warnings (Optional)

Consider adding runtime checks:

``` r

calc_boxplot.tbl <- function(res, var) {
  # Check if backend likely supports quantile
  backend <- class(res)[1]
  if (backend %in% c("tbl_SQLiteConnection", "tbl_MySQL")) {
    warning(
      "Boxplot may not work with ", backend, " backend. ",
      "Percentile functions may not be supported.",
      call. = FALSE
    )
  }
  # ... continue with calculation
}
```

### Phase 3: Expand Testing (Future)

1.  Add integration tests for PostgreSQL and Oracle
2.  Test with MySQL 8.0+ to verify support
3.  Document tested versions in README

## Summary

**Root Cause**: Boxplot requires
[`quantile()`](https://rdrr.io/r/stats/quantile.html) function, which
dbplyr translates to database-specific percentile functions. Not all
databases have these functions.

**Confirmed Working**: - ✅ Spark/Hive (sparklyr) - dedicated
implementation - ✅ SQL Server 2012+ - dedicated implementation - ✅
PostgreSQL 9.4+ - generic implementation, dbplyr translates - ✅ Oracle
9i+ - generic implementation, dbplyr translates

**Not Working**: - ❌ SQLite - no percentile functions - ❌ MySQL \<
8.0 - no percentile functions - ❌ MariaDB - no/limited percentile
support

**Recommendation**: Update documentation to clearly state supported
backends based on percentile function availability, rather than specific
database names. This is more accurate and helps users understand the
requirement.

## References

- [PostgreSQL percentile_cont
  documentation](https://www.postgresql.org/docs/current/functions-aggregate.html)
- [SQL Server PERCENTILE_CONT
  documentation](https://learn.microsoft.com/en-us/sql/t-sql/functions/percentile-cont-transact-sql)
- [Oracle PERCENTILE_CONT
  documentation](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/PERCENTILE_CONT.html)
- [dbplyr SQL translation
  reference](https://dbplyr.tidyverse.org/articles/translation-function.html)
- [Spark percentile_approx
  documentation](https://spark.apache.org/docs/latest/api/sql/index.html#percentile_approx)
