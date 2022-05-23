#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#'
#' @return profile plot in a list.
#'
#' @importFrom ChIPseeker getPromoters getTagMatrix plotAvgProf
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peaklist GRanges object
#' data("CnR_H3K27ac") # example peaklist GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- tss_plot(peaklist = peaks,
#' #                     annotation = txdb)
#' ## first plot
#' # my_plot[1]
#'
tss_plot <- function(peaklist, annotation){
  message("--- Running tss_plot() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)
  ### TxDB Annotation ###
  txdb <- annotation

  ### Obtain Promoter Ranges ###
  promoters <- ChIPseeker::getPromoters(TxDb = txdb,
                                        upstream = 3000,
                                        downstream = 3000)

  ### Calculate Tag Matrix ###
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters,
                          verbose=FALSE)

  ### Generate Profile Plot ###
  plot_list <- mapply(tagMatrixList, FUN=function(file){
    plot <- ChIPseeker::plotAvgProf(file,
                            xlim = c(-3000, 3000),
                            conf = 0.95,
                            resample = 500,
                            facet = "row",
                            verbose = FALSE) +
      ggplot2::labs(title=names(file))
    list(plot)
  })

  ### Return ###
  message("Done.")
  return(plot_list)
}
