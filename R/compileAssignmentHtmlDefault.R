
#' A fallback function to compile an assignment, if none is given in the assignment YAML
#'
#' @param path The path to the assignment folder
#' @param envir An environment in which to compile the assignment
#' @param ... Other arguments (to be ignored)
#'
#' @return Path to the file containing the compiled HTML content (as a fragment, no header)
#' @importFrom knitr knit_hooks
#' @export
#'
#' @examples
compileAssignmentHtmlDefault <- function(path, envir = new.env(parent = .GlobalEnv), ...){
  tmpfn = tempfile(fileext = ".html")
  input = file.path(path, "index.Rmd")
  output_format = rmarkdown::html_fragment(pandoc_args = c("--metadata", "title= " ) )
  knitr::knit_hooks$set(seed.status = flexTeaching::seedStatusHook)
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn,
                    intermediates_dir = dirname(tmpfn),
                    envir = envir, quiet = TRUE, ...)
  return(tmpfn)
}
