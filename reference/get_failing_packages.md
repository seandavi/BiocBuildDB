# Get list of failing packages for the most recent build

Get a list of failing (ERROR/TIMEOUT) packages for any given branch and
builder

## Usage

``` r
get_failing_packages(branch = NULL, builder = NULL)
```

## Arguments

- branch:

  a bioconductor branch (eg. 'devel', 'RELEASE_3_22')

- builder:

  name of a valid Bioconductor build machine (ie 'nebbiolo1')

## Value

a tibble of failing packages

## Details

Utilizes data from the build_summary and info parquet files to list all
packages failing (ERROR/TIMEOUT) in any stage of the process. Optionally
a Bioconductor git branch can be specified and by default will do both
the current devel and release. The report can be further filtered by
optionally specifying a build machine name. The returned tibble
includes: git branch, package name, package version number, build
machine node, collapsed column of stages and statuses.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
get_failing_packages("RELEASE_3_22")
#> # A tibble: 1,978 × 6
#>    git_branch   package  version    node      stages            statuses
#>    <chr>        <chr>    <pckg_vrs> <chr>     <chr>             <chr>   
#>  1 RELEASE_3_22 ACME     2.66.0     taishan   buildsrc, install ERROR   
#>  2 RELEASE_3_22 ADAPT    1.4.0      kjohnson1 buildsrc, install ERROR   
#>  3 RELEASE_3_22 ADAPT    1.4.0      kjohnson3 buildsrc, install ERROR   
#>  4 RELEASE_3_22 ADAPT    1.4.0      lconway   buildsrc, install ERROR   
#>  5 RELEASE_3_22 ADAPT    1.4.0      merida1   buildsrc, install ERROR   
#>  6 RELEASE_3_22 ADAPT    1.4.0      taishan   buildsrc          ERROR   
#>  7 RELEASE_3_22 ANCOMBC  2.12.0     merida1   buildsrc          TIMEOUT 
#>  8 RELEASE_3_22 ANF      1.32.0     taishan   buildsrc          TIMEOUT 
#>  9 RELEASE_3_22 APAlyzer 1.24.0     kjohnson1 checksrc          ERROR   
#> 10 RELEASE_3_22 APAlyzer 1.24.0     kjohnson3 checksrc          ERROR   
#> # ℹ 1,968 more rows
get_failing_packages("RELEASE_3_22", "nebbiolo2")
#> # A tibble: 439 × 6
#>    git_branch   package                  version    node      stages    statuses
#>    <chr>        <chr>                    <pckg_vrs> <chr>     <chr>     <chr>   
#>  1 RELEASE_3_22 APAlyzer                 1.24.0     nebbiolo2 checksrc  ERROR   
#>  2 RELEASE_3_22 ASURAT                   1.14.0     nebbiolo2 buildsrc… ERROR   
#>  3 RELEASE_3_22 AWAggregatorData         1.0.0      nebbiolo2 buildsrc  TIMEOUT 
#>  4 RELEASE_3_22 AlphaMissense.v2023.hg19 3.18.2     nebbiolo2 buildsrc  ERROR   
#>  5 RELEASE_3_22 AlphaMissense.v2023.hg38 3.18.2     nebbiolo2 buildsrc  ERROR   
#>  6 RELEASE_3_22 AlphaMissenseR           1.6.1      nebbiolo2 checksrc  ERROR   
#>  7 RELEASE_3_22 ArrayExpress             1.70.0     nebbiolo2 buildsrc… ERROR   
#>  8 RELEASE_3_22 BPRMeth                  1.36.0     nebbiolo2 checksrc  ERROR   
#>  9 RELEASE_3_22 BUSpaRse                 1.24.0     nebbiolo2 buildsrc… ERROR, …
#> 10 RELEASE_3_22 BayesSpace               1.20.0     nebbiolo2 buildsrc… ERROR   
#> # ℹ 429 more rows
```
