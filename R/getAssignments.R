
#' Get a list of assignments in a directory
#'
#' @param path Directory path
#'
#' @return
#'
getAssignments = function(path = system.file("assignments", package = "flexTeaching")){
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
}
