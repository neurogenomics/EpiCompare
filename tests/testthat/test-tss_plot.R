test_that("tss_plot works", {
 
  ### Load Data ###
  data("CnT_H3K27ac") # example peaklist GRanges object
  data("CnR_H3K27ac") # example peaklist GRanges object
  ### Create Named Peaklist ###
  peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac) 
  txdb <- check_genome_build(genome_build = "hg19")
  my_plot <- tss_plot(peaklist = peaks, 
                      txdb = txdb,
                      tss_distance=c(-50,50),
                      workers = 1)
  testthat::expect_true(methods::is(my_plot$CnT,"gg"))
  testthat::expect_true(methods::is(my_plot$CnR,"gg"))
})
