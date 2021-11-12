
#' Generate a static HTML version of an assignment (without any shiny interaction). 
#' 
#' Intended for use with, e.g., exams, where no solutions will be offered. 
#' Using a static page dramatically reduces resources needed for deploying
#' an assignment that does not requre interactivity.
#' 
#' The static version uses the same seed code as the interactive shiny app,
#' so the compiled document will be consistent (as long as the ID and master seed are). 
#'
#' Download buttons have embedded files saved as data URIs.
#'
#' @param id Student id (as would be entered in shiny app)
#' @param assignment assignment short code
#' @param masterseed master seed (as would be entered in shiny app)
#' @param solutions (boolean; default: `FALSE`) render the solutions?
#' @param entry mode to use (`solve` vs `download` currently)
#' @param format data format (for the buttons)
#' @param plain if `TRUE`, do not use flexDashboard
#' @param ... Additional arguments to `rmarkdown::render`
#'
#' @return The return value of `rmarkdown::render`
#' @export
#'
#' @examples
compileStatic = function(id, assignment, masterseed, solutions = FALSE, entry = 'download', format = 'SPSS', plain = FALSE, ...){
  
  td = tempfile(pattern = 'dir')
  dir.create(td)
  stopifnot(dir.exists(td))

  all_assignment_data =  flexTeaching:::getAssignments(simple = FALSE)
  assignment_data = all_assignment_data[[assignment]]
  
  salt0 = all_assignment_data[[assignment]]$`seed-salt`
  seed0 = flexTeaching:::animalSeed(masterseed, salt0)
  
  salt = assignment_data$`data-salt`
  seed = flexTeaching:::assignmentSeed(id, seed0, salt)
  
  e = new.env(parent = .GlobalEnv)
  
  flexTeaching:::sourceAll(assignment_data, e)
  
  if(!is.null(assignment_data$init))
  {
    init_func = get(assignment_data$init, envir = e)
    R.utils::withSeed({
      init_list = init_func(assignment_data, id, seed0, solutions, e)
    },
    seed)
  }else{
    init_list = list()
  }
  
  # Buttons
  bn = assignment_data$buttons
  bs = get(bn, envir = e)
  bl = lapply(names(bs), function(b){
    content = bs[[b]]$f(
      assignment_data,
      id,
      seed,
      solutions,
      format,
      init_list,
      entry
    )
    fn = bs[[b]]$fn(
      assignment_data,
      id,
      seed,
      solutions,
      format,
      init_list,
      entry
    )
    list(
      content = content$d,
      fn = fn, 
      label = bs[[b]]$label, 
      icon = bs[[b]]$icon)
  })
  
  content = flexTeaching:::compilePage(assignment_data, id, seed0, solutions, e, init_list)
  
  file.copy(
    from = system.file('static/', package = 'flexTeaching'),
    to = td,
    recursive = TRUE
    )
  file.copy(
    from = system.file('app/', package = 'flexTeaching'),
    to = td,
    recursive = TRUE
  )
  
  Rmd_fn = ifelse(plain, 'static/index_noflex.Rmd', 'static/index.Rmd')
  
  rmarkdown::render(
    input = file.path(td, Rmd_fn), ...
    )
}
