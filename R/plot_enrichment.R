#' Generate enrichment analysis plots
#'
#' This function runs KEGG and GO enrichment analysis of peak files
#' and generates dot plots.
#'
#' @param peaklist A list of peak files as GRanges object. Files must be listed using `list()`
#' @param namelist A list of file names in the same order as the list of peak files. Use `c()` for multiple.
#'
#' @return KEGG and GO dot plots
#' @export
#'
plot_enrichment <- function(peaklist, namelist){
  peaklist_named <- stats::setNames(peaklist, namelist) # set names
  txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene # annotation for hg19 genome
  peak_annotated <- lapply(peaklist_named,
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
  kegg_plot <- clusterProfiler::dotplot(compKEGG) + ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1))
  #GO
  names(genes) = sub("_", "\n", names(genes))
  compGO = clusterProfiler::compareCluster(geneCluster = genes,
                                           OrgDb = "org.Hs.eg.db",
                                           fun = "enrichGO",
                                           pvalueCutoff = 0.05,
                                           pAdjustMethod = "BH")
  go_plot <- clusterProfiler::dotplot(compGO) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, vjust = 1, hjust=1), axis.text.y = ggplot2::element_text(size = 7))
  return(list(kegg_plot, go_plot))
}

