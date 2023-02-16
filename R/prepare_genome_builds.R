#' Prepare genome builds
#' 
#' Parse the \code{genome_build} argument into
#' \code{peaklist_build} and \code{reference_build}.
#' @inheritParams EpiCompare
#' @returns Named list.
#' @keywords internal
prepare_genome_builds <- function(genome_build,
                                  blacklist = NULL){
    
    item_names <- c("peakfiles","reference","blacklist")
    if(length(genome_build)==0){
        stop("Must provide genome_build.")
    } else if(length(genome_build)==1){
        message(paste("Assuming same genome_build",
                      "for all file inputs:","\n",
                      "'peakfiles': ", genome_build[[1]],"\n",
                      "'reference': ",genome_build[[1]],"\n",
                      "'blacklist': ",genome_build[[1]]
                      ))
        peakfiles_build <- genome_build
        reference_build <- genome_build
        blacklist_build <- genome_build
    } else if(is.null(names(genome_build)) && 
              (length(genome_build)==3)){ 
        peakfiles_build <- genome_build[[1]]
        reference_build <- genome_build[[2]]
        blacklist_build <- genome_build[[3]]
        message(paste("genome_build doesn't contain names.",
                      "Assuming element 1 is 'peakfiles':",peakfiles_build,"\n",
                      "Assuming element 2 is 'reference':",reference_build,"\n",
                      "Assuming element 3 is 'blacklist':",blacklist_build
                      ))
    } else if( all(item_names %in% names(genome_build)) ){
        names(genome_build) <- tolower(names(genome_build))
        peakfiles_build <- genome_build[["peakfiles"]]
        reference_build <- genome_build[["reference"]]
        blacklist_build <- genome_build[["blacklist"]]
        message("Assigning 'peakfiles': ",peakfiles_build)
        message("Assigning 'reference': ",reference_build) 
        message("Assigning 'blacklist': ",blacklist_build) 
    } else if( all(item_names[c(1,2)] %in% names(genome_build)) &&
               is.null(blacklist)){
      names(genome_build) <- tolower(names(genome_build))
      peakfiles_build <- genome_build[["peakfiles"]]
      reference_build <- genome_build[["reference"]]
      blacklist_build <- NULL
    }else {
        stop("Unable to parse genome_build.")
    }
    #### Return ####
    return(list(peaklist=peakfiles_build,
                reference=reference_build,
                blacklist=blacklist_build))
}
