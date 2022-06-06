#' Calculate percentage of overlapping peaks
#'
#' This function calculates the percentage of overlapping peaks and outputs
#' a table or matrix of results.
#'
#' @param peaklist1 A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' If not named, default file names will be assigned.
#' @param peaklist2 peaklist1 A list of peak files as GRanges object.
#' Files must be listed and named using \code{list()}.
#' e.g. \code{list("name1"=file1, "name2"=file2)}.
#' @param suppress_messages Suppress messages.
#' @param precision_recall Return percision-recall results for all combinations 
#' of \code{peaklist1} (the "query") and \code{peaklist2} (the "subject"). 
#' See \link[IRanges]{subsetByOverlaps} for more details on this terminology. 
#' @inheritParams IRanges::findOverlaps
#'
#' @return data frame
#' @importMethodsFrom IRanges subsetByOverlaps
#' @importFrom data.table data.table rbindlist :=
#' @export
#' @examples
#' ### Load Data ###
#' data("encode_H3K27ac") # example peakfile GRanges object
#' data("CnT_H3K27ac") # example peakfile GRanges object
#' data("CnR_H3K27ac") # example peakfile GRanges object
#'
#' ### Create Named Peaklist ###
#' peaks <- list("CnT"=CnT_H3K27ac, "CnR"=CnR_H3K27ac)
#' reference_peak <- list("ENCODE"=encode_H3K27ac)
#'
#' ### Run ###
#' overlap <- overlap_percent(peaklist1=peaks,
#'                            peaklist2=reference_peak)
overlap_percent <- function(peaklist1,
                            peaklist2,
                            invert=FALSE, 
                            precision_recall=TRUE,
                            suppress_messages=TRUE){
    f <- if(suppress_messages) suppressMessages else function(x){x}    
  ### Calculate Overlap ###
  # When peaklist1 is the reference
  if(length(peaklist1)==1 && isFALSE(precision_recall)){
    percent_list <- mapply(peaklist2, 
                           SIMPLIFY = FALSE,
                           FUN=function(y){
      overlap <- f(
          IRanges::subsetByOverlaps(x = peaklist1[[1]],
                                    ranges = y,
                                    invert = invert)
      )
      percent <- length(overlap)/length(peaklist1[[1]])*100
      data.table::data.table(Percentage=signif(percent,3)) 
    }) |> data.table::rbindlist(use.names = TRUE, idcol = "query")
    #### Reformat to work with EpiCompare ####
    df <- data.frame(Percentage = percent_list$Percentage, 
                     row.names = percent_list$query) 
    
  ### Calculate Overlap ###
  # When peaklist2 is the reference
  } else if(length(peaklist2)==1 && isFALSE(precision_recall)){ 
    percent_list <- mapply(peaklist1, 
                           SIMPLIFY = FALSE,
                           FUN=function(x){
      overlap <- f(
          IRanges::subsetByOverlaps(x = x,
                                    ranges = peaklist2[[1]],
                                    invert = invert)
      )
      percent <- length(overlap)/length(x)*100
      data.table::data.table(Percentage=signif(percent,3)) 
  }) |> data.table::rbindlist(use.names = TRUE, idcol = "query")
    #### Reformat to work with EpiCompare ####
    df <- data.frame(Percentage = percent_list$Percentage, 
                     row.names = percent_list$query)

    ### Calculate Overlap ###
    # When peaklist1 abd peaklist2 have multiple elements
  } else { 
      messager("Computing precision-recall results.")
      # if subject or ranges is an IntegerRanges object, 
      # query or x can be an integer vector 
      # to be converted to length-one ranges. 
      #### peaklist1 as the query, peaklist2 as the subject ####
      percent_list1 <- mapply(peaklist1, 
                             SIMPLIFY = FALSE,
                             FUN = function(x){
          mapply(peaklist2,
                 SIMPLIFY = FALSE,
                 FUN=function(y){
                     overlap <- f(
                         IRanges::subsetByOverlaps(x = x, # query
                                                   ranges = y, # subject
                                                   invert = invert)
                     )
                     percent <- length(overlap)/length(x)*100
                     data.table::data.table(overlap=length(overlap),
                                            total=length(x),
                                            Percentage=signif(percent,3)) 
         }) |> data.table::rbindlist(use.names = TRUE, idcol = "subject")
      }) |> data.table::rbindlist(use.names = TRUE, idcol = "query") 
      percent_list1$type <- "precision"
      
      #### peaklist2 as the query, peaklist1 as the subject ####
      percent_list2 <- mapply(peaklist2, 
                              SIMPLIFY = FALSE,
                              FUN = function(x){
          mapply(peaklist1,
                 SIMPLIFY = FALSE,
                 FUN=function(y){
                     overlap <- f(
                         IRanges::subsetByOverlaps(x = x, # query 
                                                   ranges = y, # subject
                                                   invert = invert)
                     )
                     percent <- length(overlap)/length(x)*100
                     data.table::data.table(overlap=length(overlap),
                                            total=length(x),
                                            Percentage=signif(percent,3)) 
                 }) |> data.table::rbindlist(use.names = TRUE, idcol = "subject")
    }) |> data.table::rbindlist(use.names = TRUE, idcol = "query")
      percent_list2$type <- "recall"
      df <- rbind(percent_list1, percent_list2)
      id <- type <- query <- subject <- NULL;
      df[,peaklist1:=ifelse(type=="precision",query,subject)] 
      df[,peaklist2:=ifelse(type=="precision",subject,query)] 
  }
  ### Return ###
  return(df)
}
