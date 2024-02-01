#' Get links for all current report.tgz
#'
#' @returns character vector of all current report.tgz links
#'
#' @examples
#'
#' current_report_tgz_links()
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' current_report_tgz_links()
#'
#' @export
current_report_tgz_links <- function() {
  base_url <- "https://bioconductor.org/checkResults/"
  links = rvest::read_html(base_url) |>
    rvest::html_nodes("a") |>
    rvest::html_attr("href") |>
    stringr::str_subset("report.tgz")
  full_urls = stringr::str_c(base_url, links)
  full_urls
}

#' Get the last_modified_date for a Bioconductor URL
#'
#' Makes the assumption that the header name
#' is `Last-Modified` and that returned value is
#' parseable by clock::parse_datetime(). Bioconductor
#' uses the format `\%A, \%d \%B \%Y \%H:\%M:\%S GMT`
#'
#' @param url A URL that reports the `Last-Modified` header
#'   in the format `\%A, \%d \%B \%Y \%H:\%M:\%S GMT`
#'
#' @return A `POSIXct` object
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' last_modified_date("https://bioconductor.org/checkResults/3.14/bioc-LATEST/report.tgz")
#'
#' @export
last_modified_date <- function(url) {
  header_value = httr2::request(url) |>
    httr2::req_method('HEAD') |>
    httr2::req_timeout(180) |>
    httr2::req_perform() |>
    httr2::resp_header('Last-Modified') |>
    stringr::str_replace(' GMT', '') |>
    clock::date_time_parse(format='%A, %d %B %Y %H:%M:%S', 'GMT')
  return(header_value)
}

#' Get the last_modified_date for all current report.tgz
#'
#' @return A data frame with one row per report.tgz file
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' res = reports_last_mod_table()
#' res
#'
#' @export
reports_last_mod_table <- function() {
  report_urls = current_report_tgz_links()
  last_mod_dates = sapply(report_urls, last_modified_date)
  tibble::tibble(url = report_urls, last_modified = as.POSIXct(last_mod_dates))
}

#' Localize a report.tgz file to a local directory
#'
#' This function is used to pull down a report.tgz file from
#' Bioconductor and save it locally. The file is saved with
#' a name that is the md5sum of the file, and the file is
#' saved to the `local_dir`.
#'
#' @param url character(1) The URL of the report.tgz file
#' @param local_dir character(1) The directory to which the report.tgz file
#'   will be copied (default: tempdir())
#'
#' @return A character(1) with the path to the localized report.tgz file.
#'
#' @examples
#' localize_report_tgz("https://bioconductor.org/checkResults/3.14/bioc-LATEST/report.tgz")
#'
#'
#' @export
localize_report_tgz <- function(url, local_dir = tempdir()) {
  download.file(url, temp_file <- tempfile())
  md5 = tools::md5sum(temp_file)
  local_report_tgz <- file.path(local_dir, paste0(md5,'-report.tgz'))
  file.copy(temp_file, local_report_tgz, overwrite = TRUE)
  unlink(temp_file, force = TRUE)
  return(local_report_tgz)
}

#' Untar a report.tgz file and return a simple `report_dir` object
#'
#' This function is used to untar a report.tgz file and return a simple
#' `report_dir` object. The `report_dir` object is a character(1) with
#' class `report_dir` and with attributes `md5`, `url`, and `local_report_tgz`.
#'
#' @param local_report_tgz character(1) The path to the report.tgz file
#' @param local_dir character(1) The directory to which the report.tgz file
#'  will be untarred (default: tempdir())
#'
#' @return A character(1) with the path to the untarred report directory
#'   with class `report_dir` and with attributes `md5`, `url`, and `local_report_tgz`.
#'
#' @examples
#' report_tgz = example_report_tgz()
#' report_dir = untar_report_tgz(report_tgz)
#'
#' head(list.files(report_dir, recursive = TRUE))
#'
#' @export
untar_report_tgz <- function(local_report_tgz, local_dir = tempdir()) {
  md5 = tools::md5sum(local_report_tgz)
  untar_dir = file.path(local_dir, md5)
  dir.create(untar_dir, recursive = TRUE, showWarnings = FALSE)
  untar(local_report_tgz, exdir = untar_dir)
  report_dir = file.path(untar_dir,'report')
  class(report_dir) <- c('report_dir', class(report_dir))
  attr(report_dir, 'md5') <- unname(md5)
  attr(report_dir, 'url') <- url
  attr(report_dir, 'local_report_tgz') <- local_report_tgz
  return(report_dir)
}

