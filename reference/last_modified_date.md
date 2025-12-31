# Get the last_modified_date for a Bioconductor URL

Makes the assumption that the header name is \`Last-Modified\` and that
returned value is parseable by clock::parse_datetime(). Bioconductor
uses the format \`%A, %d %B %Y %H:%M:%S GMT\`

## Usage

``` r
last_modified_date(url)
```

## Arguments

- url:

  A URL that reports the \`Last-Modified\` header in the format \`%A, %d
  %B %Y %H:%M:%S GMT\`

## Value

A \`POSIXct\` object

## Author

Sean Davis \<seandavi@gmail.com\>

## Examples

``` r
last_modified_date("https://bioconductor.org/checkResults/3.14/bioc-LATEST/report.tgz")
#> [1] "2022-04-13 16:09:23 UTC"
```
