#' Check cell lines
#' 
#' Check whether a list of cell lines matches any of those that are made
#' available through \code{EpiCompare}.
#' 
#' @param cell_lines A character vector of cell line names.
#' If \code{NULL} (default), will return names of all cell lines.
#' @param verbose Print messages.
#' @keywords internal
#' @returns Character vector, or NULL.
check_cell_lines <- function(cell_lines=NULL,
                             verbose=TRUE){
    opts <- c("K562",
      "Gm12878",
      "H1hesc",
      "Hepg2",
      "Hmec",
      "Hsmm",
      "Huvec",
      "Nhek",
      "Nhlf"
    )
    if(is.null(cell_lines)){
        ## Return all options
        return(opts)
    } else{
        ## return only matching options
        cl_match <- opts[tolower(opts) %in% tolower(cell_lines)]
        if(length(cl_match)>0){
            msg <- paste("Returning",length(cl_match),"matching cell line(s).")
            if(verbose) message(msg)
            return(cl_match)
        }else {
            smsg <- paste("cell_lines did not match any available options.",
                         "Must be one of:",
                         paste("\n -",paste0("'",opts,"'"),collapse = ""))
            if(verbose) message(smsg)
            return(NULL)
        }
    }
}
