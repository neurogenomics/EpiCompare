check_unused_args <- function(upset_plot,
                              stat_plot,
                              chromHMM_plot,
                              chipseeker_plot,
                              enrichment_plot,
                              tss_plot,
                              precision_recall_plot,
                              corr_plot,
                              verbose=TRUE){
  #### Check which arguments are boolean ####
  # boolean_args <- names(formals(EpiCompare::EpiCompare))[
  #   sapply(formals(EpiCompare), is.logical)
  # ]
  if(isTRUE(verbose)){
    bool_args <- c(upset_plot=upset_plot, 
                   stat_plot=stat_plot, 
                   chromHMM_plot=chromHMM_plot, 
                   chipseeker_plot=chipseeker_plot, 
                   enrichment_plot=enrichment_plot, 
                   tss_plot=tss_plot, 
                   precision_recall_plot=precision_recall_plot, 
                   corr_plot=corr_plot) 
    args_not_used <- names(bool_args)[bool_args==FALSE]
    messager("NOTE: The following EpiCompare features are NOT being used:",
             paste0("\n - ",args_not_used,"=",collapse = ""))
  } 
}