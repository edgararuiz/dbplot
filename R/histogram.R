#' Calculate histogram bins
#'
#' @description
#'
#' Uses dplyr operations to create histogram bins.
#' Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @param data A table (tbl)
#' @param x A continuous variable
#' @param bins Number of bins. Defaults to 30.
#' @param binwidth Fixed width for each bin, in the same units as the data. Overrides bins when specified
#'
#' @returns An ungrouped data.frame with two columns: the bin values for the x variable
#'   and the count of observations in each bin.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Returns record count for 30 bins in mpg
#' db_mtcars |>
#'   db_compute_bins(mpg)
#'
#' # Returns record count for bins of size 10
#' db_mtcars |>
#'   db_compute_bins(mpg, binwidth = 10)
#'
#' dbDisconnect(con)
#' }
#' @seealso
#' \code{\link{db_bin}},
#'
#' @export
db_compute_bins <- function(data, x, bins = 30, binwidth = NULL) {
  if (!is.null(bins) && bins <= 0) {
    stop("`bins` must be greater than 0", call. = FALSE)
  }
  if (!is.null(binwidth) && binwidth <= 0) {
    stop("`binwidth` must be greater than 0", call. = FALSE)
  }

  x <- enquo(x)

  xf <- db_bin(
    var = !!x,
    bins = bins,
    binwidth = binwidth
  )

  res <- select(data, !!x)
  res <- count(res, !!x := !!xf)
  res <- collect(res)
  res <- ungroup(res)
  rename(res, count = n)
}

#' Histogram
#'
#' @description
#'
#' Uses dplyr operations to aggregate data and then `ggplot2`
#' to create the histogram. Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @param data A table (tbl)
#' @param x A continuous variable
#' @param bins Number of bins. Defaults to 30.
#' @param binwidth Fixed width for each bin, in the same units as the data. Overrides bins when specified
#'
#' @returns A ggplot object displaying a histogram of the specified variable.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' library(ggplot2)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # A ggplot histogram with 30 bins
#' db_mtcars |>
#'   dbplot_histogram(mpg)
#'
#' # A ggplot histogram with bins of size 10
#' db_mtcars |>
#'   dbplot_histogram(mpg, binwidth = 10)
#'
#' dbDisconnect(con)
#' }
#' @seealso
#' \code{\link{dbplot_bar}}, \code{\link{dbplot_line}} ,
#'  \code{\link{dbplot_raster}}
#'
#' @export
dbplot_histogram <- function(data, x, bins = 30, binwidth = NULL) {
  if (!is.null(bins) && bins <= 0) {
    stop("`bins` must be greater than 0", call. = FALSE)
  }
  if (!is.null(binwidth) && binwidth <= 0) {
    stop("`binwidth` must be greater than 0", call. = FALSE)
  }

  x <- enexpr(x)

  df <- db_compute_bins(
    data = data,
    x = !!x,
    bins = bins,
    binwidth = binwidth
  )
  df <- mutate(
    df,
    x = !!x
  )

  ggplot(df) +
    geom_col(aes(x, count)) +
    labs(
      x = as_label(x),
      y = "count"
    )
}
