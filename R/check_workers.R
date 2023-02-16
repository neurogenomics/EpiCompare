#' Check workers
#' 
#' Assign parallel worker cores.
#' @param workers Number of cores to parallelise across 
#' (in applicable functions).
#' If \code{NULL}, will set to the total number of available cores minus 1.
#' @returns Integer
#' 
#' @export
#' @importFrom parallel detectCores
#' @examples 
#' workers <- check_workers()
check_workers <- function(workers=NULL){
  if(is.null(workers)) workers <- parallel::detectCores()-1
  return(workers)
}