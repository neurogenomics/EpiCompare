test_that("width_boxplot works",{
  
  data("encode_H3K27ac") 
  peaklist <- list("encode"=encode_H3K27ac)
  
  p <- EpiCompare::width_boxplot(peaklist)
  testthat::expect_true(methods::is(p$plot,"ggplot"))
  testthat::expect_true(methods::is(p$data,"data.frame"))
})
