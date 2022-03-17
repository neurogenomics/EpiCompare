#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#'
#' @return profile plot
#'
#' @importFrom TxDb.Hsapiens.UCSC.hg19.knownGene TxDb.Hsapiens.UCSC.hg19.knownGene
#' @importFrom ChIPseeker getPromoters getTagMatrix plotAvgProf
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#' #my_plot <- tss_plot(peaks)
#'
tss_plot <- function(peaklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # annotation for hg19 genome
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
  # obtain promoter ranges from hg19 genome annotation
  promoters <- ChIPseeker::getPromoters(TxDb = txdb,
                                        upstream = 3000,
                                        downstream = 3000)
  # calculate the tag matrix
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters)
  # generate profile plots
  profile_plot <- ChIPseeker::plotAvgProf(tagMatrixList,
                                          xlim = c(-3000, 3000),
                                          conf = 0.95,
                                          resample = 500,
                                          facet = "row")
  return(profile_plot)
}


