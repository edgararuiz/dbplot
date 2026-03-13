# Snapshot Test

test_that("db_compute_bins works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_bins(mpg)

  expect_s3_class(result, "data.frame")
  expect_true("mpg" %in% names(result))
  expect_true("count" %in% names(result))
  expect_true(nrow(result) > 0) # has bins

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_count works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_count(am)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2) # am has 2 levels
  expect_true("am" %in% names(result))

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_raster works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_faithful <- dplyr::copy_to(con, faithful, "faithful")

  result <- db_faithful |> db_compute_raster(eruptions, waiting)

  expect_s3_class(result, "data.frame")
  expect_true("eruptions" %in% names(result))
  expect_true("waiting" %in% names(result))
  expect_equal(ncol(result), 3) # has x, y, and aggregation column

  DBI::dbDisconnect(con, shutdown = TRUE)
})

test_that("db_compute_boxplot works with DuckDB", {
  skip_on_cran()
  skip_if_not_installed("duckdb")

  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_mtcars <- dplyr::copy_to(con, mtcars, "mtcars")

  result <- db_mtcars |> db_compute_boxplot(am, mpg)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2) # am has 2 levels
  expect_true(all(c("lower", "middle", "upper", "ymin", "ymax") %in% names(result)))

  DBI::dbDisconnect(con, shutdown = TRUE)
})
