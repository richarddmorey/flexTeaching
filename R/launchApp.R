

#' Run one of the shiny interfaces
#'
#' @param which Which app to open ('solve' or 'download')
#' @param query Query string to add to the URL (no initial '?')
#'
#' @return
#' @export
#' @importFrom glue glue
#' @importFrom rmarkdown run
#' @importFrom utils browseURL
#' 
#'
launchApp <- function(which = "solve", query = "", port = NULL){
  if(which == "solve" & nchar(query) > 0){
    query = glue::glue("solve&{query}")
  }else if(which == "solve"){
    query = "solve"
  }
  path  = system.file("app/app.Rmd", package = "flexTeaching")
  if(!file.exists(path))
    stop("Rmd file does not exist: ", path)
  
  # Reset working directory on exit
  # Necessary because rmarkdown::run
  # seems to use the current working 
  # directory to serve the app
  curwd = getwd()
  on.exit( { setwd(curwd) } )
  setwd(dirname(path))
  
  rmarkdown::run(path,
                 shiny_args = list(
                   launch.browser = function(url){
                     utils::browseURL(glue::glue("{url}/app.Rmd?{query}"))
                     },
                   port = port
                   )
                 )
}
