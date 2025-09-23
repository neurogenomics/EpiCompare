plot_precision_recall_f1 <- function(plot_dat,
                                     color,
                                     shape,
                                     rows,
                                     cols,
                                     initial_threshold,
                                     interact) {
  messager("Plotting F1.")
  ggf1 <- ggplot2::ggplot(data = plot_dat,
                          ggplot2::aes(
                            x = .data$threshold,
                            y = .data$F1,
                            group = .data$peaklist1,
                            color = color
                          )) +
    ggplot2::geom_point(ggplot2::aes(size = 1 - .data$threshold, shape =
                                       shape), alpha = .8) +
    ggplot2::facet_grid(rows = rows, cols = cols) +
    ggplot2::ylim(0, 100) +
    ggplot2::xlim(initial_threshold, 1) +
    ggplot2::labs(title = "F1 plot", y = "F1\n2 * (precision * recall) / (precision + recall)") +
    ggplot2::geom_line() +
    ggplot2::theme_bw() +
    ggplot2::theme(
      strip.background = ggplot2::element_rect(fill = "grey20"),
      strip.text = ggplot2::element_text(color = "white")
    )
  if (isTRUE(interact))
    ggf1 <- as_interactive(ggf1)
  return(ggf1)
}
