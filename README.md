`EpiCompare`: QC and Benchmarking of Epigenetic Datasets
================
Sera Choi
23/11/2021

# Introduction

`EpiCompare` is an R package for QC and benchmarking epigenetic
datasets. It currently performs two functions:

1.  Calculates percentage of overlapping peaks in two peak files
2.  Performs ChromHMM for individual peak files, overlapping and unique
    peaks.

The function outputs a report in HTML format.

# Installation

How to install the package.

# Usage

Load package and example datasets. The two example peakfiles have been

``` r
library(EpiCompare)
data("encode_H3K27ac")
data("CnT_H3K27ac")
```

The two example peakfiles have been transformed into GRanges object. If
your peak files are in BED format, simply use
`ChIPseeker::readPeakFile("/path/to/peak/file", as = "GRanges")`.

``` r
EpiCompare(peakfile1 = encode_H3K27ac,
           peakfile1_name = "encode",
           peakfile2 = CnT_H3K27ac,
           peakfile2_name = "CUT&Tag",
           outpath = "./EpiCompare.html")
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
    ##  [1] compiler_4.0.2  magrittr_2.0.1  fastmap_1.1.0   tools_4.0.2    
    ##  [5] htmltools_0.5.2 yaml_2.2.1      stringi_1.7.5   rmarkdown_2.11 
    ##  [9] knitr_1.36      stringr_1.4.0   xfun_0.27       digest_0.6.28  
    ## [13] rlang_0.4.12    evaluate_0.14

</details>
