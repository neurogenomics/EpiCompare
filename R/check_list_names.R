#' Check peaklist is named
#'
#' This function checks whether the peaklist is named.
#' If not, default file names are assigned.
#'
#' @param peaklist A list of peak files as GRanges object.
#' @keywords internal
#' @export
check_list_names <- function(peaklist){
  # check that peaklist is named
  # if not, default file names are used
  if(is.null(names(peaklist))){
    default_name <- c()
    for(i in 1:length(peaklist)){
      name <- paste0("sample", i)
      default_name <- c(default_name, name)
    }
    names(peaklist) <- default_name
  }
  # check for any missing names
  for(i in 1:length(peaklist)){
    if(is.na(names(peaklist)[i])){
      names(peaklist)[i] <- paste0("sample", i)
    }
  }
  return(peaklist)
}

