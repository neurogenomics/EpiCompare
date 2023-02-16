test_that("overlap_heatmap works", {
                      
  data("encode_H3K27ac")
  data("CnT_H3K27ac")
  peaklist <- list("encode"=encode_H3K27ac,
                   "CnT"=CnT_H3K27ac)
  
  p_interact <- EpiCompare::overlap_heatmap(peaklist = peaklist, 
                                            interact = TRUE)
  testthat::expect_true(methods::is(p_interact$plot,"plotly"))
  
  p <- EpiCompare::overlap_heatmap(peaklist = peaklist, 
                                   interact = FALSE)
  testthat::expect_true(methods::is(p$plot,"ggplot"))
}) 