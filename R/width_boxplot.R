#' Peak width boxplot
#'
#' This function creates boxplots showing the distribution of widths in
#' each peak file.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be named and listed using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#'
#' @return A boxplot of peak widths.
#'
#' @importMethodsFrom GenomicRanges width
#' @importFrom ggplot2 ggplot
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peaklist GRanges object
#' data("CnT_H3K27ac") # example peaklist GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)
#'
#' ### Run ###
#' my_plot <- width_boxplot(peaklist = peaks)
#'
width_boxplot <- function(peaklist){
  message("--- Running width_boxplot() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)

  # Obtain Widths, Create Data Frame ###
  df <- NULL
  for (i in seq_len(length(peaklist))){
    sample <- names(peaklist)[i]
    width <- GenomicRanges::width(peaklist[[i]])
    width_df <- data.frame(sample, width)
    df <- rbind(df, width_df)
  }
  
  ### Create Boxplot ###
  boxplot <- ggplot2::ggplot(df, ggplot2::aes(x=sample, y = width)) +
             ggplot2::geom_boxplot(outlier.shape = NA) +
             ggplot2::scale_y_continuous(trans="log10",limits = quantile(df$width,c(0.1, 0.9)))+
             ggplot2::labs(x="",y="width (bp)") +
             ggplot2::coord_flip() +
             ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 315,
                                                                vjust = 0.5,
                                                                hjust=0))
  message("Done.")
  return(boxplot)
}
