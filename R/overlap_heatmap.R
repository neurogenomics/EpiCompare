#' Generate heatmap of percentage overlap
#'
#' This function generates a heatmap showing percentage of overlapping peaks between peak files.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param interact Default TRUE. By default heatmap is interactive. If FALSE, heatmap is static.
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
overlap_heatmap <- function(peaklist, interact=TRUE){
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
  # crete matrix of overlap percentages
  overlap_matrix <- matrix(unlist(overlap_list), ncol = max(lengths(overlap_list)), byrow = FALSE)
  colnames(overlap_matrix) <- names(peaklist) # set colnames as sample names
  rownames(overlap_matrix) <- names(peaklist) # set rownames as sample names
  # static heatmap
  if(!interact){
    overlap_heatmap <- stats::heatmap(overlap_matrix, Rowv = NA, Colv = NA)
  }else{
    overlap_heatmap <- plotly::plot_ly(x=stringr::str_wrap(colnames(overlap_matrix), 10),
                                       y=stringr::str_wrap(rownames(overlap_matrix), 10),
                                       z=overlap_matrix,
                                       type="heatmap")
  }
  return(overlap_heatmap)
}
