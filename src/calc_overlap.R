calc_overlap_chromHMM <- function(peakfile1_path, peakfile2_path, outpath){
  
  # Read as GRanges 
  peakfile1 <- ChIPseeker::readPeakFile(peakfile1_path, as = "GRanges")
  peakfile2 <- ChIPseeker::readPeakFile(peakfile2_path, as = "GRanges")
  
  # calculate overlap
  peakfile1_in_peakfile2 <- GenomicRanges::countOverlaps(query = peakfile1, subject = peakfile2)
  peakfile2_in_peakfile1 <- GenomicRanges::countOverlaps(query = peakfile2, subject = peakfile1)
  
  # calculate percentage of overlap 
  percent_overlap_peakfile1 <- length(peakfile1_in_peakfile2[peakfile1_in_peakfile2 != 0])/length(peakfile1_in_peakfile2)*100
  percent_overlap_peakfile2 <- length(peakfile2_in_peakfile1[peakfile2_in_peakfile1 != 0])/length(peakfile2_in_peakfile1)*100
  
  # ChromHMM
  peak_list <- GenomicRanges::GRangesList(PeakFile1 = peakfile1, PeakFile2 = peakfile2)
  chromHMM_annotation <- genomation::annotateWithFeatures(peak_list, chrHMM_list)
  
  # markdown object
  markobj <- c('---',
               'title: "EpiCompare',
               'output: html_document',
               '---',
               '',
               '# EpiCompare Report',
               '',
               'EpiCompare performs comparisons, benchmarking and QC of epigenetic datasets.',
               '### Dataset summary',
               'PeakFile 1: `r peakfile1_path` <br/>',
               'PeakFile 2: `r peakfile2_path`',
               '## Percentage Overlap',
               'Percentage of peaks from PeakFile1 found in PeakFile2:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile1)',
               '```',
               'Percentage of peaks from PeakFile2 found in PeakFile1:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile2)',
               '```',
               '## ChromHMM',
               'ChromHMM identifies...',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'genomation::heatTargetAnnotation(chromHMM_annotation, plot = TRUE)',
               '```'
               )
  
  markdown::markdownToHTML(text = knitr::knit(text = markobj), output = outpath)
}


# ChromHMM annotation file 
chrHMM_url <- "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmmK562HMM.bed.gz"
chrHMM <- genomation::readBed(chrHMM_url)
chrHMM_list <- GenomicRanges::split(chrHMM, chrHMM$name, drop = TRUE)

# Test function
calc_overlap_chromHMM(peakfile1_path = "./data/human_ac.broadPeak",
                      peakfile2_path = "./data/human_me.narrowPeak",
                      outpath = "./EpiCompare.html")















