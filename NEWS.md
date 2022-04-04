## CHANGES IN VERSION 0.99.3

### New Features

-   New functions with examples/unit tests:
    -   `import_narrowPeak`: Import narrowPeak files, with automated header annotation using metadata from ENCODE.\
    -   `gather_files`: Automatically peak/picard/bed files and read them in as a list of `GRanges` objects.\
    -   `write_example_peaks`: Write example peak data to disk.
-   Update *.gitignore*
-   Update *.Rbuildignore*

## CHANGES IN VERSION 0.99.1

### New features

-   New parameter in EpiCompare:
    -   `genome_build`: Specify the genome build, either "hg19" or "hg38". This parameter is also included in `plot_chrmHMM`, `plot_ChIPseeker_annotation`, `tss_plot` and `plot_enrichment`.

## CHANGES IN VERSION 0.99.0

### New Features

-   `EpiCompare` released to Bioconductor.
