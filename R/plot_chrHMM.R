#' Create ChromHMM Heatmap
#'
#' Creates a heatmap using outputs from ChromHMM using ggplot2.
#' The function takes two peak files, performs ChromHMM and outputs a heatmap.
#' ChromHMM annotation file must be loaded prior to using this function.
#'
#' @param chrHMMfile1 peakfile1 as GRanges
#' @param chrHMMfile1_name name of peakfile1
#' @param chrHMMfile2 peakfile2 as GRanges
#' @param chrHMMfile2_name name of peakfile2
#' @param chrHMM_list ChromHMM annotation list
#'
#' @return ChromHMM heatmap
#'
#' @keywords internal
#' @export
plot_chrHMM <- function(chrHMMfile1,chrHMMfile1_name, chrHMMfile2, chrHMMfile2_name, chrHMM_list){
  peak_list <- GenomicRanges::GRangesList(file1 = chrHMMfile1, file2 = chrHMMfile2) # create GRangesList from GRanges object
  chromHMM_annotation <- genomation::annotateWithFeatures(peak_list, chrHMM_list) # annotate peaks using ChromHMM annotations
  matrix <- genomation::heatTargetAnnotation(chromHMM_annotation, plot = FALSE) # obtain matrix used to create heatmaps
  rownames(matrix) <- c(chrHMMfile1_name, chrHMMfile2_name) # set row names
  matrix_melt <- reshape2::melt(matrix) # convert matrix into molten data frame
  colnames(matrix_melt) = c("Sample", "State", "value") # set column names

  # Plot heatmap using ggplot2
  chrHMM_plot <- ggplot2::ggplot(matrix_melt) +
    ggplot2::geom_tile(ggplot2::aes(x = State, y = Sample, fill = value)) +
    ggplot2::ylab("") +
    ggplot2::xlab("") +
    viridis::scale_fill_viridis() +
    ggplot2::theme_minimal() +
    ggpubr::rotate_x_text(angle = 45) +
    ggplot2::theme(axis.text = ggplot2::element_text(size = 11))

  return(chrHMM_plot)
}
