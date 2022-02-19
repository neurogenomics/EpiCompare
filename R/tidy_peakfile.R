#' Tidy peakfiles in GRanges
#'
#' This function filters peak files by removing peaks in blacklisted regions
#' and in non-standard chromosomes. It also checks that the input list of peakfiles
#' is named. If no names are provided, default file names will be used.
#'
#' @param peaklist A named list of peak files as GRanges object.
#' Objects listed using `list()` and named using `names()`.
#' If not named, default file names are assigned.
#' @param blacklist Peakfile specifying blacklisted regions as GRanges object.
#'
#' @return list of GRanges object
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("hg19_blacklist") # blacklist region for hg19 genome
#'
#' peaklist <- list(encode_H3K27ac, CnT_H3K27ac) # list two peakfiles
#' names(peaklist) <- c("encode", "CnT") # set names
#'
#' tidy_peakfile(peaklist = peaklist,
#'               blacklist = hg19_blacklist)
#'
tidy_peakfile <- function(peaklist, blacklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  # for each peakfile, remove peaks in blacklisted region
  # and remove non-standard and mitochondrial chromosomes
  # if there are more than one peakfiles, run through loop and output list
  if(is.list(peaklist)){
    peaklist_tidy <- list()
    for(sample in peaklist){
      tidy_peak <- BRGenomics::tidyChromosomes(sample, keep.X = TRUE, keep.Y = TRUE) # remove non-standard chromosomes
      blacklist_removed <- IRanges::subsetByOverlaps(tidy_peak, blacklist, invert = TRUE) # remove blacklisted peaks
      peaklist_tidy <- c(peaklist_tidy, blacklist_removed)
    }
    names(peaklist_tidy) <- names(peaklist)
    return(peaklist_tidy)
  }else{
    # if only one file, tidy and output one file
    tidy_peak <- BRGenomics::tidyChromosomes(peaklist, keep.X = TRUE, keep.Y = TRUE)
    peaklist_tidy<- IRanges::subsetByOverlaps(tidy_peak, blacklist, invert = TRUE)
    names(peaklist_tidy)[1] <- names(peaklist)[1]
    return(peaklist_tidy)
  }
}

