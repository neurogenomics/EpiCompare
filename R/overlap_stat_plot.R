#' Statistical significance of overlapping peaks
#'
#' This function calculates the statistical significance of overlapping/
#' non-overlapping peaks against a reference peak file.If the reference peak
#' file has the BED6+4 format (peak called by MACS2), the function generates a
#' series of boxplots showing the distribution of q-values for sample peaks that
#' are overlapping and non-overlapping with the reference. If the reference peak
#' file does not have the BED6+4 format, the function uses `enrichPeakOverlap()`
#' from `ChIPseeker` package to calculate the statistical significance of
#' overlapping peaks only. In this case, please provide an annotation file as
#' TxDb object.
#'
#' @param reference A reference peak file as GRanges object.
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor. This is
#' required only if the reference file does not have BED6+4 format.
#'
#' @return A boxplot or barplot showing the statistical significance of
#' overlapping/non-overlapping peaks.
#'
#' @importMethodsFrom IRanges subsetByOverlaps
#' @import GenomicRanges
#' @importFrom stats quantile
#' @importFrom ChIPseeker enrichPeakOverlap
#' @importMethodsFrom S4Vectors elementMetadata
#' @import ggplot2
#'
#' @export
#' @examples
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#' reference_peak <- list("ENCODE"=encode_H3K27ac)
#'
#' out <- overlap_stat_plot(reference = reference_peak,
#'                          peaklist = peaks)
#' stat_plot <- out[[1]] # plot
#' stat_df <- out[[2]] # df
#'
overlap_stat_plot <- function(reference, peaklist, annotation=NULL){
  # define variables
  qvalue <- NULL
  tSample <- NULL
  p.adjust <- NULL
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # check if the file has BED6+4 format
  if(ncol(S4Vectors::elementMetadata(reference[[1]])) == 7 |
     ncol(S4Vectors::elementMetadata(reference[[1]])) == 6){
    main_df <- NULL
    # for each peakfile, obtain overlapping and unique peaks
    for (i in seq_len(length(peaklist))){
      # reference peaks found in sample peaks
      overlap <- IRanges::subsetByOverlaps(x = reference[[1]],
                                           ranges = peaklist[[i]])
      # reset names of metadata
      n <- 4
      my_label <- NULL
      for (l in seq_len(ncol(S4Vectors::elementMetadata(overlap)))){
        label <- paste0("V",n)
        my_label <- c(my_label, label)
        n <- n + 1
      }
      colnames(mcols(overlap)) <- my_label

      # reference peaks not found in sample peaks
      unique <- IRanges::subsetByOverlaps(x = reference[[1]],
                                          ranges = peaklist[[i]], invert = TRUE)
      # reset names of metadata
      n <- 4
      my_label <- NULL
      for (l in seq_len(ncol(S4Vectors::elementMetadata(unique)))){
        label <- paste0("V",n)
        my_label <- c(my_label, label)
        n <- n + 1
      }
      colnames(GenomicRanges::mcols(unique)) <- my_label
      # if no overlap, set q-value as 0 to avoid error
      # else, obtain q-value from field V9
      overlap_qvalue <- overlap$V9
      if (length(overlap) == 0){
        overlap_qvalue <- 0
      }
      # create data frame of q-values for overlapping peaks
      sample <- names(peaklist)[i]
      group <- "overlap"
      overlap_df <- data.frame(overlap_qvalue, sample, group)
      colnames(overlap_df) <- c("qvalue", "sample", "group")
      #
      unique_qvalue <- unique$V9
      if(length(unique) == 0){
        unique_qvalue <- 0
      }
      # create data frame of q-values for unique peaks
      group <- "unique"
      unique_df <- data.frame(unique_qvalue, sample, group)
      colnames(unique_df) <- c("qvalue", "sample", "group")
      # combine two data frames
      sample_df <- rbind(overlap_df, unique_df)
      main_df <- rbind(main_df, sample_df)
    }
    # find value at 95th percentile
    max_val <- stats::quantile(main_df$qvalue, 0.95)
    # remove values greater than 95th quantile
    main_df <- main_df[main_df$qvalue<max_val,]

    # create paired boxplot for each peak file (sample)
    sample_plot <- ggplot2::ggplot(main_df,
                                   ggplot2::aes(x=sample,
                                                y=qvalue,
                                                fill=group)) +
                   ggplot2::geom_boxplot(outlier.shape = NA) +
                   ggplot2::theme_light() +
                   ggplot2::labs(x="",y="-log10(q)",fill="") +
                   ggplot2::theme(axis.text.x =ggplot2::element_text(angle = 270,
                                                                     vjust = 0,
                                                                     hjust=0)) +
                   ggplot2::coord_flip()

    return(list(sample_plot, main_df))
    # for files not in BED6+4 format
    }else{
      # calculate significance of overlapping peaks using enrichPeakOverlap()
      txdb <- annotation
      overlap_result <- ChIPseeker::enrichPeakOverlap(queryPeak = reference[[1]],
                                                      targetPeak = peaklist,
                                                      TxDb = txdb,
                                                      nShuffle = 50,
                                                      pAdjustMethod = "BH",
                                                      chainFile =NULL,
                                                      verbose = FALSE)
      overlap_result$tSample <- names(peaklist) # set names with sample names
      percent_overlap <- c()
      # for each peakfile, calculate percentage overlap
      for (i in seq_len(nrow(overlap_result))){
        percent <- overlap_result[i,5]/overlap_result[i,3]*100
        percent_overlap <- c(percent_overlap, percent)
      }
      # add percentage overlap to a column
      overlap_result$percent_overlap <- percent_overlap
      # create bar plot showing percentage overlap
      # and statistical significance of overlapping peaks
      plot <- ggplot2::ggplot(data=overlap_result,
                              ggplot2::aes(x=tSample,
                                           y=percent_overlap,
                                           fill=p.adjust)) +
              ggplot2::geom_bar(stat="identity") +
              ggplot2::scale_fill_continuous(type="viridis") +
              ggplot2::theme_light() +
              ggplot2::labs(x="",y="Percentage overlap (%)") +
              ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                                 vjust = 1,
                                                                 hjust=1)) +
              ggplot2::ylim(0,100)
    # return both plot and data frame
    return(list(plot, overlap_result))
  }
}
