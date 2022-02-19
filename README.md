`EpiCompare`: QC and Benchmarking of Epigenetic Datasets
================
Sera Choi
<h5>
<i>Updated</i>: Feb-16-2022
</h5>

<!-- badges: start -->
<!-- badger::badge_codecov() -->
<!-- copied from MungeSumstats README.Rmd -->
<!-- badger::badge_lifecycle("stable", "green") -->
<!-- badger::badge_last_commit()  -->
<!-- badger::badge_license() -->

[![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
[![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/DockerHub/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
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
```

Run EpiCompare:

``` r
peaklist <- list(encode_H3K27ac, CnT_H3K27ac, CnR_H3K27ac) 
namelist <- c("encode", "CnT", "CnR")
EpiCompare(peakfiles = peaklist,
           names = namelist,
           blacklist = hg19_blacklist,
           reference = encode_H3K27ac,
           stat_plot = TRUE,
           chrmHMM_plot = TRUE,
           chipseeker_plot = TRUE,
           enrichment_plot = TRUE,
           save_output = TRUE,
           output_dir = "/path/to/output")
```

#### Mandatory Inputs

These input parameters must be provided:

-   `peakfiles` : Peakfiles you want to analyse. The files must be in
    GRanges object. To convert BED files into GRanges, use
    `ChIPseeker::readPeakFile("/path/to/peak/file", as = "GRanges")`. If
    there are more than one peakfiles, the files must be listed using
    `list()`.
-   `namelist` : Names of peakfiles. If there are more than one, must be
    listed in the same order as peakfiles are listed using `c()`.
-   `blacklist` : Peakfile as GRanges object specifying genomic regions
    that have anomalous and/or unstructured signals independent of the
    cell-line or experiment. For human genome hg19, use
    `data(hg19_blacklist)` stored in the package.

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
-   `reference` : Reference peak file used in `stat_plot` and
    `chrmHMM_plot`. File must be in GRanges object.  
-   `chipseeker_plot` : ChIPseeker annotation of peaks.
-   `enrichment_plot` : KEGG pathway and GO enrichment analysis of
    peaks.

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

    ## R version 4.0.2 (2020-06-22)
    ## Platform: x86_64-apple-darwin17.0 (64-bit)
    ## Running under: macOS  10.16
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRblas.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.0/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.0.2   magrittr_2.0.1   fastmap_1.1.0    tools_4.0.2     
    ##  [5] htmltools_0.5.2  yaml_2.2.1       stringi_1.7.6    rmarkdown_2.11.3
    ##  [9] knitr_1.37       stringr_1.4.0    xfun_0.29        digest_0.6.29   
    ## [13] rlang_0.4.12     evaluate_0.14

</details>
