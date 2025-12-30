#' @title Get git information for a given package across all Bioconductor releases
#'
#' @description Get the package version and git commit data for all releases in Bioconductor.
#'
#' @details Utilizes data from the info parquet file to retrieve the equivalent
#' git information for every available Bioconductor release of a package. This
#' include the git commit hash and last commit date along with the package version.
#' 
#' @param packagename a single valid Bioconductor package name
#'
#' @return tibble of release information or NULL if package is not found
#'
#' @aliases get_package_release_info
#'
#' @seealso get_bbs_table
#'
#' @author Lori Shepherd
#'
#' @examples
#' get_package_release_info("BiocFileCache")
#'
#' @import dplyr
#' @export
#' 
get_package_release_info <- function(packagename){

    stopifnot(is.character(packagename), length(packagename)==1L)
    infoTbl <- suppressMessages(get_bbs_table("info"))
    if(packagename %in% infoTbl$Package){
        infoTbl |>
            filter(Package == packagename) |>
            group_by(Package, git_branch) |>
            slice_max(order_by = git_last_commit_date, n = 1, with_ties = FALSE) |>
            ungroup() |>
            select(Package, Version, git_branch, git_last_commit, git_last_commit_date)
    }else{
        message(sprintf("Package: '%s' Not Found.\n  Please check spelling and capitalization",
                        packagename))
        NULL
    }
}



#' @title Get the most recent build result data for a given package on a given branch
#'
#' @description Get the build status information for a given package on a specified branch.
#'
#' @details Utilizes data from the info and build_summary parquet files to
#' retrieve the latest build results for a specified package on a given
#' branch. If no branch is given it defaults to use 'devel'. The data returned
#' includes the node (builder machine name), stage (install, build, check),
#' package version number, status of stage, date stage completed, and git
#' information for the build (git branch, git commit hash, git commit date).
#' 
#' @param packagename a single valid Bioconductor package name
#' @param branch a bioconductor branch (eg. 'devel', 'RELEASE_3_22')
#' 
#' @return tibble of build status information or NULL if package or branch is not found
#'
#' @aliases get_package_build_results
#'
#' @seealso get_bbs_table
#'
#' @author Lori Shepherd
#'
#' @examples
#' get_package_build_results("BiocFileCache")
#' get_package_build_results("BiocFileCache", branch="RELEASE_3_22")
#'
#' @export
#' 
get_package_build_results <- function(packagename, branch="devel"){

    stopifnot(is.character(packagename), length(packagename)==1L)
    stopifnot(is.character(branch), length(branch)==1L)
    
    summaryTbl <- suppressMessages(get_bbs_table("build_summary"))
    
    if(!(packagename %in% summaryTbl$package)){
        message(sprintf("Package: '%s' Not Found.\n  Please check spelling and capitalization",
                        packagename))
        return(NULL)
    }
    
    pkgTbl <-
        summaryTbl |> filter(package == packagename) |>
        group_by(node, version, stage) |>
        slice_max(endedat, n = 1, with_ties = FALSE) |>
        ungroup()  |> 
        select(package, node, stage, version, status, endedat)

    infoTbl <- suppressMessages(get_bbs_table("info"))
    
    if(!(branch %in% infoTbl$git_branch)){
        message(sprintf("Branch: '%s' Not Found.\n  Please check spelling and capitalization",
                        branch))
        return(NULL)
    }
        
    info_latest <-
        infoTbl |> filter(Package == packagename) |>
        group_by(Version) |>
        slice_max(git_last_commit_date, n = 1, with_ties = FALSE) |>
        ungroup() |> 
        select(Version, git_branch, git_last_commit, git_last_commit_date)
    
    if (branch == "devel"){
        info_filtered <-
            info_latest |> filter(git_branch == branch) |>
            mutate(version_obj = package_version(Version)) |>
            slice_max(version_obj, n = 1, with_ties = FALSE) |>
            select(-version_obj)
    }else{
        info_filtered <-
            info_latest |> filter(git_branch == branch)
    }
    
    results <-
        pkgTbl |>
        inner_join(info_filtered, by = c("version" = "Version"))

    return(results)
}

