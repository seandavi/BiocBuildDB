# Get rough timeline overview of package failing events

Get rough timeline overview of a package failing events on a specific
builder

## Usage

``` r
package_failures_over_time(packagename, builder, failure_cluster_hours = 72)
```

## Arguments

- packagename:

  a single valid Bioconductor package name

- builder:

  name of a valid Bioconductor build machine (ie 'nebbiolo1')

- failure_cluster_hours:

  numeric indicating the number of hours to treat failures as a single
  event

## Value

tibble of failure event information or NULL if package or builder is not
found

## Details

This function attempts to give an overview of how long a package has
been failing on a given builder. The time to treat failures as a single
event is distinguished by consecutive days and by the
failure_cluster_hours argument. Currently there is a different cadence
of builds for release compared to devel so this allows the flexibility
to define the timeline. Let's use the following example for
interpretation of the result table: “\` version episode first_failure
last_failure n_failures 2 3.1.0 3 2025-12-15 02:57:57 2025-12-16
21:29:20 3 3 3.1.0 2 2025-12-13 02:32:33 2025-12-13 02:32:33 1 4 3.1.0 1
2025-12-08 21:30:14 2025-12-11 21:27:29 4 stages statuses 2 buildsrc,
checksrc ERROR 3 checksrc ERROR 4 buildsrc ERROR “\` The package version
being built on the build system for this package is 3.1.0. The episode
refers to the number of failing episodic events. If we look at the
episode 1, the package started failing on December 8 and continued to
fail until December 11. During that time period there were 4 number of
failures and they occurred during the build stage. The time between the
last failure of the first episode and the second episode is from
December 11 to December 13; we can infer then that the package built
cleanly on December 12. During episode 2 the package failed solely on
December 13 but during the check stage. Episode 3 began on Dec 15 and
lasted until December 16 and had 3 failures but they occurred in either
the build or check stage.

This hopefully can help determine if package failures are intermittent
and how long a package is failing on a given builder.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
package_failures_over_time("BiocFileCache", "nebbiolo1", 24)
#> # A tibble: 21 × 7
#>    version    episode first_failure       last_failure        n_failures stages 
#>    <pckg_vrs>   <int> <dttm>              <dttm>                   <int> <chr>  
#>  1 3.1.0           12 2025-12-19 02:17:53 2025-12-19 02:17:53          1 checks…
#>  2 3.1.0           11 2025-12-15 02:57:57 2025-12-16 21:29:20          3 builds…
#>  3 3.1.0           10 2025-12-13 02:32:33 2025-12-13 02:32:33          1 checks…
#>  4 3.1.0            9 2025-12-08 21:30:14 2025-12-11 21:27:29          4 builds…
#>  5 3.1.0            8 2025-12-05 21:26:25 2025-12-05 21:26:25          1 builds…
#>  6 3.1.0            7 2025-12-01 21:30:34 2025-12-03 21:39:35          3 builds…
#>  7 3.1.0            6 2025-11-25 21:30:29 2025-11-26 21:28:08          2 builds…
#>  8 3.1.0            5 2025-11-22 02:27:43 2025-11-22 02:27:43          1 checks…
#>  9 3.1.0            4 2025-11-18 02:32:56 2025-11-18 02:32:56          1 checks…
#> 10 3.1.0            3 2025-11-15 02:26:25 2025-11-15 02:26:25          1 checks…
#> # ℹ 11 more rows
#> # ℹ 1 more variable: statuses <chr>
```
