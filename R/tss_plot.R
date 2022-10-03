#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#' @param conf Confidence interval threshold estimated by bootstrapping
#'  (\code{0.95} means 95%).
#' Argument passed to \link[ChIPseeker]{plotAvgProf}.
#' @param resample Number of bootstrapped iterations to run.
#' Argument passed to \link[ChIPseeker]{plotAvgProf}.
#' @param workers Number of cores to parallelise bootstrapping across.
#' Argument passed to \link[ChIPseeker]{plotAvgProf}.
#' @inheritParams ChIPseeker::getPromoters
#' @inheritParams ChIPseeker::plotAvgProf
#' @return profile plot in a list.
#'
#' @importFrom ChIPseeker getPromoters getTagMatrix plotAvgProf
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peaklist GRanges object
#' data("CnR_H3K27ac") # example peaklist GRanges object
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#' txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' my_plot <- tss_plot(peaklist = peaks,
#'                     annotation = txdb)
tss_plot <- function(peaklist,
                     annotation,
                     upstream=3000,
                     downstream=upstream,
                     conf=0.95,
                     resample=500,
                     workers=1){
    
  message("--- Running tss_plot() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)
  ### Obtain Promoter Ranges ###
  promoters <- ChIPseeker::getPromoters(TxDb = annotation,
                                        upstream = upstream,
                                        downstream = downstream)

  ### Calculate Tag Matrix ###
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters,
                          verbose=FALSE)

  ### Generate Profile Plot ###
  plot_list <- lapply(tagMatrixList,
                      FUN=function(file){
    plot <- ChIPseeker::plotAvgProf(file,
                                    xlim = c(-upstream, downstream),
                                    conf = conf,
                                    resample = resample,
                                    facet = "row",
                                    ## Remove for now 
                                    ## (making everything super slow by default)
                                    # ncpus = workers,
                                    verbose = FALSE) +
      ggplot2::labs(title=names(file))
    list(plot)
  })

  ### Return ###
  message("Done.")
  return(plot_list)
}
