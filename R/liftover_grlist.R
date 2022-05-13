#' Liftover peak list
#' 
#' Perform genome build liftover to on a named list of
#'  \link[GenomicRanges]{GRanges} objects.
#' @param grlist A named list of \link[GenomicRanges]{GRanges} object.
#' @param input_build The genome build of \code{grlist}.
#' @param output_build Desired genome build for
#'  \code{grlist} to be lifted over to. 
#' @returns Named list of lifted \link[GenomicRanges]{GRanges} objects.
#' @export
#' @importFrom AnnotationHub AnnotationHub
#' @importFrom rtracklayer liftOver
#' @examples 
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' grlist <- list("encode_H3K27ac"=encode_H3K27ac,
#'                "CnT_H3K27ac"=CnT_H3K27ac,
#'                "CnR_H3K27ac"=CnR_H3K27ac)
#'
#' grlist_lifted <- liftover_grlist(grlist = grlist,
#'                                  input_build = "hg19",
#'                                  output_build="hg38")
liftover_grlist <- function(grlist,
                            input_build,
                            output_build="hg19"){ 
    
    input_build <- tolower(input_build)
    output_build <- tolower(output_build)
    #### No liftover necessary ####
    if(input_build==output_build){
        ## Exit early
        return(grlist)
    } 
    #### Chain file descriptions ####
    message("Preparing chain file.")
    ah <- AnnotationHub::AnnotationHub()
    # chainfiles <- AnnotationHub::query(ah , c("hg38", "hg19", "chainfile"))
    # AH14108 | hg38ToHg19.over.chain.gz                     
    # AH14150 | hg19ToHg38.over.chain.gz                     
    # AH78915 | Chain file for Homo sapiens rRNA hg19 to hg38
    # AH78916 | Chain file for Homo sapiens rRNA hg38 to hg19
    
    #### get chain  ####
    if ((input_build=="hg38") && 
        (output_build=="hg19")){ 
        chain <- ah[["AH14108"]]  
    } else if((input_build=="hg19") && 
              (output_build=="hg38")){
        chain <- ah[["AH14150"]] 
    }
    #### liftover ####
    message("Performing liftover.") 
    grlist_lifted <- mapply(grlist, FUN = function(gr){
        gr <- clean_granges(gr = gr)
        gr2 <- rtracklayer::liftOver(x = gr, 
                                     chain = chain) 
        return(unlist(gr2))
    })    
    return(grlist_lifted)
}
