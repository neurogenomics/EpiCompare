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

  Total_N <- c()
  for (sample in peak_list){
    N <- length(sample)
    Total_N <- c(Total_N, N)
  }

  blacklist_percent <- c()
  for (sample in peak_list){
    blacklistN <- length(IRanges::subsetByOverlaps(sample, blacklist))
    blacklistP <- blacklistN/length(sample)*100
    blacklist_percent <- c(blacklist_percent, signif(blacklistP, 3))
  }

  df <- data.frame(file_names, Total_N, blacklist_percent)
  colnames(df) <- c("Sample", "Total_N", "Blacklisted_Peaks (%)")
  return(df)
}
