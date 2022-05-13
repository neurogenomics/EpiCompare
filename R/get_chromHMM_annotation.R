#' Download ChromHMM annotation file(s)
#'
#' Download ChromHMM annotation file(s) for a single cell line
#'  (returned as a \link[GenomicRanges]{GRanges} object) 
#'  or a list of cell lines
#'  (returned as a named list of \link[GenomicRanges]{GRanges} objects).
#' @param cell_line ChromHMM annotation for user-specified cell-line.
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
#' @return cell-line specific ChromHMM annotation file. Default K562 cell-line.
#' @importFrom genomation readBed
#' @import GenomicRanges
#' @keywords internal
get_chromHMM_annotation <- function(cell_line,
                                    cache=BiocFileCache::BiocFileCache()){
  #use bioconductor caching package
  requireNamespace("BiocFileCache")
    
  cell <- check_cell_lines(cell_lines = cell_line) 
  chromHMM_list_all <- lapply(cell, function(x){
      chrHMM_url <- paste0("http://hgdownload.cse.ucsc.edu/goldenPath/hg19/",
                           "encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmm",
                           cell,"HMM.bed.gz")
      chrHMM <- genomation::readBed(chrHMM_url)
      chromHMM_list <- split(chrHMM, chrHMM$name, drop = TRUE)
      msg <- paste0("adding ",cell,
                    "'s chrHMM to local cache,",
                    "future invocations will use local image")
      if (!checkCache(cache,chrHMM_url)) message(msg)
      path <- BiocFileCache::bfcrpath(cache, chrHMM_url)
      # chrHMM <- genomation::readBed(path)
      return(chromHMM_list)
  }) 
  names(chromHMM_list_all) <- cell
  if(length(chromHMM_list_all)==1) {
      return(chromHMM_list_all[[1]])
  } else {
      chromHMM_list_all
  } 
}

