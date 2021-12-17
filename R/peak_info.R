
peak_info <- function(peakfiles, file_names){

  peakN <- c()
  for (file in peak_list){
    N <- length(file)
    peakN <- c(peakN, N)
  }

  df <- data.frame(file_names, peakN)
  knitr::kable(df)
}
