test_that("get_package_release_info", {

    expect_true(is.null(suppressMessages(get_package_release_info("NotAValidPackage"))))
    expect_error(get_package_release_info())
    expect_error(get_package_release_info(c("BiocFileCache", "AnnotationHub")))
    releaseInfo <- get_package_release_info("BiocFileCache")
    expect_true(all(c("tbl", "data.frame") %in% class(releaseInfo)))
    expect_true(all(c("Package", "Version", "git_branch", "git_last_commit",
    "git_last_commit_date") %in% names(releaseInfo)))
    
})

test_that("get_package_build_results", {

    expect_true(is.null(suppressMessages(get_package_build_results("NotAValidPackage")))) 
    expect_true(is.null(suppressMessages(get_package_build_results("BiocFileCache", branch="NotAValidBranch"))))
    expect_error(get_package_build_results(c("BiocFileCache", "AnnotationHub")))
    expect_error(get_package_build_results())
    expect_error(get_package_build_results("BiocFileCache", branch=c("devel", "RELEASE_3_22")))
    devBuild <- get_package_build_results("BiocFileCache")
    expect_true((devBuild |> distinct(git_branch) |> pull()) == "devel")
    expect_true((devBuild |> distinct(package) |> pull()) == "BiocFileCache")
    expect_true(all(c("package", "node", "stage", "version", "status", "git_branch", "git_last_commit",
                      "git_last_commit_date") %in% names(devBuild)))
    releaseBuild <-  get_package_build_results("BiocFileCache", "RELEASE_3_22")
    expect_true((releaseBuild |> distinct(git_branch) |> pull()) == "RELEASE_3_22")
})

test_that("package_error_count", {

    expect_true(is.null(suppressMessages(package_error_count("NotAValidPackage")))) 
    expect_error(package_error_count())
    allError <- package_error_count("BiocFileCache")
    expect_true((allError |> distinct(git_branch) |> nrow()) > 1)
    expect_true(all(c("node", "version", "stage", "count_total", "count_error", "git_branch") %in% names(allError)))
    expect_true(all(allError$count_total >= allError$count_error))
    branchError <- package_error_count("BiocFileCache", branch="RELEASE_3_22")
    expect_true((branchError |> distinct(git_branch) |> pull()) == "RELEASE_3_22")
    OSError <- package_error_count("BiocFileCache", builder="nebbiolo2", branch="RELEASE_3_22")
    expect_true((OSError |> distinct(git_branch) |> pull()) == "RELEASE_3_22")
    expect_true((OSError |> distinct(node) |> pull()) == "nebbiolo2")
    expect_true(all(OSError$count_total >= OSError$count_error))

    tempTbl <- suppressMessages(package_error_count("BiocFileCache", builder="bogus"))
    expect_true((tempTbl |> distinct(node) |> nrow()) > 1)
    expect_false("bogus" %in% tempTbl$node)
    expect_true((tempTbl |> distinct(git_branch) |> nrow()) > 1)

    tempTbl <- suppressMessages(package_error_count("BiocFileCache", branch="bogus"))
    expect_true((tempTbl |> distinct(git_branch) |> nrow()) > 1)
    expect_false("bogus" %in% tempTbl$git_branch)
    
    
})


test_that("package_failures_over_time", {

    expect_error(package_failures_over_time())
    expect_error(package_failures_over_time("NotAValidPackage"))
    expect_error(package_failures_over_time("NotAValidPackage", "NotAValidBuilder", "nottime"))
    expect_true(is.null(suppressMessages(package_failures_over_time("NotAValidPackage", "NotAValidBuilder")))) 
    expect_true(is.null(suppressMessages(package_failures_over_time("BiocFileCache", "NotAValidBuilder")))) 
    failTbl <- package_failures_over_time("BiocFileCache", "nebbiolo1", 24)
    expect_true(all(c("version", "episode", "first_failure", "last_failure","n_failures", "stages", "statuses") %in% names(failTbl)))
    expect_true(all(failTbl$first_failure <= failTbl$last_failure))

})

test_that("get_latest_branches", {

    expect_error(get_latest_branches(data.frame()))
    res <- get_latest_branches()
    expect_true(res[1] == "devel")
    expect_true(length(res)==2L)
    
})

test_that("get_build_report", {
    expect_error(get_build_report("NotADate"))
    res <-  get_build_report("2025-12-29")
    expect_true(all(c("package", "node", "version", "stage", "status", "git_branch") %in% names(res)))
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 2L)
    expect_true("devel" %in% release_vl)
    date_start <- res |> select(startedat) |> pull()
    expect_true(all(startsWith(as.character(date_start),"2025-12-29" )))
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) >= 1L)
    res <-  get_build_report("2025-12-29", branch="RELEASE_3_22")
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 1L)
    expect_true("RELEASE_3_22" == release_vl)
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) >= 1L)
    res <-  get_build_report("2025-12-29", branch="RELEASE_3_22", builder="nebbiolo2")
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 1L)
    expect_true("RELEASE_3_22" == release_vl)
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) == 1L)
    expect_true("nebbiolo2" == build_nodes) 

})

test_that("get_failing_packages", {
    res <- get_failing_packages()
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 2L)
    expect_true("devel" %in% release_vl)
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) >= 1L)
    res <- get_failing_packages("RELEASE_3_22")
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 1L)
    expect_true("RELEASE_3_22" == release_vl)
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) >= 1L)
    res <- get_failing_packages("RELEASE_3_22", "nebbiolo2")
    release_vl <- res |> select(git_branch) |> distinct() |> pull()
    expect_true(length(release_vl) == 1L)
    expect_true("RELEASE_3_22" == release_vl)
    build_nodes <- res |> select(node) |> distinct() |> pull()
    expect_true(length(build_nodes) == 1L)
    expect_true("nebbiolo2" == build_nodes) 
    
})
