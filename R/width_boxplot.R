width_boxplot <- function(peaklist, namelist){
  df <- NULL
  for (i in 1:length(peaklist)){

    sample <- namelist[i]
    width <- GenomicRanges::width(peaklist[[i]])
    width_df <- data.frame(sample, width)
    df <- rbind(df, width_df)
  }

  ggplot2::ggplot(df, ggplot2::aes(x = sample, y = width)) + ggplot2::geom_boxplot(outlier.shape = NA) + ggplot2::scale_y_continuous(trans="log10") + ggplot2::labs(x="",y="width (bp)") + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))
}
