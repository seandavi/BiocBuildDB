# Get the last_modified_date for all current report.tgz

Get the last_modified_date for all current report.tgz

## Usage

``` r
reports_last_mod_table()
```

## Value

A data frame with one row per report.tgz file

## Author

Sean Davis \<seandavi@gmail.com\>

## Examples

``` r
res = reports_last_mod_table()
res
#> # A tibble: 126 × 2
#>    url                                                       last_modified      
#>    <chr>                                                     <dttm>             
#>  1 https://bioconductor.org/checkResults/3.24/bioc-LATEST/r… 2026-10-21 16:50:49
#>  2 https://bioconductor.org/checkResults/3.24/bioc-gpu-LATE… 2026-10-22 13:27:34
#>  3 https://bioconductor.org/checkResults/3.24/data-annotati… 2026-10-21 12:00:03
#>  4 https://bioconductor.org/checkResults/3.24/data-experime… 2026-10-20 20:23:47
#>  5 https://bioconductor.org/checkResults/3.24/workflows-LAT… 2026-10-20 21:25:39
#>  6 https://bioconductor.org/checkResults/3.24/books-LATEST/… 2026-10-21 19:48:48
#>  7 https://bioconductor.org/checkResults/3.24/bioc-longtest… 2026-10-18 04:31:32
#>  8 https://bioconductor.org/checkResults/3.23/bioc-LATEST/r… 2026-10-21 16:50:42
#>  9 https://bioconductor.org/checkResults/3.23/bioc-gpu-LATE… 2026-10-21 18:28:15
#> 10 https://bioconductor.org/checkResults/3.23/data-annotati… 2026-10-21 12:00:03
#> # ℹ 116 more rows
```
