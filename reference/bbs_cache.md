# Custom Environment to store downloaded parquet tibbles.

A custom environment to store remotely read parquet files of
Bioconductor build reports. Once one of the three valid parquet files
are read in, the table is cached in this environment for quick easy
reference either to use ad hocly by the user or to be used within
pre-defined queries provided by this package.

## Usage

``` r
.bbs_cache
```

## Format

An environment
