#' read a little file-based database of last-modified dates for reports
#'
#' If the file does not exist, the function returns an empty tibble
#' with the expected columns.
#'
#' @param reportdb_file the file to read the database from
#'
#' @return a tibble with columns url and old_last_modified
#'
#' @export
report_last_mod_db <- function(reportdb_file) {
  if(file.exists(reportdb_file)) {
    reportdb = readr::read_csv(reportdb_file)
  } else {
    reportdb = tibble::tibble(
      url = character(0),
      old_last_modified = as.POSIXct(character(0))
    )
  }
  reportdb
}


#' Localize any new reports to a local directory
#'
#' Run this function to download any new reports to a local directory.
#' The function reads a little file-based database of last-modified dates
#' for reports, and compares the dates to the current last-modified dates
#' on the server. If the server has a newer report, the function downloads
#' the report to the local directory and renames it with the `md5`
#' hash of the file contents. The function then updates the database
#' with the new last-modified date and saves it to the reportdb_file.
#'
#' @param reportdb_file the file to read the database from
#' @param cache_dir the directory to store the reports in
#'
#' @examples
#' \dontrun{
#' cachedir = tempdir()
#' localize_all_new_reports("reportdb.csv", cachedir)
#' list.files(cachedir, pattern = 'tgz$')
#' }
#'
#'
#' @export
localize_all_new_reports <- function(reportdb_file, cache_dir = tempdir()) {
  reportdb = report_last_mod_db(reportdb_file)
  report_urls = current_report_tgz_links()
  last_mod_dates = sapply(report_urls, last_modified_date)
  new_reports = tibble::tibble(url = report_urls, last_modified = as.POSIXct(last_mod_dates))
  all_data = new_reports |>
    dplyr::left_join(reportdb, by = "url")
  new_reports = all_data |>
    dplyr::filter(is.na(old_last_modified) | last_modified > old_last_modified)
  sapply(new_reports$url, localize_report_tgz, local_dir = cache_dir)
  new_reports$old_last_modified = new_reports$last_modified
  new_reports$last_modified = NULL
  write.csv(new_reports, reportdb_file, row.names = FALSE)
}