# taken from BiocPackageTools:::.import_dcf_stage_node
.read_summary_dcf_file <- function(filepath) {
  fields <- c("Package", "Version", "Status", "StartedAt", "EndedAt", "Command")
  stage <- head(strsplit(basename(filepath), "-", fixed = TRUE)[[1L]],
                1L)
  node <- basename(dirname(filepath))
  dcf_pkg <- read.dcf(filepath, fields = fields)
  dcf_chr <- structure(as.character(dcf_pkg), .Names = fields)
  append(dcf_chr, c(node = node, stage = stage), after = 1L)
}

#' Extract build_summary table from an extracted report tarball
#'
#' @param report_dir The directory containing the extracted report tarball.
#'   The report_dir should have been created by localize_report_tgz and
#'   should have class 'report_dir' with at least the `md5` attribute.
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @return A data frame with one row per build process per package
#'
#' @examples
#' report_tgz = example_report_tgz()
#' report_dir = untar_report_tgz(report_tgz)
#' get_build_summary_table(report_dir)
#'
#' @export
get_build_summary_table <- function(report_dir) {
  md5 <- attr(report_dir, 'md5')
  summary_dcf_files <- list.files(
    report_dir, pattern = '-summary\\.dcf$', recursive = TRUE, full.names = TRUE
  )
  df <- do.call(rbind, lapply(summary_dcf_files, .read_summary_dcf_file))
  df <- tibble::as_tibble(df)
  colnames(df) <- tolower(colnames(df))
  df |> dplyr::mutate(
    startedat = lubridate::parse_date_time(
      substr(startedat,1,25),
      orders = '%Y-%m-%d %H:%M:%S %z'
    ),
    endedat = lubridate::parse_date_time(
      substr(endedat,1,25),
      orders = '%Y-%m-%d %H:%M:%S %z'
    ),
    report_md5 = md5
  )
}


#' Extract info table from an extracted report tarball
#'
#' @param report_dir The directory containing the extracted report tarball.
#'   The report_dir should have been created by localize_report_tgz and
#'   should have class 'report_dir' with at least the `md5` attribute.
#'
#' @return A data frame with one row per package
#'
#' @examples
#' report_tgz = example_report_tgz()
#' report_dir = untar_report_tgz(report_tgz)
#' get_info_table(report_dir)
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @export
get_info_table <- function(report_dir) {
  md5 <- attr(report_dir, 'md5')
  info_dcf_files <- list.files(
    report_dir, pattern = 'info\\.dcf$', recursive = TRUE, full.names = TRUE
  )
  df <- do.call(rbind.data.frame, lapply(info_dcf_files, read.dcf))
  df <- tibble::as_tibble(df) |>
    dplyr::mutate(
      report_md5 = md5,
      git_last_commit_date = lubridate::parse_date_time(
        substr(git_last_commit_date,1,25),
        orders = '%Y-%m-%d %H:%M:%S %z'
      )
    )
  df
}

#' Extract propagation status table from an extracted report tarball
#'
#' @param report_dir The directory containing the extracted report tarball
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @return A data frame with one row per package per process
#'
#' @examples
#' report_tgz = example_report_tgz()
#' report_dir = untar_report_tgz(report_tgz)
#' get_propagation_status_table(report_dir)
#'
#' @export
get_propagation_status_table <- function(report_dir) {
  md5 <- attr(report_dir, 'md5')
  prop_status_db <- list.files(
    report_dir,
    pattern = 'PROPAGATION_STATUS_DB.txt$',
    recursive = TRUE,
    full.names = TRUE
  )[1]
  readr::read_delim(
    prop_status_db, delim = '#',
    col_names = c('package','process','propagate'),
    show_col_types = FALSE
  ) |>
    dplyr::mutate(
      propagate = stringr::str_replace(propagate, '^propagate: ',''),
      report_md5 = md5
    )
}

#' An example report.tgz file for testing
#'
#' @return A path to an example report.tgz file
#'
#' @author Sean Davis <seandavi@gmail.com>
#'
#' @examples
#' example_report_tgz()
#'
#' @export
example_report_tgz <- function() {
  system.file('extdata/f8fd2897cd9ae78c90986c0b4a434417-report.tgz', package='BiocBuildDB')
}
