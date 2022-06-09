#' Compute correlation matrix
#' 
#' Compute correlation matrix on all peak files
#' @param genome_build The build of **all** peak and reference files to 
#' calculate the correlation matrix on. If all peak and reference files are not 
#' of the same build use 
#' \link[EpiCompare]{liftover_grlist} to convert them all before running. Genome
#' build should be one of hg19, hg38, mm9, mm10.
#' @param bin_size Default of 100. Base-pair size of the bins created to measure
#' correlation. Use smaller value for higher resolution but longer run time and 
#' larger memory usage.
#' @param method Default spearman (i.e. non-parametric). A character string 
#' indicating which correlation coefficient (or covariance) is to be computed. 
#' One of "pearson", "kendall", or "spearman": can be abbreviated.
#' @param intensity_cols Depending on which columns are present, this
#' value will be used to get quantiles and ultimately calculate the 
#' correlations:
#' \itemize{
#'  \item{"total_signal" : }{Used by the peak calling software 
#'  \href{https://github.com/FredHutch/SEACR}{SEACR}. 
#'  \emph{NOTE}: Another SEACR column (e.g. "max_signal") can be used 
#'  together or instead of "total_signal".}
#'  \item{"qValue"}{Used by the peak calling software 
#'  \href{https://github.com/macs3-project/MACS}{MACS2/3}. 
#'  Should contain the negative log of the p-values after multiple 
#'  testing correction.}
#'  \item{"Peak Score" : }{
#'  Used by the peak calling software
#'   \href{http://homer.ucsd.edu/homer/ngs/peaks.html}{HOMER}.}
#' }
#' @inheritParams EpiCompare
#' @inheritParams get_bpparam
#' @return correlation matrix
#' 
#' @export
#' @importFrom data.table rbindlist as.data.table dcast
#' @importFrom GenomicRanges  tileGenome seqinfo binnedAverage coverage
#' @importFrom GenomeInfoDb Seqinfo seqnames seqlevels
#' @importFrom BiocGenerics `%in%`
#' @examples 
#' data("CnR_H3K27ac")
#' data("CnT_H3K27ac")
#' data("encode_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
#' reference <- list("encode_H3K27ac" = encode_H3K27ac)
#' 
#' #increasing bin_size for speed but lower values will give more granular corr
#' corr_mat <- calc_corr(peakfiles = peakfiles,
#'                       reference = reference,
#'                       genome_build = "hg19",
#'                       bin_size = 1000)
calc_corr <- function(peakfiles,
                      reference,
                      genome_build,
                      bin_size = 100,
                      method = "spearman",
                      intensity_cols=c("total_signal", 
                                       "qValue",
                                       "Peak Score"),
                      workers=1){
    #check genome build
    gen_build_err <- 
      paste0("All peak files must be of the same genome build.\nUse ",
             "EpiCompare::liftover_grlist on your data first and then rerun")
    if(length(genome_build)>1)
      stop(gen_build_err)
    genome_build <- tolower(genome_build)
    msg <- paste("genome_build must be one of:",
                 "\n- 'hg19'",
                 "\n- 'hg38'",
                 "\n- 'mm9'",
                 "\n- 'mm10'")
    if(!genome_build %in% c("hg19","hg38","mm9","mm10"))
      stop(msg)
    
    #get reference gen data
    ref_bsgen <- check_genome_build(genome_build,type="bsgen")
    
    #append all peak files since all to be compared
    #make sure reference not already added to peakfiles
    all_peaks <- append(reference[!names(reference) %in% names(peakfiles)],
                          peakfiles)
    #sense check
    if(length(all_peaks)<=1)
      stop("Need more than one peak file to create correlation matrix")
    
    #### Re-bin data so comparisons made same regions ####
    BPPARAM <- get_bpparam(workers = workers)
    messager("Standardising by binning peak files")
    rebinned_peaks <- 
      BiocParallel::bpmapply(all_peaks,
                             BPPARAM = BPPARAM,
                             SIMPLIFY = FALSE,
                             FUN = function(assay){
                               ## Compute percentiles
                               assay <- compute_percentiles(
                                 gr = assay, 
                                 thresholding_cols = intensity_cols,
                                 initial_threshold = 0
                                 )
                               ## Re-bin desired level,averaging intensity score 
                               gr_windows <- 
                                 GenomicRanges::tileGenome(
                                   GenomicRanges::seqinfo(ref_bsgen),
                                   tilewidth=bin_size, 
                                   cut.last.tile.in.chrom=TRUE)
                               #get col name of intensity
                               assay_names <- names(GenomicRanges::mcols(assay))
                               #can be more than one just arbitrarily take first
                               intens_col <-
                                 assay_names[assay_names %in% 
                                               paste(intensity_cols,
                                                     "percentile",
                                                     sep="_")][1]
                               #measure to avg within the bins
                               data_cov <- 
                                 GenomicRanges::coverage(assay,
                                                          weight=intens_col)
                               rm(assay)
                               GenomeInfoDb::seqlevels(gr_windows, 
                                                       pruning.mode="coarse") <- 
                                 names(data_cov)
                               assay <- 
                                 GenomicRanges::binnedAverage(gr_windows, 
                                                              data_cov, "score")
                               #keep chr 1:22, X,Y - 
                               #this will also work for mouse since less chr
                               val_chrs <- paste0("chr",c(seq_len(22),"X","Y"))
                               assay <- 
                                 assay[BiocGenerics::`%in%`(
                                   GenomeInfoDb::seqnames(assay),val_chrs)]
                                 #assay[GenomeInfoDb::seqnames(assay) %in% 
                                    #     val_chrs]
                               #update seq lengths
                               GenomeInfoDb::seqlevels(assay, 
                                                        pruning.mode="coarse")<- 
                                 val_chrs
                               #trim parts not found in gen build
                               seqinfo(assay) <- 
                                 GenomeInfoDb::Seqinfo(genome=genome_build)
                               assay <- trim(assay)
                               ## convert to dt and return
                               assay <- data.table::as.data.table(assay)
                               #remove unnecessary cols - save mem
                               assay[,c("width","strand"):=NULL]
                               return(assay)
                              })  
    messager("Calculating Correlation Matrix")
    rebinned_peaks <- 
      data.table::rbindlist(rebinned_peaks,use.names = TRUE, idcol = "assay")
    #### Calculate correlation
    #go from long to wide
    all_assays_wide <- 
      data.table::dcast(rebinned_peaks, ...~assay, value.var = "score")
    rm(rebinned_peaks)
    #make matrix
    val_cols <- 
      names(all_assays_wide)[!names(all_assays_wide) %in% 
                               c("seqnames","start","end")]
    assay_mat <- as.matrix(all_assays_wide[,val_cols,with=FALSE])
    rm(all_assays_wide)
    cor_mat <- stats::cor(assay_mat,method=method)
    return(cor_mat)
}
