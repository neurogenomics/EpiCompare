read_picard <- function(path,
                        verbose=TRUE){
    
    messager("Reading picard report.",v=verbose)
    dat <- data.table::fread(path,
                              skip = "LIBRARY",
                              fill = TRUE,
                              nrows = 1)
    dat[,path:=path]
    return(dat)
}