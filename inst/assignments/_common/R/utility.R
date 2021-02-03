
compile_assignment_html <- function(path, envir = new.env(), ...){
  tmpfn = tempfile(fileext = ".html")
  input = file.path(path, "index.Rmd")
  output_format = rmarkdown::html_fragment(pandoc_args = c("--metadata", "title= " ) )
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn, 
                    envir = envir, quiet = TRUE, ...)
  return(tmpfn)
}

compile_assignment_pdf <- function(path, envir = new.env(), ...){
  tmpfn = tempfile(fileext = ".pdf")
  input = file.path(path, "index.Rmd")
  output_format = "pdf_document"
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn,
                    envir = envir, quiet = TRUE, ...)
  return(tmpfn)
}