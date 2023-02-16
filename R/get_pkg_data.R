get_pkg_data <- function(name,
                         pkg="EpiCompare"){
  utils::data(list = name, package = pkg)
  base::get(x = name, envir = asNamespace(pkg))
}