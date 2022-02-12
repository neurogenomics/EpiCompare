library(EpiCompare)
data("encode_H3K27ac")
data("CnR_H3K27ac")
data("CnT_H3K27ac")
data("CnT_H3K27ac_seacr")
data("hg19_blacklist")
data("CnT_H3K27ac_picard")

# Create directory for test outputs
outpath <- paste0(tempdir(),"/EpiCompare_test")
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("when all options are true, correct outputs created", {
  peaklist <- list(CnT_H3K27ac_seacr, CnR_H3K27ac, CnT_H3K27ac)
  namelist <- c("CnT_seacr", "CnR", "CnT_macs")

  EpiCompare::EpiCompare(peakfiles = peaklist,
                         names = namelist,
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         picard = list(CnT_H3K27ac_picard),
                         picard_names = "CnT",
                         reference = encode_H3K27ac,
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,
                         output_dir = outpath
                         )

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(is.element("fragment_info", files), TRUE)
  expect_equal(is.element("width_plot.png", files), TRUE)
  expect_equal(is.element("samples_percent_overlap.html", files), TRUE)
  expect_equal(is.element("stat_plot.png", files), TRUE)

})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("when no picard, no fragment info",{
  peaklist <- list(CnT_H3K27ac_seacr, CnR_H3K27ac, CnT_H3K27ac)
  namelist <- c("CnT_seacr", "CnR", "CnT_macs")

  EpiCompare::EpiCompare(peakfiles = peaklist,
                         names = namelist,
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         reference = encode_H3K27ac,
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,,
                         output_dir = outpath
  )

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(is.element("fragment_info", files), FALSE)
  expect_equal(is.element("width_plot.png", files), TRUE)
  expect_equal(is.element("samples_percent_overlap.html", files), TRUE)
  expect_equal(is.element("stat_plot.png", files), TRUE)
})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("reference peakfile is missing, correct output", {
  peaklist <- list(CnT_H3K27ac_seacr, CnR_H3K27ac, CnT_H3K27ac)
  namelist <- c("CnT_seacr", "CnR", "CnT_macs")

  EpiCompare::EpiCompare(peakfiles = peaklist,
                         names = namelist,
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         picard = list(CnT_H3K27ac_picard),
                         picard_names = "CnT",
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,
                         output_dir = outpath
  )

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(is.element("fragment_info", files), TRUE)
  expect_equal(is.element("width_plot.png", files), TRUE)
  expect_equal(is.element("samples_percent_overlap.html", files), TRUE)
  expect_equal(is.element("stat_plot.png", files), FALSE)

})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("when no picard and no stat_plot, correct outputs created", {
  peaklist <- list(CnT_H3K27ac_seacr, CnR_H3K27ac, CnT_H3K27ac)
  namelist <- c("CnT_seacr", "CnR", "CnT_macs")

  EpiCompare::EpiCompare(peakfiles = peaklist,
                         names = namelist,
                         blacklist = hg19_blacklist,
                         save_output = TRUE,
                         reference = encode_H3K27ac,
                         stat_plot = FALSE,
                         chrmHMM_plot = TRUE,
                         output_dir = outpath
  )

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(is.element("fragment_info", files), FALSE)
  expect_equal(is.element("width_plot.png", files), TRUE)
  expect_equal(is.element("samples_percent_overlap.html", files), TRUE)
  expect_equal(is.element("stat_plot.png", files), FALSE)

})

# remove test directory
unlink(outpath, recursive = TRUE)


