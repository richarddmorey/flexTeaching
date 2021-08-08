
data_file = function(assignment_data, id, seed, solutions, format, init, entry){
  df = init$data
  hash = digest::digest(df)
  ext = flexTeaching:::formats[[format]]$ext
  time = format(Sys.time(), "%d%m%Y_%H%M%S")
  shortname = assignment_data$shortname
  fn = ifelse(entry=="solve",
              glue::glue_safe("{entry}_{shortname}_{id}_{seed}_{time}_{hash}{ext}"),
              glue::glue_safe("{entry}_{shortname}_{id}_{time}_{hash}{ext}")
              )
  tf = tempfile(fileext = ext)
  flexTeaching:::formats[[format]]$f(df, tf)
  d = readBin(con = tf, what = "raw", n = file.size(tf))
  return(list(fn = fn, d = d))
}