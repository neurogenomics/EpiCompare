#' Check cache
#' 
#' Quick function to check if object is already saved.
#' @param cache BiocFileCache.
#' @param url Path to cached file.  
#' @keywords internal
#' @returns path 
checkCache <- function(cache=BiocFileCache::BiocFileCache(ask = FALSE),
                       url) {
    if (!requireNamespace("BiocFileCache"))
        stop("install BiocFileCache to use this function.")
    cached <- BiocFileCache::bfcinfo(cache)$rname
    return(url %in% cached)
}
