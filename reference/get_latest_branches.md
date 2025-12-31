# Get currently active Bioconductor git branches

Get currently active Bioconductor git branches

## Usage

``` r
get_latest_branches(infoTbl = NULL)
```

## Arguments

- infoTbl:

  downloaded paraquet info table retrieved from get_bbs_table('info')
  that includes git_branch information.

## Value

character(2) 'devel' and RELEASE_X_Y value eqivalent to current release.

## Details

Get currently active Bioconductor git branches

## See also

get_bbs_table

## Examples

``` r
get_latest_branches()
#> [1] "devel"        "RELEASE_3_22"
```
