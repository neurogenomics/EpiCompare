#' Tidy peakfiles in GRanges
#'
#' @param peaklist A list of peak files as GRanges object. If more than one, objects in lists using `list()`.
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
#' tidy_peakfile(peaklist = list(encode_H3K27ac, CnT_H3K27ac),
#'                      blacklist = hg19_blacklist)
#'
tidy_peakfile <- function(peaklist, blacklist){
  # for each peakfile, remove peaks in blacklisted region
  # and remove non-standard and mitochondrial chromosomes
  # if there are more than one peakfiles, run through loop and output list
  if(is.list(peaklist)){
    peaklist_tidy <- list()
    for(sample in peaklist){
      blacklist_removed <- IRanges::subsetByOverlaps(sample, blacklist, invert = TRUE)
      blacklist_removed_tidy <- BRGenomics::tidyChromosomes(blacklist_removed, keep.X = TRUE, keep.Y = TRUE)
      peaklist_tidy <- c(peaklist_tidy, blacklist_removed_tidy)
    }
    return(peaklist_tidy)
  }else{
    # if only one file, tidy and output one file
    blacklist_removed <- IRanges::subsetByOverlaps(peaklist, blacklist, invert = TRUE)
    peaklist_tidy <- BRGenomics::tidyChromosomes(blacklist_removed, keep.X = TRUE, keep.Y = TRUE)
    return(peaklist_tidy)
  }
}

