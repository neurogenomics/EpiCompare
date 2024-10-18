#' Remove odd chromosomes from GRanges objects
#'
#' This convenience function removes non-standard, mitochondrial, and/or sex
#' chromosomes from any GRanges object.
#' 
#' This function is adapted from \code{tidyChromosomes} in the
#' \code{BRGenomics} package licensed under the Artistic License 2.0.
#' Original author: Mike DeBerardine <https://github.com/mdeber>
#'
#' @param gr Any GRanges object, or any another object with associated
#'   \code{seqinfo} (or a \code{Seqinfo} object itself). The object should
#'   typically have a standard genome associated with it, e.g. \code{genome(gr)
#'   <- "hg38"}. \code{gr} can also be a list of such GRanges objects.
#' @param keep.X,keep.Y,keep.M,keep.nonstandard Logicals indicating which
#'   non-autosomes should be kept. By default, sex chromosomes are kept, but
#'   mitochondrial and non-standard chromosomes are removed.
#' @param genome An optional string that, if supplied, will be used to set the
#'   genome of \code{gr}.
#'
#' @return A GRanges object in which both ranges and \code{seqinfo} associated
#'   with trimmed chromosomes have been removed.
#'
#' @details Standard chromosomes are defined using the
#'   \code{\link[GenomeInfoDb:seqlevels-wrappers]{standardChromosomes}} function
#'   from the \code{GenomeInfoDb} package.
#'
#' @author Mike DeBerardine
#' @seealso \code{\link[GenomeInfoDb:seqlevels-wrappers]{
#'   GenomeInfoDb::standardChromosomes}}
#'
#' @export
#' @importFrom GenomeInfoDb standardChromosomes seqlevels keepSeqlevels
#'   sortSeqlevels genome genome<-
#' @importFrom methods is
#' @examples
#' # make a GRanges
#' chrom <- c("chr2", "chr3", "chrX", "chrY", "chrM", "junk")
#' gr <- GenomicRanges::GRanges(seqnames = chrom,
#'               ranges = IRanges::IRanges(start = 2*(1:6), end = 3*(1:6)),
#'               strand = "+",
#'               seqinfo = GenomeInfoDb::Seqinfo(chrom))
#' GenomeInfoDb::genome(gr) <- "hg38"
#'
#' gr
#'
#' tidy_chromosomes(gr)
#'
#' tidy_chromosomes(gr, keep.M = TRUE)
#'
#' tidy_chromosomes(gr, keep.M = TRUE, keep.Y = FALSE)
#'
#' tidy_chromosomes(gr, keep.nonstandard = TRUE)
#' 
#' @keywords internal
tidy_chromosomes <- function(gr, keep.X = TRUE, keep.Y = TRUE, keep.M = FALSE,
                            keep.nonstandard = FALSE, genome = NULL) {
    
    if (is.list(gr) || is(gr, "GRangesList"))
        return(lapply(gr, tidy_chromosomes, keep.X, keep.Y, keep.M,
                      keep.nonstandard, genome))
    
    if (!is.null(genome))
        genome(gr) <- genome
    
    chrom <- standardChromosomes(gr)
    
    if (keep.nonstandard) chrom <- seqlevels(gr)
    if (!keep.X)  chrom <- chrom[ chrom != "chrX" ]
    if (!keep.Y)  chrom <- chrom[ chrom != "chrY" ]
    if (!keep.M)  chrom <- chrom[ (chrom != "chrM") & (chrom != "chrMT") ]
    
    if (is(gr, "Seqinfo")) {
        gr <- keepSeqlevels(gr, chrom)
    } else {
        gr <- keepSeqlevels(gr, chrom, pruning.mode = "tidy")
    }
    sortSeqlevels(gr)
}
