#' Group files
#' 
#' Assign group names to each file in a named list based on a series of string
#' searches based on combinations of relevant metadata factors.
#' @inheritParams EpiCompare
#' 
#' @export
#' @importFrom stats setNames
#' @examples 
#' data("encode_H3K27ac") # example dataset as GRanges object
#' data("CnT_H3K27ac") # example dataset as GRanges object
#' data("CnR_H3K27ac") # example dataset as GRanges object
#' peakfiles <- list(CnR_H3K27ac=CnR_H3K27ac, 
#'                   CnT_H3K27ac=CnT_H3K27ac, 
#'                   encode_H3K27ac=encode_H3K27ac)
#'
#' peaks_grouped <- group_files(peakfiles = peakfiles,
#'                              searches=list(assay=c("H3K27ac"),
#'                                            source=c("Cn","ENCODE")))
group_files <- function(peakfiles, 
                        searches){
    # combos <- expand.grid(...)
    requireNamespace("tidyr")
    combos <- data.frame(expand.grid(searches, stringsAsFactors = FALSE),
                         stringsAsFactors = FALSE)
    rownames(combos) <- tidyr::unite(data = combos, "merged")[,1] 
    peaks_grouped <- mapply(stats::setNames(names(peakfiles),
                                            names(peakfiles)),
        SIMPLIFY = FALSE,                            
        FUN=function(nm){
            rownames(combos)[
                mapply(rownames(combos), 
                       SIMPLIFY = TRUE,
                       FUN = function(rn){
                   all(
                       unlist(
                           lapply(colnames(combos), function(x){ 
                               grepl(pattern = combos[rn,,drop=FALSE][[x]], 
                                     x = nm, 
                                     ignore.case = TRUE) 
                           })
                       )
                   )
                       })
            ] 
        }) 
    return(unlist(peaks_grouped))
}
