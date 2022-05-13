#' Check genome build
#' 
#' Check that the genome build is valid and 
#' require specific reference datasets to be installed.
#' @param genome_build Genome build name.
#' @keywords internal
#' @returns txdb
check_genome_build <- function(genome_build){
    if(genome_build == "hg19"){
        requireNamespace("TxDb.Hsapiens.UCSC.hg19.knownGene")
        txdb <- TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
    }else if(genome_build == "hg38"){
        requireNamespace("TxDb.Hsapiens.UCSC.hg38.knownGene")
        txdb <- TxDb.Hsapiens.UCSC.hg38.knownGene::TxDb.Hsapiens.UCSC.hg38.knownGene
    } else {
        msg <- paste("genome_build must be one of:",
                     "\n- 'hg19'",
                     "\n- 'hg38'")
        stop(msg)
    }
    return(txdb)
}
