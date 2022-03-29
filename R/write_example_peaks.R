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
#' @importFrom utils write.table data
#' @examples
#' save_paths <- EpiCompare::write_example_peaks()
write_example_peaks <- function(dir = file.path(tempdir(),
                                                "processed_results"),
                                datasets = c("encode_H3K27ac",
                                             "CnT_H3K27ac",
                                             "CnR_H3K27ac")){
  dir.create(dir, showWarnings = FALSE, recursive = TRUE)
  save_paths <- sapply(datasets, function(x){
    save_path <- file.path(dir,paste0(x,".narrowPeaks.bed"))
    message("Writing ==> ",save_path)
    utils::data(list = x)
    utils::write.table(x = data.frame(eval(parse(text=x))),
                file = save_path,
                row.names = FALSE,
                col.names = TRUE,
                sep="\t")
    return(save_path)
  })
  names(save_paths) <- datasets
  return(save_paths)
}
