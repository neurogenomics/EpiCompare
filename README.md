`EpiCompare`: QC and Benchmarking of Epigenetic Datasets
================
<img src='https://github.com/neurogenomics/EpiCompare/raw/master/inst/hex/hex.png' height='300'><br><br>
[![](https://img.shields.io/badge/devel%20version-0.99.20-black.svg)](https://github.com/neurogenomics/EpiCompare)
[![](https://img.shields.io/badge/release%20version-1.0.0-green.svg)](https://www.bioconductor.org/packages/EpiCompare)
[![BioC
status](http://www.bioconductor.org/shields/build/devel/bioc/EpiCompare.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/EpiCompare)
[![platforms](http://www.bioconductor.org/images/shields/availability/all.svg)](https://bioconductor.org/packages/devel/bioc/html/EpiCompare.html#archives)
[![](https://img.shields.io/badge/doi-https://doi.org/doi:10.18129/B9.bioc.EpiCompare-green.svg)](https://doi.org/https://doi.org/doi:10.18129/B9.bioc.EpiCompare)
[![](https://img.shields.io/badge/download-69/total-green.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
[![](https://img.shields.io/github/last-commit/neurogenomics/EpiCompare.svg)](https://github.com/neurogenomics/EpiCompare/commits/master)
[![](https://app.codecov.io/gh/neurogenomics/EpiCompare/branch/master/graph/badge.svg)](https://app.codecov.io/gh/neurogenomics/EpiCompare)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
<h4>
Authors: <i>Sera Choi, Brian Schilder, Leyla Abbasova, Alan Murphy,
Nathan Skene</i>
</h4>
<h5>
<i>Updated</i>: Jun-14-2022
</h5>

# Introduction

`EpiCompare` is an R package for comparing multiple epigenetic datasets
for quality control and benchmarking purposes. The function outputs a
report in HTML format consisting of three sections:

1.  General Metrics: Metrics on peaks (percentage of blacklisted and
    non-standard peaks, and peak widths) and fragments (duplication
    rate) of samples.
2.  Peak Overlap: Percentage and statistical significance of overlapping
    and non-overlapping peaks. Also includes an upset plot.
3.  Functional Annotation: Functional annotation (ChromHMM, ChIPseeker
    and enrichment analysis) of peaks. Also includes peak enrichment
    around Transcription Start Site.

*Notes*:

-   All functional analyses performed by `EpiCompare` uses annotations
    for human genome hg19 or hg38. <br>
-   Peaks located in blacklisted regions and non-standard chromosomes
    are removed from the files prior to analysis.

# Installation

To install `EpiCompare` use:

``` r
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("EpiCompare") 
```

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
peaklist <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac) # create named list of peakfiles 
reference_peak <- list("ENCODE_H3K27ac" = encode_H3K27ac) # set ref file and name 
picard <- list("CnT"=CnT_H3K27ac_picard, "CnR"=CnR_H3K27ac_picard) # create named list of Picard summary
```

Additional helps on preparing files:

``` r
# To import BED files as GRanges object
peak <-  ChIPseeker::readPeakFile("/path/to/peak/file.bed", as = "GRanges")
# EpiCompare also accepts paths (to BED files) as input 
peaklist <- list("sample1"="/path/to/BED/file1.bed", 
                 "sample2"="/path/to/BED/file2.bed")
# To import Picard summary output txt file as data frame 
picard <- read.table("/path/to/Picard/summary.txt", header = TRUE, fill = TRUE)
```

Run `EpiCompare()`:

``` r
EpiCompare(peakfiles = peaklist,
           genome_build = list(peakfiles="hg19",
                               reference="hg38",
                               blacklist="hg19"),
           genome_build_output = "hg19",
           blacklist = hg19_blacklist,
           picard_files = picard,
           reference = reference_peak,
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

-   `peakfiles` : Peakfiles you want to analyse. EpiCompare accepts
    peakfiles as GRanges object and/or as paths to BED files. Files must
    be listed and named using `list()`. E.g.
    `list("name1"=peakfile1, "name2"=peakfile2)`.
-   `genome_build` : A named list indicating the human genome build used
    to generate each of the following inputs:
    -   `peakfiles` : Genome build for the `peakfiles` input. Assumes
        genome build is the same for each element in the `peakfiles`
        list.
    -   `reference` : Genome build for the `reference` input.
    -   `blacklist` : Genome build for the `blacklist` input. <br> E.g.
        `genome_build = list(peakfiles="hg38", reference="hg19", blacklist="hg19")`
-   `genome_build_output` Genome build to standardise all inputs to.
    Liftovers will be performed automatically as needed. Default is
    “hg19”.
-   `blacklist` : Peakfile as GRanges object specifying genomic regions
    that have anomalous and/or unstructured signals independent of the
    cell-line or experiment. For human hg19 and hg38 genome, use
    built-in data `data(hg19_blacklist)` and `data(hg38_blacklist)`
    respectively.
-   `output_dir` : Please specify the path to directory, where all
    EpiCompare outputs will be saved.

#### Optional Inputs

-   `picard_files` : A list of summary metrics output from
    [Picard](https://broadinstitute.github.io/picard/). *Picard
    MarkDuplicates* can be used to identify the duplicate reads amongst
    the alignment. This tool generates a summary output, normally with
    the ending *.markdup.MarkDuplicates.metrics.txt*. If this input is
    provided, metrics on fragments (e.g. mapped fragments and
    duplication rate) will be included in the report. Files must be in
    data.frame format and listed using `list()` and named using
    `names()`. To import Picard duplication metrics (.txt file) into R
    as data frame, use
    `picard <- read.table("/path/to/picard/output", header = TRUE, fill = TRUE)`.
-   `reference` : Reference peak file(s) is used in `stat_plot` and
    `chromHMM_plot`. File must be in GRanges object, listed and named
    using `list("reference_name" = GRanges_obect)`. If more than one
    reference is specified, EpiCompare outputs individual reports for
    each reference. However, please note that this can take awhile.

#### Optional Plots

By default, these plots will not be included in the report unless set
`TRUE`.

-   `upset_plot` : Upset plot of overlapping peaks between samples.
-   `stat_plot` : included only if a `reference` dataset is provided.
    The plot shows statistical significance (p/q-values) of sample peaks
    that are overlapping/non-overlapping with the `reference` dataset.
-   `chromHMM_plot` : ChromHMM annotation of peaks. If a `reference`
    dataset is provided, ChromHMM annotation of overlapping and
    non-overlapping peaks with the `reference` is also included in the
    report.
-   `chipseeker_plot` : ChIPseeker annotation of peaks.
-   `enrichment_plot` : KEGG pathway and GO enrichment analysis of
    peaks.
-   `tss_plot` : Peak frequency around (+/- 3000bp) transcriptional
    start site. Note that it may take awhile to generate this plot for
    large sample sizes.

#### Other Options

-   `chromHMM_annotation` : Cell-line annotation for ChromHMM. Default
    is K562. Options are:
    -   “K562” = K-562 cells
    -   “Gm12878” = Cellosaurus cell-line GM12878
    -   “H1hesc” = H1 Human Embryonic Stem Cell
    -   “Hepg2” = Hep G2 cell
    -   “Hmec” = Human Mammary Epithelial Cell
    -   “Hsmm” = Human Skeletal Muscle Myoblasts
    -   “Huvec” = Human Umbilical Vein Endothelial Cells
    -   “Nhek” = Normal Human Epidermal Keratinocytes
    -   “Nhlf” = Normal Human Lung Fibroblasts
-   `interact` : By default, all heatmaps (percentage overlap and
    ChromHMM heatmaps) in the report will be interactive. If set FALSE,
    all heatmaps will be static. N.B. If `interact=TRUE`, interactive
    heatmaps will be saved as html files, which may take time for larger
    sample sizes.
-   `output_filename` : By default, the report is named EpiCompare.html.
    You can specify the filename of the report here.
-   `output_timestamp` : By default FALSE. If TRUE, the filename of the
    report includes the date.

#### Outputs

`EpiCompare` outputs the following:

1.  HTML report: A summary of all analyses saved in specified
    `output_dir`
2.  EpiCompare_file: if `save_output=TRUE`, all plots generated by
    EpiCompare will be saved in EpiCompare_file directory also in
    specified `output_dir`

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.2.0 (2022-04-22)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur/Monterey 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.2/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] BiocManager_1.30.18 compiler_4.2.0      pillar_1.7.0       
    ##  [4] RColorBrewer_1.1-3  yulab.utils_0.0.4   tools_4.2.0        
    ##  [7] digest_0.6.29       jsonlite_1.8.0      evaluate_0.15      
    ## [10] lifecycle_1.0.1     tibble_3.1.7        gtable_0.3.0       
    ## [13] pkgconfig_2.0.3     rlang_1.0.2         DBI_1.1.2          
    ## [16] cli_3.3.0           rstudioapi_0.13     rvcheck_0.2.1      
    ## [19] yaml_2.3.5          xfun_0.31           fastmap_1.1.0      
    ## [22] stringr_1.4.0       dplyr_1.0.9         knitr_1.39         
    ## [25] desc_1.4.1          generics_0.1.2      vctrs_0.4.1        
    ## [28] dlstats_0.1.5       rprojroot_2.0.3     grid_4.2.0         
    ## [31] tidyselect_1.1.2    glue_1.6.2          R6_2.5.1           
    ## [34] fansi_1.0.3         rmarkdown_2.14      ggplot2_3.3.6      
    ## [37] purrr_0.3.4         badger_0.2.1        magrittr_2.0.3     
    ## [40] scales_1.2.0        ellipsis_0.3.2      htmltools_0.5.2    
    ## [43] assertthat_0.2.1    colorspace_2.0-3    utf8_1.2.2         
    ## [46] stringi_1.7.6       munsell_0.5.0       crayon_1.5.1

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
