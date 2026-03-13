# Helper function for visual snapshots
# testthat will automatically handle platform-specific variants if needed
save_plot_snapshot <- function(plot, filename, width = 7, height = 5) {
  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(
    filename = path,
    plot = plot,
    width = width,
    height = height,
    dpi = 96  # Standard screen DPI
  )
  expect_snapshot_file(path, filename)
}
