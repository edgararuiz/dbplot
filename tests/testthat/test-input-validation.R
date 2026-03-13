# Snapshot Test

# Test input validation for invalid parameters

test_that("db_bin rejects invalid bins", {
  expect_error(db_bin(mpg, bins = 0), "must be greater than 0")
  expect_error(db_bin(mpg, bins = -5), "must be greater than 0")
})

test_that("db_bin rejects invalid binwidth", {
  expect_error(db_bin(mpg, binwidth = 0), "must be greater than 0")
  expect_error(db_bin(mpg, binwidth = -10), "must be greater than 0")
})

test_that("db_compute_bins rejects invalid bins", {
  expect_error(mtcars |> db_compute_bins(mpg, bins = 0), "must be greater than 0")
  expect_error(mtcars |> db_compute_bins(mpg, bins = -5), "must be greater than 0")
})

test_that("db_compute_bins rejects invalid binwidth", {
  expect_error(mtcars |> db_compute_bins(mpg, binwidth = 0), "must be greater than 0")
  expect_error(mtcars |> db_compute_bins(mpg, binwidth = -10), "must be greater than 0")
})

test_that("dbplot_histogram rejects invalid bins", {
  expect_error(mtcars |> dbplot_histogram(mpg, bins = 0), "must be greater than 0")
  expect_error(mtcars |> dbplot_histogram(mpg, bins = -5), "must be greater than 0")
})

test_that("dbplot_histogram rejects invalid binwidth", {
  expect_error(mtcars |> dbplot_histogram(mpg, binwidth = 0), "must be greater than 0")
  expect_error(mtcars |> dbplot_histogram(mpg, binwidth = -10), "must be greater than 0")
})

test_that("db_compute_raster rejects invalid resolution", {
  expect_error(faithful |> db_compute_raster(eruptions, waiting, resolution = 0), "must be greater than 0")
  expect_error(faithful |> db_compute_raster(eruptions, waiting, resolution = -5), "must be greater than 0")
})

test_that("dbplot_raster rejects invalid resolution", {
  expect_error(faithful |> dbplot_raster(eruptions, waiting, resolution = 0), "must be greater than 0")
  expect_error(faithful |> dbplot_raster(eruptions, waiting, resolution = -5), "must be greater than 0")
})
