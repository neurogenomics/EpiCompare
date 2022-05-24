#' Plot ChromHMM heatmap
#'
#' Creates a heatmap using outputs from ChromHMM using ggplot2.The function
#' takes a list of peakfiles, performs ChromHMM and outputs a heatmap. ChromHMM
#' annotation file must be loaded prior to using this function.
#' ChromHMM annotations are aligned to hg19, and will be automatically lifted
#' over to the \code{genome_build} to match the build of the \code{peaklist}.
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
#' @param return_data Return the plot data as in addition to the plot itself.
#' @return ChromHMM heatmap, or a named list.
#'
#' @importMethodsFrom genomation annotateWithFeatures
#' @importFrom genomation heatTargetAnnotation
#' @importFrom GenomicRanges GRangesList
#' @importFrom reshape2 melt
#' @importFrom plotly ggplotly
#' @importFrom htmltools tagList
#' @import ggplot2
#' @importMethodsFrom rtracklayer liftOver
#' @importFrom AnnotationHub AnnotationHub
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#'
#' ### Create Named Peaklist ###
#' peaklist <- list(CnT=CnT_H3K27ac, CnR=CnR_H3K27ac)
#'
#' ### Run ###
#' my_plot <- plot_chromHMM(peaklist = peaklist,
#'                          cell_line = "K562",
#'                          genome_build = "hg19")
#'
plot_chromHMM <- function(peaklist,
                          chromHMM_annotation,
                          cell_line=NULL,
                          genome_build,
                          interact=TRUE,
                          return_data=FALSE){
  # define variables
  State <- Sample <- value <- NULL;

  message("--- Running plot_chromHMM() ---")
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
  #### Liftover ####
  ## chromHMM_annotation must be lifted over to match genome build of peaklist.
  chromHMM_annotation <- liftover_grlist(grlist = chromHMM_annotation,
                                         input_build = "hg19",
                                         output_build = genome_build,
                                         as_grangeslist = TRUE)

  # check that peaklist is named, if not, default names assigned
  peaklist <- prepare_peaklist(peaklist = peaklist,
                               remove_empty = TRUE,
                               as_grangeslist = TRUE)
  # annotate peakfiles with chromHMM annotations
  message("Annotating with features.")
  annotation <- genomation::annotateWithFeatures(
      target = peaklist,
      features = chromHMM_annotation)
  # obtain matrix
  message("Obtaining target annotation matrix.")
  matrix <- genomation::heatTargetAnnotation(annotation, plot = FALSE)
  # remove numbers in front of states
  label_corrected <- gsub('X', '', colnames(matrix))
  colnames(matrix) <- label_corrected # set corrected labels
  # convert matrix into molten data frame
  matrix_melt <- reshape2::melt(matrix)
  colnames(matrix_melt) <- c("Sample", "State", "value")
  # order State labels
  sorted_label <- unique(stringr::str_sort(matrix_melt$State, numeric = TRUE))
  nm <- factor(matrix_melt$State, levels=sorted_label)
  matrix_melt$State <- nm
  # create heatmap
  chrHMM_plot <- ggplot2::ggplot(matrix_melt) +
    ggplot2::geom_tile(ggplot2::aes(x = State,
                                    y = Sample,
                                    fill = value)) +
    ggplot2::ylab("") +
    ggplot2::xlab("") +
    ggplot2::scale_fill_viridis_b() +
    ggplot2::theme_minimal() +
    ggplot2::theme(axis.text = ggplot2::element_text(size = 11)) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 315,
                                                       vjust = 0.5,
                                                       hjust=0))
    #### Make plot interactive ####
    if(isTRUE(interact)){
        chrHMM_plot <- plotly::ggplotly(chrHMM_plot)
        chrHMM_plot <- htmltools::tagList(plotly::as_widget(chrHMM_plot))
    }
    #### Return ####
    if(return_data){
        message("Returning named list with both plot and data.")
        return(
            list(plot=chrHMM_plot,
                 data=matrix_melt)
        )
    } else{
        message("Returning chrHMM_plot.")
        return(chrHMM_plot)
    }
}

