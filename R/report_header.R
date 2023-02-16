#' Report header
#' 
#' Generate a header for \link[EpiCompare]{EpiCompare} reports generated using 
#' the \emph{EpiCompare.Rmd} template.
#' @returns Header string to be rendering within Rmarkdown file.
#' 
#' @export
#' @examples 
#' report_header()
report_header <- function(){ 
  paste0(
    "<div class='report-header'>",
    "<a href=",shQuote("https://github.com/neurogenomics/EpiCompare"),
    " target='_blank'>",
    "<code>EpiCompare</code>",
    "</a>",
    "<code>Report</code>",
    "<a href=",shQuote("https://doi.org/doi:10.18129/B9.bioc.EpiCompare"),
    " target='_blank'>",
    "<img src=",
    shQuote(system.file('hex','hex.png',package = 'EpiCompare')),
    " height='100'",">",
    "</a>",
    "</div>"
  ) 
}
