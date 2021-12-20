#' Compare epigenetic datasets
#'
#' @param peakfiles A list of peak files as GRanges object. Files must be listed using `list()`
#' @param file_names A list of file names in the same order as the list of peak files.
#' Names must be specified using `c()`
#' @param blacklist A GRanges object containing blacklisted regions.
#' @param output_dir Path to where output HTML file should be saved.
#'
#' @return An HTML report
#' @export
#'
#' @examples
#' library(EpiCompare)
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("hg19_blacklist") # example blacklist dataset as GRanges object
#'
#' EpiCompare(peakfiles = list(encode_H3K27ac, CnT_H3K27ac),
#'            file_names = c("ENCODE", "CnT"),
#'            blacklist = hg19_blacklist,
#'            output_dir = "./")
#'
EpiCompare <- function(peakfiles, file_names, blacklist, output_dir){

  markdown_path <- system.file("markdown", "EpiCompare.Rmd", package = "EpiCompare")

  rmarkdown::render(
    input = markdown_path,
    output_dir = output_dir,
    params = list(
      peakfile = peakfiles,
      file_name = file_names,
      blacklist = blacklist,
      output_dir = output_dir
    )
  )
}


