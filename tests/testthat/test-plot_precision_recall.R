test_that("plot_precision_recall works", {
  
    data("CnR_H3K27ac")
    data("CnT_H3K27ac")
    data("encode_H3K27ac")
    peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
    reference <- list("encode_H3K27ac" = encode_H3K27ac)

    pr_out <- plot_precision_recall(peakfiles = peakfiles,
                                    reference = reference)
    testthat::expect_equal(nrow(pr_out$data), 22)
    testthat::expect_true(all(c("precision","recall","F1") %in% names(pr_out$data)))
    testthat::expect_true(methods::is(pr_out$precision_recall_plot,"gg"))
    testthat::expect_true(methods::is(pr_out$f1_plot,"gg"))
})
