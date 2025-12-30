#' @title Custom Environment to store downloaded parquet tibbles.
#'
#' @rdname bbs_cache
#' @name bbs_cache
#' 
#' @description A custom environment to store remotely read parquet files of
#' Bioconductor build reports. Once one of the three valid parquet files are
#' read in, the table is cached in this environment for quick easy reference
#' either to use ad hocly by the user or to be used within pre-defined queries
#' provided by this package.
#'
#' @aliases .bbs_cache
#'
#' @format An environment
.bbs_cache <- new.env(parent = emptyenv())


#' @import arrow
#'
#' @title Retrieve a remotely read parquet file of Bioconductor build data
#'
#' @description Bioconductor Build results are at times cumbersome to work with and
#' interrogate. Parquet files of condensed reports are provided remotely. These
#' functions read the remote parquet files using the arrow package and return a
#' tibble. Once retrieved the table is stored in a custom environment for easy
#' quick reference either to use ad hocly or within pre-defined queries provided
#' by this package.
#'
#' @details The get_bbs_table returns a tibble but is also saved in a custom
#' environment for quick easy subsequent reference. There are three tables
#' available and can be specified in get_bbs_table: build_summary, info, or
#' propagation_status. build_summary returns a tibble with the results of each
#' stage of the Bioconductor build process. info returns a tibble with
#' information regarding the package maintainer and git commit
#' status. propagation_status returns a tibble with data on if a package
#' propagated to the community.
#'
#' @param tblname A valid parquet file name. Currently available: build_summary,
#' info, or propagation_status.
#'
#' @return returns a tibble. 
#'
#' @author Lori Shepherd
#'
#' @aliases get_bbs_table
#'
#' @seealso get_all_bbs_tables
#' 
#' @examples
#' info <- get_bbs_table("info")
#' info
#' 
#' # all the package Lori Shepherd maintains
#' info |> filter(Maintainer == "Lori Shepherd") |> distinct(Package)
#'
#'
#' @export
get_bbs_table <- function(tblname=c("build_summary", "info",
                                    "propagation_status")){
    tblname <- match.arg(tblname)

    if (exists(tblname, envir = .bbs_cache)) {
        message(sprintf("Using cached table '%s'", tblname))
        return(get(tblname, envir = .bbs_cache))
    }  
    
    url <- paste0("s3://bioc-builddb-mirror/parquet/", tblname, ".parquet")
    message(sprintf("reading '%s' parquet file...", tblname))
    
    tbl <-
        tryCatch(
            arrow::read_parquet(url),
            error = function(e){
                warning(
                    sprintf("Could not read '%s' from remote location (%s)",
                            tblname, conditionMessage(e)),
                    call. = FALSE
                )
                return(NULL)
            })

    if (!is.null(tbl)) {
        assign(tblname, tbl, envir = .bbs_cache)
    }
  
    tbl
}

#' @title Retrieve all available Bioconductor build system parquet files
#'
#' @description Retrieve all available parquet tables at once.
#'
#' @param assign_to_global logical(1) indicating if downloaded tables should be
#' assigned to the current global environment for access. Default is FALSE and
#' only assigned to custom environment through call to get_bbs_table.
#'
#' @return invisible. tables are cached to custom environment unless
#' assign_to_global is TRUE.
#'
#' @aliases get_all_bbs_tables
#'
#' @details This function is a quick wrapper around get_bbs_table to download
#' all available parquet files as tibbles.  By default no value is returned and
#' the tibbles are stored to the custom environment and can be easily accessed
#' through a call to get_bbs_table.
#' 
#' @author Lori Shepherd
#'
#' @seealso get_bbs_table
#' 
#' @examples
#' get_all_bbs_tables()
#'
#' # Now that all are downloaded. Retrieve cached build_summary tibble
#' build_summary <- get_bbs_table("build_summary")
#'
#' # find the times the package BiocFileCache failed on linux nebbiolo builders
#' build_summary |> filter(package == "BiocFileCache", str_starts(node, "nebbiolo"), status == "ERROR")
#' 
#' @export 
get_all_bbs_tables <- function(assign_to_global = FALSE) {

    stopifnot(is.logical(assign_to_global), length(assign_to_global)==1L)
    
    table_names <- c("build_summary", "info", "propagation_status")
    tables <- list()
  
    for (tblname in table_names) {
        tbl <- get_bbs_table(tblname)
        tables[[tblname]] <- tbl
        
        if (assign_to_global && !is.null(tbl)) {
            assign(tblname, tbl, envir = .GlobalEnv)
            message(sprintf("Table '%s' assigned to global environment", tblname))
        }
    }
    
    invisible(tables)    
}



