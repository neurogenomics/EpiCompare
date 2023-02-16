#' As interactive
#' 
#' Convert a \link[ggplot2]{ggplot} object to \link[plotly]{plotly}, 
#' and enable it to be plotted within an Rmarkdown HTML file.
#' @source \href{https://github.com/yihui/knitr/issues/926}{
#' GitHub Issue to check whether knitting}
#' @param plt ggplot object.
#' @param to_widget Convert to a widget so it works within Rmarkdown HTML files.
#' By default, this will be only be set to \code{TRUE} when being run within 
#' the context of \pkg{knitr} rendering.
#' @param add_boxmode Add extra \link[plotly]{layout} to enable dodged boxplots.
#' @returns A \link[plotly]{plotly} object or a \link[htmltools]{tagList} 
#' wrapping the \link[plotly]{plotly} object.
#' 
#' @keywords internal 
#' @importFrom plotly ggplotly layout as_widget
#' @importFrom htmltools tagList
as_interactive <- function(plt, 
                           to_widget=isTRUE(getOption('knitr.in.progress')),
                           add_boxmode=FALSE){
  # plotly::renderPlotly()
  if(!methods::is(plt,"plotly")){
    plt <- plotly::ggplotly(plt)
  } 
  if(isTRUE(add_boxmode)){
    plt <- plt |> plotly::layout(boxmode = "group")
  }
  if(isTRUE(to_widget)){
    plt <- htmltools::tagList(plotly::as_widget(plt))
  } 
  return(plt)
}