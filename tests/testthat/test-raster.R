test_that("Setting the complete argument returns a ggplot", {
  expect_s3_class(dbplot_raster(mtcars, wt, mpg, complete = TRUE), "ggplot")
})


test_that("The correct number of rows are returned when using complete", {
  expect_equal(
    nrow(db_compute_raster(mtcars, wt, mpg, complete = TRUE)),
    600
  )
  expect_equal(
    nrow(db_compute_raster(mtcars,
      wt, mpg,
      complete = TRUE,
      resolution = 10
    )),
    80
  )
})

test_that("Compute raster 2 returns the right number of rows", {
  expect_equal(
    nrow(db_compute_raster2(mtcars, wt, mpg, complete = TRUE)),
    600
  )
  expect_equal(
    nrow(db_compute_raster2(mtcars,
      wt, mpg,
      complete = TRUE,
      resolution = 10
    )),
    80
  )
})

# Snapshot test for raster plot
test_that("dbplot_raster creates expected plot", {
  skip_on_cran()
  skip_on_ci()
  skip_if_not_installed("duckdb")

  set.seed(123)
  con <- DBI::dbConnect(duckdb::duckdb(), ":memory:")
  db_faithful <- dplyr::copy_to(con, faithful, "faithful")

  p <- db_faithful |> dbplot_raster(eruptions, waiting)

  expect_s3_class(p, "ggplot")

  save_plot_snapshot(p, "raster-basic.png")

  DBI::dbDisconnect(con, shutdown = TRUE)
})
