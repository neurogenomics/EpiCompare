#' Plot precision-recall curves
#' 
#' Plot precision-recall curves (and optionally F1 plots) by 
#' iteratively testing for peak overlap across a series of 
#' thresholds used to filter \code{peakfiles}. 
#' Each \link[GenomicRanges]{GRanges}
#'  object in \code{peakfiles} will be used as the "query" 
#'  against each \link[GenomicRanges]{GRanges} object in \code{reference}
#'  as the subject.
#'  Will automatically use any columns that are
#'  specified with \code{thresholding_cols} and present within each 
#'  \link[GenomicRanges]{GRanges} object 
#'  to create percentiles  for thresholding. 
#' \emph{NOTE} : Assumes that all \link[GenomicRanges]{GRanges} in
#' \code{peakfiles} and \code{reference} are already 
#' aligned to the same genome build. 
#' @param show_plot Show the plot. 
#' @param plot_f1 Generate a plot with the F1 score vs. threshold as well. 
#' @param subtitle Plot subtitle.
#' @param color Variable to color data points by. 
#' @param shape Variable to set data point shapes by. 
#' @inheritParams precision_recall
#' @inheritParams EpiCompare
#' @inheritParams get_bpparam
#' @inheritParams ggplot2::aes_string
#' @inheritParams ggplot2::facet_grid
#' @return list with data and precision recall and F1 plots
#' 
#' @export 
#' @importFrom methods show
#' @importFrom data.table data.table dcast
#' @examples 
#' data("CnR_H3K27ac")
#' data("CnT_H3K27ac")
#' data("encode_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
#' reference <- list("encode_H3K27ac" = encode_H3K27ac)
#' 
#' pr_out <- plot_precision_recall(peakfiles = peakfiles,
#'                                 reference = reference)
plot_precision_recall <- function(peakfiles,
                                  reference,
                                  thresholding_cols=c("total_signal", 
                                                      "qValue",
                                                      "Peak Score"),
                                  initial_threshold=0,
                                  n_threshold=10,
                                  max_threshold=1,
                                  workers = 1,
                                  plot_f1 = TRUE,
                                  subtitle = NULL,
                                  color = "peaklist1",
                                  shape = color,
                                  facets = "peaklist2 ~ .",
                                  interact = FALSE,
                                  show_plot = TRUE){
    requireNamespace("ggplot2")
    precision <- recall <- F1 <- NULL; 
    # #### Gather precision-recall data ####
    pr_df <- precision_recall(peakfiles = peakfiles,
                              reference = reference,
                              thresholding_cols = thresholding_cols,
                              initial_threshold = initial_threshold,
                              max_threshold = max_threshold,
                              n_threshold = n_threshold,
                              workers = workers
                              )
    pr_df <- data.table::data.table(pr_df)
    #### Post-process data ####
    plot_dat <- data.table::dcast(
        data = pr_df,
        formula = "peaklist1 + peaklist2 + threshold ~ type", 
        fun.aggregate = mean,
        value.var = c("Percentage","overlap","total")) 
    data.table::setnames(plot_dat,
                         c("Percentage_precision","Percentage_recall"), 
                         c("precision","recall"))
    plot_dat$threshold <- as.numeric(plot_dat$threshold) 
    #### Compute F1 ##### 
    plot_dat[,F1:=(2*(precision*recall) / (precision+recall))] 
    plot_dat[is.na(F1),]$F1 <- 0
    
    #### Plot precision-recall ####
    gg <- ggplot2::ggplot(
        data = plot_dat, 
        ggplot2::aes_string(x="recall", 
                            y="precision",
                            group="peaklist1", 
                            color=color)) + 
        ggplot2::geom_point(ggplot2::aes_string(size = "1-threshold",
                                                shape=shape),
                            alpha=.8) +
        ggplot2::geom_line() + 
        ggplot2::facet_grid(facets = facets) + 
        ggplot2::ylim(0, 100) +
        ggplot2::xlim(0, 100) +
        ggplot2::labs(
            title="precision-recall curves", 
            subtitle = subtitle,
            x="Recall\n(% reference peaks in sample peaks)", 
            y="Precision\n(% sample peaks in reference peaks)") + 
        ggplot2::theme_bw() +
        ggplot2::theme(
            strip.background = ggplot2::element_rect(fill = "grey20"),
            strip.text = ggplot2::element_text(color="white"),
            legend.title = ggplot2::element_text(size=7),
            legend.spacing.y = ggplot2::unit(.001, units = "npc"),
            legend.text=ggplot2::element_text(size=7)
            ) 
    if(interact) gg <- plotly::ggplotly(gg)
    #### Plot F1 #####
    if(plot_f1){
        ggf1 <- ggplot2::ggplot(
            data = plot_dat, 
            ggplot2::aes_string(x="threshold", 
                                y="F1",
                                group="peaklist1", 
                                color=color)) + 
            ggplot2::geom_point(ggplot2::aes_string(size = "1-threshold",
                                                    shape=color),
                                alpha=.8) +
            ggplot2::facet_grid(facets = facets) + 
            ggplot2::ylim(0, 100) +
            ggplot2::xlim(initial_threshold, 1) +
            ggplot2::labs(
                title="F1 plot",
                y="F1\n2 * (precision * recall) / (precision + recall)") + 
            ggplot2::geom_line() +
            ggplot2::theme_bw() +
            ggplot2::theme(
                strip.background = ggplot2::element_rect(fill = "grey20"),
                strip.text = ggplot2::element_text(color="white")
            )
        if(interact) ggf1 <- plotly::ggplotly(ggf1)
    } else {
        ggf1 <- NULL
    }
    #### Show plots ####
    if(show_plot) {
        methods::show(gg)
        methods::show(ggf1)
    }
    #### Return both the plot and data ####
    return(list(
        data=plot_dat,
        precision_recall_plot=gg,
        f1_plot=ggf1
    ))
}
