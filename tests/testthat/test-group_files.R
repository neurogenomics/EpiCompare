test_that("group_files works", {
  
    data("encode_H3K27ac") # example dataset as GRanges object
    data("CnT_H3K27ac") # example dataset as GRanges object
    data("CnR_H3K27ac") # example dataset as GRanges object
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac,
                      CnT_H3K27ac=CnT_H3K27ac,
                      encode_H3K27ac=encode_H3K27ac)

    peaks_grouped <- group_files(peakfiles = peakfiles,
                                 searches=list(assay=c("H3K27ac"),
                                               source=c("Cn","ENCODE"))) 
    testthat::expect_true(length(peakfiles)==length(peaks_grouped))
    testthat::expect_true(length(unique(peaks_grouped))==2)
    testthat::expect_true(all(c("H3K27ac_Cn","H3K27ac_Cn","H3K27ac_ENCODE")
                              %in% peaks_grouped))
    
    
    peaks_grouped <- group_files(peakfiles = peakfiles,
                                 searches=list(assay=c("H3K27ac")) ) 
    testthat::expect_true(length(peakfiles)==length(peaks_grouped))
    testthat::expect_true(length(unique(peaks_grouped))==1) 
})
