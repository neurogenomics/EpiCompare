heatmap_plotly <- function(X,
                           ...){
  # plot_ly sorts axis labels alphabetically unless they're.
  # Causes problems when trying to add numeric labels to each cell
  plotly::plot_ly(x = colnames(X),
                  y = rownames(X),
                  z = X,
                  type = "heatmap",
                  ...)
}