#' Example ChIP-seq peak file
#'
#' Human H3K27ac peak file generated with ChIP-seq using K562 cell-line.
#' Raw peak file (.BED) was obtained from ENCODE project (data accession: ENCFF044JNJ).
#' The BED file was then processed into GRanges object.
#' Peaks located on chromosome 1 were subsetted to reduce the dataset size.
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' encode_H3K27ac <- ChIPseeker::readPeakFile("./data/ENCODE_H3K27ac.bed", as = "GRanges")
#' encode_H3K27ac <- encode_H3K27ac[encode_H3K27ac@seqnames == "chr1"]
#' usethis::use_data(encode_H3K27ac)
#' }
#'
"encode_H3K27ac"

#' Example CUT&Tag peak file
#'
#' Human H3K27ac peak file generated with CUT&Tag using K562 cell-line from Kaya-Okur et al., (2019).
#' Raw peak file (.BED) was obtained from GEO (sample accession: SRR8383507).
#' Peak calling was performed by Leyla Abbasova using MACS2.
#' The peak file was then processed into GRanges object.
#' Peaks located on chromosome 1 were subsetted to reduce the dataset size.
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' CnT_H3K27ac <- ChIPseeker::readPeakFile("./data/CnT_H3K27ac_MACS2.bed", as = "GRanges")
#' CnT_H3K27ac <- CnT_H3K27ac[CnT_H3K27ac@seqnames== "chr1"]
#' usethis::use_data(CnT_H3K27ac)
#' }
#'
"CnT_H3K27ac"

#' Example CUT&Run peak file
#'
#' Human H3K27ac peak file generated with CUT&Run using K562 cell-line from Meers et al., (2019).
#' Raw peak file (.BED) was obtained from GEO (sample accession: SRR8581604).
#' Peak calling was performed by Leyla Abbasova using MACS2.
#' The peak file was then processed into GRanges object.
#' Peaks located on chromosome 1 were subsetted to reduce the dataset size.
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' CnR_H3K27ac <- ChIPseeker::readPeakFile("./data/CnR_H3K27ac_MACS2.bed", as = "GRanges")
#' CnR_H3K27ac <- CnR_H3K27ac[CnR_H3K27ac@seqnames== "chr1"]
#' usethis::use_data(CnR_H3K27ac)
#' }
#'
"CnR_H3K27ac"

#' ChromHMM annotation file
#'
#' ChromHMM annotation for human K562 cell-line.
#' Obtained from \url{http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/}
#' The annotation was subset for chromosome 1 only to reduce the size of data.
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' chrHMM_url <- "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmmK562HMM.bed.gz"
#' chrHMM <- genomation::readBed(chrHMM_url)
#' chr1_seqnames <- subset(chrHMM@seqnames, factor(chrHMM@seqnames) == "chr1") # subset chr1 seqnames
#' chr1_ranges <- chrHMM@ranges[1:67294] # subset chr1 ranges
#' chr1_strand <- chrHMM@strand[1:67294] # subset chr1 strand
#' chr1_elementMetadata <- chrHMM@elementMetadata[1:67294,] # subset chr1 element metadata
#' chrHMM@seqnames <- chr1_seqnames
#' chrHMM@ranges <- chr1_ranges
#' chrHMM@strand <- chr1_strand
#' chrHMM@elementMetadata <- chr1_elementMetadata
#' chromHMM_annotation_K562 <- GenomicRanges::split(chrHMM, chrHMM$name, drop = TRUE)
#' usethis::use_data(chromHMM_annotation_K562, overwrite = TRUE)
#' }
#'
"chromHMM_annotation_K562"

#' Human genome hg19 blacklisted regions
#' Obtained from \url{https://www.encodeproject.org/files/ENCFF000KJP/}
#' The ENCODE blacklist includes regions of the genome that have anomalous and/or unstructured signals
#' independent of the cell-line or experiment. Removal of ENCODE blacklist is recommended for quality measure.
#'
#' @source
#' The code to prepare the .Rda file is:
#' \code{
#' hg19_blacklist <- ChIPseeker::readPeakFile(file.path(path), as = "GRanges")
#' usethis::use_data(hg19_blacklist, overwrite = TRUE)
#' }
#'
"hg19_blacklist"
