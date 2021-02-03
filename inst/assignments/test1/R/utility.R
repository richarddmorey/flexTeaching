
get_data <- function(envir){
  N = 100
  df = data.frame(
    x = rnorm(N),
    y = rnorm(N)
  )
  assign(".flexteach_data", df, envir = envir)
}