#' @title Get a count of how many time a package failed on the Bioconductor
#' Build System
#'
#' @description Get a count of how many time a package failed (ERROR/TIMEOUT) on the
#' Bioconductor Build System; optionally can specify a specific builder or
#' branch to filter results.
#'
#' @details Utilizes data from the build_summary and info parquet files to
#' retrieve a count of errors (TIMEOUT/ERROR) for  a specified
#' package. Optionally a given builder machine name or Bioconductor branch may
#' be specified to filter request. If no builder is given it will return all. If
#' no branch is give it will also return all. The data returned
#' includes the node (builder machine name), package version number, stage
#' (install, build, check), total number of times that stage/builder tried to
#' run, total number of times the package failed during that stage, and the
#' given Bioconductor git branch.
#' NOTE: since 'devel' is on-going. There will be multiple 'devel' results
#' across multiple years not just the current devel. See example to filtering to
#' see most recent.
#' NOTE: If builder or branch is not found, function will continue and return
#' unfiltered results.
#' 
#' @param packagename a single valid Bioconductor package name
#' @param builder name of a valid Bioconductor build machine (ie 'nebbiolo1')
#' @param branch a bioconductor branch (eg. 'devel', 'RELEASE_3_22')
#' 
#' @return tibble of data including counts of runs and errors or NULL if package
#' is not found
#'
#' @aliases package_error_count
#'
#' @seealso get_bbs_table
#'
#' @author Lori Shepherd
#'
#' @examples
#' package_error_count("BiocFileCache")
#' package_error_count("BiocFileCache", branch="RELEASE_3_22")
#' package_error_count("BiocFileCache", builder = "nebbiolo2", branch="RELEASE_3_22")
#'
#' library(dplyr)
#' ## devel will have more than just current devel
#' devErrors <- package_error_count("BiocFileCache", branch="devel")
#' ## can use package version number to filter to current devel
#' devErrors |> filter(version == max(version))
#' 
#' @export
#' 
package_error_count <- function(packagename, builder=NULL, branch=NULL){

    stopifnot(is.character(packagename), length(packagename) == 1L)
    
    summaryTbl <- suppressMessages(get_bbs_table("build_summary"))
    
    if(!(packagename %in% summaryTbl$package)){
        message(sprintf("Package: '%s' Not Found.\n  Please check spelling and capitalization",
                        packagename))
        return(NULL)
    }

    pkgTbl <- summaryTbl |> filter(package == packagename)
    
    if (!is.null(builder)){
        if(!builder %in% pkgTbl$node){
            message(sprintf("Builder: '%s' Not Found after filtering for '%s'.\n  Please check spelling and capitalization",
                            builder, packagename))
        }else{        
            pkgTbl <- pkgTbl |> filter(node %in% builder)
        }
    }

    countTbl <- pkgTbl |>
        group_by(node, version, stage) |>
        summarise(
            count_total = n(),
            count_error = sum(status %in% c("ERROR", "TIMEOUT")),
            .groups = "drop"
        ) |>
        mutate(
            version = factor(version, levels = as.character(sort(package_version(unique(version)))))
        ) |>
        arrange(version, node)

    infoTbl <- suppressMessages(get_bbs_table("info"))
    branchTbl <- infoTbl |>
        filter(Package == packagename) |>
        mutate(Version = package_version(Version)) |>
        group_by(Version) |>
        slice_max(order_by = Version, n = 1, with_ties = FALSE) |>
        ungroup() |>
        select(Version, git_branch)
    
    countTbl <- countTbl |>
        mutate(version = package_version(as.character(version))) |>
        left_join(branchTbl, by = c("version" = "Version")) |>
        arrange(version, node)
    
    if (!is.null(branch)){
        if(!branch %in% countTbl$git_branch){
            message(sprintf("Branch: '%s' Not Found after filtering for '%s'.\n  Please check spelling and capitalization",
                            branch, packagename))
        }else{
            countTbl <- countTbl |> filter(git_branch %in% branch)
        }
    }

    return(countTbl)
}


