#' Plot ChromHMM heatmap
#'
#' Creates a heatmap using outputs from ChromHMM using ggplot2.
#' The function takes a list of peakfiles, performs ChromHMM and outputs a heatmap.
#' ChromHMM annotation file must be loaded prior to using this function.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param chrmHMM_annotation ChromHMM annotation list
#'
#' @return ChromHMM heatmap
#' @export
#'
plot_chrmHMM <- function(peaklist, chrmHMM_annotation){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  # check that there are no empty values
  # if there are, remove them
  i <- 1
  while(i < length(peaklist)){
    if (length(peaklist[[i]])==0){
      peaklist[[i]] <- NULL
    }else{
      i <- i + 1
    }
  }
  # create GRangeList from GRanges objects
  grange_list <- GenomicRanges::GRangesList(peaklist, compress = FALSE)
  # annotate peakfiles with chromHMM annotations
  annotation <- genomation::annotateWithFeatures(grange_list, chrmHMM_annotation)
  # obtain matrix
  matrix <- genomation::heatTargetAnnotation(annotation, plot = FALSE)
  rownames(matrix) <- names(peaklist) # set row names
  matrix_melt <- reshape2::melt(matrix) # convert matrix into molten data frame
  colnames(matrix_melt) = c("Sample", "State", "value") # set column names
  state_corrected <- gsub('X[0-9]*_', '', matrix_melt$State) # remove numbers in front of states
  matrix_melt$State <- state_corrected
  # create heatmap
  chrHMM_plot <- ggplot2::ggplot(matrix_melt) +
    ggplot2::geom_tile(ggplot2::aes(x = State, y = Sample, fill = value)) +
    ggplot2::ylab("") +
    ggplot2::xlab("") +
    viridis::scale_fill_viridis() +
    ggplot2::theme_minimal() +
    ggpubr::rotate_x_text(angle = 45) +
    ggplot2::theme(axis.text = ggplot2::element_text(size = 11))
  # return heatmap
  return(chrHMM_plot)
}

