# Extract info table from an extracted report tarball

Extract info table from an extracted report tarball

## Usage

``` r
get_info_table(report_dir)
```

## Arguments

- report_dir:

  The directory containing the extracted report tarball. The report_dir
  should have been created by localize_report_tgz and should have class
  'report_dir' with at least the \`md5\` attribute.

## Value

A data frame with one row per package

## Author

Sean Davis \<seandavi@gmail.com\>

## Examples

``` r
report_tgz = example_report_tgz()
report_dir = untar_report_tgz(report_tgz)
get_info_table(report_dir)
#> # A tibble: 45 × 9
#>    Package Version Maintainer MaintainerEmail git_url git_branch git_last_commit
#>    <chr>   <chr>   <chr>      <chr>           <chr>   <chr>      <chr>          
#>  1 AHCyto… 0.99.1  Michael L… michafla at ge… https:… RELEASE_3… 821428c        
#>  2 AHEnsD… 1.1.10  Johannes … johannes.raine… https:… RELEASE_3… 1cf652d        
#>  3 AHLRBa… 0.99.3  Koki Tsuy… k.t.the-answer… https:… RELEASE_3… c0e6555        
#>  4 AHMeSH… 0.99.6  Koki Tsuy… k.t.the-answer… https:… RELEASE_3… 052e156        
#>  5 AHPath… 0.99.5  Kozo Nish… kozo.nishida a… https:… RELEASE_3… a90bfd4        
#>  6 AHPubM… 0.99.8  Koki Tsuy… k.t.the-answer… https:… RELEASE_3… f43d98f        
#>  7 AHWiki… 0.99.4  Kozo Nish… kozo.nishida a… https:… RELEASE_3… 04edc62        
#>  8 AlphaM… 3.18.2  Robert Ca… robert.castelo… https:… RELEASE_3… f8b2919        
#>  9 AlphaM… 3.18.2  Robert Ca… robert.castelo… https:… RELEASE_3… 67a154f        
#> 10 BioMar… 0.99.11 Zuguang Gu z.gu at dkfz.de https:… RELEASE_3… 25ee53f        
#> # ℹ 35 more rows
#> # ℹ 2 more variables: git_last_commit_date <dttm>, report_md5 <chr>
```
