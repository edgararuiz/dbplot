# NA

## Description

Please include a summary of the changes and which issue is fixed (if
applicable).

Fixes \#(issue)

## Type of Change

Please delete options that are not relevant.

Bug fix (non-breaking change which fixes an issue)

New feature (non-breaking change which adds functionality)

Breaking change (fix or feature that would cause existing functionality
to not work as expected)

Documentation update

Code refactoring (no functional changes)

Performance improvement

Test coverage improvement

## Changes Made

Please provide a detailed description of the changes:

- 
- 
- 

## Testing

Please describe the tests you ran to verify your changes:

All existing tests pass (`devtools::test()`)

Added new tests for new functionality

Tested with different database backends (if applicable)

Tested with different R versions (if applicable)

### Test Output

``` r
# Paste relevant test output here
devtools::test()
# ✓ | F W S  OK | Context
# ...
```

## Checklist

My code follows the style guidelines of this project (see
CONTRIBUTING.md)

I have performed a self-review of my own code

I have commented my code, particularly in hard-to-understand areas

I have made corresponding changes to the documentation

I have updated roxygen comments and regenerated docs
(`devtools::document()`)

My changes generate no new warnings or errors

I have added tests that prove my fix is effective or that my feature
works

New and existing unit tests pass locally with my changes

I have updated NEWS.md with a description of changes

I have checked my code passes R CMD check (`devtools::check()`)

I have run `styler::style_pkg()` to format the code

## Package Check Results

``` r
# Paste output from devtools::check()
devtools::check()
# ── R CMD check results ─────────────────────────
# Duration: ...
# 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

## Screenshots (if applicable)

If your changes affect plots or visual output, please include
before/after screenshots.

## Breaking Changes

If this PR introduces breaking changes, please describe:

- What breaks?
- Why was this necessary?
- How can users update their code?

## Additional Context

Add any other context about the pull request here.

## Related Issues/PRs

- Related to \#
- Depends on \#
- Supersedes \#
