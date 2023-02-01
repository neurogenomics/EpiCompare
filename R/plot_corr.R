#' Plot correlation of peak files
#' 
#' Plot correlation by binning genome and measuring correlation of peak quantile
#' ranking. This ranking is based on p-value or other peak intensity measure 
#' dependent on the peak calling approach.
#' @param show_plot Show the plot. 
#' @inheritParams compute_corr
#' @inheritParams rebin_peaks
#' @inheritParams EpiCompare 
#' @inheritParams precision_recall_matrix
#' @inheritParams overlap_heatmap
#' @return list with correlation plot (corr_plot) and correlation matrix (data)
#' 
#' @export 
#' @importFrom stringr str_wrap
#' @importFrom plotly ggplotly
#' @examples 
#' data("CnR_H3K27ac")
#' data("CnT_H3K27ac")
#' data("encode_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
#' reference <- list("encode_H3K27ac"=encode_H3K27ac)
#' 
#' #increasing bin_size for speed but lower values will give more granular corr
#' cp <- plot_corr(peakfiles = peakfiles,
#'                 reference = reference,
#'                 genome_build = "hg19",
#'                 bin_size = 5000)
plot_corr <- function(peakfiles,
                      reference,
                      genome_build,
                      bin_size = 5000,
                      keep_chr = NULL,
                      drop_empty_chr = FALSE,
                      method = "spearman",
                      intensity_cols=c("total_signal", 
                                       "qValue",
                                       "Peak Score",
                                       "score"),
                      interact=FALSE,
                      draw_cellnote=TRUE,
                      fill_diag=NA,
                      workers=1,
                      show_plot=TRUE,
                      save_path = tempfile(fileext = ".corr.csv.gz")){
    
    # templateR:::args2vars(plot_corr); genome_build = "hg19";
    check_dep("ggplot2")
    peakfile1 <- peakfile2 <- corr <- NULL;
    #### Check deps ####
    fill_diag <- check_heatmap_args(draw_cellnote = draw_cellnote, 
                                    interact = interact, 
                                    fill_diag = fill_diag)
    #### Get corr matrix ####
    corr_mat <- compute_corr(peakfiles = peakfiles,
                             reference = reference,
                             genome_build = genome_build,
                             bin_size = bin_size,
                             keep_chr = keep_chr,
                             drop_empty_chr = drop_empty_chr,
                             method = method,
                             intensity_cols = intensity_cols,
                             fill_diag = fill_diag,
                             workers = workers,
                             save_path = save_path,) 
    #### Plot correlation plot ####
    # diag(corr_mat) <- NA
    corr_mat_melt <- reshape2::melt(data = corr_mat,
                                    varnames = c("peakfile1","peakfile2"),
                                    value.name = "corr")
    width <- 80
    corr_mat_melt$peakfile1 <- stringr::str_wrap(corr_mat_melt$peakfile1,
                                                 width = width)
    corr_mat_melt$peakfile2 <- stringr::str_wrap(corr_mat_melt$peakfile2, 
                                                 width = width)
    corr_mat_melt$corr <- round(corr_mat_melt$corr,2)
    plt <- ggplot2::ggplot(corr_mat_melt, 
                    ggplot2::aes(x=peakfile1, 
                                 y=peakfile2, 
                                 fill=corr,
                                 label=corr)) + 
        ggplot2::geom_tile() + 
        ggplot2::scale_fill_viridis_c(option="magma", 
                                      na.value = "grey10",
                                      breaks=seq(0,1,.5),
                                      limits=c(0,1)) + 
        ggplot2::labs(x=NULL, y=NULL, title="Peak correlation matrix") +
        ggplot2::theme_bw() +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle=45,hjust=1))
    
    if(isTRUE(draw_cellnote)){ 
      plt <- plt + ggplot2::geom_label(fill=ggplot2::alpha("white",.8), 
                                       label.size = NA,
                                       na.rm = TRUE)
    }
    if(isTRUE(interact)){
      ### Create Interactive Heatmap ###
      if(isTRUE(draw_cellnote)){
        #### heatmaply ####
        plt <- heatmap_heatmaply(X=corr_mat)
      } else {
        #### plotly #### 
        plt <- heatmap_plotly(X=corr_mat)
      } 
    }
    #### With corrplot ####
    # corr_plot <-
    #   corrplot::corrplot(corr_mat, 
    #                      type="lower",
    #                      method="number",
    #                      col=RColorBrewer::brewer.pal(n=8, name="PuOr"),
    #                      tl.col="black", tl.srt=45)
    # #plot isn't returned, work around to record it
    # corr_plot <- grDevices::recordPlot()
    
    #### Show plots ####
    if(isTRUE(show_plot))  methods::show(plt)
    #### Return both the plot and data ####
    return(list(
        data=corr_mat,
        corr_plot=plt
    ))
}
