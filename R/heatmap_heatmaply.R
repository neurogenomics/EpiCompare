heatmap_heatmaply <- function(X,
                              draw_cellnote=TRUE,
                              cellnote_textposition="middle center",
                              ...){
  requireNamespace("heatmaply")
  # https://github.com/talgalili/heatmaply/issues/11
  heatmaply::heatmaply(X, 
                       draw_cellnote=draw_cellnote,
                       cellnote_textposition=cellnote_textposition,
                       ...)
}