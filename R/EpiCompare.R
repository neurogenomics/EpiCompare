#' Compare epigenomic datasets
#'
#' This function compares and analyses multiple epigenomic datasets and outputs
#' an HTML report containing all results of the analysis. The report is mainly
#' divided into three sections: (1) General Metrics on Peakfiles,
#' (2) Peak Overlaps and (3) Functional Annotation of Peaks.
#'
#' @param peakfiles A list of peak files as GRanges object and/or as paths to
#' BED files. If paths are provided, EpiCompare imports the file as GRanges
#' object. EpiCompare also accepts a list containing a mix of GRanges objects
#' and paths.Files must be listed and named using \code{list()}.
#' E.g. \code{list("name1"=file1, "name2"=file2)}. If no names are specified,
#' default file names will be assigned.
#' @param genome_build A named list indicating the human genome build used to
#' generate each of the following inputs:
#' \itemize{
#' \item{"peakfiles" : }{Genome build for the \code{peakfiles} input.
#' Assumes genome build is the same for each element in the \code{peakfiles}
#' list.}
#' \item{"reference" : }{Genome build for the \code{reference} input.}
#' \item{"blacklist" : }{Genome build for the \code{blacklist} input.}
#' }
#' Example input list:\cr
#'  \code{genome_build = list(peakfiles="hg38",
#'  reference="hg19", blacklist="hg19")}\cr\cr
#' Alternatively, you can supply a single character string instead of a list.
#' This should \emph{only} be done in situations where all three inputs
#' (\code{peakfiles}, \code{reference}, \code{blacklist}) are of the same
#' genome build. For example:\cr
#' \code{genome_build = "hg19"}
#' @param genome_build_output Genome build to standardise all inputs to.
#' Liftovers will be performed automatically as needed.
#' Default: "hg19".
#' @param blacklist A GRanges object containing blacklisted regions.
#' @param picard_files A list of summary metrics output from Picard.
#' Files must be in data.frame format and listed using \code{list()}
#' and named using \code{names()}.
#' To import Picard duplication metrics (.txt file)
#'  into R as data frame, use:\cr
#' \code{picard <- read.table("/path/to/picard/output",
#'  header = TRUE, fill = TRUE)}.
#' @param reference A named list containing reference peak file(s) as GRanges
#'  object. Please ensure that the reference file is listed and named
#' i.e. \code{list("reference_name" = reference_peak)}. If more than one
#' reference is specified, individual reports for each reference will be
#' generated. However, please note that specifying more than one reference can
#' take awhile. If a reference is specified, it enables two analyses: (1) plot
#' showing statistical significance of overlapping/non-overlapping peaks; and
#' (2) ChromHMM of overlapping/non-overlapping peaks.
#' @param upset_plot Default FALSE. If TRUE, the report includes upset plot of
#' overlapping peaks.
#' @param stat_plot Default FALSE. If TRUE, the function creates a plot showing
#' the statistical significance of overlapping/non-overlapping peaks.
#' Reference peak file must be provided.
#' @param precision_recall_plot Default is FALSE. If TRUE,
#' creates a precision-recall curve plot and an F1 plot using
#' \link[EpiCompare]{plot_precision_recall}.
#' @param corr_plot Default is FALSE. If TRUE, creates a correlation plot across
#' all peak files using
#' \link[EpiCompare]{plot_corr}.
#' @param chromHMM_plot Default FALSE. If TRUE, the function outputs ChromHMM
#' heatmap of individual peak files. If a reference peak file is provided,
#' ChromHMM annotation of overlapping and non-overlapping peaks is also provided.
#' @param chromHMM_annotation ChromHMM annotation for ChromHMM plots.
#' Default K562 cell-line. Cell-line options are:
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
#' @param chipseeker_plot Default FALSE. If TRUE, the report includes a barplot
#' of ChIPseeker annotation of peak files.
#' @param enrichment_plot Default FALSE. If TRUE, the report includes dotplots
#' of KEGG and GO enrichment analysis of peak files.
#' @param tss_plot Default FALSE. If TRUE, the report includes peak count
#' frequency around transcriptional start site. Note that this can take awhile.
#' @param interact Default TRUE. By default, all heatmaps are interactive.
#' If set FALSE, all heatmaps in the report will be static.
#' @param save_output Default FALSE. If TRUE, all outputs (tables and plots) of
#' the analysis will be saved in a folder (EpiCompare_file).
#' @param output_filename Default EpiCompare.html. If otherwise, the html report
#'  will be saved in the specified name.
#' @param output_timestamp Default FALSE. If TRUE, date will be included in the
#' file name.
#' @param output_dir Path to where output HTML file should be saved.
#' @param display After completion, automatically display the HTML report file
#'  in one of the following ways:
#' \itemize{
#' \item{"browser" : }{Display the report in your default web browser.}
#' \item{"rsstudio" : }{Display the report in Rstudio.}
#' \item{NULL (default) : }{Do not display the report.}
#' }
#'
#' @return Path to one or more HTML report files.
#'
#' @export
#' @importFrom rmarkdown render
#' @importFrom methods show
#' @importFrom utils browseURL
#'
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' data("hg19_blacklist") # hg38 blacklist dataset
#' data("CnT_H3K27ac_picard") # example Picard summary output
#' data("CnR_H3K27ac_picard") # example Picard summary output
#'
#' #### Prepare Input ####
#' # create named list of peakfiles
#' peaks <- list(CnR=CnR_H3K27ac, CnT=CnT_H3K27ac)
#' # create named list of picard outputs
#' picard <- list(CnR=CnR_H3K27ac_picard, CnT=CnT_H3K27ac_picard)
#' # reference peak file
#' reference_peak <- list("ENCODE" = encode_H3K27ac)
#'
#' ### Run EpiCompare ###
#' EpiCompare(peakfiles = peaks,
#'            genome_build = list(peakfiles="hg19",
#'                                reference="hg19",
#'                                blacklist="hg19"),
#'            genome_build_output = "hg19",
#'            blacklist = hg19_blacklist,
#'            picard_files = picard,
#'            reference = reference_peak,
#'            output_dir = tempdir())
EpiCompare <- function(peakfiles,
                       genome_build,
                       genome_build_output = "hg19",
                       blacklist,
                       picard_files = NULL,
                       reference = NULL,
                       upset_plot = FALSE,
                       stat_plot = FALSE,
                       chromHMM_plot = FALSE,
                       chromHMM_annotation = "K562",
                       chipseeker_plot = FALSE,
                       enrichment_plot = FALSE,
                       tss_plot = FALSE,
                       precision_recall_plot = FALSE,
                       corr_plot=FALSE,
                       interact = TRUE,
                       save_output = FALSE,
                       output_filename = "EpiCompare",
                       output_timestamp = FALSE,
                       output_dir,
                       display = NULL){

  # time
  t1 <- Sys.time()
  if(!is.null(display)) display <- tolower(display)[1]
  ### Output Filename ###
  if(output_timestamp){
    date <- format(Sys.Date(), '%b_%d_%Y')
    output_filename <- paste0(output_filename,"_",date)
  }

  ### Locate Rmd ###
  markdown_path <- system.file("markdown",
                               "EpiCompare.Rmd",
                               package = "EpiCompare")

  ### Multiple Reference Files ###
  if(length(reference)>1){
      output_html <- lapply(names(reference), function(nm){
          message("\n","======>> ",nm," <<======")
          #### Create subfolder for each run ####
          output_dir <- file.path(output_dir,nm)
          dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
          #### Parse Parameters Into Markdown & Render HTML ####
          rmarkdown::render(
            input = markdown_path,
            output_dir = output_dir,
            output_file = output_filename,
            quiet = TRUE,
            params = list(
              peakfile = peakfiles,
              genome_build = genome_build,
              genome_build_output = genome_build_output,
              blacklist = blacklist,
              picard_files = picard_files,
              reference = reference[nm],
              upset_plot = upset_plot,
              stat_plot = stat_plot,
              chromHMM_plot= chromHMM_plot,
              chromHMM_annotation = chromHMM_annotation,
              chipseeker_plot = chipseeker_plot,
              enrichment_plot = enrichment_plot,
              tss_plot = tss_plot,
              precision_recall_plot = precision_recall_plot,
              corr_plot = corr_plot,
              interact = interact,
              save_output = save_output,
              output_dir = output_dir)
          )
          return(file.path(output_dir,paste0(output_filename,".html")))
        }) |> unlist()
  }else{
    ### Parse Parameters Into Markdown & Render HTML ###
      output_html <- file.path(output_dir,paste0(output_filename,".html"))
      #### Parse Parameters Into Markdown & Render HTML ####
    rmarkdown::render(
      input = markdown_path,
      output_dir = output_dir,
      output_file = output_filename,
      quiet = TRUE,
      params = list(
        peakfile = peakfiles,
        genome_build = genome_build,
        genome_build_output = genome_build_output,
        blacklist = blacklist,
        picard_files = picard_files,
        reference = reference,
        upset_plot = upset_plot,
        stat_plot = stat_plot,
        chromHMM_plot= chromHMM_plot,
        chromHMM_annotation = chromHMM_annotation,
        chipseeker_plot = chipseeker_plot,
        enrichment_plot = enrichment_plot,
        tss_plot = tss_plot,
        precision_recall_plot = precision_recall_plot,
        corr_plot = corr_plot,
        interact = interact,
        save_output = save_output,
        output_dir = output_dir)
    )
  }
  ### Show Timer ###
  t2 <- Sys.time()
  methods::show(paste(
      "Done in",round(difftime(t2, t1, units = "min"),3),"min."
  ))
  ### Display results ###
  messager("All outputs saved to:", output_dir)
  if(is.null(display)){
      return(output_html)
  } else if(display=="browser"){
      for(x in output_html){
          utils::browseURL(x)
      }
  } else if(display=="rstudio"){
      for(x in output_html){
          file.show(x)
      }
  }
  #### Return paths to html reports ####
  return(output_html)
}
