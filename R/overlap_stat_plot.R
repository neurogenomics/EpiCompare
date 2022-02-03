#' Statistical significance of overlapping peaks
#'
#' This function calculates the statistical significance of overlapping/non-overlapping peaks against a reference peak file.
#' If the reference peak file has the BED6+4 format (peak called by MACS2), the function generates a series of boxplots showing
#' the distribution of q-values for overlapping and non-overlapping peaks for each sample.
#' If the reference peak file does not have the BED6+4 format, the function uses `enrichPeakOverlap()` from ChIPseeker package
#' to calculate the statistical significance of overlapping peaks only.
#'
#' @param reference A reference peak file as GRanges object.
#' @param peaklist A list of peak files as GRanges object. Objects in lists using `list()`.
#' @param namelist A list of file names in the correct order of peak_list. Names in list using `c()`.
#'
#' @return
#' A boxplot or barplot showing the statistical significance of overlapping/non-overlapping peaks.
#'
#' @export
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' overlap_stat_plot(reference = encode_H3K27ac,
#'                   peaklist = list(CnT_H3K27ac, CnR_H3K27ac),
#'                   namelist = c("CnT","CnR"))
#'
overlap_stat_plot <- function(reference, peaklist, namelist){
  ## check if the file has BED6+4 format
  if(ncol(reference@elementMetadata) == 7){
    df <- NULL
    # for each peakfile, obtain overlapping and unique peaks
    for (i in 1:length(peaklist)){
      overlap <- IRanges::subsetByOverlaps(x = reference, ranges = peaklist[[i]])
      unique <- IRanges::subsetByOverlaps(x = reference, ranges = peaklist[[i]], invert = TRUE)
      # if no overlap, set q-value as 0 to avoid error
      # else, obtain q-value from V9 column
      if (length(overlap) == 0){
        qvalue <- 0
      }else{
        qvalue <- overlap$V9}
      # create data frame of q-values for overlapping peaks
      sample <- namelist[[i]]
      group <- "overlap"
      overlap_df <- data.frame(qvalue, sample, group)
      # if no unique peaks, set q-value as 0 to avoid error
      # else, obtain 1-values from V9 column
      if (length(unique) == 0){
        qvalue <- 0
      }else{
        qvalue <- unique$V9}
      # create data frame of q-values for unique peaks
      sample <- namelist[[i]]
      group <- "unique"
      unique_df <- data.frame(qvalue, sample, group)
      # combine two data frames
      overlap_unique_df <- rbind(overlap_df, unique_df)
      df <- rbind(df, overlap_unique_df)
    }
    # create paired boxplot for each peak file
    plot <- ggplot2::ggplot(df, ggplot2::aes(x=sample, y=qvalue, fill=group)) +
            ggplot2::geom_boxplot(outlier.shape = NA) +
            ggplot2::theme_light() + ggplot2::ylim(0, 500) +
            ggplot2::labs(x="",y="-log10(q)",fill="") +
            ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))

    return(list(plot, df))
    # for files not in BED6+4 format
    }else{
      # calculate significance of overlapping peaks using enrichPeakOverlap()
      txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
      overlap_result <- ChIPseeker::enrichPeakOverlap(queryPeak = reference, targetPeak = peaklist, TxDb = txdb, nShuffle = 50, pAdjustMethod = "BH", chainFile =NULL, verbose = FALSE)
      overlap_result$tSample <- namelist # set names with sample names
      percent_overlap <- c()
      # for each peakfile, calculate percentage overlap
      for (i in 1:nrow(overlap_result)){
        percent <- overlap_result[i,5]/overlap_result[i,3]*100
        percent_overlap <- c(percent_overlap, percent)
      }
      # add percentage overlap to a column
      overlap_result$percent_overlap <- percent_overlap
      # create bar plot showing percentage overlap and statistical significance of overlapping peaks
      plot <- ggplot2::ggplot(data=overlap_result, ggplot2::aes(x=tSample,y=percent_overlap,fill=p.adjust)) +
              ggplot2::geom_bar(stat="identity") + ggplot2::scale_fill_continuous(type="viridis") +
              ggplot2::theme_light() + ggplot2::labs(x="",y="Percentage overlap (%)") +
              ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))
    # return both plot and data frame
    return(list(plot, overlap_result))
  }
}
