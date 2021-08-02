
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
  
  .DEBUG = FALSE
  
  e = new.env(parent = .GlobalEnv)
  flexTeaching:::sourceAll(assignment_data, e)
  
  e$.flexteach_solutions = solutions
  e$.flexteach_info = init
  
  dname = tempfile(pattern="d")
  dir.create(dname)
  
  ## The following settings for tinytex.output_dir and tinytex.engine_args 
  ## are is necessary due to a bug in rmarkdown where it doesn't properly
  ## use intermediates_die for the extra tex-related files (log, etc)
  ## See:  https://github.com/rstudio/rmarkdown/issues/1615 and
  ##       https://github.com/rstudio/rmarkdown/issues/1975
  withr::local_options(
    list(
      tinytex.clean = !.DEBUG,
      tinytex.verbose = .DEBUG,
      tinytex.output_dir = dname,
      tinytex.engine_args = sprintf('"--output-directory=%s"', dname)
    )
  )
  
  tmpfn = tempfile(fileext = ".pdf", tmpdir = dname)
  input = file.path(assignment_data$path, "index.Rmd")
  output_format = rmarkdown::pdf_document(
    keep_tex = .DEBUG, keep_md = .DEBUG
  )
  out0 = tryCatch(
    {
      rmarkdown::render(
        input = input, output_format = output_format, output_file = tmpfn,
        intermediates_dir = dname, envir = e, 
        quiet = !.DEBUG, clean = !.DEBUG 
      )
      d = readBin(con = tmpfn, what = "raw", n = file.size(tmpfn))
      time = format(Sys.time(), "%d%m%Y_%H%M%S")
      fn = ifelse(entry=="solve",
                  # Use sprintf instead of glue::glue to prevent code injection vulnerability
                  sprintf("%s_practice_%s_%s_%s.pdf", assignment_data$shortname, id, seed, time),
                  sprintf("%s_assignment_%s_%s.pdf", assignment_data$shortname, id, time)
      )
      return(list(fn = fn, d = d))
    },
    ## On error, pack up the whole folder and send it. This should probably
    ## only be done while debugging, so I've started with a stop() call that
    ## prevents it.
    error = function(e){
      if(!.DEBUG)
        stop(e)
      cat(file = file.path(dname,"paths.txt"),
          glue::glue("dname: {dname}\ntmpfn: {tmpfn}\ntinytex.clean: {options()$`tinytex.clean`}\n{paste(e)}\nis_tinytex: {tinytex:::is_tinytex()}\ngetwd: {getwd()}\n"))
      tmpzip = tempfile(pattern = glue::glue("PDF_ERROR_{basename(tmpfn)}_"), fileext = ".zip")
      zip::zip(tmpzip, files = dir(dname, recursive = TRUE), root = dname)
      d = readBin(con = tmpzip, what = "raw", n = file.size(tmpzip))
      return(list(fn = basename(tmpzip), d = d))
    }
  )
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
