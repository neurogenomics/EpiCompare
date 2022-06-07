get_chain_file <- function(grlist,
                           input_build,
                           output_build,
                           verbose = TRUE){
    messager("Preparing chain file.",v=verbose)
    ah <- AnnotationHub::AnnotationHub()
    # chainfiles <- AnnotationHub::query(ah , c("hg38", "hg19", "chainfile"))
    # chainfiles <- AnnotationHub::query(ah , c("hg38", "mm10", "chainfile"))
    # chainfiles <- AnnotationHub::query(ah , c("hg19", "mm10", "chainfile")) 
    ## hg38 <--> mm9 chain file is not available ###
    # chainfiles <- AnnotationHub::query(ah , c("hg19", "mm9", "chainfile"))
    # chainfiles <- AnnotationHub::query(ah , c("mm10", "mm9", "chainfile"))
    # AH14108 | hg38ToHg19.over.chain.gz                     
    # AH14150 | hg19ToHg38.over.chain.gz                     
    # AH78915 | Chain file for Homo sapiens rRNA hg19 to hg38
    # AH78916 | Chain file for Homo sapiens rRNA hg38 to hg19
    
    #### get chain  ####
    ## Intra-species 
    #### hg38 <--> hg19 ####
    if ((input_build=="hg38") && 
        (output_build=="hg19")){ 
        chain <- ah[["AH14108"]]  
    } else if((input_build=="hg19") && 
              (output_build=="hg38")){
        chain <- ah[["AH14150"]] 
        #### mm10 <--> mm9 ####
    } else if ((input_build=="mm10") && 
               (output_build=="mm9")){ 
        chain <- ah[["AH14535"]]
    } else if((input_build=="mm9") && 
              (output_build=="mm10")){
        chain <- ah[["AH14596"]]
        ## Inter-species 
        #### mm10 ####
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
        #### mm9 ####
    } else if((input_build=="mm9") && 
              (output_build=="hg19")){
        chain <- ah[["AH14592"]] 
    } else if((input_build=="hg19") && 
              (output_build=="mm9")){
        chain <- ah[["AH14155"]] 
        #### use recursion for hg38 <-- hg19 --> mm9 ####
        ## There is no chain file mapping hg38 to mm9 directly (or vice versa), 
        ## so we must first convert to hg19 as an intermediate step.
    } else if((input_build=="hg38") && 
              (output_build=="mm9")){
        grlist <- liftover_grlist(grlist = grlist, 
                                  input_build = input_build, 
                                  output_build = "hg19", 
                                  verbose = verbose)
        input_build <- "hg19"
        chain <- ah[["AH14155"]] 
    } else if((input_build=="mm9") && 
              (output_build=="hg38")){
        grlist <- liftover_grlist(grlist = grlist, 
                                  input_build = input_build, 
                                  output_build = "hg19", 
                                  verbose = verbose)
        input_build <- "hg19"
        chain <- ah[["AH14150"]] 
    } else {
        stopper(input_build,"-->",output_build,"not currently supported.")
    }
    #### liftover ####
    messager("Performing liftover: ",
             input_build," --> ",output_build,
             v=verbose) 
    return(list(grlist=grlist,
                chain=chain))
}
