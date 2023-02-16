#' Read bowtie
#' 
#' Read a bowtie file.
#' @param path Path to bowtie file.
#' @param verbose Print messages.
#' @returns \link[data.table]{data.table}
#' 
#' @keywords internal
#' @importFrom data.table fread :=
read_bowtie <- function(path,
                        verbose=TRUE){
    
    metric <- NULL;
    if(endsWith("idxstats",path)){
        # Header info from: http://www.htslib.org/doc/samtools-idxstats.html
        messager("Reading bowtie2 idxstats.",v=verbose) 
        dat <- data.table::fread(path)|>
            `colnames<-`(c("chrom","sequence_length",
                           "mapped_read_segments",
                           "unmapped_read_segments"))
    } else {
        messager("Reading bowtie2 stats.",v=verbose)
        l <- readLines(path)
        dat <- data.table::fread(text=grep("^SN",l,value = TRUE), 
                                 sep = "\t",
                                 fill = TRUE)[,-1] |>
            `colnames<-`(c("metric","value","comment"))
        dat[,metric:=gsub(
            "[%]","pct",
            gsub("[()]|[)]","",
                 gsub("[ ]","_",trimws(metric,whitespace = ":"))))]
    } 
    dat[,path:=path]
    return(dat)
}