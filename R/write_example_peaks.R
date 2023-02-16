#' Write example peaks
#'
#' Write example peaks datasets to disk.
#'
#' @param dir Directory to save peak files to.
#' @param datasets Example datasets from \pkg{EpiCompare} to write.
#'
#' @returns Named vector of paths to saved peak files.
#'
#' @export 
#' @importFrom utils data
#' @examples
#' save_paths <- EpiCompare::write_example_peaks()
write_example_peaks <- function(dir = file.path(tempdir(),
                                                "processed_results"),
                                datasets = c("encode_H3K27ac",
                                             "CnT_H3K27ac",
                                             "CnR_H3K27ac")){
  check_dep("plyranges")
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  save_paths <- vapply(datasets, function(x){
    save_path <- file.path(dir,paste0(x,".narrowPeaks.bed"))
    message("Writing ==> ",save_path)
    #save in bed format - rtracklayer doesn't work for some reason
    #use get(x) to get the dataset from the package named char stored in x
    #rtracklayer::export.bed(get(x),con=save_path)
    #rtracklayer::export(get(x),con=save_path,format="narrowPeak",
    #                    extraCols = extraCols_narrowPeak)
    utils::data(list = x, package = "EpiCompare")
    plyranges::write_narrowpeaks(get(x),file=save_path)
    return(save_path)
  }, character(1))
  names(save_paths) <- datasets
  return(save_paths)
}
