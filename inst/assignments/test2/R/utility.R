
get_data <- function(){
  N = 100
  x = rnorm(N)
  df = data.frame(
    x = x,
    y = 2*x + rnorm(N)
  )
}


init <- function(assignment_data, id, seed, solutions, e){
  ret_list = list(
    data = get_data(),
    id = id
    )
  return(ret_list)
}

create_pdf <- function(assignment_data, id, seed, solutions, format, init, entry){
  
  e = new.env(parent = .GlobalEnv)
  flexTeaching:::sourceAll(assignment_data, e)
  
  e$.flexteach_solutions = solutions
  e$.flexteach_info = init
  
  tmpfn = tempfile(fileext = ".pdf")
  input = file.path(assignment_data$path, "index.Rmd")
  output_format = "pdf_document"
  rmarkdown::render(input = input, output_format = output_format, output_file = tmpfn,
                    envir = e, quiet = TRUE)
  d = readBin(con = tmpfn, what = "raw", n = file.size(tmpfn))
  time = format(Sys.time(), "%d%m%Y_%H%M%S")
  fn = ifelse(entry=="solve",
              glue::glue("{assignment_data$shortname}_{id}_{seed}_{time}.pdf"),
              glue::glue("{assignment_data$shortname}_{id}_{time}.pdf")
  )
  return(list(fn = fn, d = d))
}

buttons <- list(
  data = list(
    label = "Download data",
    icon = "download",
    f = data_file
  ),
  pdf = list(
    label = "Download PDF",
    icon = "file-download",
    f = create_pdf
  )
)
