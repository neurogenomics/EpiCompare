plot_precision_recall_prcurve <- function(plot_dat,
                                          color,
                                          shape,
                                          rows,
                                          cols,
                                          subtitle,
                                          interact) {
  messager("Plotting precision-recall curve.")
  gg <- ggplot2::ggplot(
    data = plot_dat,
    ggplot2::aes(
      x = .data$recall,
      y = .data$precision,
      group = .data$peaklist1,
      color = color
    )
  ) +
    ggplot2::geom_point(ggplot2::aes(size = 1 - .data$threshold, shape =
                                       shape), alpha = .8) +
    ggplot2::geom_line() +
    ggplot2::facet_grid(rows = rows, cols = cols) +
    ggplot2::ylim(0, 100) +
    ggplot2::xlim(0, 100) +
    ggplot2::labs(
      title = "precision-recall curves",
      subtitle = subtitle,
      x = "Recall\n(% reference peaks in sample peaks)",
      y = "Precision\n(% sample peaks in reference peaks)"
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(
      strip.background = ggplot2::element_rect(fill = "grey20"),
      strip.text = ggplot2::element_text(color = "white"),
      plot.margin = ggplot2::margin(.5, .5, .5, .5)
      # legend.title = ggplot2::element_text(size=7),
      # legend.spacing.y = ggplot2::unit(.001, units = "npc"),
      # legend.text=ggplot2::element_text(size=7)
    )
  if (isTRUE(interact))
    gg <- as_interactive(gg)
  return(gg)
}
