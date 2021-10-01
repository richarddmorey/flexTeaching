#' Gether file content to include in the header
#'
#'
#' @return
#' @importFrom htmltools tagAppendChild tags HTML tagList
#'
#' @examples
writeHeaders = function(){
  
  assignments =  flexTeaching:::getAssignments(simple = FALSE)
  html.content = NULL
  
  allTags = htmltools::tagList()
  
  app_path = system.file("app/", package = "flexTeaching")
  common_path = system.file("assignments/_common", package = pkg_options()$assignment_pkg)
  assignment_paths = sapply(assignments, function(a) a$path)
  if(dir.exists(common_path))
    assignment_paths = c(assignment_paths, common_path)
    
  all_paths = c(app_path, assignment_paths)
  
  for(a in all_paths){
    # CSS
    fs = dir(file.path(a, "include/css/"), full.names = TRUE, include.dirs = FALSE)
    for(f in fs){
      lns = paste(readLines(f), collapse="\n")
      allTags = htmltools::tagAppendChild( allTags, 
                                           htmltools::tags$style(HTML(lns),type="text/css") )
    }
    
    # JS
    fs = dir(file.path(a, "include/js/"), full.names = TRUE, include.dirs = FALSE)
    for(f in fs){
      lns = paste(readLines(f), collapse="\n")
      allTags = htmltools::tagAppendChild( allTags,
                                           htmltools::tags$script(HTML(lns), type="text/javascript") )
    }    
    
    # HTML
    fs = dir(file.path(a, "include/html/"), full.names = TRUE, include.dirs = FALSE)
    for(f in fs){
      lns = paste(readLines(f), collapse="\n")
      html.content = paste(html.content, lns, 
                           sep = "\n", collapse="\n")
    }
    
  }
  
  all.content = paste(html.content, as.character(allTags), sep="\n")
  file = tempfile()
  writeLines( all.content, con = file )

  return(gsub("\\\\", "\\\\\\\\", file))

}
