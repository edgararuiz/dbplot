#' @import rlang
#' @import ggplot2
#' @importFrom purrr imap
#' @importFrom dplyr mutate summarise
#' @importFrom dplyr group_by count pull
#' @importFrom dplyr ungroup collect rename
#' @importFrom dplyr select n tibble distinct
#' @importFrom stats quantile
#' @keywords internal

# Global variables used in NSE contexts across the package
utils::globalVariables(c(
  ".",
  "aes",
  "iqr",
  "labs",
  "lower",
  "max_iqr",
  "max_raw",
  "middle",
  "min_iqr",
  "min_raw",
  "percentile_approx",
  "upper",
  "w",
  "weight",
  "x_",
  "y",
  "ymax",
  "ymin"
))
