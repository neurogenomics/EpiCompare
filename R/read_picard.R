read_picard <- function(path,
                        verbose=TRUE){
    
    messager("Reading picard report.",v=verbose)
    data.table::fread(path,
                      skip = "LIBRARY",
                      fill = TRUE,
                      nrows = 1)
}