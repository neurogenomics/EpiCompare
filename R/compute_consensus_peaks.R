#' Compute consensus peaks
#' 
#' Compute consensus peaks from a list of GRanges.
#' 
#' @param grlist Named list of \link[GenomicRanges]{GRanges} objects.
#' @param groups A character vector of the same length as \code{grlist} 
#' defining how to group \link[GenomicRanges]{GRanges} objects when 
#' computing consensus peaks.
#' @param method Method to call peaks with:
#' \itemize{
#' \item{"granges" : }{Simple overlap procedure using 
#' \link[GenomicRanges]{GRanges} functions.
#' Faster but less accurate.}
#' \item{"consensusseeker" : }{
#' Uses \link[consensusSeekeR]{findConsensusPeakRegions} to compute consensus
#' peaks. 
#' Slower but more accurate.}
#' }
#' @inheritParams check_genome_build
#' @inheritParams IRanges::slice
#' @inheritParams IRanges::reduce
#' @inheritDotParams consensusSeekeR::findConsensusPeakRegions
#' @returns Named list of consensus peak \link[GenomicRanges]{GRanges}.
#' 
#' @source \href{https://ro-che.info/articles/2018-07-11-chip-seq-consensus}{
#' GenomicRanges tutorial}
#' @source \href{https://doi.org/doi:10.18129/B9.bioc.consensusSeekeR}{
#' consensusSeekeR}
#' @export
#' @importFrom GenomicRanges coverage GRangesList GRanges
#' @importFrom IRanges slice reduce
#' @importFrom GenomeInfoDb seqlevelsInUse
#' @examples 
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object 
#' grlist <- list(CnR=CnR_H3K27ac, CnT=CnT_H3K27ac, ENCODE=encode_H3K27ac)
#'
#' consensus_peaks <- compute_consensus_peaks(grlist = grlist,
#'                                            groups = c("Imperial",
#'                                                       "Imperial",
#'                                                       "ENCODE"))
compute_consensus_peaks <- function(grlist,
                                    groups=NULL,
                                    genome_build,
                                    lower=2,
                                    upper=Inf,
                                    min.gapwidth=1L,
                                    method=c("granges","consensusseeker"),
                                    ...){
    method <- tolower(method)[1]
    if(method=="consensusseeker"){
        requireNamespace("consensusSeekeR")
        if(missing(genome_build)){
            stopper("Must provide genome_build when method='consensusseeker'")
        }
    }
    #### Checking groupings are valid ####
    if(is.null(groups)){
        groups <- "all"
    } else {
        if(length(groups)!=length(grlist)){
            stopper("groups must be the same length as grlist or NULL.")
        }
    }
    #### Remove non-standard chr ####
    grlist <- remove_nonstandard_chrom(grlist = grlist)
    #### Find consensus peaks in each group ####
    consensus_peaks_grouped <- lapply(unique(groups), function(g){ 
        messager("Computing conensus peaks for group:",g)
        grlist2 <- grlist[which(groups==g)]
        if(length(grlist2)<2){
            messager(
                "WARNING:",
                "Cannot compute consensus peaks when group has <2 peak files.",
                "Returning original GRanges object instead.")
            return(grlist2[[1]])
        }
        grlist2 <- GenomicRanges::GRangesList(
            mapply(grlist2,
                   SIMPLIFY = FALSE,
                   FUN=clean_granges)
            ) 
        if(method=="consensusseeker"){ 
            consensus_peaks <- compute_consensus_peaks_consensusseeker(
                grlist = grlist2, 
                genome_build = genome_build,
                ...)
        }else if(method=="granges"){
            consensus_peaks <- compute_consensus_peaks_granges(
                grlist = grlist2,
                upper = upper, 
                lower = lower, 
                min.gapwidth = min.gapwidth)
        } else {
            stopper("Method must be one of:",
                    paste("\n -",c("granges","consensusseeker"),collapse = ""))
        }
        #### Report ####
        messager("Identified",formatC(length(consensus_peaks),big.mark = ","),
                 "consensus peaks from",formatC(length(grlist),big.mark = ","),
                 "peak files")
        return(consensus_peaks)
    }) 
    names(consensus_peaks_grouped) <- unique(groups)
    return(consensus_peaks_grouped)
}
