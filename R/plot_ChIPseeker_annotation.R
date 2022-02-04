#' Create ChIPseeker annotation plot
#'
#' This function annotates peaks using `annotatePeak` from `ChIPseeker` package.
#' It uses annotation `TxDb.Hsapiens.UCSC.hg19.knownGene` provided by Bioconductor.
#' It outputs functional annotation of each peak file in a barplot.
#'
#' @param peaklist A list of peak files as GRanges object. Files must be listed using `list()`
#' @param namelist A list of file names in the same order as the list of peak files. Use `c()` for multiple.
#'
#' @return barplot
#' @export
plot_ChIPseeker_annotation <- function(peaklist, namelist){
  peaklist_named <- stats::setNames(peaklist, namelist) # set names
  # transcript-realted features of hg19 genome
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
  # annotate features
  peak_annotated <- lapply(peaklist_named,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = c(-3000, 3000),
                           verbose = FALSE)
  # create bar plot
  anno_barplot <- ChIPseeker::plotAnnoBar(peak_annotated)
  return(anno_barplot)
}


