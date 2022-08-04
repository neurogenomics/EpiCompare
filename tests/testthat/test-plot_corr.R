test_that("plot_corr works", {
    
    data("CnR_H3K27ac")
    data("CnT_H3K27ac")
    data("encode_H3K27ac")
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
    reference <- list("encode_H3K27ac" = encode_H3K27ac)

    cp_out <- plot_corr(peakfiles = peakfiles,
                        reference = reference,
                        genome_build = "hg19", 
                        bin_size = 1000)
    testthat::expect_equal(nrow(cp_out$data), 3)
    testthat::expect_equal(round(mean(cp_out$data),2), 0.71)
    testthat::expect_true(all(c("data","corr_plot") %in% names(cp_out)))
    testthat::expect_true(all(c("CnR_H3K27ac","CnT_H3K27ac",
                                  "encode_H3K27ac") %in% colnames(cp_out$data)))
    testthat::expect_true(methods::is(cp_out$corr_plot,"gg"))
})
