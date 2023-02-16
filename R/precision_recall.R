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
#' @param n_threshold Number of thresholds to test. 
#' @param cast Cast the data into a format that's more compatible with 
#' \pkg{ggplot2}.
#' @param save_path File path to save precision-recall results to.
#' @param verbose Print messages.
#' @inheritParams EpiCompare
#' @inheritParams get_bpparam
#' @inheritParams check_workers
#' @inheritDotParams bpplapply
#' @return Overlap
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
#'                           reference = reference,
#'                           workers = 1)
precision_recall <- function(peakfiles,
                             reference,
                             thresholding_cols=c("total_signal", 
                                                 "qValue",
                                                 "Peak Score"),
                             initial_threshold=0,
                             n_threshold=20,
                             max_threshold=1,
                             cast=TRUE,
                             workers=1,
                             verbose=TRUE,
                             save_path=
                                 tempfile(fileext = "precision_recall.csv"),
                             ...){ 
    
    precision <- recall <- F1 <- NULL; 
    
    threshold_list <- seq(from=initial_threshold, 
                          to=1-(max_threshold/n_threshold), 
                          length.out=n_threshold)
    names(threshold_list) <- threshold_list 
    #### Check which have necessary columns #####
    peakfiles <- check_grlist_cols(grlist = peakfiles, 
                                   target_cols = thresholding_cols)
    ##### Iterate over peakfiles ##### 
    pr_df <- bpplapply(X = threshold_list,
                         workers = workers,
                         FUN = function(thresh){
      if(verbose) message_parallel("Threshold=",thresh,": Filtering peaks")
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
    }, ...) |> data.table::rbindlist(use.names = TRUE, idcol = "threshold")
    #### Recast data ###
    if(isTRUE(cast)){ 
        #### Post-process data ####
        messager("Reformatting precision-recall data.")
        pr_df <- data.table::dcast(
            data = pr_df,
            formula = "peaklist1 + peaklist2 + threshold ~ type", 
            fun.aggregate = mean,
            value.var = c("Percentage","overlap","total")) 
        data.table::setnames(pr_df,
                             c("Percentage_precision","Percentage_recall"), 
                             c("precision","recall"))
        pr_df$threshold <- as.numeric(pr_df$threshold) 
        #### Compute F1 ##### 
        pr_df[,F1:=(2*(precision*recall) / (precision+recall))] 
        pr_df[is.na(F1),]$F1 <- 0
    }
    #### Save ####
    save_path <- save_results(dat = pr_df, 
                              save_path = save_path, 
                              type = "precision-recall")
    #### Return ####
    return(pr_df)
}
