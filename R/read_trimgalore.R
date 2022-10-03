read_trimgalore <- function(path,
                            verbose=TRUE){
    
    messager("Parsing trimgalore report.",v=verbose)
    l <- readLines(path, )
    lstart <- grep("=== Summary ===",l)
    lend <- grep("=== Adapter 1 ===",l)
    ldat <- grep("^$",l[seq(lstart+1,lend-1)], 
                 invert = TRUE, value = TRUE)
    ldat <- stringr::str_split(gsub("[ ]+"," ",ldat),":", simplify = TRUE) 
    dat_vals <- stringr::str_split(gsub("[%]|[)]|bp|[,]|[ ]","",ldat[,2]),
                                   "[(]", simplify = TRUE)
    dat <- data.table::data.table(
        metric=tolower(gsub("[ ]|[-]","_",gsub("[(]|[)]","",ldat[,1]))),
        value=as.integer(dat_vals[,1]),
        percent=as.numeric(dat_vals[,2])
    )
    return(dat)
    # GenomicAlignments::readGAlignments(x)
}