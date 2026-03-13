#' Aggregates over a discrete field
#'
#' @description
#'
#' Uses dplyr operations to aggregate data. Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @param data A table (tbl)
#' @param x A discrete variable
#' @param ... A set of named or unnamed aggregations
#' @param y The aggregation formula. Defaults to count (n)
#'
#' @returns An ungrouped data.frame with the discrete variable and one or more
#'   aggregation columns. The first column is the grouping variable (x), followed
#'   by the aggregated values.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Returns the row count per am
#' db_mtcars |>
#'   db_compute_count(am)
#'
#' # Returns the average mpg per am
#' db_mtcars |>
#'   db_compute_count(am, mean(mpg))
#'
#' # Returns the average and sum of mpg per am
#' db_mtcars |>
#'   db_compute_count(am, mean(mpg), sum(mpg))
#'
#' dbDisconnect(con)
#' }
#' @export
db_compute_count <- function(data, x, ..., y = n()) {
  x <- enquo(x)
  y <- enquo(y)
  vars <- enquos(...)
  res <- group_by(data, !!x)
  if (length(vars) > 0) {
    res <- summarise(res, !!!vars)
  } else {
    res <- summarise(res, !!y)
  }
  res <- collect(res)
  ungroup(res)
}

#' Bar plot
#'
#' @description
#'
#' Uses dplyr operations to aggregate data and then `ggplot2`
#' to create the plot.  Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' @param data A table (tbl)
#' @param x A discrete variable
#' @param ... A set of named or unnamed aggregations
#' @param y The aggregation formula. Defaults to count (n)
#'
#' @returns A ggplot object with a bar plot. If multiple aggregations are provided,
#'   returns a list of ggplot objects, one for each aggregation.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' library(ggplot2)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Returns a plot of the row count per am
#' db_mtcars |>
#'   dbplot_bar(am)
#'
#' # Returns a plot of the average mpg per am
#' db_mtcars |>
#'   dbplot_bar(am, mean(mpg))
#'
#' # Returns the average and sum of mpg per am
#' db_mtcars |>
#'   dbplot_bar(am, avg_mpg = mean(mpg), sum_mpg = sum(mpg))
#'
#' dbDisconnect(con)
#' }
#' @seealso
#' \code{\link{dbplot_line}} ,
#' \code{\link{dbplot_histogram}},  \code{\link{dbplot_raster}}
#'
#' @export
dbplot_bar <- function(data, x, ..., y = n()) {
  x <- enquo(x)
  y <- enquo(y)
  vars <- enquos(...)

  df <- db_compute_count(
    data = data,
    x = !!x,
    !!!vars,
    y = !!y
  )

  if (ncol(df) == 2) {
    if (length(vars) == 1) {
      y <- vars
      ny <- names(y)
    } else {
      ny <- y
    }
    colnames(df) <- c("x", "y")
    output <- ggplot(df) +
      geom_col(aes(x, y)) +
      labs(x = x, y = ny)
  }

  if (ncol(df) > 2) {
    res <- select(df, -!!x)
    output <- imap(
      res,
      ~ {
        df <- tibble(
          x = pull(select(df, !!x)),
          y = .x
        )
        ggplot(df) +
          geom_col(aes(x, y)) +
          labs(x = quo_name(x), y = .y)
      }
    )
  }

  output
}

#' Line plot
#'
#' @description
#'
#' Uses dplyr operations to aggregate data and then `ggplot2`
#' to create a line plot.  Because of this approach,
#' the calculations automatically run inside the database if `data` has
#' a database or sparklyr connection. The `class()` of such tables
#' in R are: tbl_sql, tbl_dbi, tbl_spark
#'
#' If multiple named aggregations are passed, `dbplot` will only use one
#' SQL query to perform all of the operations.  The purpose is to increase
#' efficiency, and only make one "trip" to the database in order to
#' obtains multiple, related, plots.
#'
#' @param data A table (tbl)
#' @param x A discrete variable
#' @param ... A set of named or unnamed aggregations
#' @param y The aggregation formula. Defaults to count (n)
#'
#' @returns A ggplot object with a line plot. If multiple aggregations are provided,
#'   returns a list of ggplot objects, one for each aggregation.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' library(ggplot2)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Returns a plot of the row count per cyl
#' db_mtcars |>
#'   dbplot_line(cyl)
#'
#' # Returns a plot of the average mpg per cyl
#' db_mtcars |>
#'   dbplot_line(cyl, mean(mpg))
#'
#' # Returns the average and sum of mpg per am
#' db_mtcars |>
#'   dbplot_line(am, avg_mpg = mean(mpg), sum_mpg = sum(mpg))
#'
#' dbDisconnect(con)
#' }
#' @seealso
#' \code{\link{dbplot_bar}},
#' \code{\link{dbplot_histogram}},  \code{\link{dbplot_raster}}
#'
#' @export
dbplot_line <- function(data, x, ..., y = n()) {
  x <- enquo(x)
  y <- enquo(y)
  vars <- enquos(...)

  df <- db_compute_count(
    data = data,
    x = !!x,
    !!!vars,
    y = !!y
  )

  if (ncol(df) == 2) {
    if (length(vars) == 1) {
      y <- vars
      ny <- names(y)
    } else {
      ny <- y
    }
    colnames(df) <- c("x", "y")
    output <- ggplot(df) +
      geom_line(aes(x, y)) +
      labs(x = x, y = ny)
  }

  if (ncol(df) > 2) {
    res <- select(df, -!!x)
    output <- imap(
      res,
      ~ {
        df <- tibble(
          x = pull(select(df, !!x)),
          y = .x
        )
        ggplot(df) +
          geom_line(aes(x, y)) +
          labs(x = quo_name(x), y = .y)
      }
    )
  }
  output
}
