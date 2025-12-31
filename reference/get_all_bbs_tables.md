# Retrieve all available Bioconductor build system parquet files

Retrieve all available parquet tables at once.

## Usage

``` r
get_all_bbs_tables(assign_to_global = FALSE)
```

## Arguments

- assign_to_global:

  logical(1) indicating if downloaded tables should be assigned to the
  current global environment for access. Default is FALSE and only
  assigned to custom environment through call to get_bbs_table.

## Value

invisible. tables are cached to custom environment unless
assign_to_global is TRUE.

## Details

This function is a quick wrapper around get_bbs_table to download all
available parquet files as tibbles. By default no value is returned and
the tibbles are stored to the custom environment and can be easily
accessed through a call to get_bbs_table.

## See also

get_bbs_table

## Author

Lori Shepherd

## Examples

``` r
get_all_bbs_tables()
#> reading 'build_summary' parquet file...
#> reading 'info' parquet file...
#> reading 'propagation_status' parquet file...

# Now that all are downloaded. Retrieve cached build_summary tibble
build_summary <- get_bbs_table("build_summary")
#> Using cached table 'build_summary'

library(stringr)
library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union
# find the times the package BiocFileCache failed on linux nebbiolo builders
if (FALSE) { # \dontrun{
build_summary |> filter(package == "BiocFileCache", status %in% c("TIMEOUT", "ERROR"), str_starts(node, "nebbiolo")) 
} # }
```
