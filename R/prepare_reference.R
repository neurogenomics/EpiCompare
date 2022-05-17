#' Prepare referemce as GRanges
#'
#' @param reference A named list of \link[GenomicRanges]{GRanges} objects, 
#' or a single \link[GenomicRanges]{GRanges} object to be converted into a 
#' named list.
#' @param max_elements Max number of elements to use within the list.
#' Set to \code{NULL} (default) to use all elements. 
#'
#' @return A list of \link[GenomicRanges]{GRanges} objects
#'
#' @keywords internal
#' @importFrom methods is
prepare_reference <- function(reference,
                              max_elements=NULL){
    message("Preparing reference.")
    if(is.null(reference)) {
        message("No reference provided. Returning NULL.")
        return(NULL)
    }
    if(!methods::is(reference,"list")){
        reference <- list(reference)
    }
    if(is.null(names(reference))){
        names(reference) <- paste0("reference",seq_len(length(reference)))
    }  
    #### Limit the number of elements ####
    if((!is.null(max_elements))){
        if(length(reference)>max_elements){
            msg <- paste("Warning:",length(reference),
                         "elements were found in reference list",
                         "Only using first element.")
            message(msg)
            reference <- reference[seq_len(max_elements)]
        } else if(length(reference)==1 && 
                  max_elements==1) {
            msg <- paste("Extracting GRanges object from list.")
            message(msg)
            reference <- reference[[1]]
        } 
    } 
    
    return(reference)
}