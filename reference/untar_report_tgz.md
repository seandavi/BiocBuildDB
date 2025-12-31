# Untar a report.tgz file and return a simple \`report_dir\` object

This function is used to untar a report.tgz file and return a simple
\`report_dir\` object. The \`report_dir\` object is a character(1) with
class \`report_dir\` and with attributes \`md5\`, \`url\`, and
\`local_report_tgz\`.

## Usage

``` r
untar_report_tgz(local_report_tgz, local_dir = tempdir())
```

## Arguments

- local_report_tgz:

  character(1) The path to the report.tgz file

- local_dir:

  character(1) The directory to which the report.tgz file will be
  untarred (default: tempdir())

## Value

A character(1) with the path to the untarred report directory with class
\`report_dir\` and with attributes \`md5\`, \`url\`, and
\`local_report_tgz\`.

## Examples

``` r
report_tgz = example_report_tgz()
report_dir = untar_report_tgz(report_tgz)

head(list.files(report_dir, recursive = TRUE))
#> [1] "120px-Blue_Light_Icon.svg.png"       "120px-Green_Light_Icon.svg.png"     
#> [3] "120px-Red_Light_Icon.svg.png"        "AHCytoBands/index.html"             
#> [5] "AHCytoBands/nebbiolo2-buildsrc.html" "AHCytoBands/nebbiolo2-checksrc.html"
```
