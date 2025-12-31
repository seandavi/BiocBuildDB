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
#> # A tibble: 31 × 12
#>    package    node  stage version status startedat           endedat            
#>    <chr>      <chr> <fct> <pckg_> <chr>  <dttm>              <dttm>             
#>  1 BiocBookD… nebb… inst… 1.8.0   OK     2025-12-29 11:45:16 2025-12-29 11:45:19
#>  2 BiocBookD… nebb… buil… 1.8.0   OK     2025-12-29 11:47:25 2025-12-29 11:48:26
#>  3 BiocBookD… nebb… chec… 1.8.0   OK     2025-12-29 13:21:17 2025-12-29 13:21:18
#>  4 OHCA       nebb… inst… 1.6.0   OK     2025-12-29 11:45:19 2025-12-29 11:45:20
#>  5 OHCA       nebb… buil… 1.6.0   OK     2025-12-29 11:47:25 2025-12-29 12:17:07
#>  6 OHCA       nebb… chec… 1.6.0   OK     2025-12-29 13:21:17 2025-12-29 13:21:18
#>  7 OSCA       nebb… inst… 1.20.0  OK     2025-12-29 11:45:19 2025-12-29 11:45:21
#>  8 OSCA       nebb… buil… 1.20.0  OK     2025-12-29 11:47:25 2025-12-29 11:47:40
#>  9 OSCA       nebb… chec… 1.20.0  OK     2025-12-29 13:21:17 2025-12-29 13:21:18
#> 10 OSCA.adva… nebb… inst… 1.18.1  OK     2025-12-29 11:46:34 2025-12-29 11:47:15
#> # ℹ 21 more rows
#> # ℹ 5 more variables: command <chr>, report_md5 <chr>, git_branch <chr>,
#> #   git_last_commit <chr>, git_last_commit_date <dttm>
```
