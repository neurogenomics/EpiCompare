data("encode_H3K27ac")
data("CnT_H3K27ac")
data("CnR_H3K27ac")
data("hg19_blacklist")

# Create directory for test outputs
outpath <- paste0(tempdir(),"/EpiCompare_test")
if(!dir.exists(outpath)){
  dir.create(outpath)
}
# create pekalist
peaklist <- list(CnT_H3K27ac, CnR_H3K27ac)

test_that("outputs are saved in EpiCompare_file", {
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                        output_dir = outpath )
  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files)>1, TRUE)
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(file.exists(paste0(outpath,"/EpiCompare.html")), TRUE)
})

test_that("outputs are saved in EpiCompare_file", {
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = FALSE,
                         output_dir = outpath )
  expect_equal(file.exists(paste0(outpath,"/EpiCompare.html")), TRUE)
})

test_that("output filename set by users",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         output_dir = outpath,
                         output_filename = "testthat_example",
                         output_timestamp = TRUE)
  date <- format(Sys.Date(), '%b_%d_%Y')
  name <- "testthat_example"
  filename <-  paste0(name,"_",date)
  files <- list.files(outpath)
  expect_equal(file.exists(paste0(outpath,"/",filename,".html")), TRUE)
})

# remove test directory
unlink(outpath, recursive = TRUE)

