prepare_output_build <- function(genome_build_output){
    opts <- c("hg19","hg38")
    if(is.null(genome_build_output) ||
       missing(genome_build_output) ||
       (!tolower(genome_build_output) %in% opts)){
        stop("Must provide valid genome_build_output: 'hg19' or 'hg38'")
    }
    return(tolower(genome_build_output)[[1]])
}
