test_that("import_narrowPeak works", {

  path <- EpiCompare::write_example_peaks(datasets="encode_H3K27ac")
  peaks <- EpiCompare::import_narrowPeak(path=path)
  testthat::expect_true(methods::is(peaks,"GRanges"))
  testthat::expect_length(peaks,5142)
  testthat::expect_equal(ncol(GenomicRanges::mcols(peaks)),7)
})
