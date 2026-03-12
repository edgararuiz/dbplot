---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: ''

---

## Description

A clear and concise description of what the bug is.

## Reproducible Example

Please provide a minimal reproducible example using the `reprex` package:

```r
# Your code here
library(dbplot)
library(dplyr)

# Example that reproduces the issue
```

If you don't have `reprex` installed, you can install it with `install.packages("reprex")` and create a reproducible example with `reprex::reprex()`.

## Expected Behavior

What did you expect to happen?

## Actual Behavior

What actually happened? Include any error messages.

## Environment

Please provide information about your environment:

- dbplot version: [e.g., 0.4.0]
- R version: [Run `R.version.string`]
- Operating System: [e.g., macOS 13, Windows 11, Ubuntu 22.04]
- Database type: [e.g., SQLite, PostgreSQL, SQL Server, Spark]
- dplyr version: [Run `packageVersion("dplyr")`]
- dbplyr version (if using database): [Run `packageVersion("dbplyr")`]

## Additional Context

Add any other context about the problem here, such as:
- Does this work in earlier versions?
- Are there specific database configurations involved?
- Screenshots or plots showing the issue (if applicable)
