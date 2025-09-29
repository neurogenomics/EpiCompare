compute_consensus_peaks_consensusseeker <- function(grlist,
                                                    genome_build,
                                                    ...){ 
    bsgen <- check_genome_build(genome_build = genome_build,
                                type = "bsgen")
    chrInfo <- GenomicRanges::seqinfo(bsgen)[
        GenomeInfoDb::seqlevelsInUse(grlist)
    ]  
    consensus_peaks <- consensusSeekeR::findConsensusPeakRegions( 
        peaks = unlist(grlist),
        chrInfo = chrInfo, 
        ...
    )$consensusRanges
    return(consensus_peaks)
}