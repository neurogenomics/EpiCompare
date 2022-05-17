#' Prepare peaklist as GRanges
#'
#' @param peaklist A named list of peaks as \link[GenomicRanges]{GRanges}
#'  or paths to BED files.
#'
#' @return A list of \link[GenomicRanges]{GRanges} objects
#'
#' @keywords internal
#' @importFrom methods is
#' @importFrom ChIPseeker readPeakFile
prepare_peaklist <- function(peaklist){
    message("Preparing peaklist.")
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  peaklist_checked <- list() # empty list
  for(file in peaklist){
    # if path is provided, create GRangees onject
    if(!methods::is(file,"GRanges")){
      peak <- ChIPseeker::readPeakFile(file, as = "GRanges")
      peaklist_checked <- c(peaklist_checked, peak)
    }else{
      peaklist_checked <- c(peaklist_checked, file)
    }
  }
  names(peaklist_checked) <- names(peaklist) # set names
  if(length(peaklist)==0) stop("peaklist must have a length>0.")
  return(peaklist_checked)
}





