#' Peak width boxplot
#'
#' This function creates boxplots showing the distribution of widths in each peak file.
#'
#' @param peaklist A list of peak files as GRanges object. Files must be listed using `list()`
#' @param namelist A list of file names in the same order as the list of peak files. Use `c()` for multiple.
#'
#' @return A boxplot of peak widths.
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#'
#' width_boxplot(peaklist = list(encode_H3K27ac, CnT_H3K27ac),
#'               namelist = c("ENCODE", "CnT"))
#'
width_boxplot <- function(peaklist, namelist){
  df <- NULL
  for (i in 1:length(peaklist)){

    sample <- namelist[i]
    width <- GenomicRanges::width(peaklist[[i]])
    width_df <- data.frame(sample, width)
    df <- rbind(df, width_df)
  }

  boxplot <- ggplot2::ggplot(df, ggplot2::aes(x = sample, y = width)) +
                ggplot2::geom_boxplot(outlier.shape = NA) +
                ggplot2::scale_y_continuous(trans="log10") +
                ggplot2::labs(x="",y="width (bp)") +
                ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))
  return(boxplot)
}
