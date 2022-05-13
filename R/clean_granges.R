#' Clean GRanges
#' 
#' Remove columns from the metadata (\code{GenomicRanges::mcols}) that
#' conflicts with \link[GenomicRanges]{GRanges} conventions.
#' 
#' @param gr A \link[GenomicRanges]{GRanges} object.
#' @param nono_cols Problematic columns to search for and remove (if present).
#' @keywords internal
#' @importFrom GenomicRanges mcols
#' @returns Cleaned \link[GenomicRanges]{GRanges} object. 
clean_granges <- function(gr,
                          nono_cols = c("seqnames", 
                                         "ranges",
                                         "strand",
                                         "seqlevels", 
                                         "seqlengths", 
                                         "isCircular",
                                         "start", 
                                         "end", 
                                         "width", 
                                         "element")){ 
    cnames <- colnames(GenomicRanges::mcols(gr))
    rm_cols <- cnames[cnames %in% nono_cols]
    if(length(rm_cols)>0){
        for(rcol in rm_cols){
            GenomicRanges::mcols(gr)[rcol] <- NULL
        } 
    }
    return(gr)
}
