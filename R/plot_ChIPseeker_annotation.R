#' Create ChIPseeker annotation plot
#'
#' This function annotates peaks using \code{ChIPseeker::annotatePeak}.
#' It outputs functional annotation of each peak file in a barplot.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
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
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- plot_ChIPseeker_annotation(peaklist = peaks
#' #                                       annotation = txdb)
#'
plot_ChIPseeker_annotation <- function(peaklist, annotation){
  message("--- Running plot_ChIPseeker_annotation() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)

  ### TxDb Annotation ###
  txdb <- annotation

  ### Annotate Features ###
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = c(-3000, 3000),
                           verbose = FALSE)
  ### Create Plot ###
  anno_barplot <- ChIPseeker::plotAnnoBar(peak_annotated)
  message("Done.")
  return(anno_barplot)
}
