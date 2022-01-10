`EpiCompare`: QC and Benchmarking of Epigenetic Datasets
================
Sera Choi
<h5>
<i>Updated</i>: Jan-10-2022
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

`EpiCompare` is an R package for that compares different epigenetic
datasets for quality control and benchmarking purposes. The function
outputs a report in HTML format consisting of three sections:

1.  General Metrics: Metrics on fragments (mapped and unique fragments,
    duplication rate) and peaks (blacklisted peaks and widths)
2.  Peak Overlaps: Percentage and statistical significance of
    overlapping and non-overlapping peaks
3.  Functional Annotation: Functional annotation (ChromHMM, motif and
    enrichment analysis) of peaks

# Installation

\[Include How to install the package!\]

# Usage

Load package and example datasets.

``` r
library(EpiCompare)
data("encode_H3K27ac")
data("CnT_H3K27ac")
data("CnR_H3K27ac")
data("hg19_blacklist")
```

Input files must be in GRanges object. To convert BED file into GRanges,
simply use
`ChIPseeker::readPeakFile("/path/to/peak/file", as = "GRanges")`. If
there are more than one peak files, the files must be listed. \[UPDATE\]

``` r
EpiCompare(peakfiles = list(encode_H3K27ac, CnT_H3K27ac, CnR_H3K27ac),
           names = c("ENCODE", "CnT", "CnR"),
           blacklist = hg19_blacklist,
           picard = list(encode_picard, CnT_picard, CnR_picard),
           picard_names = c("encode","CnT","CnR"),
           reference = encode_H3K27ac,
           stat_plot = TRUE,
           output_dir = "./")
```

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
    ## other attached packages:
    ## [1] EpiCompare_0.99.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] compiler_4.0.2   magrittr_2.0.1   fastmap_1.1.0    tools_4.0.2     
    ##  [5] htmltools_0.5.2  yaml_2.2.1       stringi_1.7.6    rmarkdown_2.11.3
    ##  [9] knitr_1.37       stringr_1.4.0    xfun_0.29        digest_0.6.29   
    ## [13] rlang_0.4.12     evaluate_0.14

</details>
