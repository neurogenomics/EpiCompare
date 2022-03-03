`EpiCompare`: QC and Benchmarking of Epigenetic Datasets
================
Sera Choi
<h5>
<i>Updated</i>: Mar-03-2022
</h5>

<!-- badges: start -->

[![](https://img.shields.io/badge/devel%20version-0.99.0-black.svg)](https://github.com/neurogenomics/EpiCompare)
[![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
[![](https://codecov.io/gh/neurogenomics/EpiCompare/branch/master/graph/badge.svg)](https://codecov.io/gh/neurogenomics/EpiCompare)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
<!-- badges: end -->

# Introduction

`EpiCompare` is an R package for comparing different epigenetic datasets
for quality control and benchmarking purposes. The function outputs a
report in HTML format consisting of three sections:

1.  General Metrics: Metrics on peaks (blacklisted peaks and peak
    widths) and fragments (duplication rate) of input epigenetic
    datasets
2.  Peak Overlap: Percentage and statistical significance of overlapping
    and non-overlapping peaks
3.  Functional Annotation: Functional annotation (ChromHMM, ChIPseeker
    and enrichment analysis) of peaks

N.B. All functional analyses performed by EpiCompare uses annotations
for human genome hg19. N.B. Peaks in blacklisted regions and
non-standard chromosomes are removed from peak files before any analysis

# Installation

To install `EpiCompare` use:

``` r
if(!require("remotes")) install.packages("remotes")
remotes::install_github("neurogenomics/EpiCompare")
```

# Usage

Load package and example datasets.

``` r
library(EpiCompare)
data("encode_H3K27ac") # example peakfile
data("CnT_H3K27ac") # example peakfile
data("CnR_H3K27ac") # example peakfile
data("hg19_blacklist") # example blacklist 
data("CnT_H3K27ac_picard") # example Picard summary output
data("CnR_H3K27ac_picard") # example Picard summary output
```

Prepare input files:

``` r
peaklist <- list(CnT_H3K27ac, CnR_H3K27ac) # create list of peakfiles 
names(peaklist) <- c("CnT", "CnR") # set names 
reference_peak <- list("ENCODE_H3K27ac" = encode_H3K27ac) # set ref file and name 
picard <- list(CnT_H3K27ac_picard, CnR_H3K27ac_picard) # create list of Picard summary
names(picard) <- c("CnT", "CnR") # set names 
```

Additional helps on preparing files:

``` r
# To import BED files as GRanges object
peak <-  ChIPseeker::readPeakFile("/path/to/peak/file.bed", as = "GRanges")
# EpiCompare also accepts paths (to BED files) as input 
peaklist <- list("/path/to/BED/file1.bed", "/path/to/BED/file2.bed")
names(peaklist) <- c("sample1","sample2")
# To import Picard summary output txt file as data frame 
picard <- read.table("/path/to/Picard/summary.txt", header = TRUE, fill = TRUE)
```

Run EpiCompare:

``` r
EpiCompare(peakfiles = peaklist,
           blacklist = hg19_blacklist,
           picard_files = picard,
           reference = reference_peak,
           stat_plot = TRUE,
           chrmHMM_plot = TRUE,
           chrmHMM_annotation = "K562",
           chipseeker_plot = TRUE,
           enrichment_plot = TRUE,
           interact = TRUE,
           save_output = TRUE,
           output_dir = "/path/to/output")
```

#### Mandatory Inputs

These input parameters must be provided:

-   `peakfiles` : Peakfiles you want to analyse. EpiCompare accepts
    peakfiles as GRanges object and/or as paths to BED files. Files must
    be listed using `list()` and named using for example,
    `names(peaklist) <- c("sample1","sample2)`
-   `blacklist` : Peakfile as GRanges object specifying genomic regions
    that have anomalous and/or unstructured signals independent of the
    cell-line or experiment. For human genome hg19, use
    `data(hg19_blacklist)` stored in the package.

#### Optional Inputs

-   `picard_files` : A list of summary metrics output from Picard. If
    provided, metrics on fragments (e.g. mapped fragments and
    duplication rate) will be included in the report. Files must be in
    data.frame format and listed using `list()` and named using
    `names()`. To import Picard duplication metrics (.txt file) into R
    as data frame, use
    `picard <- read.table("/path/to/picard/output", header = TRUE, fill = TRUE)`.
-   `reference` : Reference peak file is used in `stat_plot` and
    `chrmHMM_plot`. File must be in GRanges object, listed and named
    using `list("reference_name" = GRanges_obect)`

#### Optional Plots

By default, these plots will not be included in the report unless set
`TRUE`.

-   `stat_plot` : included only if a `reference` dataset is provided.
    The plot shows statistical significance (p/q-values) of sample peaks
    that are overlapping/non-overlapping with the `reference` dataset.
-   `chrmHMM_plot` : ChromHMM annotation of peaks. If a `reference`
    dataset is provided, ChromHMM annotation of overlapping and
    non-overlapping peaks with the `reference` is also included in the
    report.
-   `chipseeker_plot` : ChIPseeker annotation of peaks.
-   `enrichment_plot` : KEGG pathway and GO enrichment analysis of
    peaks.

#### Other Options

-   `chrmHMM_annotation` : Cell-line annotation for ChromHMM. Default is
    K562. Options are:
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

#### Outputs

`EpiCompare` outputs the following:

-   HTML report: A summary of all analyses saved in specified
    `output_dir`
-   EpiCompare_file: if `save_output=TRUE`, all plots generated by
    EpiCompare will be saved in EpiCompare_file directory also in
    specified `output_dir`

# Documentation

[EpiCompare Website](https://neurogenomics.github.io/EpiCompare)

# Example

\[how to run and link to an example html \]

# Session Info

<details>

``` r
utils::sessionInfo()
```

    ## R version 4.1.2 (2021-11-01)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS Big Sur 10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.1/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] tidyselect_1.1.2    xfun_0.29           purrr_0.3.4        
    ##  [4] colorspace_2.0-3    vctrs_0.3.8         generics_0.1.2     
    ##  [7] htmltools_0.5.2     usethis_2.1.5       yaml_2.3.5         
    ## [10] utf8_1.2.2          rlang_1.0.1         gert_1.5.0         
    ## [13] pillar_1.7.0        glue_1.6.2          DBI_1.1.2          
    ## [16] RColorBrewer_1.1-2  rvcheck_0.2.1       lifecycle_1.0.1    
    ## [19] stringr_1.4.0       dlstats_0.1.4       munsell_0.5.0      
    ## [22] gtable_0.3.0        evaluate_0.15       knitr_1.37         
    ## [25] fastmap_1.1.0       curl_4.3.2          sys_3.4            
    ## [28] fansi_1.0.2         openssl_1.4.6       scales_1.1.1       
    ## [31] BiocManager_1.30.16 desc_1.4.0          jsonlite_1.8.0     
    ## [34] fs_1.5.2            credentials_1.3.2   ggplot2_3.3.5      
    ## [37] askpass_1.1         digest_0.6.29       stringi_1.7.6      
    ## [40] gh_1.3.0            dplyr_1.0.8         grid_4.1.2         
    ## [43] rprojroot_2.0.2     cli_3.2.0           tools_4.1.2        
    ## [46] yulab.utils_0.0.4   magrittr_2.0.2      tibble_3.1.6       
    ## [49] crayon_1.5.0        pkgconfig_2.0.3     ellipsis_0.3.2     
    ## [52] assertthat_0.2.1    rmarkdown_2.11      httr_1.4.2         
    ## [55] rstudioapi_0.13     gitcreds_0.1.1      badger_0.1.0       
    ## [58] R6_2.5.1            compiler_4.1.2

</details>

## Contact

### [Neurogenomics Lab](https://www.neurogenomics.co.uk/)

UK Dementia Research Institute  
Department of Brain Sciences  
Faculty of Medicine  
Imperial College London  
[GitHub](https://github.com/neurogenomics)  
[DockerHub](https://hub.docker.com/orgs/neurogenomicslab)

<br>
