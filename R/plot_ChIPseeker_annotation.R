#' Create ChIPseeker annotation plot
#'
#' This function annotates peaks using \code{ChIPseeker::annotatePeak}.
#' It outputs functional annotation of each peak file in a barplot.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param txdb A TxDb annotation object from Bioconductor.
#' @inheritParams EpiCompare
#' @inheritParams tss_plot
#' @returns ggplot barplot
#'
#' @export
#' @importFrom ChIPseeker annotatePeak
#' @importMethodsFrom ChIPseeker plotAnnoBar
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object 
#' peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#' my_plot <- plot_ChIPseeker_annotation(peaklist = peaklist, 
#'                                       tss_distance = c(-50,50))
plot_ChIPseeker_annotation <- function(peaklist, 
                                       txdb = NULL,
                                       tss_distance = c(-3000, 3000),
                                       interact = FALSE){
  # templateR:::args2vars(plot_ChIPseeker_annotation)
  message("--- Running plot_ChIPseeker_annotation() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist) 
  ### Annotate Features ###
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = tss_distance,
                           verbose = FALSE)
  ### Create Plot ###
  anno_barplot <- ChIPseeker::plotAnnoBar(x = peak_annotated,
                                          xlab = "Percentage (%)")
  if(isTRUE(interact)){
    anno_barplot <- as_interactive(anno_barplot)
  }
  message("Done.")
  return(anno_barplot)
}
