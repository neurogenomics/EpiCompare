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
#' @importFrom data.table data.table dcast :=
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
                                  n_threshold=20,
                                  max_threshold=1,
                                  workers = 1,
                                  plot_f1 = TRUE,
                                  subtitle = NULL,
                                  color = "peaklist1",
                                  shape = color,
                                  facets = "peaklist2 ~ .",
                                  interact = FALSE,
                                  show_plot = TRUE,
                                  save_path=
                                      tempfile(fileext = "precision_recall.csv")
                                  ){
    
    requireNamespace("ggplot2")
    # #### Gather precision-recall data ####
    plot_dat <- precision_recall(peakfiles = peakfiles,
                                 reference = reference,
                                 thresholding_cols = thresholding_cols,
                                 initial_threshold = initial_threshold,
                                 max_threshold = max_threshold,
                                 n_threshold = n_threshold,
                                 workers = workers,
                                 cast = TRUE,
                                 save_path = save_path)
    #### Plot precision-recall ####
    gg <- plot_precision_recall_prcurve(plot_dat=plot_dat,
                                        color=color,
                                        shape=shape,
                                        facets=facets,
                                        subtitle=subtitle, 
                                        interact=interact)
    #### Plot F1 #####
    if(isTRUE(plot_f1)){
        ggf1 <- plot_precision_recall_f1(plot_dat=plot_dat,
                                         color=color,
                                         shape=shape,
                                         facets=facets,
                                         initial_threshold=initial_threshold,
                                         interact=interact)
    } else {
        ggf1 <- NULL
    }
    #### Show plots ####
    if(isTRUE(show_plot)) {
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
