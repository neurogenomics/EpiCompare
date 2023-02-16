test_that("fragment_info works", {
   
  data("CnR_H3K27ac_picard")
  picardlist <- list("CnR"=CnR_H3K27ac_picard)
  
  info <- EpiCompare::fragment_info(picardlist)
  testthat::expect_true(methods::is(info,"data.frame"))
  testthat::expect_equal(ncol(info),3)
  testthat::expect_equal(nrow(info),1)
})
