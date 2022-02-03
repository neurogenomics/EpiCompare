library(EpiCompare)
data("encode_H3K27ac")
data("CnR_H3K27ac")
data("CnT_H3K27ac")
data("hg19_blacklist")

# Create directory for test outputs
outpath <- paste0(getwd(),"/EpiCompare_test")
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("outputs are saved in EpiCompare_file", {
  peaklist <- list(encode_H3K27ac, CnR_H3K27ac, CnT_H3K27ac)
  namelist <- c("encode", "CnR", "CnT")

  EpiCompare::EpiCompare(peakfiles = peaklist,
                         names = namelist,
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files)>1, TRUE)
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(file.exists(paste0(outpath,"/EpiCompare.html")), TRUE)
})

# remove test directory
unlink(outpath, recursive = TRUE)
