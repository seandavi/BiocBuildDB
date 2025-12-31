# Localize a report.tgz file to a local directory

This function is used to pull down a report.tgz file from Bioconductor
and save it locally. The file is saved with a name that is the md5sum of
the file, and the file is saved to the \`local_dir\`.

## Usage

``` r
localize_report_tgz(url, local_dir = tempdir())
```

## Arguments

- url:

  character(1) The URL of the report.tgz file

- local_dir:

  character(1) The directory to which the report.tgz file will be copied
  (default: tempdir())

## Value

A character(1) with the path to the localized report.tgz file.

## Examples

``` r
localize_report_tgz("https://bioconductor.org/checkResults/3.14/bioc-LATEST/report.tgz")
#> [1] "/tmp/RtmpINc8Ul/b0e50af261966e090388524f021bb139-report.tgz"
```
