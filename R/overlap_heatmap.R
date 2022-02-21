#' Generate heatmap of percentage overlap
#'
#' This function generates a heatmap showing percentage of overlapping peaks between peak files.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
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
#' peaks <- list(encode_H3K27ac, CnT_H3K27ac) # create list
#' names(peaks) <- c("encode", "CnT") # set names
#'
#' overlap_heatmap(peaklist = peaks)
#'
overlap_heatmap <- function(peaklist, save_dir = NULL){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  # cross-compare peakfiles and calculate overlap percentage
  overlap_list <- list() # empty list
  for(mainfile in peaklist){
    percent_list <- c()
    for(subfile in peaklist){
      overlap <- IRanges::subsetByOverlaps(x = subfile, ranges = mainfile) # overlapping peaks
      percent <- length(overlap)/length(subfile)*100 # calculate percentage overlap
      percent_list <- c(percent_list, percent)
    }
    percent_list <- list(percent_list)
    overlap_list <- c(overlap_list, percent_list)
  }
  # convert list into data frame (matrix of overlap percentages)
  df <- data.frame(matrix(unlist(overlap_list), ncol = max(lengths(overlap_list)), byrow = FALSE))
  colnames(df) <- names(peaklist) # set colnames as sample names
  rownames(df) <- names(peaklist) # set rownames as sample names
  heatmap <- heatmaply::heatmaply(df, Rowv = FALSE, Colv = FALSE)
  # if save_dir is provided save the plot as html
  # if not, return the heatmap without saving the plot
  if(is.null(save_dir) == FALSE){
    heatmaply::heatmaply(df, Rowv = FALSE, Colv = FALSE, file = save_dir)
  }else{
    return(heatmap)
  }
}
