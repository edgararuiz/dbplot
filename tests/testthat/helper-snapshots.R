# Helper function for consistent snapshot creation across platforms
save_plot_snapshot <- function(plot, filename, width = 7, height = 5) {
  path <- tempfile(fileext = ".png")
  ggplot2::ggsave(
    filename = path,
    plot = plot,
    width = width,
    height = height,
    dpi = 300,
    device = ragg::agg_png,
    bg = "white"
  )
  expect_snapshot_file(path, filename)
}
