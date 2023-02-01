#' Create a precision-recall matrix
#' 
#' Converts a list of peak files to a symmetric matrix where 
#' the y-axis indicates precision and the x-axis indicates recall.
#' 
#' @param fill_diag Fill the diagonal of the overlap matrix.
#' @param verbose Print messages.
#' @returns matrix
#' 
#' @keywords internal
#' @importMethodsFrom IRanges subsetByOverlaps
precision_recall_matrix <- function(peaklist,
                                    fill_diag=NA,
                                    verbose=TRUE){
  
    messager("Genreating precision-recall matrix.",v=verbose)
    overlap_list <- lapply(peaklist, function(mainfile){
        lapply(peaklist, function(subfile){
            # overlapping peaks
            overlap <- IRanges::subsetByOverlaps(x = subfile, 
                                                 ranges = mainfile)
            # calculate percentage overlap
            percent <- length(overlap)/length(subfile)*100
            return(percent)
        }) 
    })
    ### Create Matrix ###
    overlap_matrix <- matrix(unlist(overlap_list),
                             ncol = max(lengths(overlap_list)),
                             byrow = FALSE, 
                             dimnames = list(names(peaklist),
                                             names(peaklist)))  
    #### Fill diagonal ####
    if(!is.null(fill_diag)){
        diag(overlap_matrix) <- fill_diag
    }
    return(overlap_matrix)
}
