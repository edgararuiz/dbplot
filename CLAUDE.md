# Claude Code Instructions for dbplot

## Command Preferences

- **Consistent `tail` values**: Use `tail -20` as default for most commands
- Only vary when explicitly needed (e.g., very long build logs require `tail -50`)
- This prevents unnecessary permission prompts for similar commands

## Project Context

This is an R package for visualizing data inside databases. Key conventions:

### Code Style
- Use native pipe `|>` (not `%>%`)
- Use `dplyr` operations (not "very generic dplyr code")
- All examples should be runnable

### Documentation
- README.md is generated from README.Rmd - always edit the .Rmd file
- Use `devtools::document()` after changing roxygen comments
- Knit README.Rmd after making changes

### Testing
- All tests should pass before commits
- Use testthat 3e edition patterns
- Run `devtools::check()` to verify package quality

### pkgdown Site
- Template: Bootstrap 5 with Yeti theme and light-switch
- No custom CSS (use theme defaults)
- Build with `pkgdown::build_site()`

### Community
- CODE_OF_CONDUCT.md and CONTRIBUTING.md provide guidelines
- Planning documents in `.github/` are for maintainer reference

## Development Workflow

```r
# Standard workflow
devtools::load_all()        # Load package
devtools::test()            # Run tests
devtools::check()           # Full package check
devtools::document()        # Regenerate docs
pkgdown::build_site()       # Rebuild website
```

## Package Requirements

- R >= 4.1.0
- dplyr >= 1.0.0
- ggplot2 >= 3.3.0
- rlang >= 1.0.0

## Database Support

Functions work with:
- Standard DBI/dbplyr connections (DuckDB, PostgreSQL, SQL Server, Oracle)
- Spark connections via sparklyr

Examples use DuckDB (not SQLite) for better performance and boxplot support.

Note: Boxplot functions require database percentile function support.
Supported: DuckDB, PostgreSQL, SQL Server, Oracle, Spark/Hive
Not supported: SQLite, MySQL < 8.0, MariaDB
