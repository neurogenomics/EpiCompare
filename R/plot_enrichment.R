#' Generate enrichment analysis plots
#'
#' This function runs KEGG and GO enrichment analysis of peak files
#' and generates dot plots.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
#' If not named, default file names will be assigned.
#'
#' @return KEGG and GO dot plots
#' @export
#'
plot_enrichment <- function(peaklist){
  # check that peaklist is named, if not, default names assigned
  peaklist <- EpiCompare::check_list_names(peaklist)
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene # annotation for hg19 genome
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = c(-3000, 3000),
                           verbose = FALSE)
  genes <- lapply(peak_annotated, function(i) as.data.frame(i)$geneId)
  # KEGG
  compKEGG <- clusterProfiler::compareCluster(geneCluster = genes,
                                              fun = "enrichKEGG",
                                              pvalueCutoff = 0.05,
                                              pAdjustMethod = "BH")
  # adjust font size
  font_size <- 11
  if(length(peaklist) > 6){
    font_size <- 8
  }
  kegg_plot <- clusterProfiler::dotplot(compKEGG) +
               ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1, size = font_size))
  sample_names <- gsub('\n([0-9]*)','',kegg_plot$data$Cluster) # remove new line
  kegg_plot$data$Cluster <- sample_names

  #GO
  requireNamespace("org.Hs.eg.db")
  compGO <- clusterProfiler::compareCluster(geneCluster = genes,
                                           OrgDb = "org.Hs.eg.db",
                                           fun = "enrichGO",
                                           pvalueCutoff = 0.05,
                                           pAdjustMethod = "BH")
  go_plot <- clusterProfiler::dotplot(compGO) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1, size = font_size))
  sample_names <- gsub('\n([0-9]*)','',go_plot$data$Cluster) # remove new line
  go_plot$data$Cluster <- sample_names
  return(list(kegg_plot, go_plot))
}

