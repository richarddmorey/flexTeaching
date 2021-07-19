
#' Get a list of assignments in a directory
#'
#' @param path Directory path
#' @param simple return only a named vector (for selectInput) 
#'
#' @importFrom yaml read_yaml
#' @importFrom purrr map_df map set_names
#' @importFrom dplyr `%>%` bind_rows pull arrange select
#' @return
#'
getAssignments = function(path = system.file("assignments", package = "flexTeaching"), simple = TRUE){
   
  date_format = flexTeaching::pkg_options()$date_format_yaml
  
  potential_dirs = list.dirs(path, recursive = FALSE) 
  potential_dirs = potential_dirs[ grepl("^[^_]", basename(potential_dirs)) ] 
  
  potential_dirs %>%
    purrr::map(function(d){
      fp = file.path(d,"_assignment.yml")
      if(file.exists(fp)){
        y = yaml::read_yaml(fp)
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
  
  names(dirs) = purrr::map_chr(dirs, ~`$`(., 'shortname'))
  if(!simple) return(dirs)
  
  purrr::map_df(dirs, function(el){
    bind_rows(category = el$category, 
              title = el$title, 
              shortname = el$shortname,
              sortkey = el$sortkey,
              hidden = el$hide_before>Sys.time())
  }) %>% 
    arrange(category, sortkey, title) %>%
    select(-sortkey) -> x
  return(x)
  
}
