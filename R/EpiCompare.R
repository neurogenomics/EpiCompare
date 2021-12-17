EpiCompare <- function(peakfiles, file_names, output_dir){

  markdown_path <- system.file("markdown", "EpiCompare.Rmd", package = "EpiCompare")

  rmarkdown::render(
    input = markdown_path,
    output_dir = output_dir,
    params = list(
      peakfile = peakfiles,
      file_name = file_names,
      output_dir = output_dir
    )

  )
}


