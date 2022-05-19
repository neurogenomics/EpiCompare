#' Check peaklist is named
#'
#' This function checks whether the peaklist is named. 
#' If not, default file names are assigned.
#'
#' @param peaklist A list of peak files as GRanges object.
#' @param default_prefix Default prefix to use when creating names
#'  for \code{peaklist}. 
#' @return named peaklist
#' @keywords internal
check_list_names <- function(peaklist, 
                             default_prefix="sample"){
  # check that peaklist is named
  # if not, default file names are used
  if(is.null(names(peaklist))){
      names(peaklist) <- paste0(default_prefix, seq_len(length(peaklist))) 
  }
    # check for any missing names
  for(i in seq_len(length(peaklist))){
    if(is.na(names(peaklist)[i])){
      names(peaklist)[i] <- paste0(default_prefix, i)
    }
  }
    ####  Check for duplicate names ####
    dup_names <- names(peaklist)[duplicated(names(peaklist))]
    if(length(dup_names)>0){
        message(paste(length(dup_names),"duplicated peaklist names found.",
                      "Forcing unique names with make.unique()."))
        names(peaklist) <- make.unique(names(peaklist))
    } 
  return(peaklist)
}
