#' Get \link[BiocParallel]{BiocParallel} parameters
#' 
#' Get (and optionally register) \link[BiocParallel]{BiocParallel} parameter 
#' (\code{BPPARAM}). \link[BiocParallel]{SnowParam} is the default function
#' as it tends to be more robust. However, because it doesn't work on Windows, 
#' this function automatically detected the Operating System and switches 
#' to  \link[BiocParallel]{SerialParam} as needed. 
#' @keywords internal
#' @param workers Number of threads to parallelize across. 
#' @param register_now Register the cores now with
#' \link[BiocParallel]{register} (\code{TRUE}),
#'  or simply return the \code{BPPARAM object} (default: \code{FALSE}). 
#' @param use_snowparam Whether to use
#'  \link[BiocParallel]{SnowParam} (default: \code{TRUE}) or
#'  \link[BiocParallel]{MulticoreParam} (\code{FALSE})
#'   when parallelising across multiple \code{workers}.
#' @inheritParams BiocParallel::SnowParam
#' @returns BPPARAM
get_bpparam <- function(workers,
                        progressbar=workers>1,
                        use_snowparam=TRUE,
                        register_now=FALSE){
    
    check_dep("BiocParallel")
    if(.Platform$OS.type == "windows"){
        BPPARAM <-  BiocParallel::SerialParam()
    } else {
        if(isTRUE(use_snowparam)){
            BPPARAM <- BiocParallel::SnowParam(workers = workers,
                                               progressbar = progressbar)
        } else{
            BPPARAM <- BiocParallel::MulticoreParam(workers = workers,
                                                    progressbar = progressbar)
        } 
    } 
    if(register_now){
        BiocParallel::register(BPPARAM = BPPARAM)
    } 
    return(BPPARAM)
}
