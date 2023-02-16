#' Peak width boxplot
#'
#' This function creates boxplots showing the distribution of widths in
#' each peak file.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be named and listed using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' @inheritParams EpiCompare
#' @return A boxplot of peak widths.
#'
#' @importMethodsFrom GenomicRanges width
#' @importFrom ggplot2 ggplot 
#' @importFrom data.table data.table rbindlist
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peaklist GRanges object
#' data("CnT_H3K27ac") # example peaklist GRanges object  
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)  
#' my_plot <- width_boxplot(peaklist = peaklist) 
width_boxplot <- function(peaklist,
                          interact = FALSE){
  
  width <- NULL;
  message("--- Running width_boxplot() ---")
  #### Check Peaklist Names ####
  peaklist <- check_list_names(peaklist) 
  #### Obtain widths, create data.table #### 
  df <- lapply(seq_len(length(peaklist)), function(i){
    sample <- names(peaklist)[i]
    width <- GenomicRanges::width(peaklist[[i]])
    data.table::data.table(sample, width, name=peaklist[[i]]$name)
  }) |> data.table::rbindlist(fill=TRUE)
  #### Create Boxplot ####
  boxplot <- ggplot2::ggplot(df, ggplot2::aes(x = sample, 
                                              y = width, 
                                              fill = sample)) +
             ggplot2::geom_boxplot(outlier.shape = NA, 
                                   na.rm = TRUE) +
             ggplot2::scale_y_continuous(
               trans="log10",
               limits = quantile(df$width,c(0.1, 0.9))) +
             # ggplot2::scale_fill_viridis_d(alpha = .9, option = "mako") +
             ggplot2::labs(x="",y="width (bp)") +
             ggplot2::coord_flip() +
             ggplot2::theme_bw() +
             ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 315,
                                                                vjust = 0.5,
                                                                hjust = 0)) 
  message("Done.")
  if(isTRUE(interact)){ 
    boxplot <- as_interactive(boxplot) 
  }
  #### Return ####
  return(list(plot=boxplot,
              data=df)) 
}
