
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
   
  potential_dirs = list.dirs(path, recursive = FALSE) 
  potential_dirs = potential_dirs[ grepl("^[^_]", basename(potential_dirs)) ] 
  
  potential_dirs %>%
    purrr::map(function(d){
      fp = file.path(d,"_assignment.yml")
      if(file.exists(fp)){
        y = yaml::read_yaml(fp)
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
    bind_rows(category = el$category, title = el$title, shortname = el$shortname, sortkey = el$sortkey)
  }) %>% 
    arrange(category, sortkey, title) %>%
    select(-sortkey) %>%
    split(.$category) %>%
    purrr::map(function(el){
      z = pull(el, shortname)
      names(z) = pull(el, title)
      return(z)
    }) -> x
  return(x)
  
}
