#' Prepare blacklist as GRanges
#'
#' Selects the appropriate blacklist in a variety of conditions.
#' @param blacklist_build Genome build of the blacklist.
#' Only used when \code{blacklist} is a user-supplied 
#' \link[GenomicRanges]{GRanges} object.
#' @inheritParams liftover_grlist
#' @returns A \link[GenomicRanges]{GRanges} objects of blacklisted 
#' genomic regions from the relevant genome build.
#'
#' @keywords internal
#' @importFrom methods is
prepare_blacklist <- function(blacklist,
                              output_build,
                              blacklist_build = NULL,
                              verbose = TRUE){ 
  
  #### Select blacklist ####
  if(is.null(blacklist)){
    blacklist <- if(output_build=="hg19"){
      messager("Auto-selecting blacklist:","hg19",v=verbose)
      get_pkg_data(name = "hg19_blacklist")
    } else if(output_build=="hg38"){
      messager("Auto-selecting blacklist:","hg38",v=verbose) 
      get_pkg_data(name = "hg38_blacklist")
    } else if(output_build=="mm10"){
      messager("Auto-selecting blacklist:","mm10",v=verbose)
      get_pkg_data(name = "mm10_blacklist") 
    } else if(output_build=="mm9"){
      messager("Auto-selecting blacklist:","mm9",v=verbose)  
      get_pkg_data(name = "mm9_blacklist") 
    } else {
      stopper("When blacklist is NULL, output_build must be one of:",
              paste("\n -",shQuote(c("hg19","hg38","mm10","mm9")),
                    collapse = ""))
    }
  ##### User-specified ####
  } else if(is.character(blacklist)){
    blacklist <- if(blacklist=="hg19_blacklist"){
      messager("Using blacklist:","hg19_blacklist",v=verbose) 
      get_pkg_data(name = "hg19_blacklist")
    } else if(blacklist=="hg38_blacklist"){
      messager("Using blacklist:","hg38_blacklist",v=verbose) 
      get_pkg_data(name = "hg38_blacklist")
    } else if(blacklist=="mm10_blacklist"){
      messager("Using blacklist:","mm10_blacklist",v=verbose) 
      get_pkg_data(name = "mm10_blacklist")
    } else if(blacklist=="mm9_blacklist"){
      messager("Using blacklist:","mm9_blacklist",v=verbose) 
      get_pkg_data(name = "mm9_blacklist")
    } else {
      stopper(
        "When blacklist is a character, output_build must be one of:",
              paste("\n -",shQuote(c("hg19_blacklist","hg38_blacklist",
                                     "mm10_blacklist","mm9_blacklist")),
                    collapse = ""))
    }
  #### User-supplied ####
  } else if (methods::is(blacklist,"GRanges")){
    messager("Using user-supplied blacklist.",v=verbose)
    if(is.null(blacklist_build)){
      stopper("When blacklist is a user-supplied GRanges object, ",
              "genome_build must include the element 'blacklist'")
    }
    blacklist <- liftover_grlist(grlist = blacklist,
                                 input_build = blacklist_build,
                                 output_build = output_build,
                                 keep_chr = NULL, 
                                 verbose = verbose)
  }
  #### Check if GRanges ####
  if(!methods::is(blacklist,"GRanges")){
    stopper("blacklist must be a GRanges object.")
  } 
  #### Return ####
  return(blacklist)
}
