#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#' @param tss_distance A vector specifying the distance upstream and downstream
#' around TSS. Default value is \code{c(3000,3000)}, meaning peak frequency 
#' 3000bp upstream and downstream of TSS will be displayed. 
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
#'                     annotation = txdb,
#'                     upstream=50,
#'                     workers = 1)
tss_plot <- function(peaklist,
                     annotation,
                     tss_distance = c(3000,3000),
                     conf=0.95,
                     resample=500,
                     workers=parallel::detectCores()-1){
    
  message("--- Running tss_plot() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)
  ### Obtain Promoter Ranges ###
  upstream <- tss_distance[1]
  downstream <- tss_distance[2]
  promoters <- ChIPseeker::getPromoters(TxDb = annotation,
                                        upstream = upstream,
                                        downstream = downstream)

  ### Calculate Tag Matrix ###
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters,
                          verbose=FALSE)

  ### Generate Profile Plot ###
  plot_list <- lapply(seq_len(length(tagMatrixList)),
                      FUN=function(n){
    plot <- ChIPseeker::plotAvgProf(tagMatrixList[[n]],
                                    xlim = c(-upstream, downstream),
                                    conf = conf,
                                    resample = resample,
                                    facet = "row",
                                    ## Remove for now 
                                    ## (making everything super slow by default)
                                    ncpus = workers,
                                    verbose = FALSE) +
      ggplot2::ggtitle(names(tagMatrixList)[n])    
    list(plot)
  })

  ### Return ###
  message("Done.")
  return(plot_list)
}
