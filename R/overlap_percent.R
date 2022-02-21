#' Calculate percentage of overlapping peaks
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param reference refrence peaks file
#' @param invert whether to invert
#'
#' @return data frame
#' @export
overlap_percent <- function(peaklist, reference, invert=FALSE){
  percent_list <- c()
  if(class(peaklist)=="list"){
    for(file in peaklist){
      overlap <- IRanges::subsetByOverlaps(x = file, ranges = reference, invert = invert)
      percent <- length(overlap)/length(file)*100
      percent_list <- c(percent_list, signif(percent, 3))
    }
  }else{
    for(file in reference){
      overlap <- IRanges::subsetByOverlaps(x = peaklist, ranges = file, invert = invert)
      percent <- length(overlap)/length(peaklist)*100
      percent_list <- c(percent_list, signif(percent, 3))
    }
  }
  df <- data.frame(percent_list)
  colnames(df) <- "Percentage"
  if(class(peaklist)=="list"){
    rownames(df) <- names(peaklist)
    }else{
      rownames(df) <- names(reference)
  }
  return(df)
}

