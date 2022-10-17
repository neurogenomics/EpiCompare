#' Set min/max
#' 
#' Set the min/max values in a data.frame.
#' @param df data.frame
#' @param colname Column name to check.
#' @param min_val Minimum value.
#' @param max_val Maximum value.
#' @returns data.frame
#' 
#' @keywords internal
#' @importFrom dplyr mutate_at
set_min_max <- function(df,
                        colname,
                        min_val=0,
                        max_val=100){ 
    df |>
        dplyr::mutate_at(
            .vars = colname, 
            .funs = function(x){ifelse(x<min_val,min_val,x)}) |>
        dplyr::mutate_at(
            .vars = colname, 
            .funs = function(x){ifelse(x>max_val,max_val,x)}) 
}
