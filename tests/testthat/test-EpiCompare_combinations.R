data("encode_H3K27ac")
data("CnT_H3K27ac")
data("CnR_H3K27ac")
data("hg19_blacklist")
data("CnT_H3K27ac_picard")
data("CnR_H3K27ac_picard")

# Create directory for test outputs
outpath <- paste0(tempdir(),"/EpiCompare_test")
if(!dir.exists(outpath)){
  dir.create(outpath)
}

# create named peaklist, reference and picard list
peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
reference <- list("ENCODE"=encode_H3K27ac)
picard_list <- list("CnT"=CnT_H3K27ac_picard, "CnR"=CnR_H3K27ac_picard)

test_that("All options TRUE (interact=T), correct outputs generated",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         blacklist = hg19_blacklist,
                         picard_files = picard_list,
                         reference = reference,
                         upset_plot = TRUE,
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,
                         chipseeker_plot = TRUE,
                         enrichment_plot = TRUE,
                         tss_plot = FALSE,
                         interact = TRUE,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files), 14)
  expect_equal(is.element("peak_info", files), TRUE)
  expect_equal(is.element("fragment_info", files), TRUE)
  expect_equal(is.element("width_plot.png", files), TRUE)
  expect_equal(is.element("samples_percent_overlap.html", files), TRUE)
  expect_equal(is.element("upset_plot.png", files), TRUE)
  expect_equal(is.element("stat_plot.png", files), TRUE)
  expect_equal(is.element("samples_chrmHMM.html", files), TRUE)
  expect_equal(is.element("sample_in_ref_chrmHMM.html", files), TRUE)
  expect_equal(is.element("ref_in_sample_chrmHMM.html", files), TRUE)
  expect_equal(is.element("ref_not_in_sample_chrmHMM.html", files), TRUE)
  expect_equal(is.element("sample_not_in_ref_chrmHMM.html", files), TRUE)
  expect_equal(is.element("chipseeker_annotation.png", files), TRUE)
  expect_equal(is.element("KEGG_analysis.png", files), TRUE)
  expect_equal(is.element("GO_analysis.png", files), TRUE)
})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("All options TRUE (interact=F), correct outputs generated",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         blacklist = hg19_blacklist,
                         picard_files = picard_list,
                         reference = reference,
                         upset_plot = TRUE,
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,
                         chipseeker_plot = TRUE,
                         enrichment_plot = TRUE,
                         tss_plot = FALSE,
                         interact = FALSE,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files), 14)
  expect_equal(is.element("samples_percent_overlap.png", files), TRUE)
  expect_equal(is.element("samples_chrmHMM.png", files), TRUE)
  expect_equal(is.element("sample_in_ref_chrmHMM.png", files), TRUE)
  expect_equal(is.element("ref_in_sample_chrmHMM.png", files), TRUE)
  expect_equal(is.element("ref_not_in_sample_chrmHMM.png", files), TRUE)
  expect_equal(is.element("sample_not_in_ref_chrmHMM.png", files), TRUE)
})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("All options TRUE (reference=NULL,interact=F), correct outputs generated",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         blacklist = hg19_blacklist,
                         picard_files = picard_list,
                         reference = NULL,
                         upset_plot = TRUE,
                         stat_plot = TRUE,
                         chrmHMM_plot = TRUE,
                         chipseeker_plot = TRUE,
                         enrichment_plot = TRUE,
                         tss_plot = FALSE,
                         interact = FALSE,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files), 9)
})
