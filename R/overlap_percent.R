#' Calculate percentage of overlapping peaks
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param reference reference peaks file
#' @param invert whether to invert
#'
#' @return data frame
#' @importMethodsFrom IRanges subsetByOverlaps
#' @import methods
#' @export
#' @examples
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#' reference_peak <- list("ENCODE"=encode_H3K27ac)
#'
#' overlap <- overlap_percent(peaklist=peaks,
#'                            reference=reference_peak[[1]])
#'
overlap_percent <- function(peaklist, 
                            reference, 
                            invert=FALSE){
  percent_list <- c()
  if(methods::is(peaklist, "list")){
    for(file in peaklist){
      overlap <- IRanges::subsetByOverlaps(x = file,
                                           ranges = reference,
                                           invert = invert)
      percent <- length(overlap)/length(file)*100
      percent_list <- c(percent_list, signif(percent, 3))
    }
  }else{
    for(file in reference){
      overlap <- IRanges::subsetByOverlaps(x = peaklist,
                                           ranges = file,
                                           invert = invert)
      percent <- length(overlap)/length(peaklist)*100
      percent_list <- c(percent_list, signif(percent, 3))
    }
  }
  df <- data.frame(percent_list)
  colnames(df) <- "Percentage"
  if(methods::is(peaklist, "list")){
    rownames(df) <- names(peaklist)
    }else{
      rownames(df) <- names(reference)
  }
  return(df)
}

