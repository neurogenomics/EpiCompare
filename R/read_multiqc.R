read_multiqc <- function(path,
                         verbose=TRUE){
    
    messager("Reading multiQC report.",v=verbose)
    dat <- data.table::fread(path)
    dat[,path:=path]
    return(dat)
}