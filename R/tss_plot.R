#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#'
#' @return profile plot
#' @export
tss_plot <- function(peaklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene # annotation for hg19 genome
  # obtain promoter ranges from hg19 genome annotation
  promoters <- ChIPseeker::getPromoters(TxDb = txdb, upstream = 3000, downstream = 3000)
  # calculate the tag matrix
  tagMatrixList <- lapply(peaklist, ChIPseeker::getTagMatrix, windows = promoters)
  # generate profile plots
  profile_plot <- ChIPseeker::plotAvgProf(tagMatrixList, xlim = c(-3000, 3000), conf = 0.95, resample = 500, facet = "row")
  return(profile_plot)
}


