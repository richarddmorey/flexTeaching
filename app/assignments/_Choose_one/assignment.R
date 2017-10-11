assignment = read.csv('meta_info.csv', stringsAsFactors = FALSE)[1,"title"]

getData <- function(seed, secret, extra = ""){
    return(NULL)
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile()
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}



