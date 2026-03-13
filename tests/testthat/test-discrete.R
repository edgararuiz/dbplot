test_that("Multiple aggregations are supported", {
  expect_equal(
    ncol(db_compute_count(mtcars,
      am,
      sum_wt = sum(wt),
      sum_mpg = sum(mpg)
    )),
    3
  )
})

test_that("Multiple aggregations work with bar plots", {
  x <- dbplot_bar(mtcars,
    am,
    sum_wt = sum(wt), sum_mpg = sum(mpg)
  )
  expect_type(x, "list")
  expect_s3_class(x[[1]], "ggplot")
})

test_that("Multiple aggregations work with line plots", {
  x <- dbplot_line(mtcars,
    am,
    sum_wt = sum(wt), sum_mpg = sum(mpg)
  )
  expect_type(x, "list")
  expect_s3_class(x[[1]], "ggplot")
})

# Snapshot tests for bar plots
test_that("dbplot_bar creates expected plot", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am)

  expect_s3_class(p, "ggplot")

  save_plot_snapshot(p, "bar-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_bar with aggregation works", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am, avg_mpg = mean(mpg, na.rm = TRUE))

  expect_s3_class(p, "ggplot")

  save_plot_snapshot(p, "bar-aggregation.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

# Snapshot tests for line plots
test_that("dbplot_line creates expected plot", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_line(cyl)

  expect_s3_class(p, "ggplot")

  save_plot_snapshot(p, "line-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})
