# read a little file-based database of last-modified dates for reports

If the file does not exist, the function returns an empty tibble with
the expected columns.

## Usage

``` r
report_last_mod_db(reportdb_file)
```

## Arguments

- reportdb_file:

  the file to read the database from

## Value

a tibble with columns url and old_last_modified
