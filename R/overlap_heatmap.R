#' Generate heatmap of percentage overlap
#'
#' This function generates a heatmap showing percentage of overlapping peaks
#' between peak files.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param interact Default TRUE. By default heatmap is interactive.
#' If FALSE, heatmap is static.
#'
#' @return An interactive heatmap
#'
#' @importMethodsFrom IRanges subsetByOverlaps
#' @import ggplot2
#' @importFrom reshape2 melt
#' @importFrom plotly plot_ly
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#'
#' ### Create Named List ###
#' peaks <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)
#'
#' ### Run ###
#' my_heatmap <- overlap_heatmap(peaklist = peaks)
#'
overlap_heatmap <- function(peaklist,
                            interact=TRUE){

  ### Variables ###
  Var1 <- Var2  <- value <- NULL;
  message("--- Running overlap_heatmap() ---")

  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)

  ### Calculate Overlap Percentage ###
  overlap_list <- list() # empty list
  for(mainfile in peaklist){
    percent_list <- c()
    for(subfile in peaklist){
      # overlapping peaks
      overlap <- IRanges::subsetByOverlaps(x = subfile, ranges = mainfile)
      # calculate percentage overlap
      percent <- length(overlap)/length(subfile)*100
      percent_list <- c(percent_list, percent)
    }
    percent_list <- list(percent_list)
    overlap_list <- c(overlap_list, percent_list)
  }

  ### Create Matrix ###
  overlap_matrix <- matrix(unlist(overlap_list),
                           ncol = max(lengths(overlap_list)),
                           byrow = FALSE)
  colnames(overlap_matrix) <- names(peaklist) # set colnames as sample names
  rownames(overlap_matrix) <- names(peaklist) # set rownames as sample names

  ### Create Static Heatmap ###
  if(!interact){
    melt <- reshape2::melt(overlap_matrix)
    overlap_heatmap <- ggplot2::ggplot(
        data = melt,
        ggplot2::aes(x=Var1, y=Var2, fill=value)) +
        ggplot2::geom_tile()
  }else{
    ### Create Ineractive Heatmap ###
    overlap_heatmap <- plotly::plot_ly(x=colnames(overlap_matrix),
                                       y=rownames(overlap_matrix),
                                       z=overlap_matrix,
                                       type="heatmap")
  }
  return(overlap_heatmap)
}
