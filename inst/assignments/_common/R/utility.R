
compile_assignment_html <- function(path, envir = new.env(), ...){
  tmpfn = tempfile(fileext = ".html")
  input = file.path(path, "index.Rmd")
  output_format = rmarkdown::html_fragment(pandoc_args = c("--metadata", "title= " ) )
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn, 
                    envir = envir, quiet = TRUE, ...)
  return(tmpfn)
}

data_file = function(assignment_data, id, seed, solutions, format, init){
  df = init$data
  ext = flexTeaching:::formats[[format]]$ext
  time = format(Sys.time(), "%d%m%Y_%H%M%S")
  fn = glue::glue("data_{assignment_data$shortname}_{id}_{seed}_{time}{ext}")
  tf = tempfile(fileext = ext)
  flexTeaching:::formats[[format]]$f(df, tf)
  d = readBin(con = tf, what = "raw", n = file.size(tf))
  return(list(fn = fn, d = d))
}