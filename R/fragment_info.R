

fragment_info <- function(picard_list, namelist){
  Mapped_Fragments <- c()
  Duplication_Rate <- c()
  Unique_Fragments <- c()

  for(i in 1:length(picard_list)){
    Mapped_Fragments <- c(Mapped_Fragments, picard_list[[i]]$READ_PAIRS_EXAMINED[1])
    Duplication_Rate <- c(Duplication_Rate, round(picard_list[[i]]$PERCENT_DUPLICATION[1]*100, 2))
    unique <- ((1-picard_list[[i]]$PERCENT_DUPLICATION[1]))*picard_list[[i]]$READ_PAIRS_EXAMINED[1]
    Unique_Fragments <- c(Unique_Fragments, round(unique))
  }
  df_metric <- data.frame(Mapped_Fragments, Duplication_Rate, Unique_Fragments)
  rownames(df_metric) <- namelist
  knitr::kable(df_metric)
}
