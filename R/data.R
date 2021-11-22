#' Example ChIP-seq peak file
#'
#' Human H3K27ac peak file generated with ChIP-seq using K562 cell-line.
#' Raw peak file (.BED) was obtained from ENCODE project (data accession: ENCFF044JNJ).
#' The BED file was then processed into GRanges object.
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' encode_H3K27ac <- ChIPseeker::readPeakFile("./data/ENCODE_H3K27ac.bed", as = "GRanges")
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
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' CnT_H3K27ac <- ChIPseeker::readPeakFile("./data/CnT_H3K27ac_MACS2.bed", as = "GRanges")
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
#'
#' @source
#' The code to prepare the .Rda file from the raw peak file is:
#' \code{
#' CnR_H3K27ac <- ChIPseeker::readPeakFile("./data/CnR_H3K27ac_MACS2.bed", as = "GRanges")
#' usethis::use_data(CnR_H3K27ac)
#' }
#'
"CnR_H3K27ac"

