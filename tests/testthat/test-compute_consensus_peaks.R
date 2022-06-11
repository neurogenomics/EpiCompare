test_that("compute_consensus_peaks works", {
  
    data("encode_H3K27ac") # example dataset as GRanges object
    data("CnT_H3K27ac") # example dataset as GRanges object
    data("CnR_H3K27ac") # example dataset as GRanges object
    grlist <- list(CnR=CnR_H3K27ac, CnT=CnT_H3K27ac, ENCODE=encode_H3K27ac)

    consensus_peaks <- compute_consensus_peaks(grlist = grlist,
                                               groups = c("Imperial",
                                                          "Imperial",
                                                          "ENCODE"), 
                                               method = "granges")
    testthat::expect_length(consensus_peaks$Imperial, 1325)
    testthat::expect_length(consensus_peaks$ENCODE, length(grlist$ENCODE)) 
    
    consensus_peaks2 <- compute_consensus_peaks(grlist = grlist,
                                               groups = c("Imperial",
                                                          "Imperial", 
                                                          "ENCODE"), 
                                               genome_build = "hg19",
                                               method = "consensusseeker")
    testthat::expect_length(consensus_peaks2$Imperial, 2982)
    testthat::expect_length(consensus_peaks$ENCODE, length(grlist$ENCODE)) 
})
