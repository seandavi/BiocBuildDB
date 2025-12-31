# Get and process all new build reports

Get and process all new build reports

## Usage

``` r
process_all_new_reports(reportdb_file, local_dir)
```

## Arguments

- reportdb_file:

  character(1) Filename of the reportdb file with last modification
  dates. The file does not need to exist. If it does, it will be read
  and updated. If it does not, it will be created.

- local_dir:

  The directory to which the report.tgz files will be copied, untarred,
  and processed.
