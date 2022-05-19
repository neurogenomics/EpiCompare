#' Prepare peaklist as GRanges
#'
#' @param peaklist A named list of peaks as \link[GenomicRanges]{GRanges}
#'  or paths to BED files.
#' @param remove_empty Remove any empty elements in the list.
#' @param as_grangeslist Convert output to class
#'  \link[GenomicRanges]{GRangesList} before returning.
#'
#' @return A list of \link[GenomicRanges]{GRanges} objects
#'
#' @keywords internal
#' @importFrom methods is
#' @importFrom ChIPseeker readPeakFile
#' @importFrom GenomicRanges GRangesList
prepare_peaklist <- function(peaklist,
                             remove_empty=TRUE,
                             as_grangeslist=FALSE){
    message("Preparing peaklist.")
    # check that peaklist is named, if not, default names assigned
    if(methods::is(peaklist,"GRangesList")){
        peaklist <- as.list(peaklist)
    }
    if(!methods::is(peaklist,"list")){
        peaklist <- list(peaklist)
    }
    peaklist <- check_list_names(peaklist = peaklist,
                                 default_prefix = "sample")
    #### Remove empty elements ####
    if(remove_empty){
        peaklist <- remove_empty_elements(peaklist = peaklist)
    }
    #### Import files if necessary
    ## if path is provided, create GRanges object
    peaklist <- mapply(peaklist, FUN=function(x){
      if(!methods::is(x,"GRanges")){
          x <- ChIPseeker::readPeakFile(x, as = "GRanges")
      }
      x <- clean_granges(gr = x)
      return(x)
  })

  # create GRangeList from GRanges objects
    if(as_grangeslist){
        peaklist <- GenomicRanges::GRangesList(peaklist,
                                               compress = FALSE)
    }
  if(length(peaklist)==0) stop("peaklist must have a length>0.")
  return(peaklist)
}





