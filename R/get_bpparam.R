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
#' @returns BPPARAM
get_bpparam <- function(workers,
                        register_now=FALSE){
    requireNamespace("BiocParallel")
    if(.Platform$OS.type == "windows"){
        BPPARAM <-  BiocParallel::SerialParam()
    } else {
        BPPARAM <-  BiocParallel::SnowParam(workers = workers,
                                            progressbar = workers>1)
    } 
    if(register_now){
        BiocParallel::register(BPPARAM = BPPARAM)
    } 
    return(BPPARAM)
}
