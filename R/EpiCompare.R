#' Compare Two Epigenetic Datasets
#'
#' This function calculates the percentage of overlapping peaks in two peak files.
#' It also performs ChromHMM on individual peak files, overlapping and unique peaks.
#' The output of this function is a knitted HTML file, which will be saved in the specified outpath.
#'
#' @param peakfile1_path Path to your peakfile 1
#' @param peakfile2_path Path to your peakfile 2
#' @param outpath Path to where you want the knitted HTML report
#'
#' @return a knitted HTML report containing results of the analysis
#' @export
#' @examples
#' EpiCompare(peakfile1_path = "path/to/peakfile1",
#'            peakfile2_path = "path/to/peakfile2",
#'            outpath = "path/for/output/report" )
#'
EpiCompare <- function(peakfile1_path, peakfile2_path, outpath){

  # read peakfiles as GRanges
  peakfile1 <- ChIPseeker::readPeakFile(peakfile1_path, as = "GRanges")
  peakfile2 <- ChIPseeker::readPeakFile(peakfile2_path, as = "GRanges")

  # subset overlapping peaks
  peakfile1_in_peakfile2 <- IRanges::subsetByOverlaps(x = peakfile1, ranges = peakfile2)
  peakfile2_in_peakfile1 <- IRanges::subsetByOverlaps(x = peakfile2, ranges = peakfile1)

  # subset unique peaks
  peakfile1_in_peakfile2_unique <- IRanges::subsetByOverlaps(x = peakfile1, ranges = peakfile2, invert = TRUE)
  peakfile2_in_peakfile1_unique <- IRanges::subsetByOverlaps(x = peakfile2, ranges = peakfile1, invert = TRUE)

  # calculate percentage of overlapping peaks
  percent_overlap_peakfile1 <- length(peakfile1_in_peakfile2)/length(peakfile1)*100
  percent_overlap_peakfile2 <- length(peakfile2_in_peakfile1)/length(peakfile2)*100

  # file names
  peakfile1_name <- basename(peakfile1_path)
  peakfile2_name <- basename(peakfile2_path)
  peakfile1_in_peakfile2_name <- paste0(peakfile1_name,"_in_",peakfile2_name)
  peakfile2_in_peakfile1_name <- paste0(peakfile2_name,"_in_",peakfile1_name)
  peakfile1_in_peakfile2_unique_name <- paste0(peakfile1_name,"_not_in_",peakfile2_name)
  peakfile2_in_peakfile1_unique_name <- paste0(peakfile2_name,"_not_in_",peakfile1_name)

  # download ChromHMM annotation file
  chrHMM_url <- "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmmK562HMM.bed.gz"
  chrHMM <- genomation::readBed(chrHMM_url)
  chrHMM_list <- GenomicRanges::split(chrHMM, chrHMM$name, drop = TRUE)

  # ChromHMM for individual peak files
  chrHMM_sample <- EpiCompare::plot_chrHMM(chrHMMfile1 = peakfile1,
                                           chrHMMfile1_name = peakfile1_name,
                                           chrHMMfile2 = peakfile2,
                                           chrHMMfile2_name = peakfile2_name,
                                           chrHMM_list = chrHMM_list)

  # ChromHMM for overlapping peaks
  chrHMM_overlap <- EpiCompare::plot_chrHMM(chrHMMfile1 = peakfile1_in_peakfile2,
                                            chrHMMfile1_name = peakfile1_in_peakfile2_name,
                                            chrHMMfile2 = peakfile2_in_peakfile1,
                                            chrHMMfile2_name = peakfile2_in_peakfile1_name,
                                            chrHMM_list = chrHMM_list)

  # ChromHMM for unique peaks
  chrHMM_unique <- plot_chrHMM(chrHMMfile1 = peakfile1_in_peakfile2_unique,
                              chrHMMfile1_name = peakfile1_in_peakfile2_unique_name,
                              chrHMMfile2 = peakfile2_in_peakfile1_unique,
                              chrHMMfile2_name = peakfile2_in_peakfile1_unique_name,
                              chrHMM_list = chrHMM_list)

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
               'Peak File 1: `r peakfile1_name` <br/>',
               'Peak File 2: `r peakfile2_name`',
               '## Percentage Overlap',
               'This function calculates the percentage of overlapping peaks in each file.
               By default, two peak ranges are considered as overlapping if:',
               '* The start or end position of a range is inside the other range',
               '* The overlap has a minimum distance of 1 base pair',
               '* The overlap can be of any type (i.e. start, end, within, equal are all accepted) <br/>',
               '',
               'Percentage of **`r peakfile1_name`** peaks found in **`r peakfile2_name`** peaks:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile1)',
               '```',
               'Percentage of **`r peakfile2_name`** peaks found in **`r peakfile1_name`** peaks:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile2)',
               '```',
               '<br/>',
               '## ChromHMM {.tabset}',
               'ChromHMM annotates peaks with ChromHMM-derived chromatin states.
               The annotations for cell-line K562 were obtained from
               http://genome.ucsc.edu/cgi-bin/hgFileUi?g=wgEncodeBroadHmm&db=hg19.
               The heatmap shows the relative percentages of total peaks falling into each category.
               Note that peaks can fall into multiple categories simultaneously.',
               '### Peak files',
               'ChromHMM annotation of individual peak files.',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_sample',
               '```',
               '### Overlapping peaks',
               'ChromHMM annotation of overlapping peaks in each file.',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_overlap',
               '```',
               '### Unique peaks',
               'ChromHMM annotation of unique peaks in each file.',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_unique',
               '```'
               )

  # knit into HTML
  markdown::markdownToHTML(text = knitr::knit(text = markobj), output = outpath)
}

