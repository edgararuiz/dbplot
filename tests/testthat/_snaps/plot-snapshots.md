# dbplot_histogram creates expected plot

    Code
      p$data
    Output
      # A tibble: 19 x 3
           mpg count     x
         <dbl> <dbl> <dbl>
       1  12.8     1  12.8
       2  25.3     1  25.3
       3  21.4     3  21.4
       4  17.4     2  17.4
       5  19.0     3  19.0
       6  26.8     1  26.8
       7  15.9     1  15.9
       8  32.3     1  32.3
       9  33.1     1  33.1
      10  22.2     2  22.2
      11  23.7     1  23.7
      12  20.6     2  20.6
      13  13.5     1  13.5
      14  16.7     1  16.7
      15  30.0     2  30.0
      16  18.2     1  18.2
      17  15.1     4  15.1
      18  10.4     2  10.4
      19  14.3     2  14.3

---

    Code
      p$labels
    Output
      <ggplot2::labels> List of 2
       $ x: chr "mpg"
       $ y: chr "count"

# dbplot_bar creates expected plot

    Code
      p$data
    Output
      # A tibble: 2 x 2
            x     y
        <dbl> <dbl>
      1     0    19
      2     1    13

