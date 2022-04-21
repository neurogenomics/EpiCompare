test_that("gather_files works", {

  #### Make example files ####
  save_paths <- EpiCompare::write_example_peaks()
  dir <- unique(dirname(save_paths))
  datasets <- eval(formals(write_example_peaks)$datasets)
  testthat::expect_equal(length(save_paths), length(datasets))

  #### Gather/import files ####
  peaks <- EpiCompare::gather_files(dir=dir, type="*.narrowPeaks.bed$")
  testthat::expect_equal(length(peaks), length(datasets))
  #testthat::expect_true(all(lapply(peaks, methods::is,'GRanges')))
  for(peak in peaks){
    testthat::expect_true(methods::is(peak, 'GRanges'))
  }
})



