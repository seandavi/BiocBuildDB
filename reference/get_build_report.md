# Get a report for any given day from the Bioconductor Build System

Get a report for any given day from the Bioconductor Build System,
optionally specifying a git branch or build machine name.

## Usage

``` r
get_build_report(build_date = Sys.Date(), branch = NULL, builder = NULL)
```

## Arguments

- build_date:

  Date of report to retrieve (eg. '2025-12-19')

- branch:

  a bioconductor branch (eg. 'devel', 'RELEASE_3_22')

- builder:

  name of a valid Bioconductor build machine (ie 'nebbiolo1')

## Value

tibble representing a Bioconductor build report for a given day

## Details

Utilizes data from the build_summary and info parquet files to retrieve
a reconstructed Bioconductor Build Report for any given day. Optionally
a given build machine name or Bioconductor branch may be specified for
further filtering. By default it will use today's date and retrieve both
devel and current release for all Bioconductor build machines. NOTE:
Traditionally Bioconductor splits builds into software, data-experiment,
annotation, workflow, books; this distinction is not available in these
functions and packages regardless of 'type' will be included. The
returned tibble includes: package name, build node, build stage, package
version number, status of stage, when the run started and ended, the
command the builder ran, branch of bioconductor and relevant git commit
information.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
get_build_report("2025-12-29", branch="RELEASE_3_22", builder="nebbiolo2")
#> # A tibble: 3,827 × 12
#>    package node     stage version status startedat           endedat            
#>    <chr>   <chr>    <fct> <pckg_> <chr>  <dttm>              <dttm>             
#>  1 ABSSeq  nebbiol… inst… 1.64.0  OK     2025-12-29 20:05:54 2025-12-29 20:06:15
#>  2 ABSSeq  nebbiol… buil… 1.64.0  OK     2025-12-29 21:11:23 2025-12-29 21:12:29
#>  3 ABarray nebbiol… inst… 1.78.0  OK     2025-12-29 20:16:38 2025-12-29 20:16:47
#>  4 ABarray nebbiol… buil… 1.78.0  OK     2025-12-29 21:11:23 2025-12-29 21:11:36
#>  5 ACE     nebbiol… inst… 1.28.0  OK     2025-12-29 20:18:52 2025-12-29 20:19:11
#>  6 ACE     nebbiol… buil… 1.28.0  OK     2025-12-29 21:11:23 2025-12-29 21:12:19
#>  7 ACME    nebbiol… inst… 2.66.0  OK     2025-12-29 20:14:48 2025-12-29 20:14:54
#>  8 ACME    nebbiol… buil… 2.66.0  OK     2025-12-29 21:11:23 2025-12-29 21:11:44
#>  9 ADAM    nebbiol… inst… 1.26.0  OK     2025-12-29 20:41:39 2025-12-29 20:42:11
#> 10 ADAM    nebbiol… buil… 1.26.0  OK     2025-12-29 21:11:23 2025-12-29 21:12:07
#> # ℹ 3,817 more rows
#> # ℹ 5 more variables: command <chr>, report_md5 <chr>, git_branch <chr>,
#> #   git_last_commit <chr>, git_last_commit_date <dttm>
```
