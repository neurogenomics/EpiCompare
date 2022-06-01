#' Liftover peak list
#' 
#' Perform genome build liftover to one or more
#'  \link[GenomicRanges]{GRanges} objects at once.
#' @param grlist A named list of \link[GenomicRanges]{GRanges} objects,
#'  or simply a single unlisted \link[GenomicRanges]{GRanges} object.
#'  Can perform liftover within species or across species.
#' @param input_build The genome build of \code{grlist}.
#' @param output_build Desired genome build for
#'  \code{grlist} to be lifted over to.
#' @param as_grangeslist Return as a \link[GenomicRanges]{GRangesList}. 
#' @param merge_all Merge all \link[GenomicRanges]{GRanges} into a single
#'  \link[GenomicRanges]{GRanges} object.
#' @param style Chromosome style,
#'  set by \link[GenomeInfoDb]{seqlevelsStyle}.
#'  \itemize{
#'  \item{"UCSC" : }{Uses the chromosome style "chr1".}
#'  \item{"NCBI" : }{Uses the chromosome style "1"}
#'  }
#' @param verbose Print messages.
#' 
#' @returns Named list of lifted \link[GenomicRanges]{GRanges} objects.
#' @export
#' @importFrom AnnotationHub AnnotationHub
#' @importFrom rtracklayer liftOver
#' @importFrom GenomicRanges GRangesList
#' @examples 
#' grlist <- list("gr1"=GenomicRanges::GRanges("4:1-100000"),
#'                "gr2"=GenomicRanges::GRanges("6:1-100000"),
#'                "gr3"=GenomicRanges::GRanges("8:1-100000"))
#'
#' grlist_lifted <- liftover_grlist(grlist = grlist,
#'                                  input_build = "hg19",
#'                                  output_build="hg38")
liftover_grlist <- function(grlist,
                            input_build,
                            output_build="hg19",
                            style="UCSC",
                            as_grangeslist=FALSE,
                            merge_all=FALSE,
                            verbose=TRUE){ 
    
    input_build <- translate_genome(genome = input_build, 
                                    style = "UCSC")
    output_build <- translate_genome(genome = output_build, 
                                     style = "UCSC")
    #### No liftover necessary ####
    if(input_build==output_build){
        messager("grlist is already in the output_build format.",
                 "Skipping liftover.",v=verbose)
        ## Exit early
        return(grlist)
    } 
    #### Check if it's a single element ####
    tmp_list <- FALSE
    if(is_granges(grlist)){
        grlist <- list(gr1=grlist)
        tmp_list <- TRUE
    }
    #### Chain file descriptions ####
    messager("Preparing chain file.",v=verbose)
    ah <- AnnotationHub::AnnotationHub()
    # chainfiles <- AnnotationHub::query(ah , c("hg38", "hg19", "chainfile"))
    # chainfiles <- AnnotationHub::query(ah , c("hg38", "mm10", "chainfile"))
    # chainfiles <- AnnotationHub::query(ah , c("hg19", "mm10", "chainfile"))
    # AH14108 | hg38ToHg19.over.chain.gz                     
    # AH14150 | hg19ToHg38.over.chain.gz                     
    # AH78915 | Chain file for Homo sapiens rRNA hg19 to hg38
    # AH78916 | Chain file for Homo sapiens rRNA hg38 to hg19
    
    #### get chain  ####
    ## Intra-species 
    if ((input_build=="hg38") && 
        (output_build=="hg19")){ 
        chain <- ah[["AH14108"]]  
    } else if((input_build=="hg19") && 
              (output_build=="hg38")){
        chain <- ah[["AH14150"]] 
    ## Inter-species 
    } else if((input_build=="hg38") && 
              (output_build=="mm10")){
        chain <- ah[["AH14109"]] 
    } else if((input_build=="mm10") && 
              (output_build=="hg38")){
        chain <- ah[["AH14528"]]  
    } else if((input_build=="hg19") && 
                 (output_build=="mm10")){
        chain <- ah[["AH14156"]] 
    } else if((input_build=="mm10") && 
              (output_build=="hg19")){
        chain <- ah[["AH14527"]] 
    } 
    #### liftover ####
    messager("Performing liftover: ",
             input_build," --> ",output_build,
             v=verbose) 
    grlist_lifted <- mapply(grlist, FUN = function(gr){
        gr <- clean_granges(gr = gr)
        suppressMessages(suppressWarnings(
            GenomeInfoDb::seqlevelsStyle(gr) <- "UCSC"
        ))
        gr2 <- rtracklayer::liftOver(x = gr, 
                                     chain = chain) 
        suppressMessages(suppressWarnings(
            GenomeInfoDb::seqlevelsStyle(gr) <- style
        ))
        return(unlist(gr2))
    })    
    if(as_grangeslist){
        grlist_lifted <- GenomicRanges::GRangesList(grlist_lifted, 
                                                    compress = FALSE) 
    }
    if(merge_all){
        
    }
    if(tmp_list) grlist_lifted <- grlist_lifted[[1]]
    return(grlist_lifted)
}