#' @title Get rough timeline overview of package failing events
#'
#' @description Get rough timeline overview of a package failing events on a
#' specific builder
#'
#' @details This function attempts to give an overview of how long a package has
#' been failing on a given builder. The time to treat failures as a single event
#' is distinguished by consecutive days and by the failure_cluster_hours
#' argument. Currently there is a different cadence of builds for release
#' compared to devel so this allows the flexibility to define the timeline.
#' Let's use the following example for interpretation of the result table:
#' ```
#'   version episode       first_failure        last_failure n_failures
#'2   3.1.0       3 2025-12-15 02:57:57 2025-12-16 21:29:20          3
#'3   3.1.0       2 2025-12-13 02:32:33 2025-12-13 02:32:33          1
#'4   3.1.0       1 2025-12-08 21:30:14 2025-12-11 21:27:29          4
#'              stages statuses
#'2 buildsrc, checksrc    ERROR
#'3           checksrc    ERROR
#'4           buildsrc    ERROR
#' ```
#' The package version being built on the build system for this package is
#' 3.1.0. The episode refers to the number of failing episodic events. If we
#' look at the episode 1, the package started failing on December 8 and
#' continued to fail until December 11. During that time period there were 4
#' number of failures and they occurred during the build stage. The time between
#' the last failure of the first episode and the second episode is from December
#' 11 to December 13; we can infer then that the package built cleanly on
#' December 12. During episode 2 the package failed solely on December 13 but
#' during the check stage. Episode 3 began on Dec 15 and lasted until December
#' 16 and had 3 failures but they occurred in either the build or check stage.
#'
#' This hopefully can help determine if package failures are intermittent and
#' how long a package is failing on a given builder.
#' 
#' @param packagename a single valid Bioconductor package name
#' @param builder name of a valid Bioconductor build machine (ie 'nebbiolo1')
#' @param failure_cluster_hours numeric indicating the number of hours to treat
#' failures as a single event
#'
#' @return tibble of failure event information or NULL if package or builder is not found
#'
#' @aliases package_failure_over_time
#'
#' @seealso get_bbs_table
#'
#' @author Lori Shepherd
#'
#' @examples
#' package_failures_over_time("BiocFileCache", "nebbiolo1", 24)
#'
#' @export
#' 
package_failures_over_time <- function(packagename, builder, failure_cluster_hours = 72) {

    stopifnot(is.character(packagename), length(packagename) == 1L)
    stopifnot(is.character(builder), length(builder) == 1L)
    stopifnot(is.numeric(failure_cluster_hours), length(failure_cluster_hours) == 1L)

    summaryTbl <- suppressMessages(get_bbs_table("build_summary"))

    if (!(packagename %in% summaryTbl$package)) {
        message(sprintf("Package: '%s' Not Found.\n  Please check spelling and capitalization",
                        packagename))
        return(NULL)
    }

    if (!(builder %in% summaryTbl$node)) {
        message(sprintf("Builder: '%s' Not Found.\n  Please check spelling and capitalization",
                        builder))
        return(NULL)
    }

    pkgTbl <- summaryTbl |>
        filter(package == packagename,
               status %in% c("ERROR", "TIMEOUT"),
               node == builder) |>
        mutate(version = as.package_version(version)) |>
        arrange(startedat)   # oldest first for correct gap calculation

    if (nrow(pkgTbl) == 0) {
        message("No failing builds found for this package and builder.")
        return(NULL)
    }

    pkgEpisodes <- pkgTbl |>
        group_by(version) |>
        mutate(
            gap_hours = as.numeric(difftime(startedat, lag(startedat), units = "hours")),
            gap_days  = as.numeric(difftime(as.Date(startedat), lag(as.Date(startedat)), units = "days")),
            episode = cumsum(is.na(gap_hours) | (gap_hours > failure_cluster_hours & gap_days > 1))
        ) |>
        ungroup()

    episodeSummary <- pkgEpisodes |>
        group_by(version, episode) |>
        summarise(
            first_failure = min(startedat),
            last_failure  = max(startedat),
            n_failures    = n(),
            stages        = paste(sort(unique(stage)), collapse = ", "),
            statuses      = paste(sort(unique(status)), collapse = ", "),
            .groups = "drop"
        ) |>
        arrange(desc(first_failure))

    
    return(episodeSummary)
}
