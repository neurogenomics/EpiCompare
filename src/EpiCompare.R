EpiCompare <- function(peakfile1_path, peakfile2_path, outpath){
  
  # read as GRanges 
  peakfile1 <- ChIPseeker::readPeakFile(peakfile1_path, as = "GRanges")
  peakfile2 <- ChIPseeker::readPeakFile(peakfile2_path, as = "GRanges")
  
  # subset overlapping peaks 
  peakfile1_in_peakfile2 <- IRanges::subsetByOverlaps(x = peakfile1, ranges = peakfile2)
  peakfile2_in_peakfile1 <- IRanges::subsetByOverlaps(x = peakfile2, ranges = peakfile1)
  
  # subset unique peaks
  peakfile1_in_peakfile2_unique <- IRanges::subsetByOverlaps(x = peakfile1, ranges = peakfile2, invert = TRUE)
  peakfile2_in_peakfile1_unique <- IRanges::subsetByOverlaps(x = peakfile2, ranges = peakfile1, invert = TRUE)
  
  # calculate percentage of overlap 
  percent_overlap_peakfile1 <- length(peakfile1_in_peakfile2)/length(peakfile1)*100
  percent_overlap_peakfile2 <- length(peakfile2_in_peakfile1)/length(peakfile2)*100
  
  # file names 
  peakfile1_name <- basename(peakfile1_path)
  peakfile2_name <- basename(peakfile2_path)
  peakfile1_in_peakfile2_name <- paste0(peakfile1_name,"_in_",peakfile2_name)
  peakfile2_in_peakfile1_name <- paste0(peakfile2_name,"_in_",peakfile1_name)
  peakfile1_in_peakfile2_unique_name <- paste0(peakfile1_name,"_not_in_",peakfile2_name)
  peakfile2_in_peakfile1_unique_name <- paste0(peakfile2_name,"_not_in_",peakfile1_name)
    
  # ChromHMM
  chrHMM_url <- "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/encodeDCC/wgEncodeBroadHmm/wgEncodeBroadHmmK562HMM.bed.gz"
  chrHMM <- genomation::readBed(chrHMM_url)
  chrHMM_list <- GenomicRanges::split(chrHMM, chrHMM$name, drop = TRUE)
  
  plot_chrHMM <- function(chrHMMfile1,chrHMMfile1_name, chrHMMfile2, chrHMMfile2_name){
    peak_list <- GenomicRanges::GRangesList(file1 = chrHMMfile1, file2 = chrHMMfile2)
    chromHMM_annotation <- genomation::annotateWithFeatures(peak_list, chrHMM_list)
    matrix <- genomation::heatTargetAnnotation(chromHMM_annotation, plot = FALSE)
    rownames(matrix) <- c(chrHMMfile1_name, chrHMMfile2_name)
    matrix_melt <- reshape2::melt(matrix)
    colnames(matrix_melt) = c("Sample", "State", "value")
    
    # Plot
    chrHMM_plot <- ggplot(matrix_melt) +
      geom_tile(aes(x = State, y = Sample, fill = value)) +
      ylab("") +
      xlab("") +
      scale_fill_viridis() +
      theme_minimal() +
      ggpubr::rotate_x_text(angle = 45) +
      theme(axis.text = element_text(size = 11))
    
    return(chrHMM_plot)
  }
  
  # sample 
  chrHMM_sample <- plot_chrHMM(chrHMMfile1 = peakfile1,
                               chrHMMfile1_name = peakfile1_name,
                               chrHMMfile2 = peakfile2,
                               chrHMMfile2_name = peakfile2_name)
  
  # overlapping
  chrHMM_overlap <- plot_chrHMM(chrHMMfile1 = peakfile1_in_peakfile2,
                                chrHMMfile1_name = peakfile1_in_peakfile2_name,
                                chrHMMfile2 = peakfile2_in_peakfile1,
                                chrHMMfile2_name = peakfile2_in_peakfile1_name)
  
  # unique
  chrHMM_unique <- plot_chrHMM(chrHMMfile1 = peakfile1_in_peakfile2_unique,
                              chrHMMfile1_name = peakfile1_in_peakfile2_unique_name,
                              chrHMMfile2 = peakfile2_in_peakfile1_unique,
                              chrHMMfile2_name = peakfile2_in_peakfile1_unique_name)
  
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
               'Percentage of peaks from **`r peakfile1_name`** found in **`r peakfile2_name`**:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile1)',
               '```',
               'Percentage of peaks from **`r peakfile2_name`** found in **`r peakfile1_name`**:',
               '```{r, echo=FALSE}',
               'print(percent_overlap_peakfile2)',
               '```',
               '## ChromHMM',
               'ChromHMM annotates the chromatin state. Annotations obtained from 
               http://genome.ucsc.edu/cgi-bin/hgFileUi?g=wgEncodeBroadHmm&db=hg19',
               '### Peak files',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_sample',
               '```',
               '### Overlapping peaks',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_overlap',
               '```',
               '### Unique peaks',
               '```{r, echo=FALSE, warning=FALSE, fig.width = 9}',
               'chrHMM_unique',
               '```'
               )
  
  # knit into HTML 
  markdown::markdownToHTML(text = knitr::knit(text = markobj), output = outpath)
}

# Test function
EpiCompare(peakfile1_path = "./data/H3K27ac",
           peakfile2_path = "./data/H3K27me",
           outpath = "./EpiCompare.html")


