#' Gather files
#'
#' Recursively find peak/picard files stored within subdirectories and import
#' them as a list of \link[GenomicRanges]{GRanges} objects.
#' 
#' For "peaks.stringent" files called with 
#' \href{https://github.com/FredHutch/SEACR}{SEACR}, column names will be
#' automatically added:
#' \itemize{
#' \item{total_signal : }{Total signal contained within denoted coordinates.}
#' \item{max_signal}{Maximum bedgraph signal attained at any base pair 
#'  within denoted coordinates.}
#' \item{max_signal_region}{ Region representing the farthest upstream 
#' and farthest downstream bases within the denoted coordinates 
#'  that are represented by the maximum bedgraph signal.}
#' }
#' 
#' @param dir Directory to search within.
#' @param type File type to search for. Options include:
#' \itemize{
#' \item{"<pattern>"}{Finds files matching an arbitrary regex pattern
#' specified by user.}
#' \item{"peaks.stringent"}{Finds files ending in "*.stringent.bed$"}
#' \item{"peaks.consensus"}{Finds files ending in "*.consensus.peaks.bed$"}
#' \item{"peaks.consensus.filtered"}{
#' Finds files ending in"*.consensus.peaks.filtered.awk.bed$"}
#' \item{"picard"}{Finds files ending in
#' "*.target.markdup.MarkDuplicates.metrics.txt$"}
#' }
#' @param nfcore_cutandrun Whether the files were generated by the
#' \href{https://nf-co.re/cutandrun}{nf-core/cutandrun} Nextflow pipeline.
#'  If \code{TRUE}, can use the standardised folder structure to
#'  automatically generate more descriptive file names with sample IDs.
#' @param return_paths Return only the file paths without actually reading them 
#' in as \link[GenomicRanges]{GRanges}. 
#' @param rbind_list Bind all objects into one.
#' @param verbose Print messages. 
#' @inheritParams check_workers
#' @inheritParams BiocParallel::MulticoreParam 
#' @returns A named list of \link[GenomicRanges]{GRanges} objects.
#'
#' @export 
#' @importFrom stats setNames
#' @importFrom stringr str_split
#' @importFrom data.table fread := rbindlist
#' @importFrom GenomicRanges GRangesList
#' @examples
#' #### Make example files ####
#' save_paths <- EpiCompare::write_example_peaks()
#' dir <- unique(dirname(save_paths))
#' #### Gather/import files ####
#' peaks <- EpiCompare::gather_files(dir=dir, 
#'                                   type="peaks.narrow",
#'                                   workers = 1)
gather_files <- function(dir,
                         type = "peaks.stringent",
                         nfcore_cutandrun = FALSE,
                         return_paths = FALSE,
                         rbind_list = FALSE,
                         workers = check_workers(),
                         verbose = TRUE){

  #### Parse type arg ####
  workers <- check_workers(workers = workers)
  type_key <- c(
    ## peak files
    "peaks.stringent"="*.stringent.bed$",
    "peaks.consensus"="*.consensus.peaks.bed$",
    "peaks.consensus.filtered"="*.consensus.peaks.filtered.awk.bed$",
    "peaks.pooled"="pooledPeak",
    "peaks.narrow"="narrowPeak",
    "peaks.broad"="broadPeak",
    ## picard files 
    # "picard"= "*.target.markdup.MarkDuplicates.metrics.txt$",
    "picard"= "^multiqc_picard*",
    ## multiQC files 
    # "multiqc"=c("^meta_table"),
    "multiqc"="multiqc_general_stats.txt$|meta_table_ctrl.csv",
    ## trimgalore files
    "trimgalore"="*.fastq.gz_trimming_report.txt$",
    ## bowtie files
    "bowtie.stats"="*\\.stats$",
    "bowtie.idxstats"="*\\.idxstats$",
    "bowtie.target.stats"=".*\\.stats$",
    "bowtie.target.idxstats"=".*\\.idxstats$",
    ## bam files
    "bam"="*.bam$",
    "bam.dedup"="*.dedup.bam$",
    "bam.dedup.sorted"="*.dedup.sorted.bam$",
    "bam.dedup.sorted.target"="*.target.dedup.sorted.bam$"
  )
  #### Check for known file types ####
  pattern <- if(all(type %in% names(type_key))) {
      type_key[tolower(type)]
  } else {
      type
  }
  if(all(is.na(pattern))){
    stop("type must be at least one of:\n",
         paste("-",c(names(type_key),"<regex query>"), collapse = "\n"))
  }
  #### Search for files recursively ####
  messager("Searching for",type,"files...",v=verbose)
  paths <- list.files(path = dir,
                      pattern = paste(unname(pattern), collapse = "|"),
                      recursive = TRUE,
                      full.names = TRUE, 
                      ignore.case = TRUE)
  #### Remove any R scripts ####
  paths <- grep("\\.R", paths, value = TRUE, invert = TRUE) 
  #### Omit duplicate files ####
  ## nfcore creates duplicates of same peak files 
  ## in different subfolders: "04_reporting" and "04_called_peaks".
  ## Omit one of these subfolders.
  if(isTRUE(nfcore_cutandrun) && 
     (type=="peaks")){
      paths <- paths[!grepl("04_reporting",paths)]
  }
  #### Report files found ####
  if(length(paths)==0) {
      msg <- "0 matching files identified. Returning NULL."
      messager(msg,v=verbose)
      return(NULL)
  }
  messager(formatC(length(paths),big.mark = ","),
          "matching files identified.",v=verbose)
  #### Construct names ####
  paths <- gather_files_names(paths=paths,
                              type=type,
                              nfcore_cutandrun=nfcore_cutandrun)
  if(isTRUE(return_paths)){
      messager("Returning paths.",v=verbose)
      return(paths)
  }
  #### Import files ####
  messager("Importing files.",v=verbose)  
  files <- bpplapply(X = paths, 
                     workers = workers,
                     FUN = function(x){ 
        if(type=="picard"){
            dat <- read_picard(path = x,
                               verbose = verbose)
        } else if(type=="multiqc"){
            dat <- read_multiqc(path = x,
                                verbose = verbose)
        } else if(startsWith(type,"bowtie")){
            dat <- read_bowtie(path = x,
                               verbose = verbose)
        } else if(type=="trimgalore"){
            dat <- read_trimgalore(path = x,
                                   verbose = verbose)
        } else if(startsWith(type,"bam")){
            dat <- read_bam(path = x,
                            verbose = verbose)
        } else {
            dat <- read_peaks(path = x,
                              type = type,
                              verbose = verbose)
        }
        return(dat) 
  }) 
  #### rbind into one object ####
  if(isTRUE(rbind_list)){
      messager("Binding all files into one.",v=verbose)
      if(startsWith(type,"peaks")){
          files <- unlist(GenomicRanges::GRangesList(files))
      } else {
          files <- data.table::rbindlist(files,
                                         use.names = TRUE,
                                         idcol = "batch",
                                         fill = TRUE)
      }
  }
  #### Report ####
  messager(formatC(length(files),big.mark = ","),"files retrieved.",v=verbose)
  return(files)
}
