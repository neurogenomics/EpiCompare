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
#' @import GenomicRanges
#' @keywords internal
get_chromHMM_annotation <- function(cell_line,
                                  cache=BiocFileCache::BiocFileCache()){
  #use bioconductor caching package
  requireNamespace("BiocFileCache")

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
  chrHMM_url <- paste0("http://hgdownload.cse.ucsc.edu/goldenPath/hg19/",
                       "encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmm",
                       cell,"HMM.bed.gz")
  chrHMM <- genomation::readBed(chrHMM_url)
  chromHMM_list <- split(chrHMM, chrHMM$name, drop = TRUE)
  msg <- paste0("adding ",cell,
                "'s chrHMM to local cache,",
                "future invocations will use local image")
  if (!checkCache(cache,chrHMM_url))
    message(msg)
  path <- BiocFileCache::bfcrpath(cache, chrHMM_url)
  chrHMM <- genomation::readBed(path)

  return(chromHMM_list)
}

#quick function to check if already saved
checkCache <- function(cache=BiocFileCache::BiocFileCache(),url) {
  if (!requireNamespace("BiocFileCache"))
    stop("install BiocFileCache to use this function")
  cached <- BiocFileCache::bfcinfo(cache)$rname
  return(url %in% cached)
}
