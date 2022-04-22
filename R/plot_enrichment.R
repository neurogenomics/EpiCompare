#' Generate enrichment analysis plots
#'
#' This function runs KEGG and GO enrichment analysis of peak files
#' and generates dot plots.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed using `list()` and named using `names()`
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
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' peaks <- list(CnT_H3K27ac, CnR_H3K27ac) # create a list
#' names(peaks) <- c("CnT", "CnR") # set names
#'
#' ## not run
#' # txdb<-TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
#' # my_plot <- plot_enrichment(peaklist = peaks,
#' #                            annotation = txdb)
#'
plot_enrichment <- function(peaklist, annotation){
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # annotation for hg19 genome
  txdb <- annotation
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
  kegg_plot <- dotplot(compKEGG) +
          ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                             vjust = 1,
                                                             hjust = 1,
                                                             size = font_size))+
               ggplot2::labs(x="")
  sample_names <- gsub('\n([0-9]*)','',kegg_plot$data$Cluster) # remove new line
  kegg_plot$data$Cluster <- sample_names

  #GO
  compGO <- clusterProfiler::compareCluster(geneCluster = genes,
                                           OrgDb = "org.Hs.eg.db",
                                           fun = "enrichGO",
                                           pvalueCutoff = 0.05,
                                           pAdjustMethod = "BH")
  go_plot <- clusterProfiler::dotplot(compGO) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 1,
                                                       hjust=1,
                                                       size = font_size)) +
    ggplot2::labs(x="")
  sample_names <- gsub('\n([0-9]*)','',go_plot$data$Cluster) # remove new line
  go_plot$data$Cluster <- sample_names
  return(list(kegg_plot, go_plot))
}

