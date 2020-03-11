assignment = read.csv('meta_info.csv', stringsAsFactors = FALSE)[1,"title"]

getData <- function(seed, secret, extra = ""){
  set.seed.alpha(paste0(seed, secret, extra))
	N = sample(5:15,1)
	
  data.frame(x = round(runif(N,1,99)))
}
 
getAssignment <- function(seed, secret, assignmentDir = NULL, solutions = FALSE){
  tmpfn = tempfile(fileext = ".html")
  input = paste0(assignmentDir,"/assignment.Rmd")
  rmarkdown::render(input = input, output_format = "html_fragment", output_file = tmpfn, envir = new.env())
  return(tmpfn)
}





