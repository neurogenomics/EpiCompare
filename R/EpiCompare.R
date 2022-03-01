#' Compare epigenetic datasets
#'
#' This function compares different epigenetic datasets and performs various functional analyses.
#' The function outputs an HTML report containing results from the analysis.
#' The report is mainly divided into three areas: (1) Peakfile information, (2) Overlapping peaks and (3) Functional annotations.
#'
#' @param peakfiles A list of peak files as GRanges object and/or as paths to BED files.
#' If paths are provided, EpiCompare creates GRanges object.
#' #' EpiCompare also accepts a list containing a mix of GRanges object and paths.
#' Files must be listed using `list()` and named using `names()`.
#' If not named, default file names will be assigned.
#' @param blacklist A GRanges object containing blacklisted regions.
#' @param picard_files A list of summary metrics output from Picard.
#' Files must be in data.frame format and listed using `list()` and named using `names()`.
#' To import Picard duplication metrics (.txt file) into R as data frame,
#' use `picard <- read.table("/path/to/picard/output", header = TRUE, fill = TRUE)`.
#' @param reference A reference peak file as GRanges object.
#' If a reference is specified, it enables two analyses: (1) plot showing statistical significance of overlapping/non-overlapping peaks;
#' and (2) ChromHMM of overlapping/non-overlapping peaks. Please ensure that reference file is named using `names()`
#' @param stat_plot Default FALSE. If TRUE, the function creates a plot showing the statistical significance of
#' overlapping/non-overlapping peaks. Reference peak file must be provided.
#' @param chrmHMM_plot Default FALSE. If TRUE, the function outputs ChromHMM heatmap of individual peak files.
#' If a reference peak file is provided, ChromHMM annotation of overlapping and non-overlapping peaks is also provided.
#' @param chrmHMM_annotation ChromHMM annotation for ChromHMM plots. Default K562 cell-line. Cell-line options are:
#' \itemize{
#'   \item "K562" = K-562 cells
#'   \item "Gm12878" = Cellosaurus cell-line GM12878
#'   \item "H1hesc" = H1 Human Embryonic Stem Cell
#'   \item "Hepg2" = Hep G2 cell
#'   \item "Hmec" = Human Mammary Epithelial Cell
#'   \item "Hsmm" = Human Skeletal Muscle Myoblasts
#'   \item "Huvec" = Human Umbilical Vein Endothelial Cells
#'   \item "Nhek" = Normal Human Epidermal Keratinocytes
#'   \item "Nhlf" = Normal Human Lung Fibroblasts
#' }
#' @param chipseeker_plot Default FALSE. If TRUE, the report includes a barplot of ChIPseeker annotation of peak files.
#' @param enrichment_plot Default FALSE. If TRUE, the report includes dotplots of KEGG and GO enrichment analysis of peak files.
#' @param interact Default TRUE. By default, all heatmaps are interactive. If set FALSE, all heatmaps in the report will be static.
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
#' data("CnT_H3K27ac_picard") # example Picard summary output
#' data("CnR_H3K27ac_picard") # example Picard summary output
#'
#' # prepare input data
#' peaks <- list(CnR_H3K27ac, CnT_H3K27ac) # create list of peakfiles
#' names(peaks) <- c("CnR", "CnT") # set names
#' picard <- list(CnR_H3K27ac_picard, CnT_H3K27ac_picard) # create list of picard outputs
#' names(picard) <- c("CnR", "CnT") # set names
#' reference_peak <- encode_H3K27ac # reference peak file
#' names(reference_peak)[1] <- "encode" # set name
#'
#' EpiCompare(peakfiles = peaks,
#'            blacklist = hg19_blacklist,
#'            picard_files = picard,
#'            reference = reference_peak,
#'            stat_plot = TRUE,
#'            chrmHMM_plot = TRUE,
#'            chrmHMM_annotation = "K562",
#'            chipseeker_plot = TRUE,
#'            enrichment_plot = TRUE,
#'            interact = TRUE,
#'            save_output = FALSE,
#'            output_dir = tempdir())
#'
EpiCompare <- function(peakfiles,
                       blacklist,
                       picard_files = NULL,
                       reference = NULL,
                       stat_plot = FALSE,
                       chrmHMM_plot = FALSE,
                       chrmHMM_annotation = "K562",
                       chipseeker_plot = FALSE,
                       enrichment_plot = FALSE,
                       interact = TRUE,
                       save_output = FALSE,
                       output_dir){

  # locate Rmd file
  markdown_path <- system.file("markdown", "EpiCompare.Rmd", package = "EpiCompare")
  # parse parameters into markdown and render HTML
  rmarkdown::render(
      input = markdown_path,
      output_dir = output_dir,
      quiet = TRUE,
      params = list(
        peakfile = peakfiles,
        blacklist = blacklist,
        picard_files = picard_files,
        reference = reference,
        stat_plot = stat_plot,
        chrmHMM_plot= chrmHMM_plot,
        chrmHMM_annotation = chrmHMM_annotation,
        chipseeker_plot = chipseeker_plot,
        enrichment_plot = enrichment_plot,
        interact = interact,
        save_output = save_output,
        output_dir = output_dir)
  )
}
