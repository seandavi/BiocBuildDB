# BiocBuildDB

The goal of BiocBuildDB is to provide a set of functions to work with
Bioconductor build reports. The package provides functions to download
reports from the Bioconductor build system, extract information from
the reports, and cache the reports locally.

## Cache reports locally

This script will download all `new` reports from the Bioconductor build 
system and store them in a local directory. It will also create a csv 
file with the last modification date of each report.

```
library(BiocBuildDB)
dir.create('report_dir')
localize_all_new_reports('report_dir/last_mod_date.csv', 'report_dir')
```

## Work with a report.tgz file

```
library(BiocBuildDB)
report_tgz <- example_report_tgz()
report_dir <- untar_report_tgz(report_tgz)
summary_df <- get_build_summary_table(report_dir)
info_df <- get_info_table(report_dir)
prop_df <- get_propagation_status_table(report_dir)
```



