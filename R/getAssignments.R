
#' Get a list of assignments in a directory
#'
#' @param pkg Package from which to pull the assignments (character string)
#' @param simple return only a named vector (for selectInput) 
#'
#' @importFrom yaml read_yaml
#' @importFrom purrr map_df map set_names
#' @importFrom dplyr `%>%` bind_rows pull arrange select
#' @return
#'
getAssignments = function(pkg = pkg_options()$assignment_pkg, simple = TRUE){
  
  if(pkg != "flexTeaching" && !require(pkg, character.only = TRUE, quietly = TRUE))
    stop("Could not load assignments package: ", pkg)
   
  path = system.file("assignments", package = pkg)
  
  if(!dir.exists(path))
    stop("Assignments path does not exist: ", path)
  
  date_format = flexTeaching::pkg_options()$date_format_yaml
  
  
  potential_dirs = list.dirs(path, recursive = FALSE) 
  potential_dirs = potential_dirs[ grepl("^[^_]", basename(potential_dirs)) ]
  
  potential_dirs %>%
    purrr::map(function(d){
      fp = file.path(d,"_assignment.yml")
      if(file.exists(fp)){
        y = yaml::read_yaml(fp)
        if(is.null(y$exam)){
          y$exam = FALSE
          y$exam_practice = FALSE
        }else{
          y$exam = as.logical(y$exam)
        }
        if(is.null(y$exam_practice)){
          y$exam_practice = FALSE
        }else{
          y$exam_practice = as.logical(y$exam_practice)
        }
        if(is.null(y$category)){
          y$category = " "
        }
        if(is.null(y$sortkey)){
          y$sortkey = Inf
        }
        if(!is.null(y$hide_before)){
          y$hide_before = strptime(y$hide_before, format = date_format)
        }else{
          y$hide_before = -Inf
        }
        if(!is.null(y$restrict_before)){
          y$restrict_before = strptime(y$restrict_before, format = date_format)
        }else{
          y$restrict_before = -Inf
        }
        y$path = d
        return(y)
      }else{
        return(NULL)
      }
    }) %>%
    Filter(length, .) -> dirs
  
  if(length(dirs) < 1)
    stop("No assignment directories found: ", path)
  
  shortnames = purrr::map_chr(dirs, ~`$`(., 'shortname'))
  # Check for duplicate shortnames
  if(any(duplicated(shortnames)))
    stop("All assignment shortnames must be unique.")
  
  names(dirs) = shortnames
  if(!simple) return(dirs)
  
  purrr::map_df(dirs, function(el){
    bind_rows(category = el$category, 
              title = el$title, 
              shortname = el$shortname,
              sortkey = el$sortkey,
              hidden = el$hide_before>Sys.time(),
              exam = el$exam)
  }) %>% 
    arrange(category, sortkey, title) %>%
    select(-sortkey) -> x
  return(x)
  
}
