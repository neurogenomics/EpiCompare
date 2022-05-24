#' Is an object of class GRanges
#'
#' Check whether an object is of the class \link[GenomicRanges]{GRanges}.
#' @param obj Any R object.
#' @returns Boolean.
#' @keywords internal
#' @importFrom methods is 
is_granges <- function(obj) {
    methods::is(obj, "GRanges")
}
