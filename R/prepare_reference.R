#' Prepare referemce as GRanges
#'
#' @param reference A named list of \link[GenomicRanges]{GRanges} objects, 
#' or a single \link[GenomicRanges]{GRanges} object to be converted into a 
#' named list.
#' @param max_elements Max number of elements to use within the list.
#' Set to \code{NULL} (default) to use all elements. 
#' @param remove_empty Remove any empty elements in the list.
#' @param as_list Return as a list.
#' @param as_grangeslist Return as a \link[GenomicRanges]{GRangesList}
#' (overrides \code{as_list}).
#'
#' @return A list of \link[GenomicRanges]{GRanges} objects
#'
#' @keywords internal
#' @importFrom methods is as
prepare_reference <- function(reference,
                              max_elements=NULL,
                              remove_empty=TRUE,
                              as_list=TRUE,
                              as_grangeslist=FALSE){
    message("Preparing reference.")
    if(is.null(reference)) {
        message("No reference provided. Returning NULL.")
        return(NULL)
    }
     
    if(isTRUE(as_list) | isTRUE(as_grangeslist)){
      if(methods::is(reference,"GRangesList") &&
         isFALSE(as_grangeslist)){
        reference <- as.list(reference)
      }
      if(!methods::is(reference,"list")){
        if(methods::is(reference,"GRangesList")){
          reference <- as.list(reference)
        } else {
          reference <- list(reference) 
        }
      }
      if(isTRUE(as_grangeslist) ){
        reference <- methods::as(reference,"GRangesList") 
      }
    }
    reference <- check_list_names(peaklist = reference, 
                                  default_prefix = "reference") 
    #### Remove empty elements ####
    if(isTRUE(remove_empty)){
        reference <- remove_empty_elements(peaklist = reference)
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
                  max_elements==1 &&
                  isFALSE(as_list)) {
            msg <- paste("Extracting only the first GRanges object from list.")
            message(msg)
            reference <- reference[[1]]
        } 
    } 
    return(reference)
}