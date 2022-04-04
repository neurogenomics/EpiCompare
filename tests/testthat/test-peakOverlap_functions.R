# test peakoverlap functions
data("encode_H3K27ac")
data("CnT_H3K27ac")

# example peaklist
peaklist <- list("encode"=encode_H3K27ac,
                 "CnT"=CnT_H3K27ac)

# test overlap_heatmap()
testthat::test_that("overlap_heatmap() generates correct plot
                    when interact=T/F", {
  p_interact <- EpiCompare::overlap_heatmap(peaklist, interact = TRUE)
  p <- EpiCompare::overlap_heatmap(peaklist, interact = FALSE)
  testthat::expect_true(methods::is(p_interact,c("plotly","htmlwidget")))
  testthat::expect_true(methods::is(p,c("gg","ggplot")))
})

# test upset_plot()
testthat::test_that("overlap_upset_plot() generates correct plot", {
  p <- EpiCompare::overlap_upset_plot(peaklist)
  testthat::expect_true(methods::is(p,"upset"))
})

# example reference
reference <- list("encode"=encode_H3K27ac)

# test overlap_stat_plot()
testthat::test_that("overlap_stat_plot() generates correct output", {
  out <- EpiCompare::overlap_stat_plot(reference, peaklist)
  p <- out[[1]]
  df <- out[[2]]
  testthat::expect_true(methods::is(p,c("gg","ggplot")))
  testthat::expect_equal(unique(out[[2]]$sample),c("encode","CnT"))
  testthat::expect_equal(unique(out[[2]]$group),c("overlap","unique"))
})
