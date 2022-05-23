#' Generate enrichment analysis plots
#'
#' This function runs KEGG and GO enrichment analysis of peak files
#' and generates dot plots.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param annotation A TxDb annotation object from Bioconductor.
#'
#' @return KEGG and GO dot plots
#'
#' @import org.Hs.eg.db
#' @importFrom ChIPseeker annotatePeak
#' @import clusterProfiler
#' @import ggplot2
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- plot_enrichment(peaklist = peaks,
#' #                            annotation = txdb)
#'
plot_enrichment <- function(peaklist, annotation){
  message("--- Running plot_enrichment() ---")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)
  ### TxDB Annotation ###
  txdb <- annotation
  ### Annotate Peak ###
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = c(-3000, 3000),
                           verbose = FALSE)
  genes <- lapply(peak_annotated, function(i) as.data.frame(i)$geneId)

  ### KEGG ###
  compKEGG <- clusterProfiler::compareCluster(geneCluster = genes,
                                              fun = "enrichKEGG",
                                              pvalueCutoff = 0.05,
                                              pAdjustMethod = "BH")
  ### Adjust Font Size ###
  font_size <- 11
  if(length(peaklist) > 6){
    font_size <- 8
  }
  ### Generate KEGG Dotplot ###
  kegg_plot <- dotplot(compKEGG) +
          ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                             vjust = 1,
                                                             hjust = 1,
                                                             size = font_size))+
               ggplot2::labs(x="")
  sample_names <- gsub('\n([0-9]*)','',kegg_plot$data$Cluster) # remove new line
  kegg_plot$data$Cluster <- sample_names

  ### GO ###
  compGO <- clusterProfiler::compareCluster(geneCluster = genes,
                                           OrgDb = "org.Hs.eg.db",
                                           fun = "enrichGO",
                                           pvalueCutoff = 0.05,
                                           pAdjustMethod = "BH")
  ### Generate GO Dotplot ###
  go_plot <- clusterProfiler::dotplot(compGO) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 1,
                                                       hjust=1,
                                                       size = font_size)) +
    ggplot2::labs(x="")
  sample_names <- gsub('\n([0-9]*)','',go_plot$data$Cluster) # remove new line
  go_plot$data$Cluster <- sample_names

  ### Return ###
  message("Done.")
  return(list(kegg_plot, go_plot))
}

