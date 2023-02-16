test_that("report_header works", {
  header <- report_header()
  testthat::expect_true(grepl("EpiCompare",header))
})
