# Snapshot Test

# Visual regression tests using testthat snapshot files

test_that("dbplot_histogram creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg)

  # Test plot structure
  expect_s3_class(p, "ggplot")

  # Visual snapshot - saves plot as PNG
  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "histogram-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_histogram with binwidth works", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_histogram(mpg, binwidth = 5)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "histogram-binwidth.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_bar creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "bar-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_bar with aggregation works", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_bar(am, avg_mpg = mean(mpg, na.rm = TRUE))

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "bar-aggregation.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_line creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_line(cyl)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "line-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_raster creates expected plot", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_faithful <- dplyr::copy_to(con, faithful, "faithful")

  p <- db_faithful |> dbplot_raster(eruptions, waiting)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "raster-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("dbplot_boxplot creates expected plot with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  p <- db_mtcars |> dbplot_boxplot(am, mpg)

  expect_s3_class(p, "ggplot")

  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(path, p, width = 7, height = 5)
  expect_snapshot_file(path, "boxplot-duckdb.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})
