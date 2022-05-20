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

test_that("All options TRUE (interact=T) and no ref,
          correct outputs generated",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         picard_files = picard_list,
                         reference = NULL,
                         upset_plot = TRUE,
                         stat_plot = TRUE,
                         chromHMM_plot = TRUE,
                         chipseeker_plot = TRUE,
                         enrichment_plot = TRUE,
                         tss_plot = FALSE,
                         interact = TRUE,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files), 10)
  expect_true(is.element("peak_info.txt", files))
  expect_true(is.element("fragment_info.txt", files))
  expect_true(is.element("width_plot.png", files))
  expect_true(is.element("samples_percent_overlap.html", files))
  expect_true(is.element("upset_plot.png", files))
  expect_false(is.element("stat_plot.png", files))
  expect_true(is.element("samples_ChromHMM.html", files))
  expect_false(is.element("sample_in_ref_ChromHMM.html", files))
  expect_false(is.element("ref_in_sample_ChromHMM.html", files))
  expect_false(is.element("ref_not_in_sample_ChromHMM.html", files))
  expect_false(is.element("sample_not_in_ref_ChromHMM.html", files))
  expect_true(is.element("chipseeker_annotation.png", files))
  expect_true(is.element("KEGG_analysis.png", files))
  expect_true(is.element("GO_analysis.png", files))
})

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

# remove test directory and create new one
unlink(outpath, recursive = TRUE)
if(!dir.exists(outpath)){
  dir.create(outpath)
}

test_that("All options FALSE, correct outputs generated",{
  EpiCompare::EpiCompare(peakfiles = peaklist,
                         genome_build = "hg19",
                         blacklist = hg19_blacklist,
                         picard_files = picard_list,
                         reference = NULL,
                         upset_plot = FALSE,
                         stat_plot = FALSE,
                         chromHMM_plot = FALSE,
                         chipseeker_plot = FALSE,
                         enrichment_plot = FALSE,
                         tss_plot = FALSE,
                         interact = FALSE,
                         save_output = TRUE,
                         output_dir = outpath)

  files <- list.files(paste0(outpath,"/EpiCompare_file"))
  expect_equal(length(files), 4)
})
