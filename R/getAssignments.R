
#' Get a list of assignments in a directory
#'
#' @param path Directory path
#'
#' @return
#'
getAssignments = function(path = system.file("assignments", package = "flexTeaching"), simple = TRUE){
  potential_dirs = list.dirs(path, recursive = FALSE) 
  lapply(potential_dirs, function(d){
    fp = file.path(d,"_assignment.yml")
    if(file.exists(fp)){
      return(yaml::read_yaml(fp))
    }else{
      return(NULL)
    }
  }) -> dirs
  names(dirs) = potential_dirs
  dirs[lengths(dirs) != 0]
  
  shortnames = sapply(dirs, function(el) el$shortname)
  titles = sapply(dirs, function(el) el$title)
  
  if(simple){
    names(shortnames) = titles
    return(shortnames)
  }
  
  for(i in seq_along(dirs)){
    dirs[[i]]$path = names(dirs)[i] 
  }
  names(dirs) = shortnames

  return(dirs)
  
}
