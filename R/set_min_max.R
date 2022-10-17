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
#' @importFrom data.table data.table :=
set_min_max <- function(df,
                        colname,
                        min_val=0,
                        max_val=100){ 
    
    df <- data.table::data.table(df)
    df[,(colname):=ifelse(get(colname)<min_val,min_val,get(colname)),]
    df[,(colname):=ifelse(get(colname)>max_val,max_val,get(colname)),]
    return(df)
}
