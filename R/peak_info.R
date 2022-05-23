#' Summary of Peak Information
#'
#' This function outputs a table summarizing information on the peak files.
#' Provides the total number of peaks and the percentage of peaks in blacklisted
#'  regions.
#'
#' @param peaklist A named list of peak files as GRanges object.
#' Objects listed using \code{list("name1" = peak, "name2" = peak2)}.
#' @param blacklist A GRanges object containing blacklisted regions.
#'
#' @return A summary table of peak information
#'
#' @importMethodsFrom IRanges subsetByOverlaps
#' @importFrom BRGenomics tidyChromosomes
#' @export
#'
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("hg19_blacklist") # example blacklist GRanges object
#'
#' ### Named Peaklist ###
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac)
#'
#' ### Run ###
#' df <- peak_info(peaklist = peaklist,
#'                 blacklist = hg19_blacklist)
#'
peak_info <- function(peaklist, blacklist){
  message("--- Running peak_info() ---")
  ### Check peaklist names ###
  peaklist <- check_list_names(peaklist)

  ### Obtain Peak Number Before Standardisation ###
  peakN_before_tidy <- mapply(peaklist, FUN=function(file){
    length(file)
  })

  ### Obtain Blacklisted Region Percentage ###
  blacklist_percent <- mapply(peaklist, FUN=function(file){
    options(warn = -1) # silence warning for subsetByOverlaps
    blacklistN <- length(IRanges::subsetByOverlaps(file, blacklist))
    options(warn = 0) # turn warning back on
    blacklistP <- signif(blacklistN/length(file)*100, 3)
  })

  ### Obtain Non-standard Chromosome Percentage ###
  tidy_percent <- mapply(peaklist, FUN=function(file){
    peak_tidy <- BRGenomics::tidyChromosomes(file, keep.X = TRUE, keep.Y = TRUE)
    removedN <- length(file) - length(peak_tidy)
    percentage <- signif(removedN/length(file)*100, 3)
  })

  ### Standardize Peaklist ###
  peaklist_tidy <- tidy_peakfile(peaklist = peaklist,
                                 blacklist = blacklist)

  ### Obtain Peak Number After Standardisation ###
  peakN_after_tidy <- mapply(peaklist_tidy, FUN=function(file){
    length(file)
  })

  ### Create Data Frame ###
  df <- data.frame(peakN_before_tidy,
                   blacklist_percent,
                   tidy_percent,
                   peakN_after_tidy)

  colnames(df) <- c("PeakN Before Tidy",
                    "Blacklisted Peaks Removed (%)",
                    "Non-standard Peaks Removed (%)",
                    "PeakN After Tidy")
  message("Done.")
  return(df)
}
