#' Make file names
#'
#' Support function for \link[EpiCompare]{gather_files}.
#'
#' @keywords internal
#' @param paths Character vector of file paths.
#' @param verbose Print messages.
#' @returns Named character vector. 
#' @inheritParams gather_files
#' @importFrom stringr str_split
#' @importFrom stats setNames
gather_files_names <- function(paths,
                               type,
                               nfcore_cutandrun,
                               verbose=TRUE){
  messager("Constructing file names.",v=verbose)
  if(isTRUE(nfcore_cutandrun)){
    if(startsWith(type,"peaks")){
      # paths <- grep("03_peak_calling", paths, value = TRUE)
      list_names <- paste(
        basename(
          dirname(
            dirname(
              dirname(
                ## Some versions of nfcore/cutandrun include a seacr subdir
                gsub(file.path("","seacr",""),file.path("",""),paths)
              )
            )
          )
        ),
        stringr::str_split(basename(paths),"[.]",
                           simplify = TRUE)[,1],
        sep=".")
    } else if(type=="picard"){
      list_names <- paste(
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
    } else if(type=="multiqc"){
        list_names <- basename(dirname(dirname(paths)))
    }else if(startsWith(type,"bowtie")){
        list_names <- paste(
            basename(dirname(dirname(dirname(dirname(paths))))),
            stringr::str_split(basename(paths),"[.]",
                               simplify = TRUE)[,1],
            sep="."
        ) 
    }else if(type=="trimgalore"){
        list_names <- paste(
            basename(dirname(dirname(dirname(paths)))),
            stringr::str_split(basename(paths),"[.]",
                               simplify = TRUE)[,1],
            sep="."
        )
    }else if(startsWith(type,"bam")){
        list_names <- paste(
            basename(dirname(dirname(dirname(dirname(paths))))),
            stringr::str_split(basename(paths),"[.]",
                               simplify = TRUE)[,1],
            sep="."
        )
    }else{
        list_names <- make.unique(basename(paths))
    }
  } else {
    list_names <- make.unique(basename(paths))
  }
  return(stats::setNames(paths,list_names))
}
