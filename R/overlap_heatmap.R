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
#' @param draw_cellnote Draw the numeric values within each heatmap cell.
#' @param verbose Print messages.
#' @inheritParams precision_recall_matrix
#' @returns An interactive heatmap
#'
#' @import ggplot2
#' @importFrom reshape2 melt
#' @importFrom plotly plot_ly
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' ### Create Named List ###
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)
#' ### Run ###
#' my_heatmap <- overlap_heatmap(peaklist = peaklist) 
overlap_heatmap <- function(peaklist,
                            interact=TRUE,
                            draw_cellnote=TRUE,
                            fill_diag=NA,
                            verbose=TRUE){

  ### Variables ###
  Var1 <- Var2  <- value <- NULL;
  t1 <- Sys.time()
  messager("--- Running overlap_heatmap() ---",v=verbose) 
  #### Check deps ####
  fill_diag <- check_heatmap_args(draw_cellnote = draw_cellnote, 
                                  interact = interact, 
                                  fill_diag = fill_diag, 
                                  verbose = verbose)
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist) 
  ### Calculate Overlap Percentage ### 
  overlap_matrix <- precision_recall_matrix(peaklist = peaklist,
                                            fill_diag = fill_diag,
                                            verbose = verbose)
  ### Create Static Heatmap ###
  if(isFALSE(interact)){
    mtx_melt <- reshape2::melt(overlap_matrix)
    plt <- ggplot2::ggplot(
        data = mtx_melt,
        ggplot2::aes(x=Var1, y=Var2,
                     fill=value, 
                     label=round(value,2))) +
        ggplot2::geom_tile() + 
        ggplot2::labs(x="Recall", y="Precision",
                      fill=gsub(" ","\n","% overlap")) +
        ggplot2::scale_fill_viridis_c(na.value = "transparent") +
        ggplot2::theme_bw()
    if(isTRUE(draw_cellnote)){ 
        plt <- plt + ggplot2::geom_label(fill=ggplot2::alpha("white",.8), 
                                         label.size = NA,
                                         na.rm = TRUE)
    }
  } else{
      ### Create Interactive Heatmap ###
      if(isTRUE(draw_cellnote)){
        #### heatmaply ####
        plt <- heatmap_heatmaply(X=overlap_matrix)
      } else {
        #### plotly #### 
        plt <- heatmap_plotly(X=overlap_matrix)
      }  
  }
  report_time(t1 = t1,
              func="overlap_heatmap",
              verbose = verbose)
  #### Return ####
  return(list(plot=plt,
              data=overlap_matrix))
}
