filter_percentiles <- function(gr, 
                               thresh,
                               thresholding_cols){
    # message("Filtering percentiles.")
    for(nm in paste(thresholding_cols,"percentile",sep="_")){
        if(nm %in% names(GenomicRanges::mcols(gr))){
            gr <- gr[GenomicRanges::mcols(gr)[[nm]]>=thresh,]
        }
    }
    return(gr)
}