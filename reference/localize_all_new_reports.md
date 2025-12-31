# Localize any new reports to a local directory

Run this function to download any new reports to a local directory. The
function reads a little file-based database of last-modified dates for
reports, and compares the dates to the current last-modified dates on
the server. If the server has a newer report, the function downloads the
report to the local directory and renames it with the \`md5\` hash of
the file contents. The function then updates the database with the new
last-modified date and saves it to the reportdb_file.

## Usage

``` r
localize_all_new_reports(reportdb_file, cache_dir = tempdir())
```

## Arguments

- reportdb_file:

  the file to read the database from

- cache_dir:

  the directory to store the reports in

## Examples

``` r
if (FALSE) { # \dontrun{
cachedir = tempdir()
localize_all_new_reports("reportdb.csv", cachedir)
list.files(cachedir, pattern = 'tgz$')
} # }

```
