
#' A fallback function to compile an assignment, if none is given in the assignment YAML
#'
#' @param path The path to the assignment folder
#' @param envir An environment in which to compile the assignment
#' @param ... Other arguments (to be ignored)
#'
#' @return Path to the file containing the compiled HTML content (as a fragment, no header)
#' @export
#'
#' @examples
compileAssignmentHtmlDefault <- function(path, envir = new.env(), ...){
  tmpfn = tempfile(fileext = ".html")
  input = file.path(path, "index.Rmd")
  output_format = rmarkdown::html_fragment(pandoc_args = c("--metadata", "title= " ) )
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn, 
                    envir = envir, quiet = TRUE, ...)
  return(tmpfn)
}
