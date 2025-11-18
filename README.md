⚖<code>EpiCompare</code>⚖<br>QC and Benchmarking of Epigenomic Datasets
================
<img src='https://github.com/neurogenomics/EpiCompare/raw/master/inst/hex/hex.png' title='Hex sticker for EpiCompare' height='300'><br>
[![](https://img.shields.io/badge/release%20version-1.15.0-green.svg)](https://www.bioconductor.org/packages/EpiCompare)
[![](https://img.shields.io/badge/download-159/month-green.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![](https://img.shields.io/badge/download-3149/total-green.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![download](http://www.bioconductor.org/shields/downloads/release/EpiCompare.svg)](https://bioconductor.org/packages/stats/bioc/EpiCompare)
[![License:
GPL-3](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://cran.r-project.org/web/licenses/GPL-3)
[![](https://img.shields.io/badge/doi-https://doi.org/10.1101/2022.07.22.501149-blue.svg)](https://doi.org/https://doi.org/10.1101/2022.07.22.501149)
<br>
[![](https://img.shields.io/badge/devel%20version-1.15.0-black.svg)](https://github.com/neurogenomics/EpiCompare)
[![](https://img.shields.io/github/languages/code-size/neurogenomics/EpiCompare.svg)](https://github.com/neurogenomics/EpiCompare)
[![](https://img.shields.io/github/last-commit/neurogenomics/EpiCompare.svg)](https://github.com/neurogenomics/EpiCompare/commits/master)
<br> [![R build
status](https://github.com/neurogenomics/EpiCompare/workflows/rworkflows/badge.svg)](https://github.com/neurogenomics/EpiCompare/actions)
[![](https://codecov.io/gh/neurogenomics/EpiCompare/branch/master/graph/badge.svg)](https://app.codecov.io/gh/neurogenomics/EpiCompare)
<br>
<a href='https://app.codecov.io/gh/neurogenomics/EpiCompare/tree/master' target='_blank'><img src='https://codecov.io/gh/neurogenomics/EpiCompare/branch/master/graphs/icicle.svg' title='Codecov icicle graph' width='200' height='50' style='vertical-align: top;'></a>  
<h4>  
Authors: <i>Sera Choi, Brian Schilder, Leyla Abbasova, Alan Murphy,
Nathan Skene, Thomas Roberts, Hiranyamaya Dash</i>  
</h4>
<h5>  
<i>Updated</i>: Nov-18-2025  
</h5>

# Introduction

`EpiCompare` is an R package for comparing multiple epigenomic datasets
for quality control and benchmarking purposes. The function outputs a
report in HTML format consisting of three sections:

1.  **General Metrics**: Metrics on peaks (percentage of blacklisted and
    non-standard peaks, and peak widths) and fragments (duplication
    rate) of samples.
2.  **Peak Overlap**: Frequency, percentage, statistical significance of
    overlapping and non-overlapping peaks. This also includes Upset,
    precision-recall and correlation plots.
3.  **Functional Annotation**: Functional annotation (ChromHMM,
    ChIPseeker and enrichment analysis) of peaks. Also includes peak
    enrichment around Transcription Start Site.

*Note*: Peaks located in blacklisted regions and non-standard
chromosomes are removed from the files prior to analysis.

# Installation

## Standard

To install `EpiCompare` use:

``` r
if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
BiocManager::install("EpiCompare") 
```

## All dependencies

<details>

<summary>

👈 <strong>Details</strong>
</summary>

Installing all *Imports* and *Suggests* will allow you to use the full
functionality of `EpiCompare` right away, without having to stop and
install extra dependencies later on.

To install these packages as well, use:

``` r
BiocManager::install("EpiCompare", dependencies=TRUE) 
```

Note that this will increase installation time, but it means that you
won’t have to worry about installing any R packages when using functions
with certain suggested dependencies

</details>

## Development

<details>

<summary>

👈 <strong>Details</strong>
</summary>

To install the development version of `EpiCompare`, use:

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("neurogenomics/EpiCompare")
```

</details>

## Citation

If you use `EpiCompare`, please cite:

<!-- Modify this by editing the file: inst/CITATION  -->

> EpiCompare: R package for the comparison and quality control of
> epigenomic peak files (2022) Sera Choi, Brian M. Schilder, Leyla
> Abbasova, Alan E. Murphy, Nathan G. Skene, bioRxiv, 2022.07.22.501149;
> doi: <https://doi.org/10.1101/2022.07.22.501149>

# Documentation

## [EpiCompare website](https://neurogenomics.github.io/EpiCompare)

## [Docker/Singularity container](https://neurogenomics.github.io/EpiCompare/articles/docker)

## [Bioconductor page](https://doi.org/doi:10.18129/B9.bioc.EpiCompare)

### :warning: Note on documentation versioning

The documentation in this README and the [GitHub Pages
website](https://neurogenomics.github.io/EpiCompare/) pertains to the
*development* version of `EpiCompare`. Older versions of `EpiCompare`
may have slightly different documentation (e.g. available functions,
parameters). For documentation in older versions of `EpiCompare`, please
see the **Documentation** section of the relevant version on
[Bioconductor](https://doi.org/doi:10.18129/B9.bioc.EpiCompare)

# Usage

Load package and example datasets.

``` r
library(EpiCompare)
data("encode_H3K27ac") # example peakfile
data("CnT_H3K27ac") # example peakfile
data("CnR_H3K27ac") # example peakfile
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

<details>

<summary>

<strong>👈 Tips on importing user-supplied files</strong>
</summary>

`EpiCompare::gather_files` is helpful for identifying and importing peak
or picard files.

``` r
# To import BED files as GRanges object
peakfiles <- EpiCompare::gather_files(dir = "path/to/peaks/", 
                                      type = "peaks.stringent")
# EpiCompare alternatively accepts paths (to BED files) as input 
peakfiles <- list(sample1="/path/to/peaks/file1_peaks.stringent.bed", 
                  sample2="/path/to/peaks/file2_peaks.stringent.bed")
# To import Picard summary output txt file as data frame
picard_files <- EpiCompare::gather_files(dir = "path/to/peaks", 
                                         type = "picard")
```

</details>

Run `EpiCompare()`:

``` r
EpiCompare::EpiCompare(peakfiles = peakfiles,
                       genome_build = list(peakfiles="hg19",
                                           reference="hg38"),
                       genome_build_output = "hg19", 
                       picard_files = picard_files,
                       reference = reference,
                       run_all = TRUE
                       output_dir = tempdir())
```

#### Required Inputs

These input parameters must be provided:

<details>

<summary>

👈 <strong>Details</strong>
</summary>

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
  For mouse mm10 genome, use built-in data `data(mm10_blacklist)`.
- `output_dir` : Please specify the path to directory, where all
  `EpiCompare` outputs will be saved.

</details>

#### Optional Inputs

The following input files are optional:

<details>

<summary>

👈 <strong>Details</strong>
</summary>

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
  `chromHMM_plot`. File must be in `GRanges` object, listed and named
  using `list("reference_name" = GRanges_obect)`. If more than one
  reference is specified, `EpiCompare` outputs individual reports for
  each reference. However, please note that this can take awhile.

</details>

#### Optional Plots

By default, these plots will not be included in the report unless set to
`TRUE`. To turn on all features at once, simply use the `run_all=TRUE`
argument:

<details>

<summary>

👈 <strong>Details</strong>
</summary>

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

</details>

#### Other Options

<details>

<summary>

👈 <strong>Details</strong>
</summary>

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
- `output_filename` : By default, the report is named *EpiCompare.html*.
  You can specify the file name of the report here.
- `output_timestamp` : By default FALSE. If TRUE, the filename of the
  report includes the date.

</details>

#### Outputs

`EpiCompare` outputs the following:

1.  **HTML report**: A summary of all analyses saved in specified
    `output_dir`
2.  **EpiCompare_file**: if `save_output=TRUE`, all plots generated by
    `EpiCompare` will be saved in *EpiCompare_file* directory also in
    specified `output_dir`

An example report comparing ATAC-seq and DNase-seq can be found
[here](https://neurogenomics.github.io/EpiCompare/articles/example_report)

## Datasets

`EpiCompare` includes several built-in datasets:

<details>

<summary>

👈 <strong>Details</strong>
</summary>

- `encode_H3K27ac`: Human H3K27ac peak file generated with ChIP-seq
  using K562 cell-line. Taken from
  [ENCODE](https://www.encodeproject.org/files/ENCFF044JNJ/) project.
  For more information, run `?encode_H3K27ac`.  
- `CnT_H3K27ac`: Human H3K27ac peak file generated with CUT&Tag using
  K562 cell-line from [Kaya-Okur et al.,
  (2019)](https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR8383507).
  For more information, run `?CnT_H3K27ac`.
- `CnR_H3K27ac`: Human H3K27ac peak file generated with CUT&Run using
  K562 cell-line from [Meers et al.,
  (2019)](https://trace.ncbi.nlm.nih.gov/Traces/sra/?run=SRR8581604).
  For more details, run `?CnR_H3K27ac`.

</details>

## Contact

### [Neurogenomics Lab](https://www.neurogenomics.co.uk/inst/report/EpiCompare.html)

UK Dementia Research Institute  
Department of Brain Sciences  
Faculty of Medicine  
Imperial College London  
[GitHub](https://github.com/neurogenomics)  
[DockerHub](https://hub.docker.com/orgs/neurogenomicslab)

## Session Info

<details>

<summary>

👈 <strong>Details</strong>
</summary>

``` r
utils::sessionInfo()
```

    ## R Under development (unstable) (2025-10-27 r88972)
    ## Platform: aarch64-apple-darwin20
    ## Running under: macOS Tahoe 26.1
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/4.6-arm64/Resources/lib/libRblas.0.dylib 
    ## LAPACK: /Library/Frameworks/R.framework/Versions/4.6-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## time zone: Europe/London
    ## tzcode source: internal
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] gtable_0.3.6        jsonlite_2.0.0      renv_1.1.5         
    ##  [4] dplyr_1.1.4         compiler_4.6.0      BiocManager_1.30.26
    ##  [7] tidyselect_1.2.1    rvcheck_0.2.1       scales_1.4.0       
    ## [10] yaml_2.3.10         fastmap_1.2.0       here_1.0.2         
    ## [13] ggplot2_4.0.0       R6_2.6.1            generics_0.1.4     
    ## [16] knitr_1.50          yulab.utils_0.2.1   tibble_3.3.0       
    ## [19] desc_1.4.3          dlstats_0.1.7       rprojroot_2.1.1    
    ## [22] pillar_1.11.1       RColorBrewer_1.1-3  rlang_1.1.6        
    ## [25] badger_0.2.5        xfun_0.54           fs_1.6.6           
    ## [28] S7_0.2.0            cli_3.6.5           magrittr_2.0.4     
    ## [31] rworkflows_1.0.6    digest_0.6.37       grid_4.6.0         
    ## [34] rstudioapi_0.17.1   rappdirs_0.3.3      lifecycle_1.0.4    
    ## [37] vctrs_0.6.5         evaluate_1.0.5      glue_1.8.0         
    ## [40] data.table_1.17.8   farver_2.1.2        rmarkdown_2.30     
    ## [43] tools_4.6.0         pkgconfig_2.0.3     htmltools_0.5.8.1

</details>

<hr>
