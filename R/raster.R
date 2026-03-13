#' Aggregates intersections of two variables
#'
#' @description
#'
#' To visualize two continuous variables, we typically resort to a Scatter plot. However,
#' this may not be practical when visualizing millions or billions of dots representing the
#' intersections of the two variables. A Raster plot may be a better option,
#' because it concentrates the intersections into squares that are easier to parse visually.
#'
#' Uses dplyr operations to aggregate data. Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @details
#'
#' There are two considerations when using a Raster plot with a database. Both considerations are related
#' to the size of the results downloaded from the database:
#'
#' - The number of bins requested: The higher the bins value is, the more data is downloaded from the database.
#'
#' - How concentrated the data is: This refers to how many intersections return a value. The more
#' intersections without a value, the less data is downloaded from the database.
#'
#' @param data A table (tbl)
#' @param x A continuous variable
#' @param y A continuous variable
#' @param fill The aggregation formula. Defaults to count (n)
#' @param resolution The number of bins created per variable. The higher the number, the more records
#' will be imported from the source
#' @param complete Uses tidyr::complete to include empty bins. Inserts value of 0.
#'
#' @returns An ungrouped data.frame with three columns: the x variable bins, the y variable
#'   bins, and the aggregated fill values for each x-y intersection.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_faithful <- copy_to(con, faithful, "faithful")
#'
#' # Returns a 100x100 grid of record count of intersections of eruptions and waiting
#' db_faithful |>
#'   db_compute_raster(eruptions, waiting)
#'
#' # Returns a 50x50 grid of eruption averages of intersections of eruptions and waiting
#' db_faithful |>
#'   db_compute_raster(eruptions, waiting, fill = mean(eruptions), resolution = 50)
#'
#' dbDisconnect(con)
#' }
#' @export
db_compute_raster <- function(
  data,
  x,
  y,
  fill = n(),
  resolution = 100,
  complete = FALSE
) {
  if (resolution <= 0) {
    stop("`resolution` must be greater than 0", call. = FALSE)
  }

  x <- enquo(x)
  y <- enquo(y)
  fillname <- enquo(fill)

  xf <- db_bin(
    !!x,
    bins = resolution
  )

  yf <- db_bin(
    !!y,
    bins = resolution
  )

  df <- group_by(
    data,
    x = !!xf,
    y = !!yf
  )
  df <- summarise(df, fillname = !!fillname)
  df <- collect(df)
  df <- ungroup(df)
  df <- mutate(df, fillname = as.numeric(fillname))
  colnames(df) <- c(
    quo_name(x),
    quo_name(y),
    quo_name(fillname)
  )

  if (complete) {
    df <- tidyr::complete(
      data = df,
      !!x,
      !!y,
      fill = list(`n()` = 0)
    )
  }
  df
}

#' @rdname db_compute_raster
#' @returns For `db_compute_raster2`: A data.frame with five columns - the x and y variable
#'   bins, the fill values, and additional columns for the upper bounds of each bin
#'   (x_2 and y_2), useful for defining precise tile boundaries.
#' @export
db_compute_raster2 <- function(
  data,
  x,
  y,
  fill = n(),
  resolution = 100,
  complete = FALSE
) {
  x <- enquo(x)
  y <- enquo(y)
  fill <- enquo(fill)
  cr <- db_compute_raster(
    data,
    !!x,
    !!y,
    !!fill,
    resolution,
    complete
  )
  size_x <- bin_size(cr, !!x)
  size_y <- bin_size(cr, !!y)
  mutate(
    cr,
    !!paste0(quo_name(x), "_2") := !!x + size_x,
    !!paste0(quo_name(y), "_2") := !!y + size_y
  )
}

#' Raster plot
#'
#' @description
#'
#' To visualize two continuous variables, we typically resort to a Scatter plot. However,
#' this may not be practical when visualizing millions or billions of dots representing the
#' intersections of the two variables. A Raster plot may be a better option,
#' because it concentrates the intersections into squares that are easier to parse visually.
#'
#' Uses dplyr operations to aggregate data and ggplot2 to create
#' a raster plot. Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @details
#'
#' There are two considerations when using a Raster plot with a database. Both considerations are related
#' to the size of the results downloaded from the database:
#'
#' - The number of bins requested: The higher the bins value is, the more data is downloaded from the database.
#'
#' - How concentrated the data is: This refers to how many intersections return a value. The more intersections
#' without a value,
#' the less data is downloaded from the database.
#'
#' @param data A table (tbl)
#' @param x A continuous variable
#' @param y A continuous variable
#' @param fill The aggregation formula. Defaults to count (n)
#' @param resolution The number of bins created per variable. The higher the number, the more records
#' will be imported from the source
#' @param complete Uses tidyr::complete to include empty bins. Inserts value of 0.
#'
#' @returns A ggplot object displaying a raster/heatmap plot of the aggregated data
#'   across the two continuous variables.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' library(ggplot2)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_faithful <- copy_to(con, faithful, "faithful")
#'
#' # Returns a 100x100 raster plot of record count of intersections of eruptions and waiting
#' db_faithful |>
#'   dbplot_raster(eruptions, waiting)
#'
#' # Returns a 50x50 raster plot of eruption averages of intersections of eruptions and waiting
#' db_faithful |>
#'   dbplot_raster(eruptions, waiting, fill = mean(eruptions), resolution = 50)
#'
#' dbDisconnect(con)
#' }
#' @seealso
#' \code{\link{dbplot_bar}}, \code{\link{dbplot_line}} ,
#' \code{\link{dbplot_histogram}}
#'
#' @export
dbplot_raster <- function(
  data,
  x,
  y,
  fill = n(),
  resolution = 100,
  complete = FALSE
) {
  if (resolution <= 0) {
    stop("`resolution` must be greater than 0", call. = FALSE)
  }

  x <- enexpr(x)
  y <- enexpr(y)
  fillname <- enexpr(fill)

  df <- db_compute_raster(
    data = data,
    x = !!x,
    y = !!y,
    fill = !!fillname,
    resolution = resolution,
    complete = complete
  )

  colnames(df) <- c("x", "y", "fill")

  ggplot(df) +
    geom_tile(aes(x, y, fill = fill)) +
    labs(
      x = x,
      y = y
    ) +
    scale_fill_continuous(name = fillname)
}
