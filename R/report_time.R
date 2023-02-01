report_time <- function(t1, 
                        func=NULL,
                        verbose=TRUE){
    messager(if(!is.null(func))paste0(func,"():"),
             "Done in",
             paste0(round(difftime(Sys.time(),t1,units = "s"),1),"s."),
             v=verbose)
}