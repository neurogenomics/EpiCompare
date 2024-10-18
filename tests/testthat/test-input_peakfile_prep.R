data("encode_H3K27ac")
data("CnT_H3K27ac")
data("CnR_H3K27ac")
data("hg19_blacklist")

# test names
test_that("Default names added to peaklist if none provided",{
  # no names are provided
  peaklist <- list(encode_H3K27ac, CnT_H3K27ac, CnR_H3K27ac)
  peaklist <- check_list_names(peaklist)
  expect_equal(names(peaklist), c("sample1", "sample2", "sample3"))
  # one name is provided
  names(peaklist) <- c("encode")
  peaklist <- check_list_names(peaklist)
  expect_equal(names(peaklist), c("encode", "sample2", "sample3"))
})

# test tidy peakfile
test_that("tidy_peakfile() removes peaks in blacklisted
          and non-standard regions",{
  peaklist <- list("encode"=encode_H3K27ac)
  peaklist_tidy <- EpiCompare::tidy_peakfile(peaklist, hg19_blacklist)
  peaklist_chrm_removed <- tidy_chromosomes(peaklist[[1]],
                                            keep.X = TRUE,
                                            keep.Y = TRUE)
  peaklist_chrm_blist_removed <-IRanges::subsetByOverlaps(peaklist_chrm_removed,
                                                          hg19_blacklist,
                                                          invert = TRUE)
  testthat::expect_equal(length(peaklist_tidy[[1]]),
                          length(peaklist_chrm_blist_removed))
})
