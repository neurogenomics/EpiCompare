#' Download ChromHMM annotation file
#'
#' @param cell_line ChromHMM annotation for user-specified cell-line
#'
#' @return cell-line specific ChromHMM annotation file. Default K562 cell-line.
#' Cell-line options are:
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
#' @importFrom genomation readBed
#' @importFrom GenomicRanges split
#' @keywords internal
get_chrHMM_annotation <- function(cell_line){
  if (cell_line == "K562"){
    cell <- "K562"
  }else if (cell_line == "Gm12878"){
    cell <- "Gm12878"
  }else if (cell_line == "H1hesc"){
      cell <- "H1hesc"
  }else if (cell_line == "Hepg2"){
      cell <- "Hepg2"
  }else if (cell_line == "Hmec"){
      cell <- "Hmec"
  }else if (cell_line == "Hsmm"){
      cell <- "Hsmm"
  }else if (cell_line == "Huvec"){
      cell <- "Huvec"
  }else if (cell_line == "Nhek"){
      cell <- "Nhek"
  }else if (cell_line == "Nhlf"){
      cell <- "Nhlf"
  }
  chrHMM_url <- paste0("http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmm",cell,"HMM.bed.gz")
  chrHMM <- genomation::readBed(chrHMM_url)
  chrHMM_list <- GenomicRanges::split(chrHMM, chrHMM$name, drop = TRUE)
  return(chrHMM_list)
}
