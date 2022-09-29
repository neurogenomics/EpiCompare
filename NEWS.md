## CHANGES IN VERSION 1.1.2

### New features

* `rebin_peaks`:
    - Added arg `drop_empty_chr` to automatically drop chroms that aren't in 
    any of the `peakfiles`.
    - Added "score" as one of the default `intensity_cols` in all relevant functions.
    - Make examples use 5000bp bins to speed up. 
* `translate_genome`:
    - Add `default_genome` arg to handle `genome=NULL`. 
* `bpplapply`:
    - New exported function to automate handling of known issues with
    `BiocParallel` across OS platforms. 
    - Enable users to specify their own apply function.
* `get_bpparam`: Add args to allow users to choose which `BiocParallel` func to use.
* `checkCache`: Make default arg `cache=BiocFileCache::BiocFileCache(ask = FALSE)`
    to skip user input during runtime. 
* `precision_recall`:
    - Change `increment_threshold` arg to `n_threshold` arg, 
    using the `seq(length.out=)` feature to avoid accidentally choosing an
    inappropriately large `increment_threshold`. 
* `gather_files`: 
    - Replace iterator with `bpplapply`.
    - Pass up args from `bpplapply`.
    - Provide warning message, not error, when 0 files found. Returns `NULL`.
    
### Bug fixes

* Fix `rebin_peaks` unit tests. 
* Fix pkg size issue by adding *inst/report* to *.Rbuildignore*.
* `EpiCompare` wasn't being run when reference was a single unlisted `GRanges` object 
    because it was indeed length>1, but the `names` were all `NULL`. Now fixed.
* `plot_precision_recall`: Set default `initial_threshold=` to 0.

## CHANGES IN VERSION 1.1.1

### New features

* `check_genome_build`: Add `translate_genome` as prestep.
* `rebin_peaks`: 
    1. Move all steps that could be done just once (e.g. creating the genome-wide tiles object) outside of the `BiocParallel::bpmapply` iterator.
    2. Ensure all outputs of `BiocParallel::bpmapply` are of the same length, within the exact same bins, so that we can return  just the bare minimum data needed to create the matrix (1 numeric vector/sample).
    3. Instead of `rbind`ing the results and then casting them back into a matrix (which is safer bc it can handle vectors of different lengths), simply `cbind` all vectors into one matrix directly and name the rows using the predefined genome-wide tiles.
    4. Because we are no longer `rbind`ing a series of very long tables, this avoids the issue encountered here #103. This means this function is now much more scalable to many hundreds/thousands of samples (cells) even at very small bin sizes (e.g. 100bp).
    5. A new argument `keep_chr` allows users to specify whether they want to restrict which chromosomes are used during binning. By default, all chromosomes in the reference genome are used (`keep_chr=NULL`), but specifying a subset of chromosomes (e.g. `paste0("chr",seq_len(12))`) can drastically speed up compute time and reduce memory usage. It can also be useful for removing non-standard chromosomes (e.g. "chr21_gl383579_alt", "chrUns...", "chrRand...").
    6. As a bonus, `rebin_peaks` now reports the final binned matrix dimensions and a sparsity metric.  
- `compute_corr`:
    * Added unit tests at different bin sizes. 
    * Allow `reference` to be `NULL`. 
- Updated README to reflect latest vesion of `EpiCompare` with `gather_files`. 

### Bug fixes

* Bumped version to align with Bioc devel (currently 1.1.0).
* `compute_percentiles`:
    - Making default `initial_threshold=0`, 
    so as not to assume any particular threshold. 
* `rebin_peaks`: 
    - Addressed error that occurs when there's many samples/cells 
    with small bins.  
    

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
