#' Compute correlation matrix
#' 
#' Compute correlation matrix on all peak files.
#' @param genome_build The build of **all** peak and reference files to 
#' calculate the correlation matrix on. If all peak and reference files are not 
#' of the same build use 
#' \link[EpiCompare]{liftover_grlist} to convert them all before running. Genome
#' build should be one of hg19, hg38, mm9, mm10.
#' @param bin_size Default of 100. Base-pair size of the bins created to measure
#' correlation. Use smaller value for higher resolution but longer run time and 
#' larger memory usage.
#' @param drop_empty_chr Drop chromosomes that are not present in any of the 
#' \code{peakfiles} (default: \code{FALSE}). 
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
#' @param return_bins If \code{TRUE}, returns a named list
#'  with both the rebinned 
#' (standardised) peaks ("bin") and the correlation matrix ("cor").
#' If \code{FALSE} (default), returns only the correlation matrix (unlisted). 
#' @param save_path Path to save a table of correlation results to.
#' @inheritParams EpiCompare
#' @inheritParams get_bpparam
#' @inheritParams remove_nonstandard_chrom
#' @inheritParams precision_recall_matrix
#' @return correlation matrix
#' 
#' @export
#' @importFrom stats cor
#' @examples 
#' data("CnR_H3K27ac")
#' data("CnT_H3K27ac")
#' data("encode_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
#' reference <- list("encode_H3K27ac"=encode_H3K27ac)
#' 
#' #increasing bin_size for speed but lower values will give more granular corr
#' corr_mat <- compute_corr(peakfiles = peakfiles,
#'                          reference = reference,
#'                          genome_build = "hg19",
#'                          bin_size = 200000)
compute_corr <- function(peakfiles,
                         reference = NULL,
                         genome_build,
                         keep_chr = NULL,
                         drop_empty_chr = FALSE,
                         bin_size = 5000,
                         method = "spearman",
                         intensity_cols=c("total_signal", 
                                          "qValue",
                                          "Peak Score",
                                          "score"),
                         return_bins = FALSE,
                         fill_diag = NA,
                         workers = 1,
                         save_path = tempfile(fileext = ".corr.csv.gz")){
    # templateR:::source_all()
    # templateR:::args2vars(EpiCompare::compute_corr)
    
    t1 <- Sys.time() 
    #### append all peak files since all to be compared ####
    #make sure reference not already added to peakfiles
    if(!is.null(reference)){
        all_peaks <- append(reference[!names(reference) %in% names(peakfiles)],
                            peakfiles)
    } else {
        all_peaks <- peakfiles
    } 
    #sense check
    if(length(all_peaks)<=1)
      stop("Need more than one peak file to create correlation matrix.") 
    #### Re-bin data so comparisons made same regions ####
    gr_mat <- rebin_peaks(peakfiles = all_peaks, 
                          genome_build = genome_build, 
                          keep_chr = keep_chr,
                          drop_empty_chr = drop_empty_chr,
                          intensity_cols = intensity_cols,
                          bin_size = bin_size, 
                          ## stats::cor can only take dense matrices.
                          as_sparse = FALSE,
                          workers = workers)
    #### Run all pairwise correlations #####
    messager("Calculating correlation matrix.")
    cor_mat <- stats::cor(gr_mat, method=method)
    #### Fill diagonal ####
    if(!is.null(fill_diag)) diag(cor_mat) <- fill_diag
    #### Report time ####
    t2 <- Sys.time()
    messager("Done computing correlations in",
             round(difftime(t2,t1,units = "s"),0),"seconds.") 
    #### Save ####
    save_path <- save_results(
        dat = data.table::data.table(cor_mat, keep.rownames = TRUE), 
        save_path = save_path, 
        type = "correlation")
    #### Return ####
    if(isTRUE(return_bins)){ 
       return(
           list(bins = gr_mat,
                cor = cor_mat)
       )
    } else {
        return(cor_mat)
    } 
}
