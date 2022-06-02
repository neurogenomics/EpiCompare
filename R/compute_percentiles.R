compute_percentiles <- function(gr,
                                thresholding_cols=c("total_signal", 
                                                    "qValue",
                                                    "Peak Score"),
                                initial_threshold=0.5){
    requireNamespace("scales")
    compute_pct <- function(vec,
                            initial_threshold){
        vec2 <- stats::ecdf(vec)(vec)
        if(!is.null(initial_threshold)){
            vec2 <- scales::rescale_pal(range = c(initial_threshold,1))(vec2)
            # vec3 <- scales::rescale(vec2, c(threshold,1))
        }
        return(vec2)
    } 
    GenomicRanges::mcols(gr)$width <- GenomicRanges::width(gr) 
    # GenomicRanges::mcols(gr)$max_signal_width <- sapply(gr$max_signal_region,
    #     function(x){
    #         GenomicRanges::width(GenomicRanges::GRanges(x))
    #     }
    # ) 
    cols <- names( GenomicRanges::mcols(gr))
    for(nm in thresholding_cols){
        if(nm %in% cols){ 
            new_nm <- paste(nm,"percentile",sep="_")
            # messager("Creating new column:",new_nm)
            GenomicRanges::mcols(gr)[[new_nm]] <- compute_pct(
                vec = GenomicRanges::mcols(gr)[[nm]], 
                initial_threshold = initial_threshold)
        }
    } 
    return(gr)
}
