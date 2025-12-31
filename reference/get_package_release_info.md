# Get git information for a given package across all Bioconductor releases

Get the package version and git commit data for all releases in
Bioconductor.

## Usage

``` r
get_package_release_info(packagename)
```

## Arguments

- packagename:

  a single valid Bioconductor package name

## Value

tibble of release information or NULL if package is not found

## Details

Utilizes data from the info parquet file to retrieve the equivalent git
information for every available Bioconductor release of a package. This
include the git commit hash and last commit date along with the package
version.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
get_package_release_info("BiocFileCache")
#> # A tibble: 11 × 5
#>    Package       Version git_branch   git_last_commit git_last_commit_date
#>    <chr>         <chr>   <chr>        <chr>           <dttm>              
#>  1 BiocFileCache 2.0.0   RELEASE_3_13 280a8f9         2021-05-19 16:26:36 
#>  2 BiocFileCache 2.2.1   RELEASE_3_14 cc91212         2022-01-20 13:21:33 
#>  3 BiocFileCache 2.4.0   RELEASE_3_15 2c00eee         2022-04-26 15:39:42 
#>  4 BiocFileCache 2.6.1   RELEASE_3_16 fdeb0ad         2023-02-17 11:39:09 
#>  5 BiocFileCache 2.8.0   RELEASE_3_17 d088b32         2023-04-25 14:53:05 
#>  6 BiocFileCache 2.10.2  RELEASE_3_18 c95edcc         2024-03-27 16:42:13 
#>  7 BiocFileCache 2.12.0  RELEASE_3_19 a655653         2024-04-30 14:56:59 
#>  8 BiocFileCache 2.14.0  RELEASE_3_20 66862c5         2024-10-29 15:18:07 
#>  9 BiocFileCache 2.16.2  RELEASE_3_21 22fec96         2025-08-25 12:44:02 
#> 10 BiocFileCache 3.0.0   RELEASE_3_22 81fd6e0         2025-10-29 15:37:29 
#> 11 BiocFileCache 3.1.0   devel        c4f8ba6         2025-10-29 15:37:29 
```
