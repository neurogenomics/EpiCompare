#' Rebin peaks
#' 
#' Standardise a list of peak files by rebinning them into fixd-width
#'  tiles across the genome.
#' @param as_sparse Return the rebinned peaks as a sparse matrix
#' (default: \code{TRUE}), 
#' which is more efficiently stored than a dense matrix (\code{FALSE}). 
#' @inheritParams compute_corr
#' @inheritParams remove_nonstandard_chrom
#' @returns Binned peaks matrix
#' 
#' @export
#' @importFrom data.table rbindlist as.data.table dcast
#' @importFrom GenomicRanges tileGenome seqinfo binnedAverage coverage
#' @importFrom GenomicRanges seqnames start end 
#' @importFrom GenomeInfoDb Seqinfo seqnames seqlevels
#' @importFrom BiocGenerics `%in%`
#' @examples 
#' data("CnR_H3K27ac") 
#' data("CnT_H3K27ac")
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, CnT_H3K27ac=CnT_H3K27ac) 
#' 
#' #increasing bin_size for speed
#' peakfiles_rebinned <- rebin_peaks(peakfiles = peakfiles,
#'                                   genome_build = "hg19",
#'                                   bin_size = 5000)
rebin_peaks <- function(peakfiles,
                        genome_build,
                        intensity_cols=c("total_signal", 
                                         "qValue",
                                         "Peak Score",
                                         "score"), 
                        bin_size=100,
                        keep_chr=NULL,
                        drop_empty_chr=FALSE,
                        as_sparse=TRUE,
                        workers=1,
                        verbose=TRUE){ 
    
    #### check genome build ####
    genome_build <- unique(tolower(genome_build))
    gen_build_err <- 
        paste0("All peak files must be of the same genome build.\nUse ",
               "EpiCompare::liftover_grlist on your data first and then rerun.")
    if(length(unique(genome_build))>1) stop(gen_build_err)
    #### get reference gen data ####
    ref_bsgen <- check_genome_build(genome_build = genome_build,
                                    type="bsgen") 
    #### Check which have necessary columns #####
    peakfiles <- check_grlist_cols(grlist = peakfiles, 
                                   target_cols = intensity_cols)
    #### Specify chromosomes ####
    if(isTRUE(drop_empty_chr)){
        present_chr <- lapply(
            peakfiles,
            function(x){unique(GenomicRanges::seqnames(x))}) |> 
            unlist() |> unique() |> as.character() 
        if(is.null(keep_chr)) {
            keep_chr <- present_chr
        } else {
            keep_chr <- keep_chr[keep_chr %in% present_chr] 
        }
    }
    if(!is.null(keep_chr)){
        keep_chr <- intersect(keep_chr, 
                              GenomicRanges::seqnames(ref_bsgen))
    } else {
        keep_chr <- GenomicRanges::seqnames(ref_bsgen)
    }  
    peakfiles <- remove_nonstandard_chrom(grlist = peakfiles,
                                          keep_chr = keep_chr,
                                          verbose = FALSE)
    #### Prepare windows ####
    ## Re-bin desired level,averaging intensity score 
    gr_windows <- 
        GenomicRanges::tileGenome(
            GenomicRanges::seqinfo(ref_bsgen),
            tilewidth=bin_size, 
            cut.last.tile.in.chrom=TRUE) 
    GenomeInfoDb::seqlevels(gr_windows,
                            pruning.mode="coarse") <- keep_chr
    #### Rebin peaks ####
    BPPARAM <- get_bpparam(workers = workers)
    messager("Standardising peak files in",
             formatC(length(gr_windows),big.mark = ","),"bins of",
             paste0(formatC(bin_size,big.mark = ",")," bp."), v=verbose)
    rebinned_peaks <- 
        BiocParallel::bpmapply(
            peakfiles,
            BPPARAM = BPPARAM,
            SIMPLIFY = FALSE, 
            FUN = function(gr){
                ## Compute percentiles
                gr <- compute_percentiles(
                    gr = gr, 
                    thresholding_cols = intensity_cols,
                    initial_threshold = 0
                ) 
                # get col name of intensity
                gr_names <- names(GenomicRanges::mcols(gr))
                #can be more than one just arbitrarily take first
                intens_col <-
                    gr_names[gr_names %in% 
                                 paste(intensity_cols,
                                       "percentile",
                                       sep="_")][1] 
                # measure to avg within the bins
                data_cov <-
                    GenomicRanges::coverage(gr,
                                            weight=intens_col)
                rm(gr)
                ## For some reason,
                ## setting na.rm=TRUE drastically increases compute time.
                gr <- GenomicRanges::binnedAverage(bins = gr_windows, 
                                                   numvar = data_cov, 
                                                   varname = "score",
                                                   na.rm = FALSE)
                return(gr$score)
    })   
    #### Merge data into matrix ####
    messager("Merging data into matrix.",v=verbose)
    rebinned_peaks <- do.call("cbind", rebinned_peaks)
    rownames(rebinned_peaks) <- paste0(GenomicRanges::seqnames(gr_windows),":",
                                       GenomicRanges::start(gr_windows),"-",
                                       GenomicRanges::end(gr_windows))
    #### Convert to sparse ####
    if(isTRUE(as_sparse)){
        messager("Converting to sparse matrix.",v=verbose)
        requireNamespace("Matrix")
        rebinned_peaks <- Matrix::Matrix(rebinned_peaks, sparse=TRUE)
    }
    #### Report ####
    if(isTRUE(verbose)){
        messager("Binned matrix size:",
                 paste(formatC(dim(rebinned_peaks),big.mark = ","),
                       collapse = " x ")
        )
        sparsity <- sum(rebinned_peaks == 0, na.rm = TRUE)/
            (nrow(rebinned_peaks)*ncol(rebinned_peaks)) 
        messager("Matrix sparsity:",round(sparsity,4))
    }
    return(rebinned_peaks)
}
