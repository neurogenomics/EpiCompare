#' Plot correlation of peak files
#' 
#' Plot correlation by binning genome and measuring correlation of peak quantile
#' ranking. This ranking is based on p-value or other peak intensity measure 
#' dependent on the peak calling approach.
#' @param show_plot Show the plot. 
#' @inheritParams calc_corr
#' @inheritParams EpiCompare
#' @inheritParams corrplot::corrplot
#' @return list with correlation plot (corr_plot) and correlation matrix (data)
#' 
#' @export 
#' @importFrom RColorBrewer brewer.pal
#' @importFrom corrplot corrplot
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
                      workers=1,
                      show_plot=TRUE){
    #### Get corr matrix ####
    corr_mat <- calc_corr(peakfiles = peakfiles,
                       reference = reference,
                       genome_build = genome_build,
                       bin_size = bin_size,
                       method = method,
                       intensity_cols=intensity_cols,
                       workers=workers
                       )
    
    #### Plot correlation plot ####
    corr_plot <-
      corrplot::corrplot(corr_mat, 
                         type="lower",
                         method="number",
                         col=RColorBrewer::brewer.pal(n=8, name="PuOr"),
                         tl.col="black", tl.srt=45)
    #plot isn't returned, work around to record it
    corr_plot <- grDevices::recordPlot()
    
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
