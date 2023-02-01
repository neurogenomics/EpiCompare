test_that("tss_plot works", {
 
  ### Load Data ###
  data("CnT_H3K27ac") # example peaklist GRanges object
  data("CnR_H3K27ac") # example peaklist GRanges object
  ### Create Named Peaklist ###
  peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
  my_plot <- tss_plot(peaklist = peaks,
                      annotation = txdb, 
                      upstream=50,
                      workers = 1)
})
