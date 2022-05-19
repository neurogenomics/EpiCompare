#' Calculate percentage of overlapping peaks
#'
#' This function calculates the percentage of overlapping peaks and outputs
#' a table or matrix of results.
#'
#' @param peaklist1 A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param peaklist2 peaklist1 A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' @param invert Default FALSE. To invert the overlap, set TRUE.
#'
#' @return data frame
#' @importMethodsFrom IRanges subsetByOverlaps
#' @import methods
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#' reference_peak <- list("ENCODE"=encode_H3K27ac)
#'
#' ### Run ###
#' overlap <- overlap_percent(peaklist1=peaks,
#'                            peaklist2=reference_peak)
#'
overlap_percent <- function(peaklist1,
                            peaklist2,
                            invert=FALSE){
  ### Calculate Overlap ###
  # When peaklist1 is the reference
  if(length(peaklist1)==1){
    my_label <- names(peaklist2)
    reference <- peaklist1[[1]]
    percent_list <- mapply(peaklist2, FUN=function(file){
      overlap <- IRanges::subsetByOverlaps(x = reference,
                                           ranges = file,
                                           invert = invert)
      percent <- length(overlap)/length(reference)*100
      list(signif(percent,3))
    })
  ### Calculate Overlap ###
  # When peaklist2 is the reference
  }else if(length(peaklist2)==1){
    my_label <- names(peaklist1)
    reference <- peaklist2[[1]]
    percent_list <- mapply(peaklist1, FUN=function(file){
      overlap <- IRanges::subsetByOverlaps(x = file,
                                           ranges = reference,
                                           invert = invert)
      percent <- length(overlap)/length(file)*100
      list(signif(percent,3))
  })
  }

  ### Create Data Frame ###
  df <- data.frame(percent_list)
  df <- t(df) # transpose
  colnames(df) <- "Percentage"
  rownames(df) <- my_label

  ### Return ###
  return(df)
}



