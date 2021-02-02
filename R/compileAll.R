

#' Compile a data set and assignment document
#'
#' @param assignment_data data from _assignment.yml
#' @param id student id
#' @param seed random seed
#' @param solutions show solutions?
#' @param e environment in which to compile the document
#' @param type source (for the file name)
#' @param pdf create PDF instead of HTML?
#'
#' @return
#' 
#' @importFrom R.utils withSeed
#' @importFrom digest digest
#' @importFrom glue glue
compileAll <- function(assignment_data, id, seed, solutions, e = new.env(), type = "solve", pdf = FALSE){
  
  assignment = assignment_data$shortname
  salt = assignment_data$`data-salt`
  seed = flexTeaching:::assignmentSeed(id, seed, salt)
  
  e$.flexteach_solutions = solutions
  
  src = assignment_data$source
  if(!is.null(src))
    source(file.path(assignment_data$path, src), local = e, chdir = FALSE) 
  
  if(pdf){
    pdf_func = assignment_data$`pdf-gen`
    if(is.null(pdf_func)){
      return(NULL)
    }else{
      compile_assignment = get(pdf_func, envir = e)
    }
  }else{
    compile_assignment = get(assignment_data$`html-gen`, envir = e)
  }
  
  if(!is.null(assignment_data$`data-gen`)){
    get_data = get(assignment_data$`data-gen`, envir = e)
    R.utils::withSeed({
      get_data(envir = e)
    }, seed)
    
    data_set = e$.flexteach_data
    hash = digest::digest(data_set)
    time = format(Sys.time(), "%d%m%Y_%H%M%S")
    fn = glue::glue("data_{type}_{assignment}_{id}_{seed}_{time}_{hash}{{ext}}")
  }else{
    data_set = NULL
    fn = NULL
  }
  
  R.utils::withSeed({
    content = compile_assignment(assignment_data$path, envir = e, clean = FALSE)
    seed
  }, seed)
  
  
  if(pdf){
    return(content)
  }else{
    html_string = HTML(paste(readLines(content), collapse = "\n"))
    return(list(html = html_string, fn = fn, data_set = data_set))
  }
}
