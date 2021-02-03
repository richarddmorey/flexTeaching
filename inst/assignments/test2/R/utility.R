
get_data <- function(envir){
  N = 100
  x = rnorm(N)
  df = data.frame(
    x = x,
    y = 2*x + rnorm(N)
  )
  assign(".flexteach_data", df, envir = envir)
}
