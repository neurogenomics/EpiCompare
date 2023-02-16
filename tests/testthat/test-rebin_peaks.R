test_that("rebin_peaks works", {
    
    data("CnR_H3K27ac")
    data("CnT_H3K27ac")
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, 
                      CnT_H3K27ac=CnT_H3K27ac,
                      CnT_missing=CnT_H3K27ac)
    #### Remove the necessary column to compute percentiles ####
    GenomicRanges::mcols(peakfiles$CnT_missing)$qValue <- NULL
    GenomicRanges::mcols(peakfiles$CnT_missing)$score <- NULL
    # Using large bin_size for speed
    #### With selected chroms ####
    peakfiles_rebinned <- EpiCompare::rebin_peaks(peakfiles = peakfiles,
                                                  genome_build = "hg19",
                                                  bin_size = 5000,
                                                  workers = 1)
    testthat::expect_true(methods::is(peakfiles_rebinned,"Matrix"))
    testthat::expect_equal(dim(peakfiles_rebinned),c(647114,2))
    
    #### With selected chroms ####
    keep_chr <- paste0("chr",seq_len(12))
    peakfiles_rebinned2 <- EpiCompare::rebin_peaks(peakfiles = peakfiles,
                                                   keep_chr = keep_chr,
                                                   genome_build = "hg19",
                                                   bin_size = 5000,
                                                   workers = 1)
    testthat::expect_true(methods::is(peakfiles_rebinned2,"Matrix"))
    testthat::expect_equal(dim(peakfiles_rebinned2),c(416959,2))
})
