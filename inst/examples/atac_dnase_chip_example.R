### ATAC-seq vs. DNase-seq vs. CHiP-seq ###

#### Download files ####
ids <- list(atac1="ENCFF558BLC",
            dna1="ENCFF274YGF",
            dna2="ENCFF185XRG",
            chip1="ENCFF038DDS")

files <- lapply(ids, function(id){
  URL <- paste0(
    "https://www.encodeproject.org/files/",id,
    "/@@download/",id,".bed.gz"
  )
  f <- file.path(tempdir(),basename(URL))
  if(!file.exists(f)){
    utils::download.file(URL, f) 
  }
  return(f)
})

#### ATAC-seq peakfile ####
atac1_hg38 <- ChIPseeker::readPeakFile(files$atac1)
atac1_hg38 <- unique(atac1_hg38)
#qValue from ENCODE is V9, renaming so it can be found
GenomicRanges::mcols(atac1_hg38)$qValue <-GenomicRanges::mcols(atac1_hg38)$V9

#### DNase-seq peakfile ####
dna1_hg38 <-  ChIPseeker::readPeakFile(files$dna1)
GenomicRanges::mcols(dna1_hg38)$qValue <-GenomicRanges::mcols(dna1_hg38)$V9

dna2_hg38 <-ChIPseeker::readPeakFile(files$dna2)
GenomicRanges::mcols(dna2_hg38)$qValue <- GenomicRanges::mcols(dna2_hg38)$V9

#### ChIP-seq peakfile ####
chip_hg38 <- ChIPseeker::readPeakFile(files$chip1)
GenomicRanges::mcols(chip_hg38)$qValue <- GenomicRanges::mcols(chip_hg38)$V9

## Peaklist
peaklist <- list("ATAC_ENCFF558BLC" = atac1_hg38,
                 "Dnase_ENCFF274YGF" = dna1_hg38,
                 "ChIP_ENCFF038DDS" = chip_hg38)
peaklist_chr1 <- EpiCompare:::remove_nonstandard_chrom(grlist = peaklist, 
                                                       keep_chr = "chr1")
## Reference
reference <- list("Dnase_ENCFF185XRG_reference"=dna2_hg38)
reference_chr1 <- EpiCompare:::remove_nonstandard_chrom(grlist = reference,
                                                        keep_chr = "chr1")

#### Run Epicompare ####
html_out <- EpiCompare::EpiCompare(peakfiles = peaklist_chr1,
                                   reference = reference_chr1, 
                                   genome_build = "hg38",
                                   genome_build_output = "hg38",  
                                   output_dir = tempdir(), 
                                   run_all = TRUE,
                                   output_filename = "atac_dnase_chip_example",
                                   display = "browser",
                                   workers = NULL)
