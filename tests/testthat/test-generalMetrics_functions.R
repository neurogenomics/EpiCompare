data("encode_H3K27ac")
data("hg19_blacklist")
data("CnR_H3K27ac_picard")

# example peaklist
peaklist <- list("encode"=encode_H3K27ac)

# test peak_info()
testthat::test_that("peak_info() outputs a data.frame with correct n of rows
                    and cols",{
  info <- EpiCompare::peak_info(peaklist, hg19_blacklist)
  testthat::expect_true(methods::is(info,"data.frame"))
  testthat::expect_equal(ncol(info),4)
  testthat::expect_equal(nrow(info),1)
})

# example picard list
picardlist <- list("CnR"=CnR_H3K27ac_picard)

# test fragment_info()
testthat::test_that("fragment_info() outputs a data.frame with correct n of
                    rows and cols",{
  info <- EpiCompare::fragment_info(picardlist)
  testthat::expect_true(methods::is(info,"data.frame"))
  testthat::expect_equal(ncol(info),3)
  testthat::expect_equal(nrow(info),1)
})

# test width boxplot
testthat::test_that("width_boxplot() outputs a ggplot",{
  p <- EpiCompare::width_boxplot(peaklist)
  testthat::expect_true(methods::is(p,"ggplot"))
})
