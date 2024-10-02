check_peakfiles <- function(peakfiles){
  if(all(unlist(lapply(peakfiles,length))==0)){
    stopper("No peaks found in any of the peakfiles.")
  }
}