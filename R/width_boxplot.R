#' Peak width boxplot
#'
#' This function creates boxplots showing the distribution of widths in each peak file.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()`.
#' Files must be named using `names(peaklist) <- c("sample1","sample2)`.
#' If not named, default file names will be assigned.
#'
#' @return A boxplot of peak widths.
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
#' width_boxplot(peaklist = peaks)
#'
width_boxplot <- function(peaklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  # for each peakfile retrieve widths and combine in data frame
  df <- NULL
  for (i in 1:length(peaklist)){
    sample <- names(peaklist)[i]
    width <- GenomicRanges::width(peaklist[[i]])
    width_df <- data.frame(sample, width)
    df <- rbind(df, width_df)
  }
  # create boxplot
  boxplot <- ggplot2::ggplot(df, ggplot2::aes(x = sample, y = width)) +
                ggplot2::geom_boxplot(outlier.shape = NA) +
                ggplot2::scale_y_continuous(trans="log10") +
                ggplot2::labs(x="",y="width (bp)") +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))
  return(boxplot)
}
