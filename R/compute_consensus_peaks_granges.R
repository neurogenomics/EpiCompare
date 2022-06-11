compute_consensus_peaks_granges <- function(grlist,
                                            upper,
                                            lower,
                                            min.gapwidth){
    peak_coverage <- GenomicRanges::coverage(grlist)
    consensus_peaks <- IRanges::slice(x = peak_coverage, 
                                      upper = upper,
                                      lower = lower, 
                                      rangesOnly = TRUE)
    consensus_peaks <- GenomicRanges::GRanges(consensus_peaks)
    #### Merge nearby peaks ####
    consensus_peaks <- GenomicRanges::reduce(x = consensus_peaks, 
                                             min.gapwidth = min.gapwidth)
    return(consensus_peaks)
}
