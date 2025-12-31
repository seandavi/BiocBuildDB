# Get a count of how many time a package failed on the Bioconductor Build System

Get a count of how many time a package failed (ERROR/TIMEOUT) on the
Bioconductor Build System; optionally can specify a specific builder or
branch to filter results.

## Usage

``` r
package_error_count(packagename, builder = NULL, branch = NULL)
```

## Arguments

- packagename:

  a single valid Bioconductor package name

- builder:

  name of a valid Bioconductor build machine (ie 'nebbiolo1')

- branch:

  a bioconductor branch (eg. 'devel', 'RELEASE_3_22')

## Value

tibble of data including counts of runs and errors or NULL if package is
not found

## Details

Utilizes data from the build_summary and info parquet files to retrieve
a count of errors (TIMEOUT/ERROR) for a specified package. Optionally a
given builder machine name or Bioconductor branch may be specified to
filter request. If no builder is given it will return all. If no branch
is give it will also return all. The data returned includes the node
(builder machine name), package version number, stage (install, build,
check), total number of times that stage/builder tried to run, total
number of times the package failed during that stage, and the given
Bioconductor git branch. NOTE: since 'devel' is on-going. There will be
multiple 'devel' results across multiple years not just the current
devel. See example to filtering to see most recent. NOTE: If builder or
branch is not found, function will continue and return unfiltered
results.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
package_error_count("BiocFileCache")
#> # A tibble: 408 × 6
#>    node      version    stage    count_total count_error git_branch  
#>    <chr>     <pckg_vrs> <chr>          <int>       <int> <chr>       
#>  1 machv2    2.0.0      buildbin           1           0 RELEASE_3_13
#>  2 machv2    2.0.0      buildsrc           1           0 RELEASE_3_13
#>  3 machv2    2.0.0      checksrc           1           0 RELEASE_3_13
#>  4 machv2    2.0.0      install            1           0 RELEASE_3_13
#>  5 nebbiolo1 2.0.0      buildsrc           1           0 RELEASE_3_13
#>  6 nebbiolo1 2.0.0      checksrc           1           0 RELEASE_3_13
#>  7 nebbiolo1 2.0.0      install            1           0 RELEASE_3_13
#>  8 tokay2    2.0.0      buildbin           1           0 RELEASE_3_13
#>  9 tokay2    2.0.0      buildsrc           1           0 RELEASE_3_13
#> 10 tokay2    2.0.0      checksrc           1           0 RELEASE_3_13
#> # ℹ 398 more rows
package_error_count("BiocFileCache", branch="RELEASE_3_22")
#> # A tibble: 22 × 6
#>    node      version    stage    count_total count_error git_branch  
#>    <chr>     <pckg_vrs> <chr>          <int>       <int> <chr>       
#>  1 kjohnson1 3.0.0      buildbin           6           0 RELEASE_3_22
#>  2 kjohnson1 3.0.0      buildsrc           8           2 RELEASE_3_22
#>  3 kjohnson1 3.0.0      checksrc           6           2 RELEASE_3_22
#>  4 kjohnson1 3.0.0      install            8           0 RELEASE_3_22
#>  5 kjohnson3 3.0.0      buildbin           8           0 RELEASE_3_22
#>  6 kjohnson3 3.0.0      buildsrc          10           2 RELEASE_3_22
#>  7 kjohnson3 3.0.0      checksrc           8           0 RELEASE_3_22
#>  8 kjohnson3 3.0.0      install           10           0 RELEASE_3_22
#>  9 lconway   3.0.0      buildbin           4           0 RELEASE_3_22
#> 10 lconway   3.0.0      buildsrc           5           1 RELEASE_3_22
#> # ℹ 12 more rows
package_error_count("BiocFileCache", builder = "nebbiolo2", branch="RELEASE_3_22")
#> # A tibble: 3 × 6
#>   node      version    stage    count_total count_error git_branch  
#>   <chr>     <pckg_vrs> <chr>          <int>       <int> <chr>       
#> 1 nebbiolo2 3.0.0      buildsrc          27           8 RELEASE_3_22
#> 2 nebbiolo2 3.0.0      checksrc          19           6 RELEASE_3_22
#> 3 nebbiolo2 3.0.0      install           27           0 RELEASE_3_22

library(dplyr)
## devel will have more than just current devel
devErrors <- package_error_count("BiocFileCache", branch="devel")
## can use package version number to filter to current devel
devErrors |> filter(version == max(version))
#> # A tibble: 11 × 6
#>    node      version    stage    count_total count_error git_branch
#>    <chr>     <pckg_vrs> <chr>          <int>       <int> <chr>     
#>  1 kjohnson3 3.1.0      buildbin          29           0 devel     
#>  2 kjohnson3 3.1.0      buildsrc          40          11 devel     
#>  3 kjohnson3 3.1.0      checksrc          29           0 devel     
#>  4 kjohnson3 3.1.0      install           40           0 devel     
#>  5 lconway   3.1.0      buildbin           9           0 devel     
#>  6 lconway   3.1.0      buildsrc          11           2 devel     
#>  7 lconway   3.1.0      checksrc           9           1 devel     
#>  8 lconway   3.1.0      install           11           0 devel     
#>  9 nebbiolo1 3.1.0      buildsrc          51          14 devel     
#> 10 nebbiolo1 3.1.0      checksrc          37           8 devel     
#> 11 nebbiolo1 3.1.0      install           51           0 devel     
```
