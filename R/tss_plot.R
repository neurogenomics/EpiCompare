#' Read count frequency around TSS
#'
#' This function generates a plot of read count frequency around TSS.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' If not named, default file names will be assigned.
#' @param txdb A TxDb annotation object from Bioconductor.
#' @param tss_distance A vector specifying the distance upstream and downstream
#' around transcription start sites (TSS). 
#' The default value is \code{c(-3000,3000)}; meaning peak frequency 
#' 3000bp upstream and downstream of TSS will be displayed. 
#' @param conf Confidence interval threshold estimated by bootstrapping
#'  (\code{0.95} means 95%).
#' Argument passed to \link[ChIPseeker]{plotAvgProf}.
#' @param resample Number of bootstrapped iterations to run.
#' Argument passed to \link[ChIPseeker]{plotAvgProf}.
#' @param workers Number of cores to parallelise bootstrapping across.
#' Argument passed to \link[ChIPseeker]{plotAvgProf}. 
#' @inheritParams EpiCompare
#' @returns A named list of profile plots.
#'
#' @importFrom ChIPseeker getPromoters getTagMatrix plotAvgProf
#' @importFrom stats setNames
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peaklist GRanges object
#' data("CnR_H3K27ac") # example peaklist GRanges object
#' ### Create Named Peaklist ###
#' peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac) 
#' my_plot <- tss_plot(peaklist = peaklist, 
#'                     tss_distance=c(-50,50),
#'                     workers = 1)
tss_plot <- function(peaklist,
                     txdb = NULL,
                     tss_distance = c(-3000,3000),
                     conf = 0.95,
                     resample = 500,
                     interact = FALSE,
                     workers = check_workers()){
    
  # devoptera::args2vars(tss_plot)
  
  message("--- Running tss_plot() ---")  
  #### Check Peaklist Names ####
  peaklist <- check_list_names(peaklist)
  #### Obtain Promoter Ranges ####
  upstream <- abs(tss_distance[1])
  downstream <- abs(tss_distance[2])
  promoters <- ChIPseeker::getPromoters(TxDb = txdb,
                                        upstream = upstream,
                                        downstream = downstream) 
  #### Calculate Tag Matrix ####
  tagMatrixList <- lapply(peaklist,
                          ChIPseeker::getTagMatrix,
                          windows = promoters,
                          upstream = upstream,
                          downstream = downstream,
                          TxDb = txdb,
                          verbose = FALSE)

  #### Generate Profile Plot ####
  plot_list <- lapply(stats::setNames(seq_len(length(tagMatrixList)),
                                      names(tagMatrixList)
                                      ),
                      FUN=function(n){
    ChIPseeker::plotAvgProf(tagMatrixList[[n]],
                            xlim = c(-upstream, downstream),
                            conf = conf,
                            resample = resample,
                            facet = "row",
                            ncpus = workers,
                            verbose = FALSE) +
      ggplot2::ggtitle(names(tagMatrixList)[n])
  }) 
  #### Return ####
  if(isTRUE(interact)){
    plot_list <- lapply(plot_list,as_interactive)
  }
  message("Done.")
  return(plot_list)
}
