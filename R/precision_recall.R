#' Compute precision-recall
#' 
#' Compute precision and recall using each \link[GenomicRanges]{GRanges}
#'  object in \code{peakfiles} as the "query" 
#'  against each \link[GenomicRanges]{GRanges} object in \code{reference}
#'  as the subject.
#'  
#' @param thresholding_cols Depending on which columns are present, 
#'  \link[GenomicRanges]{GRanges} will 
#'  be filtered at each threshold according to one or more of the following:
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
#' @param initial_threshold Numeric threshold that was provided to SEACR 
#' (via the parameter \code{--ctrl}) when calling peaks without an IgG 
#' control.
#' @param max_threshold Maximum threshold to test.
#' @param increment_threshold Unit to increment tested thresholds by.
#' @inheritParams EpiCompare
#' @inheritParams get_bpparam
#' 
#' @export
#' @importFrom data.table rbindlist
#' @examples 
#' data("CnR_H3K27ac")
#' data("CnT_H3K27ac")
#' data("encode_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac)
#' reference <- list("encode_H3K27ac" = encode_H3K27ac)
#'
#' pr_df <- precision_recall(peakfiles = peakfiles,
#'                           reference = reference)
precision_recall <- function(peakfiles,
                             reference,
                             thresholding_cols=c("total_signal", 
                                                 "qValue",
                                                 "Peak Score"),
                             initial_threshold=0.5,
                             max_threshold=1,
                             increment_threshold=0.05,
                             workers=1){
    requireNamespace("BiocParallel")
    threshold_list <- seq(from=initial_threshold, 
                          to=max_threshold, 
                          by=increment_threshold)
    names(threshold_list) <- threshold_list 
    BPPARAM <- get_bpparam(workers = workers)
    overlap <- BiocParallel::bpmapply(threshold_list,
                                      BPPARAM = BPPARAM,
                                      SIMPLIFY = FALSE,
                                      FUN = function(thresh){
      message_parallel("Threshold=",thresh,": Filtering peaks")
      peakfiles_filt <- mapply(peakfiles, 
                              FUN=function(gr){
                                  ## Compute percentiles
                                  gr <- compute_percentiles(
                                      gr = gr, 
                                      thresholding_cols = thresholding_cols,
                                      initial_threshold = initial_threshold
                                  )
                                  ## Filter 
                                  gr <- filter_percentiles(
                                      gr = gr, 
                                      thresh = thresh, 
                                      thresholding_cols = thresholding_cols)
                                  return(gr)
                              })  
      df <- overlap_percent(peaklist1 = peakfiles_filt, 
                              peaklist2 = reference, 
                              suppress_messages = FALSE,
                              precision_recall = TRUE)
      return(df)
    }) |> data.table:::rbindlist(use.names = TRUE, idcol = "threshold")
    return(overlap)
}