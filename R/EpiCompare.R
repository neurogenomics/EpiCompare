#' Compare epigenetic datasets
#'
#' This function compares different epigenetic datasets and performs various functional analyses.
#' The function outputs an HTML report containing results from the analysis.
#' The report is mainly divided into three areas: (1) Peakfile information, (2) Overlapping peaks and (3) Functional annotations.
#'
#' @param peakfiles A list of peak files as GRanges object. Files must be listed using `list()`
#' @param names A list of file names in the same order as the list of peak files.
#' Names must be specified using `c()`
#' @param blacklist A GRanges object containing blacklisted regions.
#' @param picard A list of summary metrics output from Picard.
#' @param picard_names A list of names in the same order as the list of Picard summary output.
#' @param reference A reference peak file as GRanges object.
#' If a reference is specified, it enables two analyses: (1) plot showing statistical significance of overlapping/non-overlapping peaks;
#' and (2) ChromHMM of overlapping/non-overlapping peaks
#' @param stat_plot Default FALSE. If TRUE, the function creates a plot showing the statistical significance of
#' overlapping/non-overlapping peaks. Reference peak file must be provided.
#' @param chrmHMM_plot Default FALSE. If TRUE, the function outputs ChromHMM heatmap of individual peak files.
#' If a reference peak file is provided, ChromHMM annotation of overlapping and non-overlapping peaks is also provided.
#' @param save_output Default FALSE. If TRUE, all outputs (tables and plots) of the analysis will be saved in a folder (EpiCompare_file).
#' @param output_dir Path to where output HTML file should be saved.
#'
#' @return An HTML report
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' data("hg19_blacklist") # example blacklist dataset as GRanges object
#' data("chromHMM_annotation_K562") # example of ChromHMM annotation file
#'
#' EpiCompare(peakfiles = list(CnR_H3K27ac, CnT_H3K27ac),
#'            names = c("CnR", "CnT"),
#'            blacklist = hg19_blacklist,
#'            reference = encode_H3K27ac,
#'            stat_plot = TRUE,
#'            chrmHMM_plot = TRUE,
#'            save_output = FALSE,
#'            output_dir = "./")
#'
EpiCompare <- function(peakfiles, names, blacklist, picard=NULL, picard_names=NULL, reference=NULL, stat_plot = FALSE, chrmHMM_plot = FALSE, save_output=FALSE, output_dir){
  # locate Rmd file
  markdown_path <- system.file("markdown", "EpiCompare.Rmd", package = "EpiCompare")
  # parse parameters into markdown and render HTML
  rmarkdown::render(
      input = markdown_path,
      output_dir = output_dir,
      quiet = TRUE,
      params = list(
        peakfile = peakfiles,
        names = names,
        blacklist = blacklist,
        picard_list = picard,
        picard_names = picard_names,
        reference = reference,
        stat_plot = stat_plot,
        chrmHMM_plot= chrmHMM_plot,
        save_output = save_output,
        output_dir = output_dir)
  )
}


