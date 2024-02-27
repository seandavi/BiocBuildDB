#' Create tables for a report directory
#'
#' This function creates a set of tables from a report directory.
#'
#' @param report_dir character(1) The directory containing the report files.
#'
#' @return A list of data.frames with the tables from the report directory.
#'
#' @export
tables_from_report_dir <- function(report_dir) {
  tables = list()
  tables$build_summary <- get_build_summary_table(report_dir)
  tables$info <- get_info_table(report_dir)
  tables$propagation_status <- get_propagation_status_table(report_dir)
  tables
}


#' Write tables to files based on md5 naming
#'
#' @param table_list A list of data.frames to be written to files.
#' @param out_dir The directory to which the files will be written.
#' @param md5 The md5 hash of the report directory. Will be used
#' as a prefix for the files.
#'
#' @export
write_tables_to_files <- function(table_list, out_dir, md5) {
  for (table_name in names(table_list)) {
    if (is.null(table_list[[table_name]])) {
      next
    }
    readr::write_csv(
      table_list[[table_name]],
      file.path(out_dir, paste0(md5, "-", table_name, ".csv.gz"))
    )
  }
}


#' Get and process all new build reports
#'
#' @param reportdb_file character(1) Filename of the reportdb file with last modification dates.
#'   The file does not need to exist. If it does, it will be read and updated.
#'   If it does not, it will be created.
#' @param local_dir The directory to which the report.tgz files will be copied,
#'   untarred, and processed.
#'
#' @export
process_all_new_reports <- function(reportdb_file, local_dir) {
  localize_all_new_reports(reportdb_file, local_dir)
  reports = list.files(
    local_dir, pattern = "-report.tgz",
    full.names = TRUE)
  for (report_tgz in reports) {
    message("Processing ", report_tgz)
    report_dir = untar_report_tgz(report_tgz)
    tables = tables_from_report_dir(report_dir)
    md5 = attr(report_dir, 'md5')
    write_tables_to_files(tables, local_dir, md5)
    unlink(report_dir, recursive = TRUE)
    message("Processed ", report_tgz)
  }
}
