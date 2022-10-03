read_bam <- function(path,
                     verbose=TRUE){
    
    requireNamespace("GenomicAlignments")
    messager("Parsing BAM file.",v=verbose)
    bam <- GenomicAlignments::readGAlignments(file = path)
    return(bam)
}