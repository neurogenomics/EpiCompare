#' Validate input parameters
#'
#' @return No return
#' @import methods
#' @keywords internal
validate_parameters <- function(peaklist, namelist, reference, stat_plot){
  # check that outpath exists


  # Check that peakfiles are in lists
  if(!methods::is(peaklist, "list")){
    stop("peak files must be listed using list()")
  }
  # Check number of peakfiles and number of names is same
  if(length(peaklist) != length(namelist)){
    msg <- paste0("number of peak files and names do not match")
    stop(msg)
  }
  # check all peak files are in GRanges
  for(file in peaklist){
    if(!methods::is(file,"GRanges")){
      stop("peak files must be GRanges object")
    }
  }
  # check reference file is GRanges
  if(!is.null(reference)){
    if(!methods::is(reference,"GRanges")){
      stop("reference peak file must be GRanges object")
    }
  }
  # check that if stat_plot = TRUE, reference is given
  if(stat_plot){
    if(is.null(reference)){
      stop("stat_plot=TRUE, please provide reference")
    }
  }
}



