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
#> # A tibble: 1,714,270 × 9
#>    Package Version Maintainer MaintainerEmail git_url git_branch git_last_commit
#>    <chr>   <chr>   <chr>      <chr>           <chr>   <chr>      <chr>          
#>  1 a4      1.61.0  Laure Cou… laure.cougnaud… https:… devel      bb7aa77        
#>  2 a4Base  1.61.0  Laure Cou… laure.cougnaud… https:… devel      8ed1f79        
#>  3 a4Clas… 1.61.0  Laure Cou… laure.cougnaud… https:… devel      e8a308b        
#>  4 a4Core  1.61.0  Laure Cou… laure.cougnaud… https:… devel      bab9e56        
#>  5 a4Prep… 1.61.0  Laure Cou… laure.cougnaud… https:… devel      db56b19        
#>  6 a4Repo… 1.61.0  Laure Cou… laure.cougnaud… https:… devel      9309d3b        
#>  7 ABarray 1.81.0  Yongming … sunya at appli… https:… devel      196750a        
#>  8 abseqR  1.31.0  JiaHong F… jiahfong at gm… https:… devel      b7b630e        
#>  9 ABSSeq  1.67.0  Wentao Ya… wyang at zoolo… https:… devel      a18cc3f        
#> 10 acde    1.43.0  Juan Pabl… jpacostar at u… https:… devel      847deff        
#> # ℹ 1,714,260 more rows
#> # ℹ 2 more variables: git_last_commit_date <dttm>, report_md5 <chr>

library(dplyr)
# all the package Lori Shepherd maintains
info |> filter(Maintainer == "Lori Shepherd") |> distinct(Package)
#> # A tibble: 3 × 1
#>   Package          
#>   <chr>            
#> 1 BiocBuildReporter
#> 2 BiocFileCache    
#> 3 BiocMaintainerApp

```
