#' Make file names
#'
#' Support function for \link[EpiCompare]{gather_files}.
#' @keywords internal
#' @param paths Character vector of file paths.
#' @inheritParams gather_files
gather_files_names <- function(paths,
                               type,
                               nfcore_cutandrun){
  message("Constructing file names.")
  if(isTRUE(nfcore_cutandrun)){
    if(startsWith(type,"peaks")){
      # paths <- grep("03_peak_calling", paths, value = TRUE)
      names <- paste(
        basename(
          dirname(
            dirname(
              dirname(
                paths
              )
            )
          )
        ),
        stringr::str_split(basename(paths),"[.]",
                           simplify = TRUE)[,1],
        sep=".")
    } else if(type=="picard"){
      names <- paste(
        basename(
          dirname(
            dirname(
              dirname(
                dirname(
                  dirname(
                    dirname(
                      paths
                    )
                  )
                )
              )
            )
          )
        ),
        stringr::str_split(basename(paths),"[.]",
                           simplify = TRUE)[,1],
        sep=".")
    }
  } else {
    names <- make.unique(basename(paths))
  }
  return(names)
}
