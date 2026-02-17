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
#>  1 https://bioconductor.org/checkResults/3.23/bioc-LATEST/r… 2026-02-16 16:33:06
#>  2 https://bioconductor.org/checkResults/3.23/bioc-gpu-LATE… 2026-02-17 12:45:04
#>  3 https://bioconductor.org/checkResults/3.23/data-annotati… 2026-02-11 12:00:07
#>  4 https://bioconductor.org/checkResults/3.23/data-experime… 2026-02-12 20:01:31
#>  5 https://bioconductor.org/checkResults/3.23/workflows-LAT… 2026-01-13 21:30:06
#>  6 https://bioconductor.org/checkResults/3.23/books-LATEST/… 2026-01-14 19:30:05
#>  7 https://bioconductor.org/checkResults/3.23/bioc-longtest… 2026-02-15 04:55:02
#>  8 https://bioconductor.org/checkResults/3.22/bioc-LATEST/r… 2026-02-16 16:58:40
#>  9 https://bioconductor.org/checkResults/3.22/bioc-gpu-LATE… 2026-02-17 13:30:04
#> 10 https://bioconductor.org/checkResults/3.22/data-annotati… 2026-02-11 11:45:07
#> # ℹ 109 more rows
```
