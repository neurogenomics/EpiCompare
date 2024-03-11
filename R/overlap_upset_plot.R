#' Generate Upset plot for overlapping peaks
#'
#' This function generates upset plot of overlapping peaks files
#' using the 
#' \href{https://cran.r-project.org/web/packages/ComplexUpset}{
#' \pkg{ComplexUpset}} package.
#' @param peaklist A named list of peak files as GRanges object.
#' Objects must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names are assigned.
#' @param verbose Print messages
#' @returns Upset plot of overlapping peaks.
#'
#' @importMethodsFrom IRanges findOverlaps
#' @importFrom GenomicRanges elementMetadata
#' @importFrom IRanges to from 
#'
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # load example data
#' data("CnT_H3K27ac") # load example data 
#' peaklist <- list("encode"=encode_H3K27ac, "CnT"=CnT_H3K27ac) 
#' my_plot <- overlap_upset_plot(peaklist = peaklist)
overlap_upset_plot <- function(peaklist,
                               verbose=TRUE){
    
  value <- NULL;
  
  t1 <- Sys.time()
  
  font_size <- 1
  messager("--- Running overlap_upset_plot() ---",v=verbose)
  #### Check package is available ####
  check_dep("ComplexUpset")
  check_dep("tidyr") 
  ### Check Peaklist Names ###
  peaklist <- check_list_names(peaklist)
  ### Set Metadata Colnames ###
  # So it doesn't interfere
  for(i in seq_len(length(peaklist))){
    my_label <- make.unique(rep("name",
                           ncol(GenomicRanges::elementMetadata(peaklist[[i]])))
                           )
    colnames(GenomicRanges::elementMetadata(peaklist[[i]])) <- my_label
  }
  ### Erase Names ###
  peaklist_names <- names(peaklist)
  names(peaklist) <- NULL
  ### Create Merged Dataset ###
  merged_peakfile <- do.call(c, peaklist)
  ### Calculate Overlap & Create Data Frame ###
  overlap_df <- NULL
  for(i in seq_len(length(peaklist))){
   overlap <- IRanges::findOverlaps(merged_peakfile, peaklist[[i]])
   sample_name <- rep(peaklist_names[i], length(IRanges::to(overlap)))
   df <- data.frame(peak=IRanges::from(overlap), sample=sample_name)
   unique_df <- unique(df)
   overlap_df <- rbind(overlap_df, unique_df)
  }
  ### Adjust Font Size ###  
  if(length(peaklist)>6){
    font_size <- 0.65
  }
  #### Create Upset Plot ###
  overlap_df$value <- 1
  overlap_df <- tidyr::spread(data = overlap_df, 
                              key = sample, 
                              value = value, 
                              fill=0) 
  
  base_annotations <- list(
    'Intersection size'=ComplexUpset::intersection_size(),
    'Intersection ratio'=ComplexUpset::intersection_ratio(
      text_mapping=ggplot2::aes(label=!!ComplexUpset::upset_text_percentage())
    )
  )
  plt <- ComplexUpset::upset(data = overlap_df,
                             intersect = peaklist_names,
                             base_annotations = base_annotations)
  # upset_plot <- UpSetR::upset(data = overlap_df, 
  #                             order.by = "freq",
  #                             mb.ratio = c(0.60, 0.40),
  #                             sets = peaklist_names,
  #                             number.angles = 30,
  #                             text.scale = c(1, 1, 1, font_size,
  #                                            font_size+0.15, font_size))
  report_time(t1 = t1,
              func="overlap_upset_plot",
              verbose = verbose)
  return(list(plot=plt,
              data=overlap_df))
}
