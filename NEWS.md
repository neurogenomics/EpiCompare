## CHANGES IN VERSION 1.13.2 [BREAKING CHANGE]

### Bug Fixes

* [BREAKING CHANGE] Temporarily disable `upset_plot` option as one of the
dependencies, `ComplexUpset`, is not yet updated to support `ggplot 4.4.0`.
* Fix deprecated `ggplot` arguments.

### Miscellaneous

* `add_download_button`:
  - No longer changes to `TRUE` if `run_all` is `TRUE`.

## CHANGES IN VERSION 1.11.2 / 1.11.3

* Update minimum version for dependency `IRanges`. See 
[issue #155](https://github.com/neurogenomics/EpiCompare/issues/155).

## CHANGES IN VERSION 1.10.1 [HOTFIX] / 1.11.1

### Bug Fixes

* `prepare_output_build`
  - Fix support for mouse genome builds (mm9 and mm10).
  
### Documentation

* `Epicompare.Rmd`
  - Mention support for mouse genome builds.

## CHANGES IN VERSION 1.9.5

### New features

* Remove the soon-to-be-deprecated `BRGenomics` dependency.
  - Port `tidyChromosomes` function to `EpiCompare`.

### Miscellaneous

* Update maintainer details.

## CHANGES IN VERSION 1.3.4

### New features

* Example report:
  - Delete *report/* folder and upload to Releases instead:
    https://github.com/neurogenomics/EpiCompare/releases
  - Add Rscript to replicate example report in *inst/examples*.
* EpiCompare
  - New arg `add_download_button`. 
  - Always keep download button for post-processed peak files.
* `save_output``
  - Change *.txt* suffixes to more informative *.csv* suffixes for saved files.
* Create `EpiArchives` and offload report to there:
  - Updated *vignettes/example_report.Rmd* so that it just renders the markdown landing page for `EpiArchives`.

### Bug fixes

* *README.Rmd*:
  - Fix broken link to example report.
* *test-EpiCompare.R*:
  - Fix issue with PNG save path.
  - Make separate subfolders for each set of tests. 
* *test-output_files.R*
  - Make separate subfolders for each set of tests.
* `plot_enrichment`
  - Conditionally generate plots only when enrichment results aren't `NULL`.
  - Return KEGG/GO enrichment results as well as the plots.
* Add `workers <- check_workers(workers = workers)` to all functions that take `workers` to handle `workers=NULL` properly.

## CHANGES IN VERSION 1.3.3

### New features

* `download_button`:
  - Saves and downloads files.
* `prepare_blacklist`:
  - Auto-selects appropriate blacklist, or returns user-specified option.
  - `EpiCompare(blacklist=NULL)` is now the default.
* `prepare_genome_builds`:
  - Update to handle supplying builds for "peakfiles" and "reference" 
    but not "blacklist" 
    (so long as the `blacklist` arg is not a user-supplied `GRanges` object)
* Added `mm9_blacklist` 
* Made more plots interactive:
  - `width_boxplot`
  - `plot_enrichment`
  - `plot_ChIPseeker_annotation`
* `overlap_stat_plot`
  - Name elements in output list.
* Change `annotation` arg to more informative `txdb` arg, 
  and set default to `NULL`, which `ChIPseeker` functions will 
  automatically handle.
* New function `as_interactive`:
  - Help standardise this.
* New `EpiCompare::EpiCompare` arguments:
  - `error`: keep knitting even on errors.
  - `tss_distance`: upstream/downstream of TSS.
  - `quiet`: knit quietly
* Rename *'test-EpiCompare_combinations.R'* --> *'test-EpiCompare.R'*
* Separate *test-generalMetrics_functions.R* into function-specific test files.
* Separate *test-peakOverlap_functions.R* into function-specific test files.
* Make fancy header with new func:
  - `report_header()`
* Create `EpiCompare` command code as text:
  - `report_command()`
* `width_boxplot`:
  - Make more efficient with `data.table` and `lapply`
* Update hex sticker to match *custom.css* palette.
* *README.Rmd*
  - Collapse more detailed sections.

### Bug fixes

* `tss_plot`:
  - Fix examples/tests after Sera updated the arguments.
  - Pass upstream/downstream to `ChIPseeker::getTagMatrix`
  - Make interactive
  - Name plots in list
  - Remove unnecessary extra level of list nesting.
* Make documentation width <80 lines where possible.
* *EpiCompare.Rmd*
  - Remove `methods::show` from all parts
  - Name all chunks
  - Make explanations more clear
  - Add table of contents for main 3 sections.
  - Fix header levels 
  - Set `results='asis'` globally instead of in each chunk header. 
  - Automatically number sections with yaml arg: `number_sections: true`
  - Omit specific headers from numbering system with `{-}` tags.
  - Add *custom.css*
* `plot_chromHMM`:
  - `Error in (function (classes, fdef, mtable) unable to find an inherited method for function ‘annotateWithFeatures’ for signature ‘"SimpleGRangesList", "list"’`
  - Misleading error message; was actually due to `chromHMM_annotation` 
    not being converted from a list to a `GRangesList`.
  - Change yaml arg `peakfile` --> `peakfiles` 
    to be consistent with other variables.

## CHANGES IN VERSION 1.3.1

### New features

* Replace `badger` with `rworkfows`:
    - Use `rworkflows::use_badges`
* New helper functions:
    - `precision_recall_matrix`
    - `report_time`
* `overlap_upset_plot`:
  - Switched out `UpSetR` for `ComplexUpset`to show percentages.
  - Moved up dep checks to beginning of function.
* Handle bug with `heatmaply` by checking args where it might be used:
  - `check_heatmap_args`
* `tss_plot`:
  - Add unit tests 
  - Drastically reduce example/test runtime by setting `upstream=50`
* `compute_corr`:
  - Reduce example runtime by setting ` bin_size = 200000` (takes <2s).

### Bug fixes

* Fix typo in `EpiCompare` docs: "hg38 blacklist dataset"
* Avoid explicitly specifying "/" in paths to help cross-platform testing.
* `tss_plot`: 
  - Use `parallel::detectCores-1` by default to set workers, 
    but set to 1 in examples/tests to meet CRAN/Bioc standards. 
  

## CHANGES IN VERSION 1.1.4

### New features

* Add back example report html:
    - Put it in the main dir
    - Add it to the *.Rbuildignore*: *report/EpiCompare_example.html*
    - Add a new vignette that renders the HTML from the pre-saved file.
* Remove *Dockerfile*, as it's no longer necessary with 
    the updated version of `rworkflows`

### Bug fixes

* Add `@returns` to `group_files` function. 
* Add all authors to vignettes.

## CHANGES IN VERSION 1.1.3

### New features

* New function: `predict_precision_recall`
    - Added unit tests. 
* `compute_corr` and `precision_recall` now save outputs, 
    including when run via `EpiCompare` Rmarkdown script. 
* Make subfunctions for `plot_precision_recall`:
    - `plot_precision_recall_prcurve`
    - `plot_precision_recall_f1`
* `rebin_peaks`:
    - Allow users to specify `sep` between genomic coordinates in rownames.
    
### Bug fixes

* Update `gather_files` to match new Picard file scheme
    in *nf-core/cutandrun* 3.0. 


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
    - Add "multiqc" as a search option. 
    - Add dedicated subfunctions for reading in a variety of 
    *nf-core/cutandrun* outputs files: 
    `read_picard`,`read_multiqc`,`read_bowtie`,
    `read_trimgalore`,`read_bam`,`read_peaks`
    - Add file paths to each object.
    - Add new arg `rbind_list`. 
*  `rebin_peaks`/`compute_corr`:
    -Change default`bin_size` from 100 --> 5kb to improve efficiency 
    and align with other defaults of other packages (e.g `Signac`).
* `tss_plot`:
    - Pass up more arg for specifying upstream/downstream. 
* `EpiCompare`: Pass up new args:
    - `bin_size`
    - `n_threshold`
    - `workers`
    
### Bug fixes

* Fix `rebin_peaks` unit tests. 
* Fix pkg size issue by adding *inst/report* to *.Rbuildignore*.
* `EpiCompare` wasn't being run when reference was a single unlisted `GRanges` object 
    because it was indeed length>1, but the `names` were all `NULL`. Now fixed.
* `plot_precision_recall`: Set default `initial_threshold=` to 0.
*  Switch from `BiocParallel` to `parallel`, 
    as the former is extremely buggy and inconsistent.

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
* `plot_precision_recall`: Don't plot the reference as part of the PR curve. 
    

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
