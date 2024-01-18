#' Download local file
#' 
#' Save an object as RDS and create a download button that can be rendered to
#'  Rmarkdown HTML pages.
#' Uses the package \pkg{downloadthis}.
#' @source \href{https://github.com/fmmattioni/downloadthis/issues/31}{
#' csv2 Issue.}
#' @source \href{https://github.com/fmmattioni/downloadthis/issues/16}{
#' Plotly Issue}
#' @param filename Name of the file to save.
#' @param outfile_dir Directory to save the file to.
#' @param verbose Print messages.
#' @inheritParams EpiCompare
#' @inheritParams base::saveRDS
#' @inheritParams downloadthis::download_file
#' @inheritParams downloadthis::download_this
#' @returns Download button as HTML text.
#' 
#' @export
#' @importFrom downloadthis download_file download_this
#' @examples 
#' button <- download_button(object=mtcars)
download_button <- function(object,
                            save_output = FALSE,
                            outfile_dir = NULL,
                            filename = NULL,
                            button_label = paste0("Download: ",
                                                  "<code>",filename,"</code>"),
                            output_extension = ".rds",
                            icon = "fa fa-save",
                            button_type = "success",
                            self_contained = TRUE,
                            add_download_button = TRUE,
                            verbose = TRUE){
  # devoptera::args2vars(download_button)
  
  if(isFALSE(add_download_button)) {
    messager("Download button disabled.",v=verbose)
    return(NULL)
  }
  #### Make sure object is a list ####
  if(!is.list(object)){
    object <- list(object) 
  } else if(methods::is(object,"plotly")){
    object <- list(plot=object)
  }
  #### With saving file ####
  if(isTRUE(save_output)){
    #### Make file path ####
    file <- if(!is.null(filename) && 
               exists("outfile_dir")){
      if(is.null(outfile_dir)) outfile_dir <- tempdir()
      file.path(outfile_dir,filename)
    } else {
      tempfile(fileext = ".rds") 
    }  
    #### Save file ####
    if(!file.exists(file)){
      messager("Saving file ==>",file,v=verbose)
      saveRDS(object = object,
              file = file)
    }
    #### Make button ####
    downloadthis::download_file(
      path = file,
      output_name = basename(file),
      button_label = button_label,
      button_type = button_type,
      has_icon = TRUE,
      icon = icon,
      self_contained = self_contained)
  #### Without saving file ####
  } else {
    #### Get output file name ####
    output_name <- if(is.null(filename)){
      "EpiCompare_download" 
    } else {
      gsub("\\.rds$","",basename(filename),ignore.case = TRUE)
    }
    #### Make button ####
    downloadthis::download_this(
      object,
      output_name = output_name,
      output_extension = output_extension,
      button_label = button_label,
      button_type = button_type,
      has_icon = TRUE,
      icon = icon,
      csv2 = FALSE,  
      self_contained = self_contained)
  } 
}
