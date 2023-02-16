heatmap_heatmaply <- function(X,
                              draw_cellnote=TRUE,
                              cellnote_textposition="middle center",
                              ...){
  requireNamespace("heatmaply")
  requireNamespace("viridis")
  # https://github.com/talgalili/heatmaply/issues/11 
  heatmaply::heatmaply(X, 
                       colors=viridis::magma(n=256),
                       draw_cellnote=draw_cellnote,
                       cellnote_textposition=cellnote_textposition,
                       ...)
}