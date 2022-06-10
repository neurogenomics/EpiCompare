#' Rebin peaks
#' 
#' Standardise a list of peak files by rebinning them into fixd-width
#'  tiles across the genome.
#' @param as_sparse Return the rebinned peaks as a sparse matrix
#' (default: \code{TRUE}), 
#' which is more efficiently stored than a dense matrix (\code{FALSE}). 
#' @inheritParams compute_corr
#' @returns Binned peaks matrix
#' @export
#' @importFrom data.table rbindlist as.data.table dcast
#' @importFrom GenomicRanges tileGenome seqinfo binnedAverage coverage
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
#'                                   bin_size = 1000)
rebin_peaks <- function(peakfiles,
                        genome_build,
                        intensity_cols=c("total_signal", 
                                         "qValue",
                                         "Peak Score"), 
                        bin_size=100,
                        as_sparse=TRUE,
                        workers=1){ 
    id <- seqnames <- start <- end <- NULL; 
    #### check genome build ####
    gen_build_err <- 
        paste0("All peak files must be of the same genome build.\nUse ",
               "EpiCompare::liftover_grlist on your data first and then rerun.")
    if(length(unique(genome_build))>1) stop(gen_build_err)
    genome_build <- tolower(genome_build)
    msg <- paste("genome_build must be one of:",
                 "\n- 'hg19'",
                 "\n- 'hg38'",
                 "\n- 'mm9'",
                 "\n- 'mm10'")
    if(!genome_build %in% c("hg19","hg38","mm9","mm10")) stop(msg)
    #### get reference gen data ####
    ref_bsgen <- check_genome_build(genome_build = genome_build,
                                    type="bsgen")
    #### Rebin peaks ####
    BPPARAM <- get_bpparam(workers = workers)
    messager("Standardising peak files in bins of",
             paste0(formatC(bin_size,big.mark = ",")," bp."))
    rebinned_peaks <- 
        BiocParallel::bpmapply(
            peakfiles,
            BPPARAM = BPPARAM,
            SIMPLIFY = FALSE,
            FUN = function(gr){
                print(gr)
                ## Compute percentiles
                gr <- compute_percentiles(
                    gr = gr, 
                    thresholding_cols = intensity_cols,
                    initial_threshold = 0
                )
                print(gr)
                ## Re-bin desired level,averaging intensity score 
                gr_windows <- 
                    GenomicRanges::tileGenome(
                        GenomicRanges::seqinfo(ref_bsgen),
                        tilewidth=bin_size, 
                        cut.last.tile.in.chrom=TRUE)
                #get col name of intensity
                gr_names <- names(GenomicRanges::mcols(gr))
                #can be more than one just arbitrarily take first
                intens_col <-
                    gr_names[gr_names %in% 
                                 paste(intensity_cols,
                                       "percentile",
                                       sep="_")][1]
                #if you don't find intensity col don't include 
                if(length(intens_col)==0 || is.na(intens_col)){
                  msg <- paste0("Peak file missing intensity col, will be ",
                                  "excluded from correlation matrix/plot")
                  message_parallel(msg)
                  return(NULL)
                } else {
                #measure to avg within the bins
                data_cov <- 
                    GenomicRanges::coverage(gr,
                                            weight=intens_col)
                rm(gr)
                GenomeInfoDb::seqlevels(gr_windows, 
                                        pruning.mode="coarse"
                                        ) <- names(data_cov)
                gr <- GenomicRanges::binnedAverage(gr_windows, 
                                                   data_cov, "score")
                gr <- remove_nonstandard_chrom(grlist = gr,
                                               verbose = FALSE) 
                #trim parts not found in gen build
                GenomicRanges::seqinfo(gr) <- 
                    GenomeInfoDb::Seqinfo(genome=genome_build)
                gr <- GenomicRanges::trim(gr)
                ## convert to dt and return
                gr <- data.table::as.data.table(gr)
                #remove unnecessary cols - save mem
                gr[,c("width","strand"):=NULL]
                return(gr)
                }
    })   
    rebinned_peaks <- 
        data.table::rbindlist(rebinned_peaks,use.names = TRUE,
                              idcol = "assay") 
    #make sure you hve at least two peak files remaining 
    if(length(unique(rebinned_peaks$assay))<=1)
      stop("Need more than one peak file to create correlation matrix.") 
    # Reshape data from long to wide
    messager("Reshaping binned peaks.")
    all_gr_wide <- 
        data.table::dcast(data = rebinned_peaks, 
                          formula = ...~assay, 
                          value.var = "score")
    all_gr_wide[,id:=paste0(seqnames,":",start,"-",end)]
    rm(rebinned_peaks)
    # make matrix
    val_cols <- 
        names(all_gr_wide)[!names(all_gr_wide) %in% 
                                   c("seqnames","start","end","id")]
    gr_mat <- as.matrix(all_gr_wide[,val_cols,with=FALSE])
    rownames(gr_mat) <- all_gr_wide$id 
    rm(all_gr_wide)
    if(as_sparse){
        messager("Converting to sparse matrix.")
        requireNamespace("Matrix")
        gr_mat <- Matrix::Matrix(gr_mat,sparse=TRUE)
    }
    return(gr_mat)
}
