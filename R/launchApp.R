

#' Run one of the shiny interfaces
#'
#' @param which Which app to open ('solve' or 'download')
#' @param query Query string to add to the URL
#'
#' @return
#' @export
#' @importFrom glue glue
#' @importFrom rmarkdown run
#' @importFrom utils browseURL
#' 
#'
launchApp <- function(which = "solve", query = "", port = NULL){
  path = system.file(glue::glue("app/{which}.Rmd"), package = "flexTeaching")
  if(!file.exists(path))
    stop("Rmd file does not exist: ", path)
  rmarkdown::run(path,
                 shiny_args = list(
                   launch.browser = function(url){
                     utils::browseURL(glue::glue("{url}/{which}.Rmd{query}"))
                     },
                   port = port
                   )
                 )
}
