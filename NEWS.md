## CHANGES IN VERSION 0.99.17

### Bug fixes

* Make `output_dir` creation recursive and without warnings. 
* Add new params to *Code* section of rmarkdown output. 

### New features

* Add new `peaklist` length check to `prepare_peaklist`.
* `check_genomebuild`: ensure necessary packages installed and that 
    "genomebuild" is valid.
* `liftover_grlist`: Dedicated liftover function, exported. 

## CHANGES IN VERSION 0.99.16

### Bug fixes

* Fix GHA pkgdown building: 
    - The newest version of [git introduced bugs when building pkgdown sites](https://github.com/actions/checkout/issues/760) from within Docker containers (e.g. via my Linux GHA workflow). Adjusting GHA to fix this. 

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
    -   `genome_build`: Specify the genome build, either "hg19" or "hg38". This parameter is also included in `plot_chromHMM`, `plot_ChIPseeker_annotation`, `tss_plot` and `plot_enrichment`.

## CHANGES IN VERSION 0.99.0

### New Features

-   `EpiCompare` submitted to Bioconductor.
