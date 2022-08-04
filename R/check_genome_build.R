#' Check genome build
#' 
#' Check that the genome build is valid and 
#' require specific reference datasets to be installed.
#' @param genome_build Genome build name.
#' @param type whether to fetch the txdb or bsgen reference data
#' @keywords internal
#' @returns txdb or bsgen
check_genome_build <- function(genome_build,
                               type="txdb"){
    genome_build <- translate_genome(genome = genome_build)
    if(type=="txdb"){
      if(genome_build == "hg19"){
          requireNamespace("TxDb.Hsapiens.UCSC.hg19.knownGene")
          txdb <- 
            TxDb.Hsapiens.UCSC.hg19.knownGene::TxDb.Hsapiens.UCSC.hg19.knownGene
      }else if(genome_build == "hg38"){
          requireNamespace("TxDb.Hsapiens.UCSC.hg38.knownGene")
          txdb <- 
            TxDb.Hsapiens.UCSC.hg38.knownGene::TxDb.Hsapiens.UCSC.hg38.knownGene
      }else if(genome_build == "mm9"){
          requireNamespace("TxDb.Mmusculus.UCSC.mm9.knownGene")
          txdb <- 
            TxDb.Mmusculus.UCSC.mm9.knownGene::TxDb.Mmusculus.UCSC.mm9.knownGene
      }else if(genome_build == "mm10"){
          requireNamespace("TxDb.Mmusculus.UCSC.mm10.knownGene")
          txdb <- 
            TxDb.Mmusculus.UCSC.mm10.knownGene::TxDb.Mmusculus.UCSC.mm10.knownGene
      }else {
          msg <- paste("genome_build must be one of:",
                       "\n- 'hg19'",
                       "\n- 'hg38'",
                       "\n- 'mm9'",
                       "\n- 'mm10'")
          stop(msg)
      }
      return(txdb)
    }else{ #BSgenome
      if(genome_build == "hg19"){
        requireNamespace("BSgenome.Hsapiens.UCSC.hg19")
        bsgen <- BSgenome.Hsapiens.UCSC.hg19::Hsapiens
      }else if(genome_build == "hg38"){
        requireNamespace("BSgenome.Hsapiens.UCSC.hg38")
        bsgen <- BSgenome.Hsapiens.UCSC.hg38::Hsapiens
      }else if(genome_build == "mm9"){
        requireNamespace("BSgenome.Mmusculus.UCSC.mm9")
        bsgen <- BSgenome.Mmusculus.UCSC.mm9::Mmusculus
      }else if(genome_build == "mm10"){
        requireNamespace("BSgenome.Mmusculus.UCSC.mm10")
        bsgen <- BSgenome.Mmusculus.UCSC.mm10::Mmusculus
      }else {
        msg <- paste("genome_build must be one of:",
                     "\n- 'hg19'",
                     "\n- 'hg38'",
                     "\n- 'mm9'",
                     "\n- 'mm10'")
        stop(msg)
      }
      return(bsgen)
    }
}
