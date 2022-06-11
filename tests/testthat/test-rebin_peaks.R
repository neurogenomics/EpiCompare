test_that("rebin_peaks works", {
    
    data("CnR_H3K27ac")
    data("CnT_H3K27ac")
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, 
                      CnT_H3K27ac=CnT_H3K27ac,
                      CnT_missing=CnT_H3K27ac)
    #### Remove the necessary column to compute percentiles ####
    GenomicRanges::mcols(peakfiles$CnT_missing)$qValue <- NULL
    #increasing bin_size for speed
    peakfiles_rebinned <- rebin_peaks(peakfiles = peakfiles,
                                      genome_build = "hg19",
                                      bin_size = 5000)
    testthat::expect_true(methods::is(peakfiles_rebinned,"Matrix"))
    testthat::expect_equal(dim(peakfiles_rebinned),c(619146,2))
})
