assignment = "summaries"

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))
	data.frame(y = rnorm(50))
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile()
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}





