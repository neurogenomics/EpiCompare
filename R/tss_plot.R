#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#'
#' @return profile plot in a list.
#'
#' @importFrom ChIPseeker getPromoters getTagMatrix plotAvgProf
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- tss_plot(peaklist = peaks,
#' #                     annotation = txdb)
#' ## first plot
#' # my_plot[1]
#'
tss_plot <- function(peaklist, annotation){
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # annotation
  txdb <- annotation
  # obtain promoter ranges genome annotation
  promoters <- ChIPseeker::getPromoters(TxDb = txdb,
                                        upstream = 3000,
                                        downstream = 3000)
  # calculate the tag matrix
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters,
                          verbose=FALSE)
  # generate profile plots
  plot_list <- list()
  for (i in seq_len(length(tagMatrixList))){
    plot <- ChIPseeker::plotAvgProf(tagMatrixList[[i]],
                                    xlim = c(-3000, 3000),
                                    conf = 0.95,
                                    resample = 500,
                                    facet = "row",
                                    verbose = FALSE) +
      ggplot2::labs(title=names(tagMatrixList)[i])
    plot_list <- list(plot_list, plot)
  }
  return(plot_list)
}
