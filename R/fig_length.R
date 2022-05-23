#' Dynamic Figure Length Generator
#'
#' This function calculates the appropriate figure height depending on the
#' number of items.
#'
#' @param default_size The default figure length. Must be numeric.
#' @param number_of_items Number of peak files, or terms.
#' @param max_items Maximum number of peak files, or terms.
#'
#' @return Figure height/width. A number.
#' @keywords internal

fig_length <- function(default_size, number_of_items ,max_items){
  if(number_of_items > max_items){
    extra_N <- number_of_items - max_items
    length <- default_size + extra_N*0.25
  }else{
    length <- default_size
  }
  return(length)
}
