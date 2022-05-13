#' Check peaklist is named
#'
#' This function checks whether the peaklist is named. If not, default file
#' names are assigned.
#'
#' @param peaklist A list of peak files as GRanges object.
#' @return named peaklist
#' @keywords internal
check_list_names <- function(peaklist){
  # check that peaklist is named
  # if not, default file names are used
  if(is.null(names(peaklist))){
      names(peaklist) <- paste0("sample", seq_len(length(peaklist))) 
  }
    # check for any missing names
  for(i in seq_len(length(peaklist))){
    if(is.na(names(peaklist)[i])){
      names(peaklist)[i] <- paste0("sample", i)
    }
  }
  return(peaklist)
}

