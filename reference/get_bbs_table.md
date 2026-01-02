# Retrieve a remotely read parquet file of Bioconductor build data

Bioconductor Build results are at times cumbersome to work with and
interrogate. Parquet files of condensed reports are provided remotely.
These functions read the remote parquet files using the arrow package
and return a tibble. Once retrieved the table is stored in a custom
environment for easy quick reference either to use ad hocly or within
pre-defined queries provided by this package.

## Usage

``` r
get_bbs_table(tblname = c("build_summary", "info", "propagation_status"))
```

## Arguments

- tblname:

  A valid parquet file name. Currently available: build_summary, info,
  or propagation_status.

## Value

returns a tibble.

## Details

The get_bbs_table returns a tibble but is also saved in a custom
environment for quick easy subsequent reference. There are three tables
available and can be specified in get_bbs_table: build_summary, info, or
propagation_status. build_summary returns a tibble with the results of
each stage of the Bioconductor build process. info returns a tibble with
information regarding the package maintainer and git commit status.
propagation_status returns a tibble with data on if a package propagated
to the community.

## See also

get_all_bbs_tables

## Author

Lori Shepherd

## Examples

``` r
info <- get_bbs_table("info")
#> Using cached table 'info'
info
#> # A tibble: 1,161,894 × 9
#>    Package Version Maintainer MaintainerEmail git_url git_branch git_last_commit
#>    <chr>   <chr>   <chr>      <chr>           <chr>   <chr>      <chr>          
#>  1 adduct… 1.26.0  Josie Hay… jlhayes1982 at… https:… RELEASE_3… 371b0e2        
#>  2 affyco… 1.48.0  Robert D … rshear at ds.d… https:… RELEASE_3… 45dff8f        
#>  3 affyda… 1.58.0  Robert D … rshear at ds.d… https:… RELEASE_3… 10b07a5        
#>  4 Affyhg… 1.46.0  Zhicheng … zji4 at jhu.edu https:… RELEASE_3… 3087443        
#>  5 Affyhg… 1.48.0  Zhicheng … zji4 at jhu.edu https:… RELEASE_3… 404c1b6        
#>  6 Affyhg… 1.44.0  Zhicheng … zji4 at jhu.edu https:… RELEASE_3… 2df08dd        
#>  7 Affyme… 0.48.0  Henrik Be… henrikb at bra… https:… RELEASE_3… d77ca79        
#>  8 Affymo… 1.48.0  Zhicheng … zji4 at jhu.edu https:… RELEASE_3… 53202e1        
#>  9 airway  1.30.0  Michael L… michaelisaiahl… https:… RELEASE_3… a6a39c3        
#> 10 ALL     1.52.0  Robert Ge… rgentlem at gm… https:… RELEASE_3… 0bc53bb        
#> # ℹ 1,161,884 more rows
#> # ℹ 2 more variables: git_last_commit_date <dttm>, report_md5 <chr>

library(dplyr)
# all the package Lori Shepherd maintains
info |> filter(Maintainer == "Lori Shepherd") |> distinct(Package)
#> # A tibble: 1 × 1
#>   Package      
#>   <chr>        
#> 1 BiocFileCache

```
