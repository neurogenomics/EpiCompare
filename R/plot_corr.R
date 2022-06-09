#' Plot correlation of peak files
#' 
#' Plot correlation by binning genome and measuring correlation of peak quantile
#' ranking. This ranking is based on p-value or other peak intensity measure 
#' dependent on the peak calling approach.
#' @param show_plot Show the plot. 
#' @inheritParams compute_corr
#' @inheritParams EpiCompare 
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
#' reference <- list("encode_H3K27ac" = encode_H3K27ac)
#' 
#' #increasing bin_size for speed but lower values will give more granular corr
#' cp <- plot_corr(peakfiles = peakfiles,
#'                 reference = reference,
#'                 genome_build = "hg19",
#'                 bin_size = 1000)
plot_corr <- function(peakfiles,
                      reference,
                      genome_build,
                      bin_size = 100,
                      method = "spearman",
                      intensity_cols=c("total_signal", 
                                       "qValue",
                                       "Peak Score"),
                      interact=FALSE,
                      workers=1,
                      show_plot=TRUE){
    
    requireNamespace("ggplot2")
    peakfile1 <- peakfile2 <- corr <- NULL;
    #### Get corr matrix ####
    corr_mat <- compute_corr(peakfiles = peakfiles,
                             reference = reference,
                             genome_build = genome_build,
                             bin_size = bin_size,
                             method = method,
                             intensity_cols = intensity_cols,
                             workers = workers) 
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
    corr_mat_melt$corr <- round(corr_mat_melt$corr,3)
    corr_plot <- ggplot2::ggplot(corr_mat_melt, 
                    ggplot2::aes(x=peakfile1, 
                                 y=peakfile2, 
                                 fill=corr,
                                 label=corr)) + 
        ggplot2::geom_tile() + 
        ggplot2::geom_text(color="white", size=5) + 
        ggplot2::scale_fill_viridis_c(option="magma", 
                                      na.value = "grey10",
                                      breaks=seq(0,1,.5),
                                      limits=c(0,1)) + 
        ggplot2::labs(x=NULL, y=NULL, title="Peak correlation matrix") +
        ggplot2::theme_bw() +
        ggplot2::theme(axis.text.x = ggplot2::element_text(angle=45,hjust=1))
    if(interact){
        plotly::ggplotly(corr_plot)
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
    if(show_plot) {
        methods::show(corr_plot)
    }
    #### Return both the plot and data ####
    return(list(
        data=corr_mat,
        corr_plot=corr_plot
    ))
}
