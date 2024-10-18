#' Tidy peakfiles in GRanges
#'
#' This function filters peak files by removing peaks in blacklisted regions
#' and in non-standard chromosomes. It also checks that the input list of
#' peakfiles is named. If no names are provided, default file names will be
#' used.
#'
#' @param peaklist A named list of peak files as GRanges object.
#' Objects must be named and listed using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}
#' If not named, default names are assigned.
#' @param blacklist Peakfile specifying blacklisted regions as GRanges object.
#'
#' @return list of GRanges object
#' @export
#'
#' @importMethodsFrom IRanges subsetByOverlaps
#'
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("hg19_blacklist") # blacklist region for hg19 genome
#'
#' ### Create Named Peaklist ###
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)
#'
#' ### Run ###
#' peaklist_tidy <- tidy_peakfile(peaklist = peaklist,
#'                                blacklist = hg19_blacklist)
#'
tidy_peakfile <- function(peaklist, blacklist){
  ### check peaklist names ###
  peaklist <- check_list_names(peaklist)
  ### standardise peakfiles ###
  peaklist_tidy <- mapply(peaklist, FUN = function(file){
    # remove non-standard chromosomes
    sample <- tidy_chromosomes(file, keep.X = TRUE, keep.Y = TRUE)
    # remove blacklisted regions
    IRanges::subsetByOverlaps(sample,
                              blacklist,
                              invert = TRUE)
  })
  return(peaklist_tidy)
}

