#' Generate heatmap of percentage overlap
#'
#' @param peaklist A list of peaks as GRanges object. Objects in list using `list()`
#' @param namelist A list of names. Names in list using `c()`
#'
#' @return An interactive heatmap
#' @export
#'
#' @examples
overlap_heatmap <- function(peaklist, namelist){

  overlap_list <- list() # empty list
  for(mainfile in peaklist){

    percent_list <- c()
    for(subfile in peaklist){
      overlap <- IRanges::subsetByOverlaps(x = mainfile, ranges = subfile)
      percent <- length(overlap)/length(mainfile)*100
      percent_list <- c(percent_list, percent)
    }
    percent_list <- list(percent_list)
    overlap_list <- c(overlap_list, percent_list)
  }

  df <- data.frame(matrix(unlist(overlap_list), ncol = max(lengths(overlap_list)), byrow = FALSE))
  colnames(df) <- namelist
  rownames(df) <- namelist
  heatmap <- heatmaply::heatmaply(df, Rowv = FALSE, Colv = FALSE)
  return(heatmap)
}

