#' Report command
#' 
#' Reconstruct the \link[EpiCompare]{EpiCompare} command 
#' used to generate the current Rmarkdown report.
#' @param params Parameters supplied to the Rmarkdown template.
#' @param peaklist_tidy Post-processed target peaks.
#' @param reference_tidy Post-processed reference peaks.
#' @returns String reconstructing R function call.
#' 
#' @export
#' @examples 
#' # report_command()
report_command <- function(params,
                           peaklist_tidy,
                           reference_tidy){
  cmd <- paste(
    paste0(
      "EpiCompare(peakfiles = list(",
      paste(shQuote(names(peaklist_tidy)),collapse = ","),
      ")"
    ),
    paste0(
      "genome_build =  list(",
      paste(shQuote(params$genome_build), collapse = ","),
      ")"
    ),
    paste0("genome_build_output = ",shQuote(params$genome_build_output)),
    paste0(
      "blacklist = ",if(is.character(params$blacklist)) {
        shQuote(params$blacklist)
      } else if(is.null(params$blacklist)) {
        "NULL"
      } else {
        shQuote("<user_supplied>")
      }
    ),
    paste0("picard_files = list(",
           paste(shQuote(names(params$picard_files)),collapse = ","),
           ")"
    ),
    paste0(
      "reference = ",if(is.null(params$reference)) {
        "NULL"
      } else {
        paste(shQuote(names(reference_tidy)), collapse = ",")
      }
    ),
    paste0("upset_plot = ",params$upset_plot),
    paste0("stat_plot = ",params$stat_plot),
    paste0("chromHMM_plot = ",params$chromHMM_plot),
    paste0("chromHMM_annotation = ",shQuote(params$chromHMM_annotation)),
    paste0("chipseeker_plot = ",params$chipseeker_plot),
    paste0("enrichment_plot = ",params$enrichment_plot),
    paste0("tss_plot = ",params$tss_plot),
    paste0("tss_distance = c(",paste0(params$tss_distance, collapse = ","),")"),
    paste0("precision_recall_plot = ",params$precision_recall_plot),
    paste0("n_threshold = ",params$n_threshold),
    paste0("corr_plot = ",params$corr_plot),
    paste0("interact = ",params$interact),
    paste0("save_output = ",params$save_output),
    paste0(
      "output_dir = ",if(is.null(params$output_dir)){
        "NULL"
      } else {
        shQuote(params$output_dir)
      }
    ),
    paste0("workers = ",params$workers),
    paste0(paste0("error = ",params$error),")"),
    sep = paste0(",\n", paste0(rep(" ",nchar("EpiCompare(")),collapse = "") )
  ) 
  ## <pre> tag is neccesarry for multiline code
  cmd <- paste0("<pre><code class='language-r'>",cmd,"</code></pre>")
  return(cmd)
}