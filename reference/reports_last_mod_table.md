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
#> # A tibble: 119 × 2
#>    url                                                       last_modified      
#>    <chr>                                                     <dttm>             
#>  1 https://bioconductor.org/checkResults/3.23/bioc-LATEST/r… 2025-12-31 16:36:06
#>  2 https://bioconductor.org/checkResults/3.23/bioc-gpu-LATE… 2025-12-31 12:45:04
#>  3 https://bioconductor.org/checkResults/3.23/data-annotati… 2025-12-31 12:00:08
#>  4 https://bioconductor.org/checkResults/3.23/data-experime… 2025-12-30 20:01:36
#>  5 https://bioconductor.org/checkResults/3.23/workflows-LAT… 2025-12-30 21:30:05
#>  6 https://bioconductor.org/checkResults/3.23/books-LATEST/… 2025-12-29 19:30:06
#>  7 https://bioconductor.org/checkResults/3.23/bioc-longtest… 2025-12-28 04:55:02
#>  8 https://bioconductor.org/checkResults/3.22/bioc-LATEST/r… 2025-12-29 17:00:06
#>  9 https://bioconductor.org/checkResults/3.22/bioc-gpu-LATE… 2025-12-31 13:30:04
#> 10 https://bioconductor.org/checkResults/3.22/data-annotati… 2025-12-31 11:45:08
#> # ℹ 109 more rows
```
