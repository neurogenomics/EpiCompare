check_heatmap_args <- function(draw_cellnote,
                               interact,
                               fill_diag,
                               verbose=TRUE){
  if(isTRUE(draw_cellnote) && isTRUE(interact)){
    check_dep("heatmaply")
    if(!is.null(fill_diag)){
      messager("Warning: fill_diag must =NULL",
               "due to a known bug in the package 'heatmaply'.",v=verbose)
      fill_diag <- NULL
    } 
  }
  return(fill_diag)
}