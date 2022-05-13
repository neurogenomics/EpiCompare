test_that("liftover_grlist works", {
  
    data("encode_H3K27ac") # example dataset as GRanges object
    data("CnT_H3K27ac") # example dataset as GRanges object
    data("CnR_H3K27ac") # example dataset as GRanges object
    grlist <- list("encode_H3K27ac"=encode_H3K27ac,
                   "CnT_H3K27ac"=CnT_H3K27ac,
                   "CnR_H3K27ac"=CnR_H3K27ac)

    grlist_lifted <- liftover_grlist(grlist = grlist,
                                     input_build = "hg19",
                                     output_build="hg38")
    testthat::expect_length(grlist_lifted,length(grlist))
    testthat::expect_true(all(unlist(lapply(grlist_lifted,methods::is,"GRanges"))))
    
    nm <- names(grlist)[1]
    gr1 <- grlist[[nm]] 
    gr2 <- grlist_lifted[[nm]] 
    testthat::expect_gt(length(gr2), length(gr1))
})
