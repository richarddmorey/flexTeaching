


#' Source all the files indicated in the assignment data
#'
#' @param assignment_data data for the particular assignment
#' @param e environment in which to source
#'
#' @return
#'
#' @examples
sourceAll <- function(assignment_data, e){
  
  if(length(assignment_data$source)){
    src = file.path(assignment_data$path, assignment_data$source)
    for(s in src)
      source(s, local = e, chdir = TRUE)
  }
  return()
}
