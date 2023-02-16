test_that("overlap_stat_plot works", {
  
  ### Load Data ###
  data("encode_H3K27ac") # example peakfile GRanges object
  data("CnT_H3K27ac") # example peakfile GRanges object
  data("CnR_H3K27ac") # example peakfile GRanges object
  ### Create Named Peaklist & Reference ###
  peaklist <- list('CnT'=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
  reference <- list("ENCODE"=encode_H3K27ac)
  out <- overlap_stat_plot(reference = reference,
                           peaklist = peaklist, 
                           workers = 1)
  testthat::expect_true(methods::is(out$plot,"gg"))
  testthat::expect_true(methods::is(out$data,"data.frame"))
  
  out <- EpiCompare::overlap_stat_plot(reference = reference, 
                                       peaklist = peaklist) 
  testthat::expect_true(methods::is(out$plot,"ggplot"))
  testthat::expect_equal(unique(out$data$sample),names(peaklist))
  testthat::expect_equal(unique(out$data$group),c("overlap","unique"))
})
