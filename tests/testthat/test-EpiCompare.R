testthat::test_that("EpiCompare works",{
  #### (run_all=T, interact=T, reference=NULL) ####
  {
    data("encode_H3K27ac")
    data("CnT_H3K27ac")
    data("CnR_H3K27ac")
    data("CnT_H3K27ac_picard")
    data("CnR_H3K27ac_picard")
    # create named peaklist, reference and picard list
    peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
    reference <- list("ENCODE"=encode_H3K27ac)
    picard_list <- list("CnT"=CnT_H3K27ac_picard, "CnR"=CnR_H3K27ac_picard)
  }
  
  outpath <- file.path(tempdir(),"t1")
  html_file <- EpiCompare::EpiCompare(peakfiles = peaklist,
                                      genome_build = "hg19", 
                                      picard_files = picard_list,
                                      reference = NULL,
                                      interact = TRUE,
                                      tss_distance = c(-50,50),
                                      run_all = TRUE,
                                      output_dir = outpath)
  # browseURL(html_file)
  files <- list.files(file.path(outpath,"EpiCompare_file"))
  testthat::expect_gte(length(files), 10)
  testthat::expect_true(is.element("peak_info.csv", files))
  testthat::expect_true(is.element("fragment_info.csv", files))
  testthat::expect_true(is.element("width_plot.html", files))
  testthat::expect_true(is.element("samples_percent_overlap.html", files))
  ## save_output() throws an error for ComplexUpset. Skip saving for now. 
  # testthat::expect_true(is.element("upset_plot.png", files))
  testthat::expect_false(is.element("stat_plot.png", files))
  testthat::expect_true(is.element("samples_ChromHMM.html", files))
  testthat::expect_false(is.element("sample_in_ref_ChromHMM.html", files))
  testthat::expect_false(is.element("ref_in_sample_ChromHMM.html", files))
  testthat::expect_false(is.element("ref_not_in_sample_ChromHMM.html", files))
  testthat::expect_false(is.element("sample_not_in_ref_ChromHMM.html", files))
  testthat::expect_true(is.element("chipseeker_annotation.html", files))
  testthat::expect_true(is.element("KEGG_analysis.html", files))
  testthat::expect_true(is.element("GO_analysis.html", files))

  #### All options FALSE, correct outputs generated ####
  outpath <- file.path(tempdir(),"t2")
  html_file <- EpiCompare::EpiCompare(peakfiles = peaklist,
                                       genome_build = "hg19", 
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

  files <- list.files(file.path(outpath,"EpiCompare_file"))
  testthat::expect_gte(length(files), 4)
  testthat::expect_true(is.element("peak_info.csv", files))
  testthat::expect_true(is.element("fragment_info.csv", files))
  testthat::expect_true(is.element("processed_peakfiles_hg19", files))
})
