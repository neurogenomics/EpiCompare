read_bam <- function(path,
                     verbose=TRUE){
    
    check_dep("GenomicAlignments")
    messager("Parsing BAM file.",v=verbose)
    bam <- GenomicAlignments::readGAlignments(file = path)
    return(bam)
}