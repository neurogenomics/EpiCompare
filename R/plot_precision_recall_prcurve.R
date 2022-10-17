plot_precision_recall_prcurve <- function(plot_dat,
                                          color,
                                          shape,
                                          facets,
                                          subtitle,
                                          interact){
    
    messager("Plotting precision-recall curve.")
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
            plot.margin = ggplot2::margin(.5,.5,.5,.5)
            # legend.title = ggplot2::element_text(size=7),
            # legend.spacing.y = ggplot2::unit(.001, units = "npc"),
            # legend.text=ggplot2::element_text(size=7)
        ) 
    if(isTRUE(interact)) gg <- plotly::ggplotly(gg)
    return(gg)
}
