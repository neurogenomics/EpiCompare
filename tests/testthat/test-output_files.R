data("encode_H3K27ac")
data("CnT_H3K27ac")
data("CnR_H3K27ac")
data("hg19_blacklist")
# create peaklist
peaklist <- list(CnT_H3K27ac, CnR_H3K27ac)

testthat::test_that("outputs are saved in EpiCompare_file", {
  outpath <- file.path(tempdir(),"t1") 
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                        output_dir = outpath)
  files <- list.files(file.path(outpath,"EpiCompare_file"))
  testthat::expect_true(length(files)>1)
  testthat::expect_true(is.element("peak_info.csv", files))
  testthat::expect_true(file.exists(file.path(outpath,"EpiCompare.html")))
})

test_that("outputs are saved in EpiCompare_file", {
  outpath <- file.path(tempdir(),"t2") 
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = FALSE,
                         output_dir = outpath )
  testthat::expect_true(file.exists(file.path(outpath,"EpiCompare.html")))
})

test_that("output filename set by users",{
  outpath <- file.path(tempdir(),"t3") 
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         output_dir = outpath,
                         output_filename = "testthat_example",
                         output_timestamp = TRUE)
  date <- format(Sys.Date(), '%b_%d_%Y')
  name <- "testthat_example"
  filename <- paste0(name,"_",date)
  files <- list.files(outpath)
  testthat::expect_true(file.exists(file.path(outpath,paste0(filename,".html"))))
})
