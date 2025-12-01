heatmap_heatmaply <- function(X,
                              draw_cellnote=TRUE,
                              cellnote_textposition="middle center",
                              round_digits=1,
                              ...){
  requireNamespace("heatmaply")
  requireNamespace("viridis")
  
  cellnote_mat_rounded <- round(X, round_digits)
  
  # https://github.com/talgalili/heatmaply/issues/11 
  heatmaply::heatmaply(X, 
                       colors=viridis::magma(n=256),
                       draw_cellnote=draw_cellnote,
                       cellnote=cellnote_mat_rounded,
                       cellnote_textposition=cellnote_textposition,
                       ...)
}