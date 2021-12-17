#' Summary of Peak Information
#'
#' This function outputs a table summarizing information on the peak files.
#'
#' @param peak_list A list of peak files as GRanges object. Objects in lists using `list()`.
#' @param file_names A list of file names in the correct order of peak_list. Names in list using `c()`.
#' @param blacklist A GRanges object containing blacklisted regions.
#'
#' @return A summary table of peak information
#' @export
#'
#' @examples
peak_info <- function(peak_list, file_names, blacklist){

  totalN <- c()
  for (sample in peak_list){
    N <- length(sample)
    totalN <- c(totalN, N)
  }

  blacklist_percent <- c()
  for (sample in peak_list){
    blacklistN <- length(IRanges::subsetByOverlaps(sample, blacklist))
    blacklistP <- blacklistN/length(sample)*100
    blacklist_percent <- c(blacklist_percent, signif(blacklistP, 3))
  }

  df <- data.frame(file_names, totalN, blacklist_percent)
  knitr::kable(df)
}
