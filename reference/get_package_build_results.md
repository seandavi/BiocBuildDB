# Get the most recent build result data for a given package on a given branch

Get the build status information for a given package on a specified
branch.

## Usage

``` r
get_package_build_results(packagename, branch = "devel")
```

## Arguments

- packagename:

  a single valid Bioconductor package name

- branch:

  a bioconductor branch (eg. 'devel', 'RELEASE_3_22')

## Value

tibble of build status information or NULL if package or branch is not
found

## Details

Utilizes data from the info and build_summary parquet files to retrieve
the latest build results for a specified package on a given branch. If
no branch is given it defaults to use 'devel'. The data returned
includes the node (builder machine name), stage (install, build, check),
package version number, status of stage, date stage completed, and git
information for the build (git branch, git commit hash, git commit
date).

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
get_package_build_results("BiocFileCache")
#> # A tibble: 11 × 9
#>    package       node      stage   version status endedat             git_branch
#>    <chr>         <chr>     <chr>   <chr>   <chr>  <dttm>              <chr>     
#>  1 BiocFileCache kjohnson3 buildb… 3.1.0   OK     2026-01-01 04:20:49 devel     
#>  2 BiocFileCache kjohnson3 builds… 3.1.0   OK     2025-12-31 20:45:20 devel     
#>  3 BiocFileCache kjohnson3 checks… 3.1.0   OK     2025-12-31 23:42:10 devel     
#>  4 BiocFileCache kjohnson3 install 3.1.0   OK     2025-12-31 20:05:19 devel     
#>  5 BiocFileCache lconway   buildb… 3.1.0   OK     2025-11-28 10:57:17 devel     
#>  6 BiocFileCache lconway   builds… 3.1.0   OK     2025-11-27 21:14:18 devel     
#>  7 BiocFileCache lconway   checks… 3.1.0   OK     2025-11-28 01:22:22 devel     
#>  8 BiocFileCache lconway   install 3.1.0   OK     2025-11-27 20:15:11 devel     
#>  9 BiocFileCache nebbiolo1 builds… 3.1.0   OK     2025-12-31 21:28:04 devel     
#> 10 BiocFileCache nebbiolo1 checks… 3.1.0   OK     2026-01-01 02:27:07 devel     
#> 11 BiocFileCache nebbiolo1 install 3.1.0   OK     2025-12-31 20:08:47 devel     
#> # ℹ 2 more variables: git_last_commit <chr>, git_last_commit_date <dttm>
get_package_build_results("BiocFileCache", branch="RELEASE_3_22")
#> # A tibble: 22 × 9
#>    package       node      stage   version status endedat             git_branch
#>    <chr>         <chr>     <chr>   <chr>   <chr>  <dttm>              <chr>     
#>  1 BiocFileCache kjohnson1 buildb… 3.0.0   OK     2025-12-21 11:31:00 RELEASE_3…
#>  2 BiocFileCache kjohnson1 builds… 3.0.0   OK     2025-12-19 01:06:04 RELEASE_3…
#>  3 BiocFileCache kjohnson1 checks… 3.0.0   OK     2025-12-19 21:04:05 RELEASE_3…
#>  4 BiocFileCache kjohnson1 install 3.0.0   OK     2025-12-18 20:29:23 RELEASE_3…
#>  5 BiocFileCache kjohnson3 buildb… 3.0.0   OK     2025-11-11 04:12:43 RELEASE_3…
#>  6 BiocFileCache kjohnson3 builds… 3.0.0   OK     2025-11-10 20:48:12 RELEASE_3…
#>  7 BiocFileCache kjohnson3 checks… 3.0.0   OK     2025-11-10 23:57:58 RELEASE_3…
#>  8 BiocFileCache kjohnson3 install 3.0.0   OK     2025-11-10 20:05:16 RELEASE_3…
#>  9 BiocFileCache lconway   buildb… 3.0.0   OK     2025-11-04 06:29:51 RELEASE_3…
#> 10 BiocFileCache lconway   builds… 3.0.0   OK     2025-11-03 21:17:15 RELEASE_3…
#> # ℹ 12 more rows
#> # ℹ 2 more variables: git_last_commit <chr>, git_last_commit_date <dttm>
```
