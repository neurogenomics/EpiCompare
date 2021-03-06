## CHANGES IN VERSION 0.99.21

### Bug fixes

* Changed terminology from "epigenetic" to "epigenomic"
* Updated README to include precision_recall_plot and corr_plot
* Removed bugs in html report 
* Added example EpiCompare report in inst/report/EpiCompare_example.html

## CHANGES IN VERSION 0.99.20

### New features

* Upgraded `liftover_grl` and added genome standardization. 
    - Enable  cross-species liftover from/to mm10 and mm9 --> hg19 and hg38. 
    - Subfunctionalize `get_chain_file`. 
    - Add `merge_all` option. 
* Support mm10/mm9 as `output_build` options. 
* Removed `dplyr`.
* Moved `plyranges` to *Suggests*.
* `plot_precision_recall`:
    - New exported function to create precision-recall plots from MACS2, 
    MACS3, HOMER, or SEACR peak files.
    - Added unit tests. 
    - Added to EpiCompare html report. 
    - Added `EpiCompare(precision_recall_plot=)` param and documented. 
* Add *ISSUE* templates. 
* Include code in html report (collapsed by default). 
* Add correlation matrix/plot functionality.
* Add `compute_consensus_peaks()` as function for preprocessing peak files. 
    - Add `group_files()` function to help assign each peakfile to a group based
    on substring searches. 
* `EpiCompare`:
    - Return paths to HTML reports.
    - Automatically open report in browser or rstudio. 
* Add Docker vignette and advertise in README. 

### Bug fixes

* Made `BiocParallel` functions compatible with Windows. 
* Organize author fields in DESCRIPTION.
* Fix typos in README. 
* Remove threshold=1 from list of thresholds to test in precision-recall curves.
* Set first chunk in *EpiCompare.Rmd* as `echo=FALSE` instead of `include=FALSE`
so the output messages will still be printed (without showing the code). 
* Remove `here` from *Suggests*. 
* Fix directory creation in `EpiCompare::EpiCompare`. 


## CHANGES IN VERSION 0.99.19

### Bug fixes
* Simplified loops with `mapply`/`lapply`.   

### New features
* `EpiCompare`: accepts multiple reference files - creates individual reports
for each reference. Added timing feature. 
* `save_output()`: this function saves all plots and tables generated by EpiCompare.
Also saves interactive heatmaps. Used in EpiCompare.Rmd. 
* `fig_length()`: This function outputs dynamic figure height/width depending
on the number of items. Used in EpiCompare.Rmd. 

## CHANGES IN VERSION 0.99.18

### Bug fixes

* `prepare_reference`: Validate reference input before passing to next step.
* Pass named list to `genome_build` to allow for different builds between
`reference` and `peaklist`. 
* Liftover `blacklist` to match GRanges list it's being used to filter in `tidy_peakfile`. 
* Ensure all names are unique in `peaklist` and `reference`. 
* `gather_files`:
    - Avoid gathering duplicates peak files from `nf-core/cutandrun`. 
    - Add progress bar. 
    - Add report at the end. 
    - Add extra arg `return_paths` to return only the paths 
    without actually reading in the files.  

### New features

* Overhaul how *EpiCompare* handles genome builds:  
    - New argument `genome_build_output` allows users to specify 
    which genome build to standardise all inputs to. 
    - `genome_build` can now take a named list to specify different genome builds
    for `peakfiles`, `reference`, and `blacklist`.  
    - Added functions to parse and validate all genome build-related arguments. 
* Remove unnecessary deps.
* Use `data.table` to read/write tables. 
* `prepare_peaklist`:
    - Simplified code.
    - Added arg `remove_empty` to automatically drop any empty elements.
    - Embed `check_list_names` within. 
* `plot_chromHMM`:
    - Can return data as well with `return_data`. 
    - Performs liftover on chromHMM data instead of the `peaklist`.

## CHANGES IN VERSION 0.99.17

### Bug fixes

* Make `output_dir` creation recursive and without warnings. 
* Add new params to *Code* section of rmarkdown output. 

### New features

* Add new `peaklist` length check to `prepare_peaklist`.
* New check functions:
    - `check_genomebuild`: ensure necessary packages installed and that 
    "genomebuild" is valid.
    - `check_cell_lines` 
* `liftover_grlist`: Dedicated liftover function, exported.  
* Document `checkCache`. 
* `get_chromHMM_annotation` can now take a list of cell lines as an argument. 

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
