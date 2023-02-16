test_that("peak_info works",{
  
  data("encode_H3K27ac")
  data("hg19_blacklist")
  data("CnR_H3K27ac_picard")
  peaklist <- list("encode"=encode_H3K27ac) 
  
  info <- EpiCompare::peak_info(peaklist, hg19_blacklist)
  testthat::expect_true(methods::is(info,"data.frame"))
  testthat::expect_equal(ncol(info),4)
  testthat::expect_equal(nrow(info),1)
})