#' Check \link[GenomicRanges]{GRanges} list columns
#' 
#' Check that at least one of the required columns is in 
#' a list of \link[GenomicRanges]{GRanges} objects.
#' Elements that do not meet this criterion will be dropped from the list.
#' 
#' @param grlist Named list of \link[GenomicRanges]{GRanges} objects.
#' @param target_cols A character vector of column names to search for.
#' 
#' @keywords internal
#' @importFrom GenomicRanges mcols
#' @returns Named list of \link[GenomicRanges]{GRanges} objects.
check_grlist_cols <- function(grlist,
                              target_cols){ 
    nms <- names(grlist)
    grlist <- lapply(seq_len(length(grlist)),  
                     FUN=function(i){
                         gr <- grlist[[i]]
                         if(all(!target_cols %in%
                                names(GenomicRanges::mcols(gr))) ){
                             msg <- paste(
                                 "WARNING:",
                                 paste0("'",names(grlist)[i],"'"),
                                 "missing threshold col,",
                                 "will be",
                                 "excluded from precision-recall",
                                 "calculations.")
                             message(msg)
                             return(NULL)
                         } else {
                             return(gr)
                         } 
                     }) 
    names(grlist) <- nms
    #### Remove NULL items ####
    grlist <- grlist[!unlist(lapply(grlist, is.null))]
    return(grlist)
}