#' Generate enrichment analysis plots
#'
#' This function runs KEGG and GO enrichment analysis of peak files
#' and generates dot plots.
#'
#' @param peaklist A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param txdb A TxDb annotation object from Bioconductor.
#' @param pvalueCutoff P-value cutoff,
#'  passed to \link[clusterProfiler]{compareCluster}.
#' @param verbose Print messages.
#' @inheritParams EpiCompare
#' @inheritParams tss_plot
#' @return KEGG and GO dot plots
#'
#' @importFrom ChIPseeker annotatePeak
#' @import ggplot2
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object 
#' ### Create Named Peaklist ###
#' peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac) 
#' enrich_res <- plot_enrichment(peaklist = peaklist, 
#'                               tss_distance = c(-50,50)) 
plot_enrichment <- function(peaklist, 
                            txdb = NULL,
                            tss_distance = c(-3000, 3000),
                            pvalueCutoff = 0.05,
                            interact = FALSE,
                            verbose = TRUE){
  
  # templateR:::args2vars(plot_enrichment) 
  messager("--- Running plot_enrichment() ---",v=verbose)
  ### Check deps ### 
  check_dep("clusterProfiler")  
  check_dep("org.Hs.eg.db")
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)  
  ### Annotate Peak ###
  peak_annotated <- lapply(peaklist,
                           ChIPseeker::annotatePeak,
                           TxDb = txdb,
                           tssRegion = tss_distance,
                           verbose = FALSE)
  genes <- lapply(peak_annotated, function(i) as.data.frame(i)$geneId)

  ### KEGG ### 
  messager("+ Running clusterProfiler::compareCluster for KEGG.",v=verbose)
  compKEGG <- clusterProfiler::compareCluster(geneCluster = genes,
                                              fun = "enrichKEGG",
                                              pvalueCutoff = pvalueCutoff,
                                              pAdjustMethod = "BH")
  ### Adjust Font Size ###
  font_size <- 11
  if(length(peaklist) > 6){
    font_size <- 8
  }
  ### Generate KEGG Dotplot ###
  kegg_plot <- clusterProfiler::dotplot(compKEGG) +
    ggplot2::labs(x="") +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 1,
                                                       hjust = 1,
                                                       size = font_size))
  # Remove new line
  sample_names <- gsub('\n([0-9]*)','',kegg_plot$data$Cluster)
  kegg_plot$data$Cluster <- sample_names

  ### GO ###
  messager("+ Running clusterProfiler::compareCluster for GO.",v=verbose)
  compGO <- clusterProfiler::compareCluster(geneCluster = genes,
                                           OrgDb = "org.Hs.eg.db",
                                           fun = "enrichGO",
                                           pvalueCutoff = pvalueCutoff,
                                           pAdjustMethod = "BH")
  ### Generate GO Dotplot ###
  go_plot <- clusterProfiler::dotplot(compGO) +
    ggplot2::labs(x="") +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45,
                                                       vjust = 1,
                                                       hjust=1,
                                                       size = font_size))
  # Remove new line
  sample_names <- gsub('\n([0-9]*)','',go_plot$data$Cluster)
  go_plot$data$Cluster <- sample_names

  
  ### Return ###
  message("Done.")
  if(isTRUE(interact)){
    return(list(kegg_plot=as_interactive(kegg_plot), 
                go_plot=as_interactive(go_plot))
           )
  }else {
    return(list(kegg_plot=kegg_plot, 
                go_plot=go_plot)
           )
  }
}

