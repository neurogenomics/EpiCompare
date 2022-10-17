save_results <- function(dat,
                         save_path,
                         type=NULL,
                         verbose=TRUE,
                         ...){
    if(!is.null(save_path)){
        dir.create(dirname(save_path), showWarnings = FALSE, recursive = TRUE)
        messager("Saving",type,"results ==>",save_path,v=verbose)
        data.table::fwrite(x = dat, 
                           file = save_path,
                           ...)
    }
    return(save_path)
}
