#' Remove non-standard chromosomes
#' 
#' Remove non-standard chromosomes from a list of 
#' \link[GenomicRanges]{GRanges} objects.
#' @param grlist Named list of \link[GenomicRanges]{GRanges} objects.
#' @param keep_chr Which chromosomes to keep.
#' @param verbose Print messages.
#' @returns Named list of \link[GenomicRanges]{GRanges} objects.
#' @keywords internal
#' @importFrom Seqinfo seqnames sortSeqlevels seqlevelsInUse
#' @importFrom GenomeInfoDb seqlevelsStyle
#' @importFrom BiocGenerics %in% 
remove_nonstandard_chrom <- function(grlist,
                                     keep_chr = paste0(
                                         "chr",c(seq_len(22),"X","Y")
                                     ),
                                     verbose = TRUE){
    #### Check if keep_chr is NULL ####
    if(is.null(keep_chr)) return(grlist)
    messager("Removing non-standard chromosomes.",v=verbose)
    #### Check if it's a single element ####
    tmp_list <- FALSE
    if(is_granges(grlist)){
        grlist <- list(gr1=grlist)
        tmp_list <- TRUE
    }
    grlist <- lapply(grlist, function(gr){ 
               suppressMessages(suppressWarnings(
                   GenomeInfoDb::seqlevelsStyle(gr) <- "UCSC"
               ))
               gr <- gr[BiocGenerics::`%in%`(Seqinfo::seqnames(gr),
                                             keep_chr)]
               Seqinfo::seqlevels(gr) <- Seqinfo::sortSeqlevels(
                   Seqinfo::seqlevelsInUse(gr)
               )
               #update seq lengths
               Seqinfo::seqlevels(
                   gr, pruning.mode="coarse") <- keep_chr
               return(gr)
           })
    if(tmp_list) grlist <- grlist[[1]]
    return(grlist)
}
