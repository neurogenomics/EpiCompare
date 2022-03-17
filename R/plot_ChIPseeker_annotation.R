#' Create ChIPseeker annotation plot
#'
#' This function annotates peaks using `annotatePeak` from `ChIPseeker` package.
#' It uses annotation `TxDb.Hsapiens.UCSC.hg19.knownGene` provided by
#' Bioconductor.It outputs functional annotation of each peak file in a barplot.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#'
#' @return barplot
#'
#' @importFrom TxDb.Hsapiens.UCSC.hg19.knownGene TxDb.Hsapiens.UCSC.hg19.knownGene
#' @importFrom ChIPseeker annotatePeak plotAnnoBar
#'
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#'
#' #my_plot <- plot_ChIPseeker_annotation(peaks)
#'
plot_ChIPseeker_annotation <- function(peaklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # transcript-realted features of hg19 genomes
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
  # annotate features
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = c(-3000, 3000),
                           verbose = FALSE)
  # create bar plot
  anno_barplot <- ChIPseeker::plotAnnoBar(peak_annotated)
  return(anno_barplot)
}
