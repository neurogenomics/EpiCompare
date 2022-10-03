read_multiqc <- function(path,
                         verbose=TRUE){
    
    messager("Reading multiQC report.",v=verbose)
    data.table::fread(path)
}