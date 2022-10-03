#' Read peaks
#' 
#' Read peak files.
#' @param path Path to peak file.
#' @param verbose Print messages.
#' @inheritParams gather_files
#' @return \link[GenomicRanges]{GRanges}
#' 
#' @keywords internal
#' @importFrom methods is
#' @importFrom GenomicRanges makeGRangesFromDataFrame mcols
#' @importFrom rtracklayer import
#' @importFrom data.table fread 
#' @importFrom ChIPseeker readPeakFile
read_peaks <- function(path,
                       type,
                       verbose=TRUE){
    
   
    if(startsWith(type,"peaks")){
        messager("Reading peaks.",v=verbose)
        dat <- ChIPseeker::readPeakFile(path, as = "GRanges")
        if(type=="peaks.stringent" && 
           (ncol(GenomicRanges::mcols(dat))==3)){
            ## Colnames are not included in SEACR output,
            ## but can be found in the SEACR documentation.
            colnames(GenomicRanges::mcols(dat))  <- c("total_signal",
                                                      "max_signal",
                                                      "max_signal_region")
        }
    } else if(grepl("narrowPeak",path,ignore.case = TRUE)){
        messager("Reading narrowPeaks",v=verbose)
        dat <- rtracklayer::import(path, 
                                   format = "narrowPeak")
    } else {
        messager("Reading peaks with data.table.",v=verbose)
        dat <- data.table::fread(path)
    }
    #### Ensure GRanges format ####
    if(length(dat)==0){
        messager("WARNING: File contains 0 rows.",v=verbose)
        return(NULL)
    }
    if(!methods::is(dat,"GRanges")) {
        ## Try to convert to GRanges, but if it fails,
        ## just return the data.table
        dat <- tryCatch({
            GenomicRanges::makeGRangesFromDataFrame(
                df = dat,
                keep.extra.columns = TRUE)
        }, error = function(e) {message(e); NULL}) 
    } 
    return(dat)
}
