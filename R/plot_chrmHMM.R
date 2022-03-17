#' Plot ChromHMM heatmap
#'
#' Creates a heatmap using outputs from ChromHMM using ggplot2.The function
#' takes a list of peakfiles, performs ChromHMM and outputs a heatmap. ChromHMM
#' annotation file must be loaded prior to using this function.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param chrmHMM_annotation ChromHMM annotation list
#' @param interact Default TRUE. By default, the heatmaps are interactive.
#' If set FALSE, the function generates a static ChromHMM heatmap.
#'
#' @return ChromHMM heatmap
#'
#' @importFrom GenomicRanges GRangesList
#' @importFrom genomation annotateWithFeatures heatTargetAnnotation
#' @importFrom reshape2 melt
#' @importFrom plotly plot_ly
#' @import ggplot2
#'
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' data("chromHMM_annotation_K562") # example chromHMM annotation
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#'
#' my_plot <- plot_chrmHMM(peaklist=peaks,
#'                         chrmHMM_annotation=chromHMM_annotation_K562)
#'
plot_chrmHMM <- function(peaklist, chrmHMM_annotation, interact = TRUE){
  # define variables
  State <- NULL
  Sample <- NULL
  value <- NULL
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # check that there are no empty values
  i <- 1
  while(i <= length(peaklist)){
    if (length(peaklist[[i]])==0){
      peaklist[[i]] <- NULL
    }else{
      i <- i + 1
    }
  }
  # create GRangeList from GRanges objects
  grange_list <- GenomicRanges::GRangesList(peaklist, compress = FALSE)
  # annotate peakfiles with chromHMM annotations
  annotation <- genomation::annotateWithFeatures(grange_list,
                                                 chrmHMM_annotation)
  # obtain matrix
  matrix <- genomation::heatTargetAnnotation(annotation, plot = FALSE)
  rownames(matrix) <- names(peaklist) # set row names
  # remove numbers in front of states
  label_corrected <- gsub('X', '', colnames(matrix))
  colnames(matrix) <- label_corrected # set corrected labels
  # if interaction is FALSE
  if(!interact){
    # convert matrix into molten data frame
    matrix_melt <- reshape2::melt(matrix)
    colnames(matrix_melt) <- c("Sample", "State", "value")
    # create heatmap
    chrHMM_plot <- ggplot2::ggplot(matrix_melt) +
      ggplot2::geom_tile(ggplot2::aes(x = State, y = Sample, fill = value)) +
      ggplot2::ylab("") +
      ggplot2::xlab("") +
      viridis::scale_fill_viridis() +
      ggplot2::theme_minimal() +
      ggpubr::rotate_x_text(angle = 45) +
      ggplot2::theme(axis.text = ggplot2::element_text(size = 11))
  }else{
    chrHMM_plot <- plotly::plot_ly(x = colnames(matrix),
                                   y = rownames(matrix),
                                   z = matrix,
                                   type = "heatmap")
  }
  # return heatmap
  return(chrHMM_plot)
}

