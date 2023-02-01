`EpiCompare`: QC and Benchmarking of Epigenomic Datasets
================
<img src= 'https://github.com/neurogenomics/EpiCompare/raw/master/inst/hex/hex.png' height= '600' ><br><br><br><br>
[![](https://img.shields.io/badge/devel%20version-1.3.0-black.svg)](https://github.com/neurogenomics/EpiCompare)
[![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/rworkflows/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
[![](https://img.shields.io/github/last-commit/neurogenomics/EpiCompare.svg)](https://github.com/neurogenomics/EpiCompare/commits/master)
[![](https://img.shields.io/github/languages/code-size/neurogenomics/EpiCompare.svg)](https://github.com/neurogenomics/EpiCompare)
[![](https://codecov.io/gh/neurogenomics/EpiCompare/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/EpiCompare)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/doi-https://doi.org/10.1101/2022.07.22.501149-blue.svg)](https://doi.org/https://doi.org/10.1101/2022.07.22.501149)
[![](https://img.shields.io/badge/release%20version-1.2.0-green.svg)](https://www.bioconductor.org/packages/EpiCompare)
[![](https://img.shields.io/badge/download-37/month-green.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![](https://img.shields.io/badge/download-403/total-green.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![download](http://www.bioconductor.org/shields/downloads/release/EpiCompare.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
¶ <h4> ¶ Authors: <i>Sera Choi, Brian Schilder, Leyla Abbasova, Alan
Murphy, Nathan Skene</i> ¶ </h4>
<h5> ¶ <i>Updated</i>: Jan-31-2023 ¶ </h5>

# Introduction

`EpiCompare` is an R package for comparing multiple epigenomic datasets
for quality control and benchmarking purposes. The function outputs a
report in HTML format consisting of three sections:

1.  General Metrics: Metrics on peaks (percentage of blacklisted and
    non-standard peaks, and peak widths) and fragments (duplication
    rate) of samples.
2.  Peak Overlap: Frequency, percentage, statistical significance of
    overlapping and non-overlapping peaks. This also includes Upset,
    precision-recall and correlation plots.
3.  Functional Annotation: Functional annotation (ChromHMM, ChIPseeker
    and enrichment analysis) of peaks. Also includes peak enrichment
    around Transcription Start Site.

*Notes*:

- Peaks located in blacklisted regions and non-standard chromosomes are
  removed from the files prior to analysis.

# Installation

To install `EpiCompare` use:

``` r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("EpiCompare") 
```

## Citation

If you use `EpiCompare`, please cite:

<!-- Modify this by editing the file: inst/CITATION  -->

> EpiCompare: R package for the comparison and quality control of
> epigenomic peak files (2022) Sera Choi, Brian M. Schilder, Leyla
> Abbasova, Alan E. Murphy, Nathan G. Skene bioRxiv 2022.07.22.501149;
> doi: <https://doi.org/10.1101/2022.07.22.501149>

# Documentation

## [EpiCompare website](https://neurogenomics.github.io/EpiCompare)

## [Docker/Singularity container](https://neurogenomics.github.io/EpiCompare/articles/docker)

# Usage

Load package and example datasets.

``` r
library(EpiCompare)
data("encode_H3K27ac") # example peakfile
data("CnT_H3K27ac") # example peakfile
data("CnR_H3K27ac") # example peakfile
data("hg19_blacklist") # hg19 blacklist 
data("CnT_H3K27ac_picard") # example Picard summary output
data("CnR_H3K27ac_picard") # example Picard summary output
```

Prepare input files:

``` r
# create named list of peakfiles 
peakfiles <- list("CnT"=CnT_H3K27ac, 
                  "CnR"=CnR_H3K27ac) 
# set ref file and name 
reference <- list("ENCODE_H3K27ac" = encode_H3K27ac) 
# create named list of Picard summary
picard_files <- list("CnT"=CnT_H3K27ac_picard, 
                     "CnR"=CnR_H3K27ac_picard) 
```

Additional helps on preparing files:

``` r
# To import BED files as GRanges object
peakfiles <-  EpiCompare::gather_files(dir = "path/to/peak", 
                                       type = "peaks.stringent")
# EpiCompare alternatively accepts paths (to BED files) as input 
peakfiles <- list(sample1="/path/to/peak/file1_peaks.stringent.bed", 
                  sample2="/path/to/peak/file2_peaks.stringent.bed")
# To import Picard summary output txt file as data frame
picard_files <- EpiCompare::gather_files(dir = "path/to/peak", 
                                         type = "picard")
```

Run `EpiCompare()`:

``` r
EpiCompare(peakfiles = peakfiles,
           genome_build = list(peakfiles="hg19",
                               reference="hg38",
                               blacklist="hg19"),
           genome_build_output = "hg19",
           blacklist = hg19_blacklist,
           picard_files = picard_files,
           reference = reference,
           upset_plot = TRUE,
           stat_plot = TRUE,
           chromHMM_plot = TRUE,
           chromHMM_annotation = "K562",
           chipseeker_plot = TRUE,
           enrichment_plot = TRUE,
           tss_plot = TRUE,
           interact = TRUE,
           save_output = TRUE,
           output_dir = "/path/to/output")
```

#### Mandatory Inputs

These input parameters must be provided:

- `peakfiles` : Peakfiles you want to analyse. EpiCompare accepts
  peakfiles as GRanges object and/or as paths to BED files. Files must
  be listed and named using `list()`. E.g.
  `list("name1"=peakfile1, "name2"=peakfile2)`.
- `genome_build` : A named list indicating the human genome build used
  to generate each of the following inputs:
  - `peakfiles` : Genome build for the `peakfiles` input. Assumes genome
    build is the same for each element in the `peakfiles` list.
  - `reference` : Genome build for the `reference` input.
  - `blacklist` : Genome build for the `blacklist` input. <br> E.g.
    `genome_build = list(peakfiles="hg38", reference="hg19", blacklist="hg19")`
- `genome_build_output` Genome build to standardise all inputs to.
  Liftovers will be performed automatically as needed. Default is
  “hg19”.
- `blacklist` : Peakfile as GRanges object specifying genomic regions
  that have anomalous and/or unstructured signals independent of the
  cell-line or experiment. For human hg19 and hg38 genome, use built-in
  data `data(hg19_blacklist)` and `data(hg38_blacklist)` respectively.
- `output_dir` : Please specify the path to directory, where all
  EpiCompare outputs will be saved.

#### Optional Inputs

- `picard_files` : A list of summary metrics output from
  [Picard](https://broadinstitute.github.io/picard/). *Picard
  MarkDuplicates* can be used to identify the duplicate reads amongst
  the alignment. This tool generates a summary output, normally with the
  ending *.markdup.MarkDuplicates.metrics.txt*. If this input is
  provided, metrics on fragments (e.g. mapped fragments and duplication
  rate) will be included in the report. Files must be in data.frame
  format and listed using `list()` and named using `names()`. To import
  Picard duplication metrics (.txt file) into R as data frame, use
  `picard <- read.table("/path/to/picard/output", header = TRUE, fill = TRUE)`.
- `reference` : Reference peak file(s) is used in `stat_plot` and
  `chromHMM_plot`. File must be in GRanges object, listed and named
  using `list("reference_name" = GRanges_obect)`. If more than one
  reference is specified, EpiCompare outputs individual reports for each
  reference. However, please note that this can take awhile.

#### Optional Plots

By default, these plots will not be included in the report unless set
`TRUE`.

- `upset_plot` : Upset plot of overlapping peaks between samples.
- `stat_plot` : included only if a `reference` dataset is provided. The
  plot shows statistical significance (p/q-values) of sample peaks that
  are overlapping/non-overlapping with the `reference` dataset.
- `chromHMM_plot` : ChromHMM annotation of peaks. If a `reference`
  dataset is provided, ChromHMM annotation of overlapping and
  non-overlapping peaks with the `reference` is also included in the
  report.
- `chipseeker_plot` : ChIPseeker annotation of peaks.
- `enrichment_plot` : KEGG pathway and GO enrichment analysis of peaks.
- `tss_plot` : Peak frequency around (+/- 3000bp) transcriptional start
  site. Note that it may take awhile to generate this plot for large
  sample sizes.
- `precision_recall_plot` : Plot showing the precision-recall score
  across the peak calling stringency thresholds.
- `corr_plot` : Plot showing the correlation between the quantiles when
  the genome is binned at a set size. These quantiles are based on the
  intensity of the peak, dependent on the peak caller used (q-value for
  MACS2).

#### Other Options

- `chromHMM_annotation` : Cell-line annotation for ChromHMM. Default is
  K562. Options are:
  - “K562” = K-562 cells
  - “Gm12878” = Cellosaurus cell-line GM12878
  - “H1hesc” = H1 Human Embryonic Stem Cell
  - “Hepg2” = Hep G2 cell
  - “Hmec” = Human Mammary Epithelial Cell
  - “Hsmm” = Human Skeletal Muscle Myoblasts
  - “Huvec” = Human Umbilical Vein Endothelial Cells
  - “Nhek” = Normal Human Epidermal Keratinocytes
  - “Nhlf” = Normal Human Lung Fibroblasts
- `interact` : By default, all heatmaps (percentage overlap and ChromHMM
  heatmaps) in the report will be interactive. If set FALSE, all
  heatmaps will be static. N.B. If `interact=TRUE`, interactive heatmaps
  will be saved as html files, which may take time for larger sample
  sizes.
- `output_filename` : By default, the report is named EpiCompare.html.
  You can specify the filename of the report here.
- `output_timestamp` : By default FALSE. If TRUE, the filename of the
  report includes the date.

#### Outputs

`EpiCompare` outputs the following:

1.  HTML report: A summary of all analyses saved in specified
    `output_dir`
2.  EpiCompare_file: if `save_output=TRUE`, all plots generated by
    EpiCompare will be saved in EpiCompare_file directory also in
    specified `output_dir`

An example report comparing ATAC-seq and Dnase-seq can be found
[here](https://neurogenomics.github.io/EpiCompare/inst/report/EpiCompare_example.html)

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.2.1 (2022-06-23)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur ... 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] pillar_1.8.1        compiler_4.2.1      RColorBrewer_1.1-3 
    ##  [4] BiocManager_1.30.19 yulab.utils_0.0.6   tools_4.2.1        
    ##  [7] digest_0.6.31       jsonlite_1.8.4      evaluate_0.20      
    ## [10] lifecycle_1.0.3     tibble_3.1.8        gtable_0.3.1       
    ## [13] pkgconfig_2.0.3     rlang_1.0.6         cli_3.6.0          
    ## [16] rstudioapi_0.14     rvcheck_0.2.1       yaml_2.3.7         
    ## [19] xfun_0.36           fastmap_1.1.0       dplyr_1.1.0        
    ## [22] knitr_1.42          generics_0.1.3      desc_1.4.2         
    ## [25] vctrs_0.5.2         dlstats_0.1.6       rprojroot_2.0.3    
    ## [28] grid_4.2.1          tidyselect_1.2.0    here_1.0.1         
    ## [31] glue_1.6.2          R6_2.5.1            fansi_1.0.4        
    ## [34] rmarkdown_2.20      ggplot2_3.4.0       badger_0.2.2       
    ## [37] magrittr_2.0.3      scales_1.2.1        htmltools_0.5.4    
    ## [40] rworkflows_0.99.5   colorspace_2.1-0    utf8_1.2.2         
    ## [43] munsell_0.5.0

</details>

## Contact

### [Neurogenomics Lab](https://www.neurogenomics.co.uk/inst/report/EpiCompare.html)

UK Dementia Research Institute  
Department of Brain Sciences  
Faculty of Medicine  
Imperial College London  
[GitHub](https://github.com/neurogenomics)  
[DockerHub](https://hub.docker.com/orgs/neurogenomicslab)

<br>
