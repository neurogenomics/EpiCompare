#' Wrapper for \link[BiocParallel]{bplapply}
#' 
#' Wrapper function for \link[BiocParallel]{bplapply} that automatically
#' handles issues with \pkg[BiocParallel] related to different OS platforms.
#' @inheritParams get_bpparam 
#' @inheritParams BiocParallel::bplapply
#' @inheritDotParams BiocParallel::bplapply
#' @returns (Named) list.
#' 
#' @export
#' @examples
#' X <- stats::setNames(seq_len(length(letters)), letters)
#' out <- bpplapply(X, print) 
bpplapply <- function(X, 
                      FUN, 
                      workers=1, 
                      register_now=FALSE,
                      ...){
    
    requireNamespace("BiocParallel")
    BPPARAM <- get_bpparam(workers = workers,
                           register_now = register_now)
    BiocParallel::bplapply(X = X, 
                           FUN = FUN, 
                           BPPARAM = BPPARAM, 
                           ...)
}
