#' Bin formula
#'
#' Uses the rlang package to build the formula needed to create the bins of a numeric variable
#' in an unevaluated fashion.  This way, the formula can be then passed inside a dplyr
#' verb.
#'
#' @param var Variable name or formula
#' @param bins Number of bins. Defaults to 30.
#' @param binwidth Fixed width for each bin, in the same units as the data. Overrides bins when specified
#'
#' @returns An unevaluated expression (rlang quosure) that calculates bin membership
#'   for the specified variable. This expression is designed to be used within dplyr
#'   verbs using the `!!` operator.
#'
#' @examples
#' \dontrun{
#' library(DBI)
#' library(dplyr)
#' con <- dbConnect(duckdb::duckdb(), ":memory:")
#' db_mtcars <- copy_to(con, mtcars, "mtcars")
#'
#' # Important: Always name the field and
#' # prefix the function with `!!` (See Details)
#'
#' # Uses the default 30 bins
#' db_mtcars |>
#'   group_by(x = !!db_bin(mpg)) |>
#'   count()
#'
#' # Uses binwidth which overrides bins
#' db_mtcars |>
#'   group_by(x = !!db_bin(mpg, binwidth = 10)) |>
#'   count()
#'
#' dbDisconnect(con)
#' }
#' @export
db_bin <- function(var, bins = 30, binwidth = NULL) {
  if (!is.null(bins) && bins <= 0) {
    stop("`bins` must be greater than 0", call. = FALSE)
  }
  if (!is.null(binwidth) && binwidth <= 0) {
    stop("`binwidth` must be greater than 0", call. = FALSE)
  }

  var <- enquo(var)
  var <- quo_squash(var)

  range <- expr((max(!!var, na.rm = TRUE) - min(!!var, na.rm = TRUE)))

  if (is.null(binwidth)) {
    binwidth <- expr((!!range / !!bins))
  } else {
    bins <- expr(as.integer(!!range / !!binwidth))
  }

  bin_number <- expr(as.integer(floor(
    (!!var - min(!!var, na.rm = TRUE)) / !!binwidth
  )))

  expr(
    ((!!binwidth) *
      ifelse(!!bin_number == !!bins, !!bin_number - 1, !!bin_number)) +
      min(!!var, na.rm = TRUE)
  )
}

bin_size <- function(.data, field) {
  field <- enquo(field)

  vals <- pull(.data, !!field)
  vals_sort <- sort(vals)
  sort_1 <- vals_sort[1:length(vals_sort) - 1]
  sort_2 <- vals_sort[2:length(vals_sort)]
  comp <- sort_1 - sort_2
  comp <- comp[comp != 0]
  comp <- sort(-comp)
  comp[1]
}
