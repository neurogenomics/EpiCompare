remove_empty_elements <- function(peaklist){
    is_empty <- unlist(lapply(peaklist, function(x){length(x)==0}))
    if(sum(is_empty)>0) {
        message("Removing ",sum(is_empty)," empty elements in peaklist")
        peaklist <- peaklist[!is_empty] 
    } 
    return(peaklist)
}