#' Create ChIPseeker annotation plot
#'
#' This function annotates peaks using `annotatePeak` from `ChIPseeker` package.
#' It outputs functional annotation of each peak file in a barplot.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#'
#' @return barplot
#'
#' @importFrom ChIPseeker annotatePeak 
#' @importMethodsFrom ChIPseeker plotAnnoBar
#'
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- plot_ChIPseeker_annotation(peaklist = peaks
#' #                                       annotation = txdb)
#'
plot_ChIPseeker_annotation <- function(peaklist, annotation){
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # TxDb annotation
  txdb <- annotation
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
