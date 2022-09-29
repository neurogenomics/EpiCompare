test_that("gather_files works", {

  #### Make example files ####
  save_paths <- EpiCompare::write_example_peaks()
  dir <- unique(dirname(save_paths))
  datasets <- eval(formals(write_example_peaks)$datasets)
  testthat::expect_equal(length(save_paths), length(datasets))

  #### Import files ####
  peaks <- EpiCompare::gather_files(dir=dir, type="*.narrowPeaks.bed$")
  testthat::expect_equal(length(peaks), length(datasets)) 
  for(peak in peaks){
    testthat::expect_true(methods::is(peak,'GRanges'))
  }
  
  #### Gather files ####
  peaks2 <- EpiCompare::gather_files(dir=dir, 
                                     type="peaks.narrow",
                                     return_paths = TRUE)
  testthat::expect_equal(length(peaks2), length(datasets)) 
  for(peak in peaks2){
      testthat::expect_true(file.exists(peak))
  }
  
  #### Gather NO files ####
  peaks3 <- EpiCompare::gather_files(dir="./", 
                                     type="peaks.narrow",
                                     return_paths = TRUE)
  testthat::expect_null(peaks3)
})



