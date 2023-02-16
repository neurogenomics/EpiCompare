plot_precision_recall_f1 <- function(plot_dat,
                                     color,
                                     shape,
                                     facets,
                                     initial_threshold,
                                     interact){
    
    messager("Plotting F1.")
    ggf1 <- ggplot2::ggplot(
        data = plot_dat, 
        ggplot2::aes_string(x="threshold", 
                            y="F1",
                            group="peaklist1", 
                            color=color)) + 
        ggplot2::geom_point(ggplot2::aes_string(size = "1-threshold",
                                                shape=shape),
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
    if(isTRUE(interact)) ggf1 <- as_interactive(ggf1)
    return(ggf1)
}
