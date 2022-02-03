#' Generate heatmap of percentage overlap
#'
#' This function generates a heatmap showing percentage of overlapping peaks between peak files.
#'
#' @param peaklist A list of peaks as GRanges object. Objects in list using `list()`
#' @param namelist A list of names. Names in list using `c()`
#' @param save_dir Name of file to save the interactive heatmap output as HTML
#'
#' @return An interactive heatmap
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#'
#' overlap_heatmap(peaklist = list(encode_H3K27ac, CnT_H3K27ac),
#'                 namelist = c("ENCODE", "CnT"))
#'
overlap_heatmap <- function(peaklist, namelist, save_dir = NULL){
  ##  cross-compare peakfiles and calculate overlap percentage
  overlap_list <- list() # empty list
  for(mainfile in peaklist){
    percent_list <- c()
    for(subfile in peaklist){
      overlap <- IRanges::subsetByOverlaps(x = mainfile, ranges = subfile) # overlapping peaks
      percent <- length(overlap)/length(mainfile)*100 # calculate percentage overlap
      percent_list <- c(percent_list, percent)
    }
    percent_list <- list(percent_list)
    overlap_list <- c(overlap_list, percent_list)
  }
  # convert list into data frame (matrix of overlap percentages)
  df <- data.frame(matrix(unlist(overlap_list), ncol = max(lengths(overlap_list)), byrow = FALSE))
  colnames(df) <- namelist # set colnames as sample names
  rownames(df) <- namelist # set rownames as sample names
  heatmap <- heatmaply::heatmaply(df, Rowv = FALSE, Colv = FALSE)
  # if save_dir is provided save the plot as html
  # if not, return the heatmap without saving the plot
  if(is.null(save_dir) == FALSE){
    heatmaply::heatmaply(df, Rowv = FALSE, Colv = FALSE, file = save_dir)
  }else{
    return(heatmap)
  }
}
