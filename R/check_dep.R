check_dep <- function(dep){
  if(!requireNamespace(dep, quietly = TRUE)){
    stp <- paste("Package",shQuote(dep),
                 "must be installed to use this function.")
    stop(stp,
         call. = FALSE)
  }
}