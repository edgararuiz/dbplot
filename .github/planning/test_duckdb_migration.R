#!/usr/bin/env Rscript
# Phase 5: Testing & Verification for DuckDB Migration
# This script tests all dbplot functionality with DuckDB

cat("=== DuckDB Migration Testing ===\n\n")

# 1. Check dependencies
cat("1. Checking dependencies...\n")
if (!requireNamespace("duckdb", quietly = TRUE)) {
  stop("duckdb package not installed. Run: install.packages('duckdb')")
}
if (!requireNamespace("nycflights13", quietly = TRUE)) {
  stop("nycflights13 package not installed. Run: install.packages('nycflights13')")
}
cat("   ✓ duckdb installed\n")
cat("   ✓ nycflights13 installed\n\n")

# 2. Load required libraries
cat("2. Loading libraries...\n")
library(DBI)
library(dplyr)
library(dbplot)
library(ggplot2)
cat("   ✓ All libraries loaded\n\n")

# 3. Create DuckDB connection
cat("3. Creating DuckDB connection...\n")
con <- dbConnect(duckdb::duckdb(), ":memory:")
cat("   ✓ Connection created: ", class(con)[1], "\n\n")

# 4. Load data
cat("4. Loading flights data into DuckDB...\n")
db_flights <- copy_to(con, nycflights13::flights, "flights")
cat("   ✓ Data loaded: ", format(nrow(db_flights), big.mark = ","), " rows\n\n")

# 5. Test histogram
cat("5. Testing dbplot_histogram()...\n")
tryCatch({
  p <- db_flights |> dbplot_histogram(distance)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Histogram test passed\n\n")
}, error = function(e) {
  cat("   ✗ Histogram test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 6. Test bar plot
cat("6. Testing dbplot_bar()...\n")
tryCatch({
  p <- db_flights |> dbplot_bar(origin)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Bar plot test passed\n\n")
}, error = function(e) {
  cat("   ✗ Bar plot test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 7. Test bar plot with aggregation
cat("7. Testing dbplot_bar() with aggregation...\n")
tryCatch({
  p <- db_flights |> dbplot_bar(origin, avg_delay = mean(dep_delay, na.rm = TRUE))
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Bar plot with aggregation test passed\n\n")
}, error = function(e) {
  cat("   ✗ Bar plot with aggregation test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 8. Test line plot
cat("8. Testing dbplot_line()...\n")
tryCatch({
  p <- db_flights |> dbplot_line(month)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Line plot test passed\n\n")
}, error = function(e) {
  cat("   ✗ Line plot test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 9. Test raster plot
cat("9. Testing dbplot_raster()...\n")
tryCatch({
  p <- db_flights |> dbplot_raster(sched_dep_time, sched_arr_time)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Raster plot test passed\n\n")
}, error = function(e) {
  cat("   ✗ Raster plot test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 10. Test boxplot with DuckDB (KEY TEST!)
cat("10. Testing dbplot_boxplot() with DuckDB (KEY BENEFIT!)...\n")
tryCatch({
  p <- db_flights |> dbplot_boxplot(origin, distance)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ ✓ ✓ Boxplot with DuckDB test PASSED! ✓ ✓ ✓\n")
  cat("   This is the KEY BENEFIT - boxplot now works with database!\n\n")
}, error = function(e) {
  cat("   ✗ ✗ ✗ Boxplot with DuckDB test FAILED:", e$message, "\n\n")
  stop("Critical test failed")
})

# 11. Disconnect
cat("11. Disconnecting from DuckDB...\n")
dbDisconnect(con)
cat("   ✓ Disconnected successfully\n\n")

# 12. Test boxplot with local data frame (regression test)
cat("12. Testing dbplot_boxplot() with local data frame (regression)...\n")
tryCatch({
  p <- nycflights13::flights |> dbplot_boxplot(origin, distance)
  if (!inherits(p, "ggplot")) stop("Not a ggplot object")
  cat("   ✓ Boxplot with local data frame test passed\n\n")
}, error = function(e) {
  cat("   ✗ Boxplot with local data frame test FAILED:", e$message, "\n\n")
  stop("Test failed")
})

# 13. Test computation functions
cat("13. Testing db_compute_* functions...\n")
con <- dbConnect(duckdb::duckdb(), ":memory:")
db_flights <- copy_to(con, nycflights13::flights, "flights")

tryCatch({
  result <- db_flights |> db_compute_bins(distance)
  if (!is.data.frame(result)) stop("Not a data frame")
  cat("   ✓ db_compute_bins() test passed\n")

  result <- db_flights |> db_compute_count(origin)
  if (!is.data.frame(result)) stop("Not a data frame")
  cat("   ✓ db_compute_count() test passed\n")

  result <- db_flights |> db_compute_raster(sched_dep_time, sched_arr_time)
  if (!is.data.frame(result)) stop("Not a data frame")
  cat("   ✓ db_compute_raster() test passed\n")

  result <- db_flights |> db_compute_boxplot(origin, distance)
  if (!is.data.frame(result)) stop("Not a data frame")
  cat("   ✓ db_compute_boxplot() with DuckDB test passed\n\n")
}, error = function(e) {
  cat("   ✗ Computation function test FAILED:", e$message, "\n\n")
  dbDisconnect(con)
  stop("Test failed")
})

dbDisconnect(con)

# Summary
cat("=== ALL TESTS PASSED ===\n\n")
cat("Summary:\n")
cat("✓ All plot functions work with DuckDB\n")
cat("✓ Boxplot now works with database connections (KEY BENEFIT)\n")
cat("✓ All computation functions work with DuckDB\n")
cat("✓ Local data frame functionality preserved (no regression)\n")
cat("✓ Migration successful!\n\n")

cat("Next steps:\n")
cat("1. Update checklist to mark Phase 5 complete\n")
cat("2. Commit changes with appropriate messages\n")
cat("3. Push to GitHub and deploy documentation\n")
