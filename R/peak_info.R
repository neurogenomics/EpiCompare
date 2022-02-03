#' Summary of Peak Information
#'
#' This function outputs a table summarizing information on the peak files.
#' Provides the total number of peaks and the percentage of peaks in blacklisted regions.
#'
#' @param peak_list A list of peak files as GRanges object. Objects in lists using `list()`.
#' @param file_names A list of file names in the correct order of peak_list. Names in list using `c()`.
#' @param blacklist A GRanges object containing blacklisted regions.
#'
#' @return A summary table of peak information
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("hg19_blacklist") # example blacklist dataset as GRanges object
#'
#' peak_info(peak_list = list(encode_H3K27ac, CnT_H3K27ac),
#'           file_names = c("ENCODE", "CnT"),
#'           blacklist = hg19_blacklist)
#'
peak_info <- function(peak_list, file_names, blacklist){
  # for each peakfile retrieve the number of peaks and store in list
  peakN_before_tidy <- c()
  for (sample in peak_list){
    N <- length(sample)
    peakN_before_tidy <- c(peakN_before_tidy, N)
  }
  # for each peakfile calculate the percentage of overlapping peaks with
  # blacklisted region
  blacklist_percent <- c()
  for (sample in peak_list){
    blacklistN <- length(IRanges::subsetByOverlaps(sample, blacklist))
    blacklistP <- blacklistN/length(sample)*100
    blacklist_percent <- c(blacklist_percent, signif(blacklistP, 3))
  }
  # for each peakfile calculate percentage of non-standard and mitochondrial chromosome
  tidy_percent <- c()
  for (sample in peak_list){
    tidy_peak <- BRGenomics::tidyChromosomes(sample, keep.X = TRUE, keep.Y = TRUE)
    removedN <- length(sample) - length(tidy_peak)
    tidy_peak_percent <- removedN/length(sample)*100
    tidy_percent <- c(tidy_percent, signif(tidy_peak_percent, 3))
  }
  # remove blacklisted regions and non-standard chromosomes
  peaklist_tidy <- tidy_peakfile(peaklist = peak_list,
                                 blacklist = blacklist)

  # after tidying, retrieve the number of peaks and store in list
  peakN_after_tidy <- c()
  for (sample in peaklist_tidy){
    N <- length(sample)
    peakN_after_tidy <- c(peakN_after_tidy, N)
  }

  # combine two metrics into a data frame
  df <- data.frame(file_names, peakN_before_tidy, blacklist_percent, tidy_percent, peakN_after_tidy)
  colnames(df) <- c("Sample", "PeakN before tidy", "Blacklisted peaks removed (%)", "Non-standard peaks removed (%)", "PeakN after tidy")
  return(df)
}
