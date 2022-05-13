#' Plot ChromHMM heatmap
#'
#' Creates a heatmap using outputs from ChromHMM using ggplot2.The function
#' takes a list of peakfiles, performs ChromHMM and outputs a heatmap. ChromHMM
#' annotation file must be loaded prior to using this function.
#'
#' @param peaklist A named \link[base]{list} of peak files as GRanges object. 
#' If list is not named, default names will be assigned.
#' @param chromHMM_annotation ChromHMM annotation list.
#' @param cell_line If not \code{cell_line}, 
#' will replace \code{chromHMM_annotation}
#'  by importing chromHMM data for a given cell line using  
#'  \link[EpiCompare]{get_chromHMM_annotation}.  
#' @param genome_build The human genome reference build used to generate
#' peakfiles. "hg19" or "hg38".
#' @param interact Default TRUE. By default, the heatmaps are interactive.
#' If\code{FALSE}, the function generates a static ChromHMM heatmap.
#'
#' @return ChromHMM heatmap
#'
#' @importFrom GenomicRanges GRangesList
#' @importMethodsFrom genomation annotateWithFeatures
#' @importFrom genomation heatTargetAnnotation
#' @importFrom reshape2 melt
#' @importFrom plotly plot_ly
#' @import ggplot2
#' @importMethodsFrom rtracklayer liftOver
#' @importFrom AnnotationHub AnnotationHub
#'
#' @export
#' @examples
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object 
#' peaks <- list(CnT=CnT_H3K27ac, CnR=CnR_H3K27ac) # create a list
#' 
#' my_plot <- plot_chromHMM(peaklist=peaks, 
#'                          cell_line = "K562",
#'                          genome_build = "hg19") 
plot_chromHMM <- function(peaklist,
                          chromHMM_annotation,
                          cell_line=NULL,
                          genome_build,
                          interact=TRUE){
  # define variables
  chain <- NULL
  State <- NULL
  Sample <- NULL
  value <- NULL
   
  #### Automatically get cell line data ####
  if(!is.null(cell_line) &&
     !is.null(check_cell_lines(cell_lines = cell_line,
                               verbose = FALSE))){
      chromHMM_annotation <- get_chromHMM_annotation(cell_line = cell_line) 
  } 
  if(missing(chromHMM_annotation)) {
      stp <- "Must supply chromHMM_annotation or cell_line."
      stop(stp)
  }
  # check that peaklist is named, if not, default names assigned
  peaklist <- check_list_names(peaklist)
  # check that there are no empty values
  i <- 1
  while(i <= length(peaklist)){
    if (length(peaklist[[i]])==0){
      peaklist[[i]] <- NULL
    }else{
      i <- i + 1
    }
  }
  peaklist <- liftover_grlist(grlist = peaklist, 
                              input_build = genome_build, 
                              output_build = "hg19")
  # create GRangeList from GRanges objects
  grange_list <- GenomicRanges::GRangesList(peaklist, compress = FALSE)
  # annotate peakfiles with chromHMM annotations
  annotation <- genomation::annotateWithFeatures(grange_list,
                                                 chromHMM_annotation)
  # obtain matrix
  matrix <- genomation::heatTargetAnnotation(annotation, plot = FALSE)
  rownames(matrix) <- names(peaklist) # set row names
  # remove numbers in front of states
  label_corrected <- gsub('X', '', colnames(matrix))
  colnames(matrix) <- label_corrected # set corrected labels
  # if interaction is FALSE generate static heatmap
  if(!interact){
    # convert matrix into molten data frame
    matrix_melt <- reshape2::melt(matrix)
    colnames(matrix_melt) <- c("Sample", "State", "value")
    # create heatmap
    chrHMM_plot <- ggplot2::ggplot(matrix_melt) +
      ggplot2::geom_tile(ggplot2::aes(x = State, y = Sample, fill = value)) +
      ggplot2::ylab("") +
      ggplot2::xlab("") +
      ggplot2::scale_fill_viridis_b() +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text = ggplot2::element_text(size = 11)) +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 315,
                                                         vjust = 0.5,
                                                         hjust=0))
  }else{
    # generate interactive heatmap
    chrHMM_plot <- plotly::plot_ly(x = colnames(matrix),
                                   y = rownames(matrix),
                                   z = matrix,
                                   type = "heatmap")
  }
  # return heatmap
  return(chrHMM_plot)
}

