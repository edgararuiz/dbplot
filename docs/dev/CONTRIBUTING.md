# Contributing to dbplot

Thank you for considering contributing to dbplot! This document provides
guidelines and instructions for contributing to the project.

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](https://edgararuiz.github.io/dbplot/dev/CODE_OF_CONDUCT.md). By
participating in this project you agree to abide by its terms.

## How Can I Contribute?

### Reporting Bugs

Bugs are tracked as [GitHub
issues](https://github.com/edgararuiz/dbplot/issues). Before creating a
bug report, please check the existing issues to avoid duplicates.

When reporting a bug, please include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your R version and relevant package versions
- Database connection type (if applicable)
- Code examples (preferably using
  [`reprex::reprex()`](https://reprex.tidyverse.org/reference/reprex.html))

### Suggesting Enhancements

Enhancement suggestions are also tracked as [GitHub
issues](https://github.com/edgararuiz/dbplot/issues). When suggesting an
enhancement, please include:

- A clear and descriptive title
- A detailed description of the proposed enhancement
- Use cases and examples
- Any potential drawbacks or limitations

### Pull Requests

We actively welcome your pull requests! Please follow these steps:

1.  Fork the repository and create your branch from `main`
2.  Follow the development setup instructions below
3.  Make your changes following our code style guidelines
4.  Add or update tests as needed
5.  Ensure all tests pass
6.  Update documentation if needed
7.  Submit a pull request

## Development Setup

### Prerequisites

- R \>= 4.1.0
- RStudio (recommended)
- Git

### Installation

1.  Clone your fork of the repository:

``` bash
git clone https://github.com/YOUR_USERNAME/dbplot.git
cd dbplot
```

2.  Install development dependencies:

``` r

# Install devtools if not already installed
install.packages("devtools")

# Install package dependencies
devtools::install_deps(dependencies = TRUE)
```

3.  Load the package for development:

``` r

devtools::load_all()
```

## Testing Guidelines

### Running Tests

Run all tests with:

``` r

devtools::test()
```

Run a specific test file:

``` r

devtools::test_active_file()  # In RStudio with test file open
testthat::test_file("tests/testthat/test-histogram.R")
```

### Writing Tests

- Place tests in `tests/testthat/` with the prefix `test-`
- Use descriptive test names that explain what is being tested
- Use `test_that()` for individual test cases
- Test both expected behavior and error conditions
- Use testthat 3e patterns (no `context()`, use `expect_s3_class()`
  instead of `expect_is()`)

Example test structure:

``` r

test_that("dbplot_histogram creates correct number of bins", {
  result <- mtcars |>
    db_compute_bins(mpg, bins = 10)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 10)
})

test_that("dbplot_histogram validates bins parameter", {
  expect_error(
    mtcars |> dbplot_histogram(mpg, bins = -1),
    "`bins` must be greater than 0"
  )
})
```

### Test Coverage

We aim for \>70% test coverage. Check coverage with:

``` r

covr::package_coverage()
covr::report()  # Opens interactive report
```

## Code Style Guidelines

### General Principles

- Follow the [tidyverse style guide](https://style.tidyverse.org/)
- Write clear, readable code with meaningful variable names
- Add comments for complex logic, not obvious code
- Keep functions focused and single-purpose

### Specific Guidelines

**Naming Conventions:** - Functions: `snake_case` (e.g.,
`db_compute_bins`, `dbplot_histogram`) - Variables: `snake_case` -
Arguments: `snake_case`

**Spacing:**

``` r

# Good
result <- data |>
  filter(x > 0) |>
  summarise(mean = mean(y))

# Bad
result<-data|>filter(x>0)|>summarise(mean=mean(y))
```

**Pipes:** - Use native pipe `|>` (not `%>%`) - One pipe operation per
line for readability

**Function Documentation:** - Use roxygen2 comments (`#'`) - Include
`@param`, `@return`, `@examples` - Keep examples runnable and concise

**Tidy Evaluation:** - Use `enquo()` + `!!` for defusing and unquoting -
Use `enquos()` + `!!!` for `...` arguments - Use `:=` for dynamic column
naming - See `.github/RLANG_REVIEW.md` for patterns used in this package

### Code Formatting

Format your code before committing:

``` r

styler::style_pkg()
```

Check for common issues:

``` r

lintr::lint_package()
```

## Documentation

### Function Documentation

Update roxygen comments when adding or modifying functions:

``` r

#' Short description
#'
#' @description
#' Longer description if needed
#'
#' @param data A table (tbl)
#' @param x Variable name
#' @param bins Number of bins. Defaults to 30.
#'
#' @return A data frame with binned data
#'
#' @examples
#' mtcars |>
#'   db_compute_bins(mpg)
#'
#' @export
```

Regenerate documentation:

``` r

devtools::document()
```

### README and Vignettes

- Update README.Rmd (not README.md directly)
- Knit README.Rmd to regenerate README.md:

``` r

rmarkdown::render("README.Rmd")
```

## Package Checks

Before submitting a PR, ensure your changes pass all checks:

``` r

# Run all tests
devtools::test()

# Check package
devtools::check()

# Check code coverage
covr::package_coverage()

# Check URLs
urlchecker::url_check()

# Check spelling
spelling::spell_check_package()
```

All checks should pass with: - 0 errors - 0 warnings - 0 notes (if
possible)

## Git Workflow

### Branch Naming

Use descriptive branch names: - `feature/add-violin-plot` -
`fix/histogram-bin-validation` - `docs/improve-readme-examples`

### Commit Messages

Write clear commit messages:

    Short summary (50 chars or less)

    More detailed explanation if needed. Wrap at 72 characters.

    - Bullet points are fine
    - Reference issues: Fixes #123

### Pull Request Process

1.  Update the NEWS.md file with a brief description of your changes
2.  Ensure all tests pass and package checks are clean
3.  Update documentation as needed
4.  Request a review from maintainers
5.  Address any review feedback
6.  Once approved, a maintainer will merge your PR

## Additional Resources

- [R Packages book](https://r-pkgs.org/) - Comprehensive guide to R
  package development
- [tidyverse style guide](https://style.tidyverse.org/) - Code style
  conventions
- [Tidy evaluation](https://tidyeval.tidyverse.org/) - Programming with
  dplyr/tidyverse
- [testthat documentation](https://testthat.r-lib.org/) - Testing
  framework

## Questions?

If you have questions about contributing, please: - Open an issue for
discussion - Check existing issues and PRs - Read through this guide and
linked resources

Thank you for contributing to dbplot! 🎉
