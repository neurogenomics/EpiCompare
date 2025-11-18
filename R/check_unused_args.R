check_unused_args <- function(peak_score_plot,
                              upset_plot,
                              stat_plot,
                              chromHMM_plot,
                              chipseeker_plot,
                              enrichment_plot,
                              tss_plot,
                              precision_recall_plot,
                              corr_plot,
                              add_download_button,
                              verbose=TRUE){
  #### Check which arguments are boolean ####
  # boolean_args <- names(formals(EpiCompare::EpiCompare))[
  #   sapply(formals(EpiCompare), is.logical)
  # ]
  if(isTRUE(verbose)){
    bool_args <- c(peak_score_plot=peak_score_plot,
                   upset_plot=upset_plot, 
                   stat_plot=stat_plot, 
                   chromHMM_plot=chromHMM_plot, 
                   chipseeker_plot=chipseeker_plot, 
                   enrichment_plot=enrichment_plot, 
                   tss_plot=tss_plot, 
                   precision_recall_plot=precision_recall_plot, 
                   corr_plot=corr_plot,
                   add_download_button=add_download_button) 
    args_not_used <- names(bool_args)[bool_args==FALSE]
    if(length(args_not_used)>0){
      messager("NOTE: The following EpiCompare features are NOT being used:",
               paste0("\n - ",args_not_used,"=",collapse = ""),
               v=verbose) 
    } else{
      messager("All EpiCompare features are being used.",v=verbose)
    }
  } 
}