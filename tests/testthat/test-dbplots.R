test_that("A ggplot2 object is returned", {
  expect_s3_class(dbplot_bar(mtcars, am), "ggplot")
  expect_s3_class(dbplot_bar(mtcars, am, mean(wt)), "ggplot")
  expect_s3_class(dbplot_line(mtcars, am), "ggplot")
  expect_s3_class(dbplot_histogram(mtcars, mpg), "ggplot")
  expect_s3_class(dbplot_raster(mtcars, wt, mpg), "ggplot")
})

test_that("No warnings or errors are returned", {
  expect_silent(dbplot_bar(mtcars, am))
  expect_silent(dbplot_bar(mtcars, am, mean(wt)))
  expect_silent(dbplot_line(mtcars, am))
  expect_silent(dbplot_histogram(mtcars, mpg))
  expect_silent(dbplot_raster(mtcars, wt, mpg))
})

# Snapshot tests for histogram
test_that("dbplot_histogram creates expected plot", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg)

  # Test plot structure
  expect_s3_class(p, "ggplot")

  # Visual snapshot - only runs locally, not on CI
  save_plot_snapshot(p, "histogram-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_histogram with binwidth works", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg, binwidth = 5)

  expect_s3_class(p, "ggplot")

  save_plot_snapshot(p, "histogram-binwidth.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})
