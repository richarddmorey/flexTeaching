

#' Compile a data set and assignment document
#'
#' @param assignment_data data from _assignment.yml
#' @param id student id
#' @param seed random seed
#' @param solutions show solutions?
#' @param e environment in which to compile the document
#' @param init_list assignment initialization information
#'
#' @return
#' 
#' @importFrom R.utils withSeed
#' @importFrom shiny HTML
compilePage <- function(assignment_data, id, seed, solutions, e, init_list = list()){
  
  salt = assignment_data$`data-salt`
  seed0 = flexTeaching:::assignmentSeed(id, seed, salt)
  
  e$.flexteach_solutions = solutions
  e$.flexteach_info = init_list
  
  compile_assignment = get(assignment_data$`html-gen`, envir = e)

  R.utils::withSeed({
    content = compile_assignment(assignment_data$path, envir = e)
  }, seed0)
  
  html_string = shiny::HTML(paste(readLines(content), collapse = "\n"))
  
  return(html_string)
}
