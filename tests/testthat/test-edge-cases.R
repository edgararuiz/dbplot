# Snapshot Test

# Edge case tests for advanced features

test_that("db_compute_boxplot works with vars() syntax", {
  result <- mtcars |>
    db_compute_boxplot(vars(am, gear), mpg)

  expect_s3_class(result, "data.frame")
  expect_true("am" %in% names(result))
  expect_true("gear" %in% names(result))
})

test_that("dbplot_line works with single named aggregation", {
  # This exercises the length(vars) == 1 path
  p <- mtcars |>
    dbplot_line(cyl, avg_mpg = mean(mpg, na.rm = TRUE))

  expect_s3_class(p, "ggplot")
})
