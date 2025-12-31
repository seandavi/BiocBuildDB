# Extract build_summary table from an extracted report tarball

Extract build_summary table from an extracted report tarball

## Usage

``` r
get_build_summary_table(report_dir)
```

## Arguments

- report_dir:

  The directory containing the extracted report tarball. The report_dir
  should have been created by localize_report_tgz and should have class
  'report_dir' with at least the \`md5\` attribute.

## Value

A data frame with one row per build process per package

## Author

Sean Davis \<seandavi@gmail.com\>

## Examples

``` r
report_tgz = example_report_tgz()
report_dir = untar_report_tgz(report_tgz)
get_build_summary_table(report_dir)
#> # A tibble: 132 × 9
#>    package    node  stage version status startedat           endedat            
#>    <chr>      <chr> <chr> <chr>   <chr>  <dttm>              <dttm>             
#>  1 AHCytoBan… nebb… buil… 0.99.1  OK     2024-01-17 10:31:13 2024-01-17 10:31:14
#>  2 AHCytoBan… nebb… chec… 0.99.1  OK     2024-01-17 10:35:23 2024-01-17 10:35:31
#>  3 AHCytoBan… nebb… inst… 0.99.1  OK     2024-01-17 10:30:08 2024-01-17 10:30:11
#>  4 AHEnsDbs   nebb… buil… 1.1.10  OK     2024-01-17 10:31:13 2024-01-17 10:32:01
#>  5 AHEnsDbs   nebb… chec… 1.1.10  OK     2024-01-17 10:35:23 2024-01-17 10:37:24
#>  6 AHEnsDbs   nebb… inst… 1.1.10  OK     2024-01-17 10:30:23 2024-01-17 10:30:49
#>  7 AHLRBaseD… nebb… buil… 0.99.3  OK     2024-01-17 10:31:13 2024-01-17 10:31:28
#>  8 AHLRBaseD… nebb… chec… 0.99.3  OK     2024-01-17 10:35:23 2024-01-17 10:35:47
#>  9 AHLRBaseD… nebb… inst… 0.99.3  OK     2024-01-17 10:30:17 2024-01-17 10:30:18
#> 10 AHMeSHDbs  nebb… buil… 0.99.6  OK     2024-01-17 10:31:13 2024-01-17 10:31:28
#> # ℹ 122 more rows
#> # ℹ 2 more variables: command <chr>, report_md5 <chr>
```
