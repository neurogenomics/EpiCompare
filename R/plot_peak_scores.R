#' Plot Peak Scores boxplot
#'
#' This function creates a boxplot showing the distribution of peak scores in
#' each peak file.
#'
#' @param score_cols Depending on which columns are present, this
#' value will be used to get peak scores to plot from the metadata columns.
#' @inheritParams width_boxplot
#' @inheritParams plot_corr
#' @return A boxplot of peak scores.
#'
#' @importFrom GenomicRanges mcols
#' @importFrom ggplot2 ggplot
#' 
#' @export
#' @examples
#' data("encode_H3K27ac") # example peaklist GRanges object
#' data("CnT_H3K27ac") # example peaklist GRanges object  
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)  
#' my_plot <- plot_peak_scores(peaklist = peaklist) 
plot_peak_scores <- function(peaklist,
                             score_cols = c("score", "signal.value"),
                             interact = FALSE) {
    message("--- Running plot_peak_scores() ---")
    
    # Check for score columns
    peaklist <- check_grlist_cols(grlist = peaklist, target_cols = score_cols)
    
    # Get scores for each peak file
    scores_list <- lapply(peaklist, function(pf) {
        if (!any(score_cols %in% colnames(mcols(pf)))) {
            warning("No score columns found in peak file.")
        } else {
            score_col <- score_cols[score_cols %in% colnames(mcols(pf))][1]
            mcols(pf)[[score_col]]
        }
    })
    
    # Box plot
    score_data <- do.call(rbind, lapply(names(scores_list), function(name) {
        data.frame(sample = name, score = scores_list[[name]])
    }))
    
    font_size <- 11
    if (length(peaklist) > 6) {
        font_size <- 8
    }
    
    boxplot <- ggplot(score_data, aes(x = sample, y = score, fill = sample)) +
        geom_boxplot() +
        theme_bw() +
        labs(y = "Score", x = "") +
        ggplot2::coord_flip() +
        ggplot2::theme(axis.text.x = ggplot2::element_text(
            angle = 45,
            vjust = 1,
            hjust = 1,
            size = font_size
        )) +
        ggplot2::scale_y_continuous(
            limits = quantile(score_data$score, c(0.025, 0.975), na.rm = TRUE)
        )
    
    if (isTRUE(interact)) {
        boxplot <- as_interactive(boxplot)
    }
    
    message("Done.")
    
    # Return
    return(list(plot = boxplot, data = score_data))
}
