heatmap_plotly <- function(X,
                           ...){
  # plot_ly sorts axis labels alphabetically unless they're.
  # Causes problems when trying to add numeric labels to each cell
  requireNamespace("viridis")
  plotly::plot_ly(x = colnames(X),
                  y = rownames(X),
                  z = X,
                  type = "heatmap",
                  colors=viridis::magma(n=256),
                  ...)
}