# Extract propagation status table from an extracted report tarball

Extract propagation status table from an extracted report tarball

## Usage

``` r
get_propagation_status_table(report_dir)
```

## Arguments

- report_dir:

  The directory containing the extracted report tarball

## Value

A data frame with one row per package per process

## Author

Sean Davis \<seandavi@gmail.com\>

## Examples

``` r
report_tgz = example_report_tgz()
report_dir = untar_report_tgz(report_tgz)
get_propagation_status_table(report_dir)
#> # A tibble: 34 × 4
#>    package                        process propagate                   report_md5
#>    <chr>                          <chr>   <chr>                       <chr>     
#>  1 AHCytoBands                    source  UNNEEDED, same version is … f8fd2897c…
#>  2 AHEnsDbs                       source  UNNEEDED, same version is … f8fd2897c…
#>  3 AHLRBaseDbs                    source  NO, version to propagate (… f8fd2897c…
#>  4 AHMeSHDbs                      source  NO, version to propagate (… f8fd2897c…
#>  5 AHPathbankDbs                  source  UNNEEDED, same version is … f8fd2897c…
#>  6 AHPubMedDbs                    source  NO, version to propagate (… f8fd2897c…
#>  7 AHWikipathwaysDbs              source  UNNEEDED, same version is … f8fd2897c…
#>  8 AlphaMissense.v2023.hg19       source  UNNEEDED, same version is … f8fd2897c…
#>  9 AlphaMissense.v2023.hg38       source  UNNEEDED, same version is … f8fd2897c…
#> 10 alternativeSplicingEvents.hg19 source  UNNEEDED, same version is … f8fd2897c…
#> # ℹ 24 more rows
```
